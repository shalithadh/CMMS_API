using CMMS_Model.Common;
using CMMS_Model.UserProf;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.UserProf
{
    public interface IUserProfileApplicationService
    {
        UserProfileMainViewModel GetUserProfileDetails(int UserID);
        List<UserProfImgURLModel> GetUserProfImgUrlsByUserID(int UserID);
        List<OutputMessageModel> UpdateUserProfDetails(UserProfUpdateModel user);
        List<OutputMessageModel> SaveUserProfImageURLs(int UserID, List<UserProfImgURLModel> userImgURLs, string UserIP);
        List<OutputMessageModel> UpdateUserProfPassword(UserProfChangePasswordModel user);
    }
}
