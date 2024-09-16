using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.OrderMgnt
{
    public class OrderMgntStatusUpdateModel
    {
        public int OrderID { get; set; }
        public int PackageID { get; set; }
        public int OrderStatus { get; set; }
        public int? CreateUser { get; set; }
        public string? CreateIP { get; set; }
    }
}
