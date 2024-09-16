using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.UserAccount
{
    public class UserRegInitialDataModel
    {
        public List<UserRoleTypeModel> userRoleTypes { get; set; }
        public List<ServiceTypeModel> serviceTypes { get; set; }
        public List<VendorCategoryType> vendorCategoryTypes { get; set; }
    }

    public class UserRoleTypeModel
    {
        public int ValueID { get; set; }
        public string Value { get; set; }
    }

    public class ServiceTypeModel
    {
        public int ValueID { get; set; }
        public string Value { get; set; }
    }

    public class VendorCategoryType
    {
        public int ValueID { get; set; }
        public string Value { get; set; }
    }
}
