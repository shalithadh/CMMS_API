using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.AdvMgnt
{
    public class AdvImgURLViewModel
    {
        public int AdvID { get; set; }
        public List<AdvImgURLModel> AdvImgURLs { get; set; }
    }

    public class AdvImgURLModel
    {
        public string ImageName { get; set; }
        public string ImageURL { get; set; }
    }
}
