using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.ProjectMgnt
{
    public class ProjectModel
    {
        public int? ProjectID { get; set; }
        public string ProjectTitle { get; set; }
        public int ClientID { get; set; }
        public string? ClientName { get; set; }
        public int ProjectPriority { get; set; }
        public int ProjectSize { get; set; }
        public string StartDate { get; set; }
        public string StartTime { get; set; }
        public string EndDate { get; set; }
        public string EndTime { get; set; }
        public string Description { get; set; }
        public int ProjectStatus { get; set; }
        public int? CreateUser { get; set; }
        public string? CreateIP { get; set; }
    }
}
