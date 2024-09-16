using CMMS_DataService.UserProf;
using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using CMMS_Model.UserProf;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.UserProf
{
    public class UserProfileApplicationService : IUserProfileApplicationService
    {
        DB_Handle oDB_Handle = new DB_Handle();

        public UserProfileMainViewModel GetUserProfileDetails(int UserID)
        {
            UserProfileDataService userProfileDataService = new UserProfileDataService();
            UserProfileMainViewModel userProfile = new UserProfileMainViewModel();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                userProfile = userProfileDataService.GetUserProfileDetails(oDB_Handle, UserID);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return userProfile;
        }

        public List<UserProfImgURLModel> GetUserProfImgUrlsByUserID(int UserID)
        {
            UserProfileDataService userProfileDataService = new UserProfileDataService();
            List<UserProfImgURLModel> userImgURLs = new List<UserProfImgURLModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                userImgURLs = userProfileDataService.GetUserProfImgUrlsByUserID(oDB_Handle, UserID);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return userImgURLs;
        }

        public List<OutputMessageModel> UpdateUserProfDetails(UserProfUpdateModel user)
        {
            UserProfileDataService userProfileDataService = new UserProfileDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                msgModel = userProfileDataService.UpdateUserProfDetails(oDB_Handle, user);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return msgModel;
        }

        public List<OutputMessageModel> SaveUserProfImageURLs(int UserID, List<UserProfImgURLModel> userImgURLs, string UserIP)
        {
            UserProfileDataService userProfileDataService = new UserProfileDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                //Convert List object to JSON string
                var UserImgURLJson = JsonConvert.SerializeObject(userImgURLs.Select(
                x => new
                {
                    x.ImageName,
                    x.ImageURL
                }
                ).ToList());

                msgModel = userProfileDataService.SaveUserProfImageURLs(oDB_Handle, UserID, UserImgURLJson, UserIP);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return msgModel;
        }

        public List<OutputMessageModel> UpdateUserProfPassword(UserProfChangePasswordModel user)
        {
            UserProfileDataService userProfileDataService = new UserProfileDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                msgModel = userProfileDataService.UpdateUserProfPassword(oDB_Handle, user);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return msgModel;
        }

    }
}
