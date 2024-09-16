using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.UserProf
{
    public class UserProfUpdateModel
    {
        public int? UserID { get; set; }
        public int? UserRoleID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string NIC { get; set; }
        public string MobileNo { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string Address3 { get; set; }
        public string District { get; set; }
        public string Province { get; set; }
        public string? ContractorServiceList { get; set; }
        public string? VendorCategoryList { get; set; }
        public int? CreateUser { get; set; }
        public string? CreateIP { get; set; }
    }
}
