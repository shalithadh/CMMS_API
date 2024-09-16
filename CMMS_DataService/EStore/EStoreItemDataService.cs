using CMMS_Model.DbAccess;
using CMMS_Model.EStore;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_DataService.EStore
{
    public class EStoreItemDataService
    {
        public EStoreInitialDataModel GetInitialEStoreItemData(DB_Handle oDB_Handle)
        {
            string sqlQuery;
            DataSet oDataSet = new DataSet();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_EStoreItemsInitialData";
                oSqlCommand = new SqlCommand();
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataSet);

                //vendor category types table
                DataTable vendorCategoryTypeTable = oDataSet.Tables[0];

                List<EStoreVendorCategoryTypeModel> eStoreVendorCategoryTypes = vendorCategoryTypeTable.AsEnumerable().Select(row =>
                new EStoreVendorCategoryTypeModel
                {
                    ValueID = row.Field<int>("ValueID"),
                    Value = row.Field<string>("Value")
                }).ToList();

                EStoreInitialDataModel eStoreInitialData = new EStoreInitialDataModel();
                eStoreInitialData.vendorCategoryTypes = eStoreVendorCategoryTypes;

                return eStoreInitialData;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<EStoreItemViewModel> GetEStoreItemList(DB_Handle oDB_Handle, int VendorCategoryTypeID)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_EStoreItemsForProductList";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@VendorCategoryTypeID", VendorCategoryTypeID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<EStoreItemViewModel> eStoreItems = oDataTable.AsEnumerable().Select(row =>
                new EStoreItemViewModel
                {
                    ItemID = row.Field<int>("ItemID"),
                    VendorCategoryTypeID = row.Field<int>("VendorCategoryTypeID"),
                    VendorCategoryName = row.Field<string>("VendorCategoryName"),
                    ItemName = row.Field<string>("ItemName"),
                    ItemDescription = row.Field<string>("ItemDescription"),
                    ItemImageURL = row.Field<string>("ItemImageURL"),
                    VendorID = row.Field<int>("VendorID"),
                    VendorName = row.Field<string>("VendorName"),
                    ItemWeight = row.Field<decimal>("ItemWeight"),
                    WeightUnit = row.Field<int>("WeightUnit"),
                    WeightUnitName = row.Field<string>("WeightUnitName"),
                    UOM = row.Field<int>("UOM"),
                    UOMName = row.Field<string>("UOMName"),
                    UnitAmount = row.Field<decimal>("UnitAmount"),
                    MinQty = row.Field<decimal>("MinQty"),
                    MaxQty = row.Field<decimal>("MaxQty"),
                    TotalQty = row.Field<decimal>("TotalQty"),
                    SoldQty = row.Field<decimal>("SoldQty"),
                    AvailableQty = row.Field<decimal>("AvailableQty"),
                    IsSoldUnitWise = row.Field<bool>("IsSoldUnitWise"),
                    IsActive = row.Field<bool>("IsActive")
                }).ToList();

                return eStoreItems;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<EStoreItemViewModel> GetEStoreItemListByItemID(DB_Handle oDB_Handle, int ItemID)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_EStoreItemsForProductPageByItemID";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@ItemID", ItemID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<EStoreItemViewModel> eStoreItems = oDataTable.AsEnumerable().Select(row =>
                new EStoreItemViewModel
                {
                    ItemID = row.Field<int>("ItemID"),
                    VendorCategoryTypeID = row.Field<int>("VendorCategoryTypeID"),
                    VendorCategoryName = row.Field<string>("VendorCategoryName"),
                    ItemName = row.Field<string>("ItemName"),
                    ItemDescription = row.Field<string>("ItemDescription"),
                    ItemImageURL = row.Field<string>("ItemImageURL"),
                    VendorID = row.Field<int>("VendorID"),
                    VendorName = row.Field<string>("VendorName"),
                    ItemWeight = row.Field<decimal>("ItemWeight"),
                    WeightUnit = row.Field<int>("WeightUnit"),
                    WeightUnitName = row.Field<string>("WeightUnitName"),
                    UOM = row.Field<int>("UOM"),
                    UOMName = row.Field<string>("UOMName"),
                    UnitAmount = row.Field<decimal>("UnitAmount"),
                    MinQty = row.Field<decimal>("MinQty"),
                    MaxQty = row.Field<decimal>("MaxQty"),
                    TotalQty = row.Field<decimal>("TotalQty"),
                    SoldQty = row.Field<decimal>("SoldQty"),
                    AvailableQty = row.Field<decimal>("AvailableQty"),
                    IsSoldUnitWise = row.Field<bool>("IsSoldUnitWise"),
                    IsActive = row.Field<bool>("IsActive")
                }).ToList();

                return eStoreItems;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<EStoreItemSearchModel> GetEStoreItemSearch(DB_Handle oDB_Handle, string? searchKeyword)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_EStoreItemsSearchItem";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@SearchKeyword", searchKeyword);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<EStoreItemSearchModel> eStoreItems = oDataTable.AsEnumerable().Select(row =>
                new EStoreItemSearchModel
                {
                    Value = row.Field<int>("Value"),
                    Label = row.Field<string>("Label"),
                    Desc = row.Field<string>("Desc")
                }).ToList();

                return eStoreItems;
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}
