using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.UserMgnt
{
    public class UserRoleInitialDataModel
    {
        public List<UserRolePermiModel> userRoles { get; set; }
    }

    public class UserRolePermiModel
    {
        public int ValueID { get; set; }
        public string Value { get; set; }
    }

}
