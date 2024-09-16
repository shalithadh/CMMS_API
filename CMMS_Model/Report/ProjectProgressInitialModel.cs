using CMMS_Model.ProjectMgnt;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.Report
{
    public class ProjectProgressInitialModel
    {
        public List<ProjectDetailModel> projectDetails { get; set; }
    }

    public class ProjectDetailModel
    {
        public int ValueID { get; set; }
        public string Value { get; set; }
    }

}
