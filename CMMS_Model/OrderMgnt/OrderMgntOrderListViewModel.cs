using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.OrderMgnt
{
    public class OrderMgntOrderListViewModel
    {
        public int OrderID { get; set; }
        public string OrderNo { get; set; }
        public string PlacedDate { get; set; }
        public string EstDeliveryDate { get; set; }
        public int PaymentMethod { get; set; }
        public string PayMethodName { get; set; }
        public int PackageID { get; set; }
        public int OrderStatus { get; set; }
        public string OrderStatusName { get; set; }
        public int VendorID { get; set; }
        public string VendorName { get; set; }
        public int CustomerID { get; set; }
        public string CustomerName { get; set; }
    }
}