using CMMS_Model.Email;
using CMMS_Model.UserMgnt;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.Email
{
    public interface IUserMgntEmailApplicationService
    {
        UserMgntEmailModel GeneratePasswordResetEmailToUser(UserMgntAllUserViewModel user, string TempPassword);
    }
}
