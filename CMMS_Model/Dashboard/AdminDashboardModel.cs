using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.Dashboard
{
    public class AdminDashboardModel
    {
        public List<AdminTotalSalesModel> adminTotalSales { get; set; }
        public List<AdminTotalItemsModel> adminTotalItems { get; set; }
        public List<AdminTotalOrdersModel> adminTotalOrders { get; set; }
        public List<AdminTotalUsersModel> adminTotalUsers { get; set; }
        public List<AdminBestContractorModel> adminBestContractors { get; set; }
        public List<AdminBestCustomerModel> adminBestCustomers { get; set; }
        public List<AdminBestVendorModel> adminBestVendors { get; set; }
        public List<AdminRecentProjectModel> adminRecentProjects { get; set; }
        public List<AdminRecentOrderModel> adminRecentOrders { get; set; }
    }

    public class AdminTotalSalesModel
    {
        public decimal? TotalSales { get; set; }
    }

    public class AdminTotalItemsModel
    {
        public int? TotalItems { get; set; }
    }

    public class AdminTotalOrdersModel
    {
        public int? TotalOrders { get; set; }
    }

    public class AdminTotalUsersModel
    {
        public int? TotalUsers { get; set; }
    }

    public class AdminBestContractorModel
    {
        public string? BestContractor { get; set; }
    }

    public class AdminBestCustomerModel
    {
        public string? BestCustomer { get; set; }
    }

    public class AdminBestVendorModel
    {
        public string? BestVendor { get; set; }
    }

    public class AdminRecentProjectModel
    {
        public string? ProjectTitle { get; set; }
        public string? ContractorName { get; set; }
        public string? ClientName { get; set; }
        public decimal? ProjectProgress { get; set; }
    }

    public class AdminRecentOrderModel
    {
        public string? OrderNo { get; set; }
        public string? VendorName { get; set; }
        public string? CustomerName { get; set; }
        public string? PlacedDate { get; set; }
    }

}
