using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.UserProf
{
    public class UserProfImgURLViewModel
    {
        public int UserID { get; set; }
        public List<UserProfImgURLModel> UserImgURLs { get; set; }
    }

    public class UserProfImgURLModel
    {
        public string ImageName { get; set; }
        public string ImageURL { get; set; }
    }
}
