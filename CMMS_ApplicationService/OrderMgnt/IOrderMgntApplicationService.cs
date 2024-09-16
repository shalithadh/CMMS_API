using CMMS_Model.Common;
using CMMS_Model.OrderMgnt;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.OrderMgnt
{
    public interface IOrderMgntApplicationService
    {
        OrderMgntInitialDataModel GetInitialOrderMgntData();
        List<OrderMgntOrderListViewModel> GetOrderMgntOrderList(int VendorID, int OrderStatusID,
            string StartDate, string EndDate);
        OrderMgntOrderDetailViewModel GetOrderDetailByOrderID(int OrderID, int PackageID, int VendorID);
        List<OutputMessageModel> UpdateOrderStatusDetails(OrderMgntStatusUpdateModel updateModel);
    }
}
