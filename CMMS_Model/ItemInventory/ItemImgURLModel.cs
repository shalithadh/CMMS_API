using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.ItemInventory
{
    public class ItemImgURLViewModel
    {
        public int ItemID { get; set; }
        public List<ItemImgURLModel> ItemImgURLs { get; set; }
    }

    public class ItemImgURLModel
    {
        public string ImageName { get; set; }
        public string ImageURL { get; set; }
    }
}
