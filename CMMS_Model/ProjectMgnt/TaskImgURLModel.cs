using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.ProjectMgnt
{

    public class TaskImgURLViewModel
    {
        public int TaskID { get; set; }
        public List<TaskImgURLModel> TaskImgURLs { get; set; }
    }

    public class TaskImgURLModel
    {
        public string ImageName { get; set; }
        public string ImageURL { get; set; }
    }
}
