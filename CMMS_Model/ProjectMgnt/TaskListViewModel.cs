using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.ProjectMgnt
{
    public class TaskListViewModel
    {
        public int TaskID { get; set; }
        public int ProjectID { get; set; }
        public string ProjectTitle { get; set; }
        public string TaskName { get; set; }
        public decimal TaskRate { get; set; }
        public int TaskRateType { get; set; }
        public string TaskRateTypeName { get; set; }
        public int TaskPriority { get; set; }
        public string PriorityName { get; set; }
        public int TaskStatus { get; set; }
        public string TaskStatusName { get; set; }
        public string Description { get; set; }
        public string StartDate { get; set; }
        public string StartTime { get; set; }
        public string EndDate { get; set; }
        public string EndTime { get; set; }
        public int ServiceType { get; set; }
        public string ServiceTypeName { get; set; }
        public string? ClientEmail { get; set; }
        public int AssignTo { get; set; }
        public string AssignToName { get; set; }
        public string? ContractorEmail { get; set; }
        public int ApprovalStatus { get; set; }
        public int CreateUser { get; set; }
    }
}
