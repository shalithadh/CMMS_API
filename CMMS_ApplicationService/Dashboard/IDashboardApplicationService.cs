using CMMS_Model.Dashboard;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.Dashboard
{
    public interface IDashboardApplicationService
    {
        AdminDashboardModel GetAdminDashboardDetails();
        ContractorDashboardModel GetContractorDashboardDetails(int UserID);
        VendorDashboardModel GetVendorDashboardDetails(int UserID);
        CustomerDashboardModel GetCustomerDashboardDetails(int UserID);
    }
}
