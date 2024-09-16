using CMMS_Model.EStore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.EStore
{
    public interface IEStoreItemApplicationService
    {
        EStoreInitialDataModel GetInitialEStoreItemData();
        List<EStoreItemViewModel> GetEStoreItemList(int VendorCategoryTypeID);
        List<EStoreItemViewModel> GetEStoreItemListByItemID(int ItemID);
        List<EStoreItemSearchModel> GetEStoreItemSearch(string? searchKeyword);
    }
}
