using CMMS_DataService.EStore;
using CMMS_Model.DbAccess;
using CMMS_Model.EStore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.EStore
{
    public class EStoreItemApplicationService: IEStoreItemApplicationService
    {
        DB_Handle oDB_Handle = new DB_Handle();

        public EStoreInitialDataModel GetInitialEStoreItemData()
        {
            EStoreItemDataService eStoreItemDataService = new EStoreItemDataService();
            EStoreInitialDataModel eStoreInitialData = new EStoreInitialDataModel();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                eStoreInitialData = eStoreItemDataService.GetInitialEStoreItemData(oDB_Handle);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return eStoreInitialData;
        }

        public List<EStoreItemViewModel> GetEStoreItemList(int VendorCategoryTypeID)
        {
            EStoreItemDataService eStoreItemDataService = new EStoreItemDataService();
            List<EStoreItemViewModel> eStoreItems = new List<EStoreItemViewModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                eStoreItems = eStoreItemDataService.GetEStoreItemList(oDB_Handle, VendorCategoryTypeID);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return eStoreItems;
        }

        public List<EStoreItemViewModel> GetEStoreItemListByItemID(int ItemID)
        {
            EStoreItemDataService eStoreItemDataService = new EStoreItemDataService();
            List<EStoreItemViewModel> eStoreItem = new List<EStoreItemViewModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                eStoreItem = eStoreItemDataService.GetEStoreItemListByItemID(oDB_Handle, ItemID);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return eStoreItem;
        }

        public List<EStoreItemSearchModel> GetEStoreItemSearch(string? searchKeyword)
        {
            EStoreItemDataService eStoreItemDataService = new EStoreItemDataService();
            List<EStoreItemSearchModel> eStoreItems = new List<EStoreItemSearchModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                eStoreItems = eStoreItemDataService.GetEStoreItemSearch(oDB_Handle, searchKeyword);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return eStoreItems;
        }

    }
}
