using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.OrderMgnt
{
    public class OrderMgntInitialDataModel
    {
        public List<OrderMgntOrderStatusTypeModel> orderStatusTypes { get; set; }
    }

    public class OrderMgntOrderStatusTypeModel
    {
        public int ValueID { get; set; }
        public string Value { get; set; }
    }
}
