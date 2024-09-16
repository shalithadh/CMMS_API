using CMMS_DataService.ItemInventory;
using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using CMMS_Model.ItemInventory;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.ItemInventory
{
    public class ItemInventoryApplicationService: IItemInventoryApplicationService
    {
        DB_Handle oDB_Handle = new DB_Handle();

        public ItemInvInitialDataModel GetInitialItemInventoryData(int VendorID)
        {
            ItemInventoryDataService itemInventoryDataService = new ItemInventoryDataService();
            ItemInvInitialDataModel initialDataModel = new ItemInvInitialDataModel();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                initialDataModel = itemInventoryDataService.GetInitialItemInventoryData(oDB_Handle, VendorID);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return initialDataModel;
        }

        public List<ItemInvListViewModal> GetItemInvListByUserID(int VendorCategoryTypeID, int VendorID)
        {
            ItemInventoryDataService itemInventoryDataService = new ItemInventoryDataService();
            List<ItemInvListViewModal> itemInvLists = new List<ItemInvListViewModal>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                itemInvLists = itemInventoryDataService.GetItemInvListByUserID(oDB_Handle, VendorCategoryTypeID, VendorID);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return itemInvLists;
        }

        public List<ItemImgURLModel> GetItemInvImgUrlsByItemID( int ItemID)
        {
            ItemInventoryDataService itemInventoryDataService = new ItemInventoryDataService();
            List<ItemImgURLModel> itemImgURLs = new List<ItemImgURLModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                itemImgURLs = itemInventoryDataService.GetItemInvImgUrlsByItemID(oDB_Handle, ItemID);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return itemImgURLs;
        }

        public List<OutputMessageModel> SaveItemInvDetails(ItemModel item)
        {
            ItemInventoryDataService itemInventoryDataService = new ItemInventoryDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                msgModel = itemInventoryDataService.SaveItemInvDetails(oDB_Handle, item);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return msgModel;
        }

        public List<OutputMessageModel> UpdateItemInvDetails(ItemModel item)
        {
            ItemInventoryDataService itemInventoryDataService = new ItemInventoryDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                msgModel = itemInventoryDataService.UpdateItemInvDetails(oDB_Handle, item);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return msgModel;
        }

        public List<OutputMessageModel> SaveItemImageURLs(int ItemID, List<ItemImgURLModel> itemImgURLs, int UserID, string UserIP)
        {
            ItemInventoryDataService itemInventoryDataService = new ItemInventoryDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                //Convert List object to JSON string
                var TaskImgURLJson = JsonConvert.SerializeObject(itemImgURLs.Select(
                x => new
                {
                    x.ImageName,
                    x.ImageURL
                }
                ).ToList());

                msgModel = itemInventoryDataService.SaveItemImageURLs(oDB_Handle, ItemID, TaskImgURLJson, UserID, UserIP);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return msgModel;
        }

    }
}
