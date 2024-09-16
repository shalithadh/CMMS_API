using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.Report
{
    public class InventorySummaryModel
    {
        public int ItemID { get; set; }
        public int VendorCategoryTypeID { get; set; }
        public string VendorCategoryName { get; set; }
        public string ItemName { get; set; }
        public decimal UnitAmount { get; set; }
        public decimal TotalQty { get; set; }
        public decimal SoldQty { get; set; }
        public decimal AvailableQty { get; set; }
        public string IsActiveStatusName { get; set; }
    }
}
