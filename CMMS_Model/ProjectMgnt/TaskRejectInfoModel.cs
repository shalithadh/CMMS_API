using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.ProjectMgnt
{
    public class TaskRejectInfoModel
    {
        public int TaskID { get; set; }
        public string Reason { get; set; }
        public int? CreateUser { get; set; }
        public string? CreateIP { get; set; }
    }
}
