using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.ItemInventory
{
    public class ItemModel
    {
        public int? ItemID { get; set; }
        public int VendorCategoryTypeID { get; set; }
        public string ItemName { get; set; }
        public string ItemDescription { get; set; }
        public decimal ItemWeight { get; set; }
        public int WeightUnit { get; set; }
        public int UOM { get; set; }
        public decimal UnitAmount { get; set; }
        public decimal MinQty { get; set; }
        public decimal MaxQty { get; set; }
        public decimal Qty { get; set; }
        public int? VendorID { get; set; }
        public bool IsSoldUnitWise { get; set; }
        public bool IsActive { get; set; }
        public int? CreateUser { get; set; }
        public string? CreateIP { get; set; }
    }
}
