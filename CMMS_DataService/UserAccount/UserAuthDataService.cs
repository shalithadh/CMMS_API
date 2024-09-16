using CMMS_Model.Authentication;
using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using CMMS_Model.UserAccount;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_DataService.UserAccount
{
    public class UserAuthDataService
    {
        public UserLogin AuthorizeUser(DB_Handle oDB_Handle, UserDetail user)
        {
            string sqlQuery;
            DataSet oDataSet = new DataSet();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_AuthorizeUser";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@Username", user.UserName);
                oSqlCommand.Parameters.AddWithValue("@Password", AESOperation.EncryptString(Constants.AESCustomKey, user.Password));
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataSet);

                //user detail table
                DataTable userTable = oDataSet.Tables[0];
                //output message table
                DataTable outputMsgTable = oDataSet.Tables[1];

                IList<UserDetail> userDetails = userTable.AsEnumerable().Select(row =>
                new UserDetail
                {
                    UserID = row.Field<int>("UserID"),
                    UserName = row.Field<string>("Username"),
                    Name = row.Field<string>("FullName"),
                    RoleID = row.Field<int>("UserRoleID"),
                    RoleName = row.Field<string>("UserRoleName"),
                    AttemptCount = row.Field<int>("AttemptCount"),
                    IsTempPassword = row.Field<bool>("IsTempPassword"),
                    //Common Parameters
                    DeliveryCharge = row.Field<decimal>("DeliveryCharge")
                }).ToList();

                IList<OutputMessageModel> outputs = outputMsgTable.AsEnumerable().Select(row =>
                new OutputMessageModel
                {
                    OutputInfo = row.Field<string>("outputInfo"),
                    RsltType = row.Field<int>("rsltType")
                }).ToList();

                UserLogin userLogin = new UserLogin();
                if(userDetails.Count > 0) 
                {
                    userLogin.userDetail = userDetails[0];
                }
                else 
                {
                    userLogin.userDetail = null;
                }              
                userLogin.outputMessage = outputs[0];

                return userLogin;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public string[] GetAllUserPermissions(DB_Handle oDB_Handle)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_UserAllPermissionList";
                oSqlCommand = new SqlCommand();
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                string[] userPermissions = oDataTable.Rows.OfType<DataRow>().Select(k => k[0].ToString()).ToArray();

                return userPermissions;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public string[] GetUserPermissions(DB_Handle oDB_Handle, int UserID)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_UserPermissionList";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@UserID", UserID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                string[] userPermissions = oDataTable.Rows.OfType<DataRow>().Select(k => k[0].ToString()).ToArray();

                return userPermissions;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public UserRegInitialDataModel GetInitialUserRegData(DB_Handle oDB_Handle)
        {
            string sqlQuery;
            DataSet oDataSet = new DataSet();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_UserRegInitialData";
                oSqlCommand = new SqlCommand();
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataSet);

                //user roles table
                DataTable userRoleTable = oDataSet.Tables[0];
                //service types table
                DataTable serviceTypeTable = oDataSet.Tables[1];
                //vendor category type table
                DataTable vendorCategoryTypeTable = oDataSet.Tables[2];

                List<UserRoleTypeModel> userRoles = userRoleTable.AsEnumerable().Select(row =>
                new UserRoleTypeModel
                {
                    ValueID = row.Field<int>("ValueID"),
                    Value = row.Field<string>("Value")
                }).ToList();

                List<ServiceTypeModel> serviceTypes = serviceTypeTable.AsEnumerable().Select(row =>
                new ServiceTypeModel
                {
                    ValueID = row.Field<int>("ValueID"),
                    Value = row.Field<string>("Value")
                }).ToList();

                List<VendorCategoryType> vendorCategoryTypes = vendorCategoryTypeTable.AsEnumerable().Select(row =>
                new VendorCategoryType
                {
                    ValueID = row.Field<int>("ValueID"),
                    Value = row.Field<string>("Value")
                }).ToList();


                UserRegInitialDataModel userRegInitialData = new UserRegInitialDataModel();
                userRegInitialData.userRoleTypes = userRoles;
                userRegInitialData.serviceTypes = serviceTypes;
                userRegInitialData.vendorCategoryTypes = vendorCategoryTypes;

                return userRegInitialData;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<OutputMessageModel> SaveUserDetails(DB_Handle oDB_Handle, UserRegistration user)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_ADD_UserDetails";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@FirstName", user.FirstName);
                oSqlCommand.Parameters.AddWithValue("@LastName", user.LastName);
                oSqlCommand.Parameters.AddWithValue("@Username", user.Username);
                oSqlCommand.Parameters.AddWithValue("@Email", user.Email);
                oSqlCommand.Parameters.AddWithValue("@Password", AESOperation.EncryptString(Constants.AESCustomKey, user.Password));
                oSqlCommand.Parameters.AddWithValue("@NIC", user.NIC);
                oSqlCommand.Parameters.AddWithValue("@MobileNo", user.MobileNo);
                oSqlCommand.Parameters.AddWithValue("@Address1", user.Address1);
                oSqlCommand.Parameters.AddWithValue("@Address2", user.Address2);
                oSqlCommand.Parameters.AddWithValue("@Address3", user.Address3);
                oSqlCommand.Parameters.AddWithValue("@District", user.District);
                oSqlCommand.Parameters.AddWithValue("@Province", user.Province);
                oSqlCommand.Parameters.AddWithValue("@UserRoleID", user.UserRoleID);
                oSqlCommand.Parameters.AddWithValue("@ContractorServiceList", user.ContractorServiceList);
                oSqlCommand.Parameters.AddWithValue("@VendorCategoryList", user.VendorCategoryList);
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

        public List<OutputMessageModel> ResetUserLoginPassword(DB_Handle oDB_Handle, UserPassResetModel user)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_UPDATE_UserLoginChangePassword";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@Username", user.Username);
                oSqlCommand.Parameters.AddWithValue("@NewPassword", AESOperation.EncryptString(Constants.AESCustomKey, user.NewPassword));
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
