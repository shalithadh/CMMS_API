using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.ProjectMgnt
{
    public class AssignToComboModel
    {
        public List<AssignToContactorList> contactorList { get; set; }
    }

    public class AssignToContactorList
    {
        public int ValueID { get; set; }
        public string Value { get; set; }
    }
}
