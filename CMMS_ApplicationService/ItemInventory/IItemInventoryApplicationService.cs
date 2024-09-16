using CMMS_Model.Common;
using CMMS_Model.ItemInventory;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.ItemInventory
{
    public interface IItemInventoryApplicationService
    {
        ItemInvInitialDataModel GetInitialItemInventoryData(int VendorID);
        List<ItemInvListViewModal> GetItemInvListByUserID(int VendorCategoryTypeID, int VendorID);
        List<ItemImgURLModel> GetItemInvImgUrlsByItemID(int ItemID);
        List<OutputMessageModel> SaveItemInvDetails(ItemModel item);
        List<OutputMessageModel> UpdateItemInvDetails(ItemModel item);
        List<OutputMessageModel> SaveItemImageURLs(int ItemID, List<ItemImgURLModel> itemImgURLs, int UserID, string UserIP);
    }
}
