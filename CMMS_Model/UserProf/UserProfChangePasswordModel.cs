﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.UserProf
{
    public class UserProfChangePasswordModel
    {
        public int? UserID { get; set; }
        public string CurrentPassword { get; set; }
        public string NewPassword { get; set; }
        public int? CreateUser { get; set; }
        public string? CreateIP { get; set; }
    }
}
