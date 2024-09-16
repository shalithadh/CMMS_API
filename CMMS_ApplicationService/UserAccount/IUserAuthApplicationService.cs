using CMMS_Model.Common;
using CMMS_Model.UserAccount;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.UserAccount
{
    public interface IUserAuthApplicationService
    {
        UserLogin AuthorizeUser(UserDetail user);
        string[] GetAllUserPermissions();
        string[] GetUserPermissions(int UserID);
        UserRegInitialDataModel GetInitialUserRegData();
        public List<OutputMessageModel> SaveUserDetails(UserRegistration user);
        List<OutputMessageModel> ResetUserLoginPassword(UserPassResetModel user);
    }
}
