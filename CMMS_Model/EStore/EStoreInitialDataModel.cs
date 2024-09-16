using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.EStore
{
    public class EStoreInitialDataModel
    {
        public List<EStoreVendorCategoryTypeModel> vendorCategoryTypes { get; set; }
    }

    public class EStoreVendorCategoryTypeModel
    {
        public int ValueID { get; set; }
        public string Value { get; set; }
    }
}
