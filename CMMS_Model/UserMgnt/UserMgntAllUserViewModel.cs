using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.UserMgnt
{
    public class UserMgntAllUserViewModel
    {
        public int UserID { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int UserRoleID { get; set; }
        public string RoleName { get; set; }
        public bool IsActive { get; set; }
        public string IsActiveStatusName { get; set; }
    }
}
