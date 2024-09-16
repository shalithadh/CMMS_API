using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using CMMS_Model.UserMgnt;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_DataService.UserMgnt
{
    public class PermissionDataService
    {
        public List<PermissionModel> GetAllPermissionDetails(DB_Handle oDB_Handle)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_PermissionDetails";
                oSqlCommand = new SqlCommand();
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<PermissionModel> permissions = oDataTable.AsEnumerable().Select(row =>
                new PermissionModel
                {
                    PermissionID = row.Field<int>("PermissionID"),
                    ScreenName = row.Field<string>("ScreenName"),
                    PermissionName = row.Field<string>("PermissionName"),
                    IsActive = row.Field<bool>("IsActive")
                }).ToList();

                return permissions;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<OutputMessageModel> AddPermissionDetails(DB_Handle oDB_Handle, PermissionModel permission)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_ADD_PermissionDetails";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@ScreenName", permission.ScreenName);
                oSqlCommand.Parameters.AddWithValue("@PermissionName", permission.PermissionName);
                oSqlCommand.Parameters.AddWithValue("@IsActive", permission.IsActive);
                oSqlCommand.Parameters.AddWithValue("@CreateUser", permission.CreateUser);
                oSqlCommand.Parameters.AddWithValue("@CreateIP", permission.CreateIP);
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

        public List<OutputMessageModel> UpdatePermissionDetails(DB_Handle oDB_Handle, PermissionModel permission)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_UPDATE_PermissionDetails";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@PermissionID", permission.PermissionID);
                oSqlCommand.Parameters.AddWithValue("@ScreenName", permission.ScreenName);
                oSqlCommand.Parameters.AddWithValue("@PermissionName", permission.PermissionName);
                oSqlCommand.Parameters.AddWithValue("@IsActive", permission.IsActive);
                oSqlCommand.Parameters.AddWithValue("@CreateUser", permission.CreateUser);
                oSqlCommand.Parameters.AddWithValue("@CreateIP", permission.CreateIP);
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
