using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.ProjectMgnt
{
    public class TaskInitialDataModel
    {
        public List<TaskRateTypeModel> taskRateTypes { get; set; }
        public List<TaskPriorityModel> taskPriorities { get; set; }
        public List<TaskStatusModel> taskStatuses { get; set; }
        public List<TaskServiceTypeModel> taskServiceTypes { get; set; }
    }

    public class TaskRateTypeModel
    {
        public int ValueID { get; set; }
        public string Value { get; set; }
    }

    public class TaskPriorityModel
    {
        public int ValueID { get; set; }
        public string Value { get; set; }
    }

    public class TaskStatusModel
    {
        public int ValueID { get; set; }
        public string Value { get; set; }
    }

    public class TaskServiceTypeModel
    {
        public int ValueID { get; set; }
        public string Value { get; set; }
    }
}
