using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.Dashboard
{
    public class CustomerDashboardModel
    {
        public List<CusTotalOrdersModel> cusTotalOrders { get; set; }
        public List<CusPreferredContractorModel> cusPreferredContractors { get; set; }
        public List<CusPreferredVendorModel> cusPreferredVendors { get; set; }
        public List<CusAdvertisementsModel> cusAdvertisements { get; set; }
        public List<CusRecentOrdersModel> cusRecentOrders { get; set; }
        public List<CusRecentTasksModel> cusRecentTasks { get; set; }
    }

    public class CusTotalOrdersModel
    {
        public int? TotalOrders { get; set; }
    }

    public class CusPreferredContractorModel
    {
        public string? PreferredContractor { get; set; }
    }

    public class CusPreferredVendorModel
    {
        public string? PreferredVendor { get; set; }
    }

    public class CusAdvertisementsModel
    {
        public int? AdvID { get; set; }
        public string? ImageName { get; set; }
        public string? ImageURL { get; set; }
    }

    public class CusRecentOrdersModel
    {
        public string? OrderNo { get; set; }
        public string? VendorName { get; set; }
        public string? PlacedDate { get; set; }
    }

    public class CusRecentTasksModel
    {
        public string? TaskName { get; set; }
        public string? ProjectTitle { get; set; }
        public string? ContractorName { get; set; }
        public int? TaskStatus { get; set; }
        public string? TaskStatusName { get; set; }
    }

}
