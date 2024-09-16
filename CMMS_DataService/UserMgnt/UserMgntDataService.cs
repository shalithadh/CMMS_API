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
    public class UserMgntDataService
    {
        public List<UserMgntAllUserViewModel> GetAllUserDetails(DB_Handle oDB_Handle)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_UserMgntLoadAllUsers";
                oSqlCommand = new SqlCommand();
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<UserMgntAllUserViewModel> users = oDataTable.AsEnumerable().Select(row =>
                new UserMgntAllUserViewModel
                {
                    UserID = row.Field<int>("UserID"),
                    Username = row.Field<string>("Username"),
                    Email = row.Field<string>("Email"),
                    FirstName = row.Field<string>("FirstName"),
                    LastName = row.Field<string>("LastName"),
                    UserRoleID = row.Field<int>("UserRoleID"),
                    RoleName = row.Field<string>("RoleName"),
                    IsActive = row.Field<bool>("IsActive"),
                    IsActiveStatusName = row.Field<string>("IsActiveStatusName")
                }).ToList();

                return users;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<UserMgntAllUserViewModel> GetUserDetailsByUserID(DB_Handle oDB_Handle, int UserID)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_UserMgntLoadUserByUserID";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@UserID", UserID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<UserMgntAllUserViewModel> users = oDataTable.AsEnumerable().Select(row =>
                new UserMgntAllUserViewModel
                {
                    UserID = row.Field<int>("UserID"),
                    Username = row.Field<string>("Username"),
                    Email = row.Field<string>("Email"),
                    FirstName = row.Field<string>("FirstName"),
                    LastName = row.Field<string>("LastName"),
                    UserRoleID = row.Field<int>("UserRoleID"),
                    RoleName = row.Field<string>("RoleName"),
                    IsActive = row.Field<bool>("IsActive"),
                    IsActiveStatusName = row.Field<string>("IsActiveStatusName")
                }).ToList();

                return users;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<OutputMessageModel> ResetUserPassword(DB_Handle oDB_Handle, UserMgntResetPasswordModel user)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_UPDATE_UserMgntResetPassword";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@UserID", user.UserID);
                oSqlCommand.Parameters.AddWithValue("@TempPassword", user.TempPassword);
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

        public List<OutputMessageModel> UpdateUserStatusDetails(DB_Handle oDB_Handle, UserMgntChangeUserStatusModel user)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_UPDATE_UserMgntChangeUserStatus";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@UserID", user.UserID);
                oSqlCommand.Parameters.AddWithValue("@Status", user.Status);
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

    }
}
