using CMMS_DataService.UserAccount;
using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using CMMS_Model.UserAccount;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.UserAccount
{
    public class UserAuthApplicationService : IUserAuthApplicationService
    {
        DB_Handle oDB_Handle = new DB_Handle();

        public UserLogin AuthorizeUser(UserDetail user)
        {
            UserAuthDataService userAuthDataService = new UserAuthDataService();
            UserLogin userLogin = new UserLogin();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                userLogin = userAuthDataService.AuthorizeUser(oDB_Handle, user);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return userLogin;
        }

        public string[] GetAllUserPermissions()
        {
            UserAuthDataService userAuthDataService = new UserAuthDataService();
            string[] userPermissions;

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                userPermissions = userAuthDataService.GetAllUserPermissions(oDB_Handle);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return userPermissions;
        }

        public string[] GetUserPermissions(int UserID)
        {
            UserAuthDataService userAuthDataService = new UserAuthDataService();
            string[] userPermissions;

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                userPermissions = userAuthDataService.GetUserPermissions(oDB_Handle, UserID);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return userPermissions;
        }

        public UserRegInitialDataModel GetInitialUserRegData()
        {
            UserAuthDataService userAuthDataService = new UserAuthDataService();
            UserRegInitialDataModel userRegInitialData = new UserRegInitialDataModel();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                userRegInitialData = userAuthDataService.GetInitialUserRegData(oDB_Handle);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return userRegInitialData;
        }

        public List<OutputMessageModel> SaveUserDetails(UserRegistration user)
        {
            UserAuthDataService userAuthDataService = new UserAuthDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                msgModel = userAuthDataService.SaveUserDetails(oDB_Handle, user);

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

        public List<OutputMessageModel> ResetUserLoginPassword(UserPassResetModel user)
        {
            UserAuthDataService userAuthDataService = new UserAuthDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                msgModel = userAuthDataService.ResetUserLoginPassword(oDB_Handle, user);

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
