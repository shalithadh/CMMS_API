using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.Dashboard
{
    public class VendorDashboardModel
    {
        public List<VendorTotalOrdersModel> vendorTotalOrders { get; set; }
        public List<VendorBestCustomerModel> vendorBestCustomer { get; set; }
        public List<VendorTotalItemsModel> vendorTotalItems { get; set; }
        public List<VendorRecentOrdersModel> vendorRecentOrders { get; set; }
        public List<VendorRecentItemsModel> vendorRecentItems { get; set; }
    }

    public class VendorTotalOrdersModel
    {
        public int? TotalOrders { get; set; }
    }

    public class VendorBestCustomerModel
    {
        public string? BestCustomer { get; set; }
    }

    public class VendorTotalItemsModel
    {
        public int? TotalItems { get; set; }
    }

    public class VendorRecentOrdersModel
    {
        public string? OrderNo { get; set; }
        public string? CustomerName { get; set; }
        public string? PlacedDate { get; set; }
    }

    public class VendorRecentItemsModel
    {
        public string? ItemName { get; set; }
        public string? Category { get; set; }
        public string? AddedDate { get; set; }
        public string? StockAvailability { get; set; }
    }

}
