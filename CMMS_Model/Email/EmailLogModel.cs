using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.Email
{
    public class EmailLogModel
    {
        public string FromEmail { get; set; }
        public string ToEmail { get; set; }
        public string MailSubject { get; set; }
        public string MailBody { get; set; }
        public bool IsSent { get; set; }
    }
}
