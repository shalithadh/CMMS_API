using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.Email
{
    public class EmailModel
    {
        public string ToEmail { get; set; }
        public string MailSubject { get; set; }
        public string BodyContent { get; set; }
    }
}
