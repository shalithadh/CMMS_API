using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.Email
{
    public class ProjectMgntEmailModel
    {
        public string ProMgntEmailSubject { get; set; }
        public string ProMgntEmailBody { get; set; }
    }

    public class ProTaskTestModel
    {
        public int TaskID { get; set; }
        public string Email { get; set; }
    }

}
