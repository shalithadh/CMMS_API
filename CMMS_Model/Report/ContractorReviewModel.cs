using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.Report
{
    public class ContractorReviewModel
    {
        public int ContractorID { get; set; }
        public string ContractorName { get; set; }
        public decimal OverallRating { get; set; }
    }
}
