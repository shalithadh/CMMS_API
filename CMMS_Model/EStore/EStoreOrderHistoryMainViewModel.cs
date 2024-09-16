using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.EStore
{
    public class EStoreOrderHistoryMainViewModel
    {
        public int OrderID { get; set; }
        public string OrderNo { get; set; }
        public string PlacedDate { get; set; }
        public string EstDeliveryDate { get; set; }
        public int PaymentMethod { get; set; }
        public string PayMethodName { get; set; }
        public string ClientName { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string Address3 { get; set; }
        public string District { get; set; }
        public string Province { get; set; }
        public string MobileNo { get; set; }
        public string Email { get; set; }
        public decimal Discount { get; set; }
        public decimal SubTotal { get; set; }
        public decimal DeliveryCharge { get; set; }
        public decimal Total { get; set; }
    }
}
