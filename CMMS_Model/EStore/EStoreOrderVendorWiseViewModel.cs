using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.EStore
{
    public class EStoreOrderVendorWiseViewModel
    {
        public int VendorID { get; set; }
        public string VendorName { get; set; }
        public string Email { get; set; }
        public int OrderID { get; set; }
        public int PackageID { get; set; }
        public int OrderDetailStatus { get; set; }
        public string OrderStatusName { get; set; }
    }
}
