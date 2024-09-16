using CMMS_Model.ProjectMgnt;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.EStore
{
    public class EStoreOrderDetail
    {
        public int PaymentMethod { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string Address3 { get; set; }
        public string District { get; set; }
        public string Province { get; set; }
        public string Remarks { get; set; }
        public decimal Discount { get; set; }
        public decimal SubTotal { get; set; }
        public decimal DeliveryCharge { get; set; }
        public decimal Total { get; set; }
        public int? CreateUser { get; set; }
        public string? CreateIP { get; set; }
        public List<EStoreOrderCartDetail> EStoreCartInfo { get; set; }
    }

    public class EStoreOrderCartDetail
    {
        public int ItemID { get; set; }
        public decimal UnitAmount { get; set; }
        public decimal Quantity { get; set; }
        public decimal DiscountAmount { get; set; }
        public decimal ItemWiseTotal { get; set; }
        public int VendorID { get; set; }
    }
}
