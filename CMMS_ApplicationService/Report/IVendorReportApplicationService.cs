using CMMS_Model.Report;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.Report
{
    public interface IVendorReportApplicationService
    {
        List<SalesOverviewModel> GetSalesOverviewDetails(int UserID, int Year, int Month);
        List<OrderStatusModel> GetOrderStatusDetails(int UserID, int Year, int Month);
        List<InventorySummaryModel> GetInventorySummaryDetails(int VendorCategoryTypeID, int UserID);
        List<CustomerOverallModel> GetCustomerOverallDetails(int UserID, int Year, int Month);
        List<PopularItemModel> GetPopularItemDetails(int UserID, int Year, int Month);
    }
}
