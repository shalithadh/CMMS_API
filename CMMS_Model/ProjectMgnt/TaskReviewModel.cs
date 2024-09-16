using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.ProjectMgnt
{
    public class TaskReviewModel
    {
        public int TaskID { get; set; }
        public int Rating { get; set; }
        public string Comment { get; set; }
        public int ContractorID { get; set; }
        public bool IsVisitedSite { get; set; }
        public int? CreateUser { get; set; }
        public string? CreateIP { get; set; }
    }
}
