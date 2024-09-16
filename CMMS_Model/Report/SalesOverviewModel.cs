using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.Report
{
    public class SalesOverviewModel
    {
        public string PlacedDate { get; set; }
        public int PaymentMethod { get; set; }
        public string PayMethodName { get; set; }
        public decimal Total { get; set; }
    }
}
