using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using CMMS_Model.ItemInventory;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_DataService.ItemInventory
{
    public class ItemInventoryDataService
    {
        public ItemInvInitialDataModel GetInitialItemInventoryData(DB_Handle oDB_Handle, int VendorID)
        {
            string sqlQuery;
            DataSet oDataSet = new DataSet();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_ItemInvInitialData";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@VendorID", VendorID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataSet);

                //vendor category types table
                DataTable vendorCategoryTable = oDataSet.Tables[0];
                //weight unit table
                DataTable weightUnitTable = oDataSet.Tables[1];
                //uom table
                DataTable uomTable = oDataSet.Tables[2];

                List<VendorCategoryTypeModel> vendorCategoryTypes = vendorCategoryTable.AsEnumerable().Select(row =>
                new VendorCategoryTypeModel
                {
                    ValueID = row.Field<int>("ValueID"),
                    Value = row.Field<string>("Value")
                }).ToList();

                List<WeightUnitModel> weightUnits = weightUnitTable.AsEnumerable().Select(row =>
                new WeightUnitModel
                {
                    ValueID = row.Field<int>("ValueID"),
                    Value = row.Field<string>("Value")
                }).ToList();

                List<ItemUOMModel> itemUOMs = uomTable.AsEnumerable().Select(row =>
                new ItemUOMModel
                {
                    ValueID = row.Field<int>("ValueID"),
                    Value = row.Field<string>("Value")
                }).ToList();

                ItemInvInitialDataModel taskInitialData = new ItemInvInitialDataModel();
                taskInitialData.vendorCategoryTypes = vendorCategoryTypes;
                taskInitialData.weightUnits = weightUnits;
                taskInitialData.itemUOMs = itemUOMs;

                return taskInitialData;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<ItemInvListViewModal> GetItemInvListByUserID(DB_Handle oDB_Handle, int VendorCategoryTypeID, int VendorID)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_ItemInvListByUserID";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@VendorCategoryTypeID", VendorCategoryTypeID);
                oSqlCommand.Parameters.AddWithValue("@VendorID", VendorID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<ItemInvListViewModal> invItemList = oDataTable.AsEnumerable().Select(row =>
                new ItemInvListViewModal
                {
                    ItemID = row.Field<int>("ItemID"),
                    VendorCategoryTypeID = row.Field<int>("VendorCategoryTypeID"),
                    VendorCategoryName = row.Field<string>("VendorCategoryName"),
                    ItemName = row.Field<string>("ItemName"),
                    ItemDescription = row.Field<string>("ItemDescription"),
                    ItemWeight = row.Field<decimal>("ItemWeight"),
                    WeightUnit = row.Field<int>("WeightUnit"),
                    UOM = row.Field<int>("UOM"),
                    UOMName = row.Field<string>("UOMName"),
                    UnitAmount = row.Field<decimal>("UnitAmount"),
                    MinQty = row.Field<decimal>("MinQty"),
                    MaxQty = row.Field<decimal>("MaxQty"),
                    TotalQty = row.Field<decimal>("TotalQty"),
                    SoldQty = row.Field<decimal>("SoldQty"),
                    AvailableQty = row.Field<decimal>("AvailableQty"),
                    IsSoldUnitWise = row.Field<bool>("IsSoldUnitWise"),
                    IsActive = row.Field<bool>("IsActive"),
                    IsActiveStatusName = row.Field<string>("IsActiveStatusName")
                }).ToList();

                return invItemList;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<ItemImgURLModel> GetItemInvImgUrlsByItemID(DB_Handle oDB_Handle, int ItemID)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_ItemInvImgUrlsByItemID";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@ItemID", ItemID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<ItemImgURLModel> itemImgURLs = oDataTable.AsEnumerable().Select(row =>
                new ItemImgURLModel
                {
                    ImageName = row.Field<string>("ImageName"),
                    ImageURL = row.Field<string>("ImageURL")
                }).ToList();

                return itemImgURLs;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<OutputMessageModel> SaveItemInvDetails(DB_Handle oDB_Handle, ItemModel item)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_ADD_ItemInventory";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@VendorCategoryTypeID", item.VendorCategoryTypeID);
                oSqlCommand.Parameters.AddWithValue("@ItemName", item.ItemName);
                oSqlCommand.Parameters.AddWithValue("@ItemDescription", item.ItemDescription);
                oSqlCommand.Parameters.AddWithValue("@ItemWeight", item.ItemWeight);
                oSqlCommand.Parameters.AddWithValue("@WeightUnit", item.WeightUnit);
                oSqlCommand.Parameters.AddWithValue("@UOM", item.UOM);
                oSqlCommand.Parameters.AddWithValue("@UnitAmount", item.UnitAmount);
                oSqlCommand.Parameters.AddWithValue("@MinQty", item.MinQty);
                oSqlCommand.Parameters.AddWithValue("@MaxQty", item.MaxQty);
                oSqlCommand.Parameters.AddWithValue("@Qty", item.Qty);
                oSqlCommand.Parameters.AddWithValue("@VendorID", item.VendorID);
                oSqlCommand.Parameters.AddWithValue("@IsSoldUnitWise", item.IsSoldUnitWise);
                oSqlCommand.Parameters.AddWithValue("@IsActive", item.IsActive);
                oSqlCommand.Parameters.AddWithValue("@CreateUser", item.CreateUser);
                oSqlCommand.Parameters.AddWithValue("@CreateIP", item.CreateIP);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<OutputMessageModel> msgModel = oDataTable.AsEnumerable().Select(row =>
                new OutputMessageModel
                {
                    OutputInfo = row.Field<string>("outputInfo"),
                    RsltType = row.Field<int>("rsltType"),
                    SavedID = row.Field<int>("savedID")
                }).ToList();

                return msgModel;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<OutputMessageModel> UpdateItemInvDetails(DB_Handle oDB_Handle, ItemModel item)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_UPDATE_ItemInventory";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@ItemID", item.ItemID);
                oSqlCommand.Parameters.AddWithValue("@VendorCategoryTypeID", item.VendorCategoryTypeID);
                oSqlCommand.Parameters.AddWithValue("@ItemName", item.ItemName);
                oSqlCommand.Parameters.AddWithValue("@ItemDescription", item.ItemDescription);
                oSqlCommand.Parameters.AddWithValue("@ItemWeight", item.ItemWeight);
                oSqlCommand.Parameters.AddWithValue("@WeightUnit", item.WeightUnit);
                oSqlCommand.Parameters.AddWithValue("@UOM", item.UOM);
                oSqlCommand.Parameters.AddWithValue("@UnitAmount", item.UnitAmount);
                oSqlCommand.Parameters.AddWithValue("@MinQty", item.MinQty);
                oSqlCommand.Parameters.AddWithValue("@MaxQty", item.MaxQty);
                oSqlCommand.Parameters.AddWithValue("@Qty", item.Qty);
                oSqlCommand.Parameters.AddWithValue("@VendorID", item.VendorID);
                oSqlCommand.Parameters.AddWithValue("@IsSoldUnitWise", item.IsSoldUnitWise);
                oSqlCommand.Parameters.AddWithValue("@IsActive", item.IsActive);
                oSqlCommand.Parameters.AddWithValue("@CreateUser", item.CreateUser);
                oSqlCommand.Parameters.AddWithValue("@CreateIP", item.CreateIP);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<OutputMessageModel> msgModel = oDataTable.AsEnumerable().Select(row =>
                new OutputMessageModel
                {
                    OutputInfo = row.Field<string>("outputInfo"),
                    RsltType = row.Field<int>("rsltType")
                }).ToList();

                return msgModel;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<OutputMessageModel> SaveItemImageURLs(DB_Handle oDB_Handle, int ItemID, string ItemImgURLJson, int UserID, string UserIP)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_ADD_ItemInventoryImgURL";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@ItemID", ItemID);
                oSqlCommand.Parameters.AddWithValue("@ItemImgURLJson", ItemImgURLJson);
                oSqlCommand.Parameters.AddWithValue("@CreateUser", UserID);
                oSqlCommand.Parameters.AddWithValue("@CreateIP", UserIP);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<OutputMessageModel> msgModel = oDataTable.AsEnumerable().Select(row =>
                new OutputMessageModel
                {
                    OutputInfo = row.Field<string>("outputInfo"),
                    RsltType = row.Field<int>("rsltType")
                }).ToList();

                return msgModel;
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}
