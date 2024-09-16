using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using CMMS_Model.UserMgnt;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.UserMgnt
{
    public interface IUserMgntApplicationService
    {
        List<UserMgntAllUserViewModel> GetAllUserDetails();
        List<UserMgntAllUserViewModel> GetUserDetailsByUserID(int UserID);
        List<OutputMessageModel> ResetUserPassword(UserMgntResetPasswordModel user);
        List<OutputMessageModel> UpdateUserStatusDetails(UserMgntChangeUserStatusModel user);
        void SendUserResetPasswordEmails(int UserID, string TempPassword);
    }
}
