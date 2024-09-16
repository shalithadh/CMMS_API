using CMMS_Model.Common;
using CMMS_Model.EStore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.EStore
{
    public interface IEStoreOrderApplicationService
    {
        List<EStoreOrderCusDetail> GetEStoreCustomerDetails(int CustomerID);
        List<EStoreOrderHistoryMainViewModel> GetOrderCustomerHistory(int CustomerID);
        public EStoreInvoiceViewModel GetOrderDetailByOrderID(int OrderID, int CustomerID);
        List<OutputMessageModel> SaveCusOrderDetails(EStoreOrderDetail eStoreOrder);
        void SendAllOrderRelatedEmails(int OrderID, int CustomerID);
    }
}
