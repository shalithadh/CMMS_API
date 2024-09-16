using CMMS_Model.DbAccess;
using CMMS_Model.Report;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_DataService.Report
{
    public class VendorReportDataService
    {
        public List<SalesOverviewModel> GetSalesOverviewDetails(DB_Handle oDB_Handle, int UserID, int Year, int Month)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_ReportMgntSalesOverview";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@UserID", UserID);
                oSqlCommand.Parameters.AddWithValue("@Year", Year);
                oSqlCommand.Parameters.AddWithValue("@Month", Month);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<SalesOverviewModel> reportDetails = oDataTable.AsEnumerable().Select(row =>
                new SalesOverviewModel
                {
                    PlacedDate = row.Field<string>("PlacedDate"),
                    PaymentMethod = row.Field<int>("PaymentMethod"),
                    PayMethodName = row.Field<string>("PayMethodName"),
                    Total = row.Field<decimal>("Total")
                }).ToList();

                return reportDetails;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<OrderStatusModel> GetOrderStatusDetails(DB_Handle oDB_Handle, int UserID, int Year, int Month)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_ReportMgntOrderStatus";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@UserID", UserID);
                oSqlCommand.Parameters.AddWithValue("@Year", Year);
                oSqlCommand.Parameters.AddWithValue("@Month", Month);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<OrderStatusModel> reportDetails = oDataTable.AsEnumerable().Select(row =>
                new OrderStatusModel
                {
                    PlacedDate = row.Field<string>("PlacedDate"),
                    ProcessingCount = row.Field<int>("ProcessingCount"),
                    ShippedCount = row.Field<int>("ShippedCount"),
                    DeliveredCount = row.Field<int>("DeliveredCount"),
                    CancelledCount = row.Field<int>("CancelledCount")
                }).ToList();

                return reportDetails;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<InventorySummaryModel> GetInventorySummaryDetails(DB_Handle oDB_Handle, int VendorCategoryTypeID, int UserID)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_ReportMgntInventory";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@VendorCategoryTypeID", VendorCategoryTypeID);
                oSqlCommand.Parameters.AddWithValue("@UserID", UserID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<InventorySummaryModel> reportDetails = oDataTable.AsEnumerable().Select(row =>
                new InventorySummaryModel
                {
                    ItemID = row.Field<int>("ItemID"),
                    VendorCategoryTypeID = row.Field<int>("VendorCategoryTypeID"),
                    VendorCategoryName = row.Field<string>("VendorCategoryName"),
                    ItemName = row.Field<string>("ItemName"),
                    UnitAmount = row.Field<decimal>("UnitAmount"),
                    TotalQty = row.Field<decimal>("TotalQty"),
                    SoldQty = row.Field<decimal>("SoldQty"),
                    AvailableQty = row.Field<decimal>("AvailableQty"),
                    IsActiveStatusName = row.Field<string>("IsActiveStatusName")
                }).ToList();

                return reportDetails;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<CustomerOverallModel> GetCustomerOverallDetails(DB_Handle oDB_Handle, int UserID, int Year, int Month)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_ReportMgntCustomerOverall";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@UserID", UserID);
                oSqlCommand.Parameters.AddWithValue("@Year", Year);
                oSqlCommand.Parameters.AddWithValue("@Month", Month);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<CustomerOverallModel> reportDetails = oDataTable.AsEnumerable().Select(row =>
                new CustomerOverallModel
                {
                    CustomerID = row.Field<int>("CustomerID"),
                    CustomerName = row.Field<string>("CustomerName"),
                    Total = row.Field<decimal>("Total")
                }).ToList();

                return reportDetails;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<PopularItemModel> GetPopularItemDetails(DB_Handle oDB_Handle, int UserID, int Year, int Month)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_ReportMgntPopularItem";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@UserID", UserID);
                oSqlCommand.Parameters.AddWithValue("@Year", Year);
                oSqlCommand.Parameters.AddWithValue("@Month", Month);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<PopularItemModel> reportDetails = oDataTable.AsEnumerable().Select(row =>
                new PopularItemModel
                {
                    ItemName = row.Field<string>("ItemName"),
                    VendorCategoryName = row.Field<string>("VendorCategoryName"),
                    SoldQty = row.Field<decimal>("SoldQty")
                }).ToList();

                return reportDetails;
            }
            catch (Exception)
            {
                throw;
            }
        }

    }
}
