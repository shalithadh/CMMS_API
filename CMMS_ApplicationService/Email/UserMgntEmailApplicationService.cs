using CMMS_Model.Email;
using CMMS_Model.UserMgnt;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.Email
{
    public class UserMgntEmailApplicationService: IUserMgntEmailApplicationService
    {

        public UserMgntEmailModel GeneratePasswordResetEmailToUser(UserMgntAllUserViewModel user, string TempPassword)
        {

            UserMgntEmailModel emailModel = new UserMgntEmailModel();
            var emailBody = "";

            try
            {
                var emailHead = "";

                var emailHeaderTableHead =
                  "<p>Hi! "+ user.FirstName + ", </p>" +
                  "<br/>" +
                  "<center>" +
                  "<table border=" + 0 + " cellpadding=" + 0 + " cellspacing=" + 0 + " width = '100%'>" +
                  //row1
                  "<tr>" +
                  "<td>Please find the temporary password to access your account. </td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "</tr>" +
                  //row2
                  "<tr>" +
                  "<td>Temporary Password: <b>" + TempPassword + "</b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "</tr>" +
                  "</table>" +
                  "</center>" +
                  "<br/><br/>"
                  ;

                //Email Head
                emailHead = emailHeaderTableHead;

                //Email Footer
                var emailFooter = "<center><p><b>This is an auto-generated mail from CMMS.</b></p></center>";

                //Full Email
                emailBody = emailHead + emailFooter;

                emailModel.UMEmailSubject = "Admin has reset your CMMS account password";
                emailModel.UMEmailBody = emailBody;

                return emailModel;
            }
            catch (Exception)
            {
                emailModel.UMEmailBody = "Failed";
                return emailModel;
                throw;
            }
        }

    }
}
