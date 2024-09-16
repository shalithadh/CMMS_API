using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.UserAccount
{
    public class UserPassResetModel
    {
        public string Username { get; set; }
        public string NewPassword { get; set; }
        public string? CreateIP { get; set; }
    }
}
