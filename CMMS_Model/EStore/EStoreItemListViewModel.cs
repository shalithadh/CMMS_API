using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.EStore
{
    public class EStoreItemListViewModel
    {
        public List<EStoreItemViewModel> eStoreItems { get; set; }
    }

    public class EStoreItemViewModel
    {
        public int ItemID { get; set; }
        public int VendorCategoryTypeID { get; set; }
        public string VendorCategoryName { get; set; }
        public string ItemName { get; set; }
        public string ItemDescription { get; set; }
        public string ItemImageURL { get; set; }
        public int VendorID { get; set; }
        public string VendorName { get; set; }
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
    }
}
