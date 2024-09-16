using CMMS_ApplicationService.Email;
using CMMS_DataService.EStore;
using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using CMMS_Model.Email;
using CMMS_Model.EStore;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.EStore
{
    public class EStoreOrderApplicationService: IEStoreOrderApplicationService
    {
        DB_Handle oDB_Handle = new DB_Handle();

        public List<EStoreOrderCusDetail> GetEStoreCustomerDetails(int CustomerID)
        {
            EStoreOrderDataService eStoreOrderDataService = new EStoreOrderDataService();
            List<EStoreOrderCusDetail> eStoreOrderCusDetails = new List<EStoreOrderCusDetail>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                eStoreOrderCusDetails = eStoreOrderDataService.GetEStoreCustomerDetails(oDB_Handle, CustomerID);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return eStoreOrderCusDetails;
        }

        public List<EStoreOrderHistoryMainViewModel> GetOrderCustomerHistory(int CustomerID)
        {
            EStoreOrderDataService eStoreOrderDataService = new EStoreOrderDataService();
            List<EStoreOrderHistoryMainViewModel> eStoreOrderHistories = new List<EStoreOrderHistoryMainViewModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                eStoreOrderHistories = eStoreOrderDataService.GetOrderCustomerHistory(oDB_Handle, CustomerID);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return eStoreOrderHistories;
        }

        public EStoreInvoiceViewModel GetOrderDetailByOrderID(int OrderID, int CustomerID)
        {
            EStoreOrderDataService eStoreOrderDataService = new EStoreOrderDataService();
            EStoreInvoiceViewModel eStoreInvoice = new EStoreInvoiceViewModel();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                eStoreInvoice = eStoreOrderDataService.GetOrderDetailByOrderID(oDB_Handle, OrderID, CustomerID);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return eStoreInvoice;
        }

        public List<OutputMessageModel> SaveCusOrderDetails(EStoreOrderDetail eStoreOrder)
        {
            EStoreOrderDataService eStoreOrderDataService = new EStoreOrderDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                //Convert List object to JSON string
                var OrderDetailJson = JsonConvert.SerializeObject(eStoreOrder.EStoreCartInfo.Select(
                x => new
                {
                    x.ItemID,
                    x.UnitAmount,
                    x.Quantity,
                    x.DiscountAmount,
                    x.ItemWiseTotal,
                    x.VendorID
                }
                ).ToList());

                msgModel = eStoreOrderDataService.SaveCusOrderDetails(oDB_Handle, eStoreOrder, OrderDetailJson);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return msgModel;
        }

        public void SendAllOrderRelatedEmails(int OrderID, int CustomerID) {

            IEStoreOrderApplicationService eStoreOrderApplication = new EStoreOrderApplicationService();
            IOrderEmailApplicationService orderEmailApplication = new OrderEmailApplicationService();
            IEmailMgntApplicationService emailMgntApplication = new EmailMgntApplicationService();

            EStoreInvoiceViewModel invoiceViewModel = new EStoreInvoiceViewModel();
            var orderID = OrderID;
            var customerID = CustomerID;
            invoiceViewModel = eStoreOrderApplication.GetOrderDetailByOrderID((int)orderID, (int)customerID);

            #region Send Email to Customer
            OrderEmailModel orderEmailModel = new OrderEmailModel();
            orderEmailModel = orderEmailApplication.GenerateCustomerOrderEmail(invoiceViewModel);

            EmailModel emailModel = new EmailModel();
            emailModel.ToEmail = invoiceViewModel.OrderInfo[0].Email;
            emailModel.MailSubject = orderEmailModel.OrderEmailSubject;
            emailModel.BodyContent = orderEmailModel.OrderEmailBody;

            var output1 = emailMgntApplication.SendGeneratedEmail(emailModel);
            #endregion

            #region Send Emails to Vendors
            OrderEmailModel orderEmailModel2 = new OrderEmailModel();
            EmailModel emailModel2 = new EmailModel();

            foreach (var item in invoiceViewModel.OrderVendorInfo)
            {
                orderEmailModel2 = orderEmailApplication.GenerateVendorOrderReceivedEmail(invoiceViewModel, item);
                emailModel2.ToEmail = item.Email;
                emailModel2.MailSubject = orderEmailModel2.OrderEmailSubject;
                emailModel2.BodyContent = orderEmailModel2.OrderEmailBody;

                var output2 = emailMgntApplication.SendGeneratedEmail(emailModel2);
            }
            #endregion

        }

    }
}
