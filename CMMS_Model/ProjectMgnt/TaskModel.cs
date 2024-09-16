using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.ProjectMgnt
{
    public  class TaskModel
    {
        public int? TaskID { get; set; }
        public int ProjectID { get; set; }
        public string TaskName { get; set; }
        public decimal TaskRate { get; set; }
        public int TaskRateType { get; set; }
        public int TaskPriority { get; set; }
        public int TaskStatus { get; set; }
        public string Description { get; set; }
        public string StartDate { get; set; }
        public string StartTime { get; set; }
        public string EndDate { get; set; }
        public string EndTime { get; set; }
        public int ServiceType { get; set; }
        public int AssignTo { get; set; }
        public int? CreateUser { get; set; }
        public string? CreateIP { get; set; }
    }
}
