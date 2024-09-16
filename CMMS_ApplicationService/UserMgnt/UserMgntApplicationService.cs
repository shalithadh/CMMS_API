using CMMS_ApplicationService.Email;
using CMMS_DataService.UserMgnt;
using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using CMMS_Model.Email;
using CMMS_Model.UserMgnt;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.UserMgnt
{
    public class UserMgntApplicationService: IUserMgntApplicationService
    {
        DB_Handle oDB_Handle = new DB_Handle();

        public List<UserMgntAllUserViewModel> GetAllUserDetails()
        {
            UserMgntDataService userMgntDataService = new UserMgntDataService();
            List<UserMgntAllUserViewModel> users = new List<UserMgntAllUserViewModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                users = userMgntDataService.GetAllUserDetails(oDB_Handle);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return users;
        }

        public List<UserMgntAllUserViewModel> GetUserDetailsByUserID(int UserID)
        {
            UserMgntDataService userMgntDataService = new UserMgntDataService();
            List<UserMgntAllUserViewModel> users = new List<UserMgntAllUserViewModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                users = userMgntDataService.GetUserDetailsByUserID(oDB_Handle, UserID);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return users;
        }

        public List<OutputMessageModel> ResetUserPassword(UserMgntResetPasswordModel user)
        {
            UserMgntDataService userMgntDataService = new UserMgntDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                msgModel = userMgntDataService.ResetUserPassword(oDB_Handle, user);

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

        public List<OutputMessageModel> UpdateUserStatusDetails(UserMgntChangeUserStatusModel user)
        {
            UserMgntDataService userMgntDataService = new UserMgntDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                msgModel = userMgntDataService.UpdateUserStatusDetails(oDB_Handle, user);

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

        public void SendUserResetPasswordEmails(int UserID, string TempPassword)
        {

            IUserMgntApplicationService userMgntApplication = new UserMgntApplicationService();
            IUserMgntEmailApplicationService userMgntEmailApplication = new UserMgntEmailApplicationService();
            IEmailMgntApplicationService emailMgntApplication = new EmailMgntApplicationService();

            List<UserMgntAllUserViewModel> users = new List<UserMgntAllUserViewModel>();
            users = userMgntApplication.GetUserDetailsByUserID(UserID);

            #region Send Email to User
            UserMgntEmailModel userMgntEmailModel = new UserMgntEmailModel();
            userMgntEmailModel = userMgntEmailApplication.GeneratePasswordResetEmailToUser(users[0], TempPassword);

            EmailModel emailModel = new EmailModel();
            emailModel.ToEmail = users[0].Email;
            emailModel.MailSubject = userMgntEmailModel.UMEmailSubject;
            emailModel.BodyContent = userMgntEmailModel.UMEmailBody;

            var output1 = emailMgntApplication.SendGeneratedEmail(emailModel);
            #endregion

        }

    }
}
