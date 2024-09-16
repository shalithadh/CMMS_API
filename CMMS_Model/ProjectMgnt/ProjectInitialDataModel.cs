using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.ProjectMgnt
{
    public class ProjectInitialDataModel
    {
        public List<ProjectTypeModel> projectTypes { get; set; }
        public List<ProjectPriorityModel> projectPriorities { get; set; }
        public List<ProjectSizeModel> projectSizes { get; set; }
        public List<ProjectStatusModel> ProjectStatuses { get; set; }
    }

    public class ProjectTypeModel
    {
        public int ValueID { get; set; }
        public string Value { get; set; }
    }

    public class ProjectPriorityModel
    {
        public int ValueID { get; set; }
        public string Value { get; set; }
    }

    public class ProjectSizeModel
    {
        public int ValueID { get; set; }
        public string Value { get; set; }
    }

    public class ProjectStatusModel
    {
        public int ValueID { get; set; }
        public string Value { get; set; }
    }

}
