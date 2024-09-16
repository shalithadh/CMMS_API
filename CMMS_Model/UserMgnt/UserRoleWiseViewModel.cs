using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.UserMgnt
{
    public class UserRoleWiseViewModel
    {
        public int RoleID { get; set; }
        public List<UserRoleWiseModel> UserRolePermiList { get; set; }
        public int? CreateUser { get; set; }
        public string? CreateIP { get; set; }
    }

    public class UserRoleWiseModel
    {
        public int PermissionID { get; set; }
    }

}
