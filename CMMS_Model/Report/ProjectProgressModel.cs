using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.Report
{
    public class ProjectProgressModel
    {
        public int TaskID { get; set; }
        public int ProjectID { get; set; }
        public string ProjectTitle { get; set; }
        public string TaskName { get; set; }
        public string PriorityName { get; set; }
        public int TaskStatus { get; set; }
        public string TaskStatusName { get; set; }
        public string StartDate { get; set; }
        public string StartTime { get; set; }
        public string EndDate { get; set; }
        public string EndTime { get; set; }
        public int AssignTo { get; set; }
        public string AssignToName { get; set; }
    }
}
