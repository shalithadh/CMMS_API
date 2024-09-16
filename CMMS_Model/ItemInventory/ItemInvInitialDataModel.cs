using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.ItemInventory
{
    public class ItemInvInitialDataModel
    {
        public List<VendorCategoryTypeModel> vendorCategoryTypes { get; set; }
        public List<WeightUnitModel> weightUnits { get; set; }
        public List<ItemUOMModel> itemUOMs { get; set; }
    }

    public class VendorCategoryTypeModel
    {
        public int ValueID { get; set; }
        public string Value { get; set; }
    }

    public class WeightUnitModel
    {
        public int ValueID { get; set; }
        public string Value { get; set; }
    }

    public class ItemUOMModel
    {
        public int ValueID { get; set; }
        public string Value { get; set; }
    }
}
