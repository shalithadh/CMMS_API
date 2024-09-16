using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.Email
{
    public class EmailSender
    {
        public string SendMail(string fromEmail, string toEmail, string mailSubject, string bodyContent)
        {
            string sendMail = "";
            try
            {

                MailMessage mailMessage = new MailMessage(fromEmail, toEmail, mailSubject, bodyContent);

                mailMessage.IsBodyHtml = true;
                SmtpClient smtpClient = new SmtpClient("smtp.gmail.com", 587);
                smtpClient.EnableSsl = true;
                smtpClient.UseDefaultCredentials = false;
                smtpClient.Credentials = new NetworkCredential(fromEmail, EmailCredentials.Password);
                smtpClient.Send(mailMessage);

                sendMail = "SUCCESS";


            }
            catch (Exception ex)
            {

                sendMail = "FAILED";

            }
            return sendMail;
        }
    }
}
