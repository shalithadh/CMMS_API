using CMMS_DataService.OrderMgnt;
using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using CMMS_Model.OrderMgnt;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.OrderMgnt
{
    public class OrderMgntApplicationService : IOrderMgntApplicationService
    {
        DB_Handle oDB_Handle = new DB_Handle();

        public OrderMgntInitialDataModel GetInitialOrderMgntData()
        {
            OrderMgntDataService orderMgntDataService = new OrderMgntDataService();
            OrderMgntInitialDataModel initialDataModel = new OrderMgntInitialDataModel();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                initialDataModel = orderMgntDataService.GetInitialOrderMgntData(oDB_Handle);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return initialDataModel;
        }

        public List<OrderMgntOrderListViewModel> GetOrderMgntOrderList(int VendorID, int OrderStatusID,
            string StartDate, string EndDate)
        {
            OrderMgntDataService orderMgntDataService = new OrderMgntDataService();
            List<OrderMgntOrderListViewModel> orderMgntOrderLists = new List<OrderMgntOrderListViewModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                orderMgntOrderLists = orderMgntDataService.GetOrderMgntOrderList(oDB_Handle, VendorID, OrderStatusID, StartDate, EndDate);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return orderMgntOrderLists;
        }

        public OrderMgntOrderDetailViewModel GetOrderDetailByOrderID(int OrderID, int PackageID, int VendorID)
        {
            OrderMgntDataService orderMgntDataService = new OrderMgntDataService();
            OrderMgntOrderDetailViewModel orderMgntOrderDetailView = new OrderMgntOrderDetailViewModel();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                orderMgntOrderDetailView = orderMgntDataService.GetOrderDetailByOrderID(oDB_Handle, OrderID, PackageID, VendorID);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return orderMgntOrderDetailView;
        }

        public List<OutputMessageModel> UpdateOrderStatusDetails(OrderMgntStatusUpdateModel updateModel)
        {
            OrderMgntDataService orderMgntDataService = new OrderMgntDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                msgModel = orderMgntDataService.UpdateOrderStatusDetails(oDB_Handle, updateModel);

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

    }
}
