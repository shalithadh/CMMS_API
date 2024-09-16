using CMMS_Model.Common;
using CMMS_Model.Email;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.Email
{
    public interface IEmailMgntApplicationService
    {
        List<OutputMessageModel> SendGeneratedEmail(EmailModel email);
    }
}
