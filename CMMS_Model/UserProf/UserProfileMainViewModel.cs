using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.UserProf
{
    public class UserProfileMainViewModel
    {
        public List<UserProfPrimaryDetailModel> CusPrimaryInfo { get; set; }
        public List<UserProfAddressDetailModel> CusAddressInfo { get; set; }
        public List<UserProfContractorDetailModel> CusContractorDInfo { get; set; }
        public List<UserProfVendorDetailModel> CusVendorDInfo { get; set; }
    }

    public class UserProfPrimaryDetailModel 
    {
        public int UserID { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int UserRoleID { get; set; }
        public string RoleName { get; set; }
        public string NIC { get; set; }
        public string MobileNo { get; set; }
    }

    public class UserProfAddressDetailModel
    {
        public int AddressID { get; set; }
        public int UserID { get; set; }
        public string Username { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string Address3 { get; set; }
        public string District { get; set; }
        public string Province { get; set; }
    }

    public class UserProfContractorDetailModel
    {
        public int UserID { get; set; }
        public int ServiceTypeID { get; set; }
        public string ServiceTypeName { get; set; }
    }

    public class UserProfVendorDetailModel
    {
        public int UserID { get; set; }
        public int VendorCategoryTypeID { get; set; }
        public string VendorCategoryName { get; set; }
    }

}
