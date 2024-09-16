using CMMS_Model.AdvMgnt;
using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.Intrinsics.Arm;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_DataService.AdvMgnt
{
    public class AdvMgntDataService
    {
        public List<AdvListViewModel> GetAdvListByUserID(DB_Handle oDB_Handle, int UserID, string StartDate, string EndDate)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_AdvMgntDetails";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@UserID", UserID);
                oSqlCommand.Parameters.AddWithValue("@StartDate", StartDate);
                oSqlCommand.Parameters.AddWithValue("@EndDate", EndDate);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<AdvListViewModel> advList = oDataTable.AsEnumerable().Select(row =>
                new AdvListViewModel
                {
                    AdvID = row.Field<int>("AdvID"),
                    CampaignName = row.Field<string>("CampaignName"),
                    Description = row.Field<string>("Description"),
                    StartDate = row.Field<string>("StartDate"),
                    EndDate = row.Field<string>("EndDate"),
                    IsActive = row.Field<bool>("IsActive")
                }).ToList();

                return advList;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<AdvImgURLModel> GetAdvImgUrlsByAdvID(DB_Handle oDB_Handle, int AdvID)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_AdvMgntImgUrlsByAdvID";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@AdvID", AdvID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<AdvImgURLModel> advImgURLs = oDataTable.AsEnumerable().Select(row =>
                new AdvImgURLModel
                {
                    ImageName = row.Field<string>("ImageName"),
                    ImageURL = row.Field<string>("ImageURL")
                }).ToList();

                return advImgURLs;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<OutputMessageModel> SaveAdvDetails(DB_Handle oDB_Handle, AdvModel adv)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_ADD_AdvMgntDetails";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@CampaignName", adv.CampaignName);
                oSqlCommand.Parameters.AddWithValue("@Description", adv.Description);
                oSqlCommand.Parameters.AddWithValue("@StartDate", adv.StartDate);
                oSqlCommand.Parameters.AddWithValue("@EndDate", adv.EndDate);
                oSqlCommand.Parameters.AddWithValue("@IsActive", adv.IsActive);
                oSqlCommand.Parameters.AddWithValue("@UserRoleID", adv.UserRoleID);
                oSqlCommand.Parameters.AddWithValue("@CreateUser", adv.CreateUser);
                oSqlCommand.Parameters.AddWithValue("@CreateIP", adv.CreateIP);
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

        public List<OutputMessageModel> UpdateAdvDetails(DB_Handle oDB_Handle, AdvModel adv)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_UPDATE_AdvMgntDetails";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@AdvID", adv.AdvID);
                oSqlCommand.Parameters.AddWithValue("@CampaignName", adv.CampaignName);
                oSqlCommand.Parameters.AddWithValue("@Description", adv.Description);
                oSqlCommand.Parameters.AddWithValue("@StartDate", adv.StartDate);
                oSqlCommand.Parameters.AddWithValue("@EndDate", adv.EndDate);
                oSqlCommand.Parameters.AddWithValue("@IsActive", adv.IsActive);
                oSqlCommand.Parameters.AddWithValue("@UserRoleID", adv.UserRoleID);
                oSqlCommand.Parameters.AddWithValue("@CreateUser", adv.CreateUser);
                oSqlCommand.Parameters.AddWithValue("@CreateIP", adv.CreateIP);
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

        public List<OutputMessageModel> SaveAdvImageURLs(DB_Handle oDB_Handle, int AdvID, string AdvImgURLJson, int UserID, string UserIP)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_ADD_AdvMgntImgURL";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@AdvID", AdvID);
                oSqlCommand.Parameters.AddWithValue("@AdvImgURLJson", AdvImgURLJson);
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
