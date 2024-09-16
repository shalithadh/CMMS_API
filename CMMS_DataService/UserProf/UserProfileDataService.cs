using CMMS_Model.Authentication;
using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using CMMS_Model.UserProf;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_DataService.UserProf
{
    public class UserProfileDataService
    {
        public UserProfileMainViewModel GetUserProfileDetails(DB_Handle oDB_Handle, int UserID)
        {
            string sqlQuery;
            DataSet oDataSet = new DataSet();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_UserProfDetails";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@UserID", UserID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataSet);

                //user primary info table
                DataTable userPrimaryInfoTable = oDataSet.Tables[0];
                //user address table
                DataTable userAddressTable = oDataSet.Tables[1];
                //user contractor info table
                DataTable contractorInfoTable = oDataSet.Tables[2];
                //user vendor info table
                DataTable vendorInfoTable = oDataSet.Tables[3];

                List<UserProfPrimaryDetailModel> userPrimaryInfoModel = userPrimaryInfoTable.AsEnumerable().Select(row =>
                new UserProfPrimaryDetailModel
                {
                    UserID = row.Field<int>("UserID"),
                    Username = row.Field<string>("Username"),
                    Email = row.Field<string>("Email"),
                    FirstName = row.Field<string>("FirstName"),
                    LastName = row.Field<string>("LastName"),
                    UserRoleID = row.Field<int>("UserRoleID"),
                    RoleName = row.Field<string>("RoleName"),
                    NIC = row.Field<string>("NIC"),
                    MobileNo = row.Field<string>("MobileNo")
                }).ToList();

                List<UserProfAddressDetailModel> userAddressModel = userAddressTable.AsEnumerable().Select(row =>
                new UserProfAddressDetailModel
                {
                    AddressID = row.Field<int>("AddressID"),
                    UserID = row.Field<int>("UserID"),
                    Username = row.Field<string>("Username"),
                    Address1 = row.Field<string>("Address1"),
                    Address2 = row.Field<string>("Address2"),
                    Address3 = row.Field<string>("Address3"),
                    District = row.Field<string>("District"),
                    Province = row.Field<string>("Province")
                }).ToList();

                List<UserProfContractorDetailModel> userContractorModel = contractorInfoTable.AsEnumerable().Select(row =>
                new UserProfContractorDetailModel
                {
                    UserID = row.Field<int>("UserID"),
                    ServiceTypeID = row.Field<int>("ServiceTypeID"),
                    ServiceTypeName = row.Field<string>("ServiceTypeName")
                }).ToList();

                List<UserProfVendorDetailModel> userVendorModel = vendorInfoTable.AsEnumerable().Select(row =>
                new UserProfVendorDetailModel
                {
                    UserID = row.Field<int>("UserID"),
                    VendorCategoryTypeID = row.Field<int>("VendorCategoryTypeID"),
                    VendorCategoryName = row.Field<string>("VendorCategoryName")
                }).ToList();

                UserProfileMainViewModel userProfile = new UserProfileMainViewModel();
                userProfile.CusPrimaryInfo = userPrimaryInfoModel;
                userProfile.CusAddressInfo = userAddressModel;
                userProfile.CusContractorDInfo = userContractorModel;
                userProfile.CusVendorDInfo = userVendorModel;

                return userProfile;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<UserProfImgURLModel> GetUserProfImgUrlsByUserID(DB_Handle oDB_Handle, int UserID)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_UserProfImgUrlsByUserID";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@UserID", UserID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<UserProfImgURLModel> userImgURLs = oDataTable.AsEnumerable().Select(row =>
                new UserProfImgURLModel
                {
                    ImageName = row.Field<string>("ImageName"),
                    ImageURL = row.Field<string>("ImageURL")
                }).ToList();

                return userImgURLs;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<OutputMessageModel> UpdateUserProfDetails(DB_Handle oDB_Handle, UserProfUpdateModel user)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_UPDATE_UserProfDetails";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@UserID", user.UserID);
                oSqlCommand.Parameters.AddWithValue("@UserRoleID", user.UserRoleID);
                oSqlCommand.Parameters.AddWithValue("@FirstName", user.FirstName);
                oSqlCommand.Parameters.AddWithValue("@LastName", user.LastName);
                oSqlCommand.Parameters.AddWithValue("@NIC", user.NIC);
                oSqlCommand.Parameters.AddWithValue("@MobileNo", user.MobileNo);
                oSqlCommand.Parameters.AddWithValue("@Address1", user.Address1);
                oSqlCommand.Parameters.AddWithValue("@Address2", user.Address2);
                oSqlCommand.Parameters.AddWithValue("@Address3", user.Address3);
                oSqlCommand.Parameters.AddWithValue("@District", user.District);
                oSqlCommand.Parameters.AddWithValue("@Province", user.Province);
                oSqlCommand.Parameters.AddWithValue("@ContractorServiceList", user.ContractorServiceList);
                oSqlCommand.Parameters.AddWithValue("@VendorCategoryList", user.VendorCategoryList);
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

        public List<OutputMessageModel> SaveUserProfImageURLs(DB_Handle oDB_Handle, int UserID, string UserImgURLJson, string UserIP)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_ADD_UserProfImgURL";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@UserID", UserID);
                oSqlCommand.Parameters.AddWithValue("@UserImgURLJson", UserImgURLJson);
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

        public List<OutputMessageModel> UpdateUserProfPassword(DB_Handle oDB_Handle, UserProfChangePasswordModel user)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_UPDATE_UserProfChangePassword";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@UserID", user.UserID);
                oSqlCommand.Parameters.AddWithValue("@CurrentPassword", AESOperation.EncryptString(Constants.AESCustomKey, user.CurrentPassword));
                oSqlCommand.Parameters.AddWithValue("@NewPassword", AESOperation.EncryptString(Constants.AESCustomKey, user.NewPassword));
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
