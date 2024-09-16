using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.Report
{
    public class ContractorReviewInitialModel
    {
        public List<YearMstrModel> years { get; set; }
        public List<MonthMstrModel> months { get; set; }
    }

    public class YearMstrModel
    {
        public int ValueID { get; set; }
        public string Value { get; set; }
    }

    public class MonthMstrModel
    {
        public int ValueID { get; set; }
        public string Value { get; set; }
    }

}
