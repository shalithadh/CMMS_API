using CMMS_Model.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.UserAccount
{
    public class UserLogin
    {
        public UserDetail userDetail { get; set; }
        public OutputMessageModel outputMessage { get; set; }
    }
}
