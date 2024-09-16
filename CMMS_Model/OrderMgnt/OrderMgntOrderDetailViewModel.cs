using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.OrderMgnt
{
    public class OrderMgntOrderDetailViewModel
    {
        public List<OrderMgntHeaderViewModel> OrderHeaderInfo { get; set; }
        public List<OrderMgntItemViewModel> OrderDetailInfo { get; set; }
    }

    public class OrderMgntHeaderViewModel
    {
        public int OrderID { get; set; }
        public string OrderNo { get; set; }
        public int PackageID { get; set; }
        public int OrderDetailStatus { get; set; }
        public string OrderStatusName { get; set; }
        public string CustomerName { get; set; }
        public decimal Total { get; set; }
    }

    public class OrderMgntItemViewModel
    {
        public int ItemID { get; set; }
        public string ItemName { get; set; }
        public int OrderID { get; set; }
        public int PackageID { get; set; }
        public decimal UnitAmount { get; set; }
        public decimal Quantity { get; set; }
        public decimal DiscountAmount { get; set; }
        public decimal ItemWiseTotal { get; set; }
        public int VendorID { get; set; }
        public string VendorName { get; set; }
        public int OrderDetailStatus { get; set; }
        public string OrderStatusName { get; set; }
    }
}
