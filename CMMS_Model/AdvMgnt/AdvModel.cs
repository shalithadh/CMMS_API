using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.AdvMgnt
{
    public class AdvModel
    {
        public int? AdvID { get; set; }
        public string CampaignName { get; set; }
        public string Description { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }     
        public bool IsActive { get; set; }
        public int? UserRoleID { get; set; }
        public int? CreateUser { get; set; }
        public string? CreateIP { get; set; }
    }
}
