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
    public class UserRoleDataService
    {
        public UserRoleInitialDataModel GetInitialUserRolePermiData(DB_Handle oDB_Handle)
        {
            string sqlQuery;
            DataSet oDataSet = new DataSet();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_UserRoleInitialData";
                oSqlCommand = new SqlCommand();
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataSet);

                //uer role table
                DataTable userRoleTable = oDataSet.Tables[0];

                List<UserRolePermiModel> userRoles = userRoleTable.AsEnumerable().Select(row =>
                new UserRolePermiModel
                {
                    ValueID = row.Field<int>("ValueID"),
                    Value = row.Field<string>("Value")
                }).ToList();
;

                UserRoleInitialDataModel userRoleInitialData = new UserRoleInitialDataModel();
                userRoleInitialData.userRoles= userRoles;

                return userRoleInitialData;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<UserRoleAllPermissionViewModel> GetUserRoleAllPermissions(DB_Handle oDB_Handle)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_UserRoleAllPermissions";
                oSqlCommand = new SqlCommand();
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<UserRoleAllPermissionViewModel> userRoleAllPermissions = oDataTable.AsEnumerable().Select(row =>
                new UserRoleAllPermissionViewModel
                {
                    RowNo = row.Field<int>("RowNo"),
                    PermissionID = row.Field<int>("PermissionID"),
                    ScreenName = row.Field<string>("ScreenName"),
                    PermissionName = row.Field<string>("PermissionName")
                }).ToList();

                return userRoleAllPermissions;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<UserRolePermiByRoleIDViewModel> GetUserRolePermissionsByRoleID(DB_Handle oDB_Handle, int RoleID)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_UserRolePermissionsByRoleID";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@RoleID", RoleID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<UserRolePermiByRoleIDViewModel> userRoleAllPermissions = oDataTable.AsEnumerable().Select(row =>
                new UserRolePermiByRoleIDViewModel
                {
                    PermissionID = row.Field<int>("PermissionID"),
                    ScreenName = row.Field<string>("ScreenName"),
                    PermissionName = row.Field<string>("PermissionName")
                }).ToList();

                return userRoleAllPermissions;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<OutputMessageModel> SaveUserRolePermissionDetails(DB_Handle oDB_Handle, UserRoleWiseViewModel user, string RoleWisePermissionJson)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_ADD_UserRolePermissionDetails";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@RoleID", user.RoleID);
                oSqlCommand.Parameters.AddWithValue("@RoleWisePermissionJson", RoleWisePermissionJson);
                oSqlCommand.Parameters.AddWithValue("@CreateUser", user.CreateUser);
                oSqlCommand.Parameters.AddWithValue("@CreateIP", user.CreateIP);
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
