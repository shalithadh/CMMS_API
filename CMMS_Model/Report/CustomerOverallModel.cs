using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.Report
{
    public class CustomerOverallModel
    {
        public int CustomerID { get; set; }
        public string CustomerName { get; set; }
        public decimal Total { get; set; }
    }
}
