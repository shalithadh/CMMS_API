using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.UserMgnt
{
    public class UserMgntResetPasswordModel
    {
        public int UserID { get; set; }
        public string? TempPassword { get; set; }
        public int? CreateUser { get; set; }
        public string? CreateIP { get; set; }
    }
}
