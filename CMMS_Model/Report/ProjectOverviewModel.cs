using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.Report
{
    public class ProjectOverviewModel
    {
        public int ProjectID { get; set; }
        public string ProjectTitle { get; set; }
        public string ClientName { get; set; }
        public string PriorityName { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string ProjectStatusName { get; set; }
        public int NewTaskCount { get; set; }
        public int InProgressTaskCount { get; set; }
        public int CompleteTaskCount { get; set; }
        public decimal ProjectProgress { get; set; }
    }
}
