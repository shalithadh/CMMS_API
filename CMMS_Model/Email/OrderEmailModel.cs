using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.Email
{

    public class OrderEmailModel
    {
        public string OrderEmailSubject { get; set; }
        public string OrderEmailBody { get; set; }
    }

    public class CusOrderTestModel
    {
        public int OrderID { get; set; }
        public int CustomerID { get; set; }
        public string Email { get; set; }
    }

}
