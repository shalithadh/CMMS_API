using CMMS_DataService.Email;
using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using CMMS_Model.Email;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.Email
{
    public class EmailMgntApplicationService: IEmailMgntApplicationService
    {
        DB_Handle oDB_Handle = new DB_Handle();

        public List<OutputMessageModel> SendGeneratedEmail(EmailModel email)
        {
            EmailMgntDataService emailMgntDataService = new EmailMgntDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
            EmailLogModel emailLog = new EmailLogModel();
            EmailSender emailSender = new EmailSender();

            try
            {
                var outputMsg = emailSender.SendMail(EmailCredentials.EmailName, email.ToEmail, email.MailSubject, email.BodyContent);

                emailLog.FromEmail = EmailCredentials.EmailName;
                emailLog.ToEmail = email.ToEmail;
                emailLog.MailSubject = email.MailSubject;
                emailLog.MailBody = email.BodyContent;
                if (outputMsg == "SUCCESS") { 
                    emailLog.IsSent = true;
                }
                else
                {
                    emailLog.IsSent = false;
                }

                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                msgModel = emailMgntDataService.SaveEmailLogDetails(oDB_Handle, emailLog);

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
