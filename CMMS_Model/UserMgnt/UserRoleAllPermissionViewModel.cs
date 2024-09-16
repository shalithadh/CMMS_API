using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.UserMgnt
{
    public class UserRoleAllPermissionViewModel
    {
        public int RowNo { get; set; }
        public int PermissionID { get; set; }
        public string ScreenName { get; set; }
        public string PermissionName { get; set; }
        public int? CreateUser { get; set; }
    }
}
