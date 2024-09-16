using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.ItemInventory
{
    public class ItemInvListViewModal
    {
        public int ItemID { get; set; }
        public int VendorCategoryTypeID { get; set; }
        public string VendorCategoryName { get; set; }
        public string ItemName { get; set; }
        public string ItemDescription { get; set; }
        public decimal ItemWeight { get; set; }
        public int WeightUnit { get; set; }
        public string WeightUnitName { get; set; }
        public int UOM { get; set; }
        public string UOMName { get; set; }
        public decimal UnitAmount { get; set; }
        public decimal MinQty { get; set; }
        public decimal MaxQty { get; set; }
        public decimal TotalQty { get; set; }
        public decimal SoldQty { get; set; }
        public decimal AvailableQty { get; set; }
        public bool IsSoldUnitWise { get; set; }
        public bool IsActive { get; set; }
        public string IsActiveStatusName { get; set; }
    }
}
