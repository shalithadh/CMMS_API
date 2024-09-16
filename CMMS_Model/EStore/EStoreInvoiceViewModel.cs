using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.EStore
{
    public class EStoreInvoiceViewModel
    {
        public List<EStoreOrderHistoryMainViewModel> OrderInfo { get; set; }
        public List<EStoreOrderWiseItemView> OrderItemInfo { get; set; }
        public List<EStoreOrderVendorWiseViewModel> OrderVendorInfo { get; set; }
    }
}
