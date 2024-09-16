using CMMS_Model.Dashboard;
using CMMS_Model.DbAccess;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_DataService.Dashboard
{
    public class DashboardDataService
    {
        public AdminDashboardModel GetAdminDashboardDetails(DB_Handle oDB_Handle)
        {
            string sqlQuery;
            DataSet oDataSet = new DataSet();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_DashBoardAdminDetails";
                oSqlCommand = new SqlCommand();
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataSet);

                DataTable totalSalesTable = oDataSet.Tables[0];
                DataTable totalItemsTable = oDataSet.Tables[1];
                DataTable totalOrdersTable = oDataSet.Tables[2];
                DataTable totalUsersTable = oDataSet.Tables[3];
                DataTable bestContractorTable = oDataSet.Tables[4];
                DataTable bestCustomerTable = oDataSet.Tables[5];
                DataTable bestVendorTable = oDataSet.Tables[6];
                DataTable recentProjectsTable = oDataSet.Tables[7];
                DataTable recentOrdersTable = oDataSet.Tables[8];

                List<AdminTotalSalesModel> adminTotalSalesModel = totalSalesTable.AsEnumerable().Select(row =>
                new AdminTotalSalesModel
                {
                    TotalSales = row.Field<decimal>("TotalSales")

                }).ToList();

                List<AdminTotalItemsModel> adminTotalItemsModel = totalItemsTable.AsEnumerable().Select(row =>
                new AdminTotalItemsModel
                {
                    TotalItems = row.Field<int>("TotalItems")

                }).ToList();

                List<AdminTotalOrdersModel> adminTotalOrdersModel = totalOrdersTable.AsEnumerable().Select(row =>
                new AdminTotalOrdersModel
                {
                    TotalOrders = row.Field<int>("TotalOrders")

                }).ToList();

                List<AdminTotalUsersModel> adminTotalUsersModel = totalUsersTable.AsEnumerable().Select(row =>
                new AdminTotalUsersModel
                {
                    TotalUsers = row.Field<int>("TotalUsers")

                }).ToList();

                List<AdminBestContractorModel> adminBestContractorModel = bestContractorTable.AsEnumerable().Select(row =>
                new AdminBestContractorModel
                {
                    BestContractor = row.Field<string>("BestContractor")

                }).ToList();

                List<AdminBestCustomerModel> adminBestCustomerModel = bestCustomerTable.AsEnumerable().Select(row =>
                new AdminBestCustomerModel
                {
                    BestCustomer = row.Field<string>("BestCustomer")

                }).ToList();

                List<AdminBestVendorModel> adminBestVendorModel = bestVendorTable.AsEnumerable().Select(row =>
                new AdminBestVendorModel
                {
                    BestVendor = row.Field<string>("BestVendor")

                }).ToList();

                List<AdminRecentProjectModel> adminRecentProjectModel = recentProjectsTable.AsEnumerable().Select(row =>
                new AdminRecentProjectModel
                {
                    ProjectTitle = row.Field<string>("ProjectTitle"),
                    ContractorName = row.Field<string>("ContractorName"),
                    ClientName = row.Field<string>("ClientName"),
                    ProjectProgress = row.Field<decimal>("ProjectProgress")
                }).ToList();

                List<AdminRecentOrderModel> adminRecentOrderModel = recentOrdersTable.AsEnumerable().Select(row =>
                new AdminRecentOrderModel
                {
                    OrderNo = row.Field<string>("OrderNo"),
                    VendorName = row.Field<string>("VendorName"),
                    CustomerName = row.Field<string>("CustomerName"),
                    PlacedDate = row.Field<string>("PlacedDate")
                }).ToList();

                AdminDashboardModel adminDashboard = new AdminDashboardModel();
                adminDashboard.adminTotalSales = adminTotalSalesModel;
                adminDashboard.adminTotalItems = adminTotalItemsModel;
                adminDashboard.adminTotalOrders = adminTotalOrdersModel;
                adminDashboard.adminTotalUsers = adminTotalUsersModel;
                adminDashboard.adminBestContractors = adminBestContractorModel;
                adminDashboard.adminBestCustomers = adminBestCustomerModel;
                adminDashboard.adminBestVendors = adminBestVendorModel;
                adminDashboard.adminRecentProjects = adminRecentProjectModel;
                adminDashboard.adminRecentOrders = adminRecentOrderModel;
                return adminDashboard;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public ContractorDashboardModel GetContractorDashboardDetails(DB_Handle oDB_Handle, int UserID)
        {
            string sqlQuery;
            DataSet oDataSet = new DataSet();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_DashBoardContractorDetails";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@UserID", UserID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataSet);

                DataTable totalProjectsTable = oDataSet.Tables[0];
                DataTable bestClientTable = oDataSet.Tables[1];
                DataTable overallRatingTable = oDataSet.Tables[2];
                DataTable recentProjectTable = oDataSet.Tables[3];
                DataTable recentCompletedTasksTable = oDataSet.Tables[4];

                List<ContractorTotalProjectsModel> contractorTotalProjectsModel = totalProjectsTable.AsEnumerable().Select(row =>
                new ContractorTotalProjectsModel
                {
                    TotalProjects = row.Field<int>("TotalProjects")

                }).ToList();

                List<ContractorBestClientModel> contractorBestClientModel = bestClientTable.AsEnumerable().Select(row =>
                new ContractorBestClientModel
                {
                    BestClient = row.Field<string>("BestClient")

                }).ToList();

                List<ContractorOverallRatingModel> contractorOverallRatingModel = overallRatingTable.AsEnumerable().Select(row =>
                new ContractorOverallRatingModel
                {
                    MyOverallRating = row.Field<decimal>("MyOverallRating")

                }).ToList();
             
                List<ContractorRecentProjectModel>  contractorRecentProjectModel = recentProjectTable.AsEnumerable().Select(row =>
                new ContractorRecentProjectModel
                {
                    ProjectTitle = row.Field<string>("ProjectTitle"),
                    ClientName = row.Field<string>("ClientName"),
                    ProjectProgress = row.Field<decimal>("ProjectProgress")
                }).ToList();

                List<ContractorRecentCompletedTasksModel> contractorRecentCompletedTasksModel = recentCompletedTasksTable.AsEnumerable().Select(row =>
                new ContractorRecentCompletedTasksModel
                {
                    TaskName = row.Field<string>("TaskName"),
                    ProjectTitle = row.Field<string>("ProjectTitle"),
                    ClientName = row.Field<string>("ClientName"),
                    CompletedDate = row.Field<string>("CompletedDate")
                }).ToList();

                ContractorDashboardModel contractorDashboard = new ContractorDashboardModel();
                contractorDashboard.contractorTotalProjects = contractorTotalProjectsModel;
                contractorDashboard.contractorBestClients = contractorBestClientModel;
                contractorDashboard.contractorOverallRatings = contractorOverallRatingModel;
                contractorDashboard.contractorRecentProjects = contractorRecentProjectModel;
                contractorDashboard.contractorRecentCompletedTasks = contractorRecentCompletedTasksModel;
                return contractorDashboard;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public VendorDashboardModel GetVendorDashboardDetails(DB_Handle oDB_Handle, int UserID)
        {
            string sqlQuery;
            DataSet oDataSet = new DataSet();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_DashBoardVendorDetails";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@UserID", UserID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataSet);

                DataTable totalOrdersTable = oDataSet.Tables[0];
                DataTable bestCustomerTable = oDataSet.Tables[1];
                DataTable totalItemsTable = oDataSet.Tables[2];
                DataTable recentOrdersTable = oDataSet.Tables[3];
                DataTable recentItemsTable = oDataSet.Tables[4];

                List<VendorTotalOrdersModel> vendorTotalOrdersModel = totalOrdersTable.AsEnumerable().Select(row =>
                new VendorTotalOrdersModel
                {
                    TotalOrders = row.Field<int>("TotalOrders")

                }).ToList();

                List<VendorBestCustomerModel> vendorBestCustomerModel = bestCustomerTable.AsEnumerable().Select(row =>
                new VendorBestCustomerModel
                {
                    BestCustomer = row.Field<string>("BestCustomer")

                }).ToList();

                List<VendorTotalItemsModel> vendorTotalItemsModel = totalItemsTable.AsEnumerable().Select(row =>
                new VendorTotalItemsModel
                {
                    TotalItems = row.Field<int>("TotalItems")

                }).ToList();

                List<VendorRecentOrdersModel> vendorRecentOrdersModel = recentOrdersTable.AsEnumerable().Select(row =>
                new VendorRecentOrdersModel
                {
                    OrderNo = row.Field<string>("OrderNo"),
                    CustomerName = row.Field<string>("CustomerName"),
                    PlacedDate = row.Field<string>("PlacedDate")
                }).ToList();

                List<VendorRecentItemsModel> vendorRecentItemsModel = recentItemsTable.AsEnumerable().Select(row =>
                new VendorRecentItemsModel
                {
                    ItemName = row.Field<string>("ItemName"),
                    Category = row.Field<string>("Category"),
                    AddedDate = row.Field<string>("AddedDate"),
                    StockAvailability = row.Field<string>("StockAvailability")
                }).ToList();

                VendorDashboardModel vendorDashboard = new VendorDashboardModel();
                vendorDashboard.vendorTotalOrders = vendorTotalOrdersModel;
                vendorDashboard.vendorBestCustomer = vendorBestCustomerModel;
                vendorDashboard.vendorTotalItems = vendorTotalItemsModel;
                vendorDashboard.vendorRecentOrders = vendorRecentOrdersModel;
                vendorDashboard.vendorRecentItems = vendorRecentItemsModel;
                return vendorDashboard;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public CustomerDashboardModel GetCustomerDashboardDetails(DB_Handle oDB_Handle, int UserID)
        {
            string sqlQuery;
            DataSet oDataSet = new DataSet();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_DashBoardCustomerDetails";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@UserID", UserID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataSet);

                DataTable totalOrdersTable = oDataSet.Tables[0];
                DataTable preferredContractorTable = oDataSet.Tables[1];
                DataTable preferredVendorTable = oDataSet.Tables[2];
                DataTable advertisementTable = oDataSet.Tables[3];
                DataTable recentOrdersTable = oDataSet.Tables[4];
                DataTable recentTasksTable = oDataSet.Tables[5];

                List<CusTotalOrdersModel> cusTotalOrdersModel = totalOrdersTable.AsEnumerable().Select(row =>
                new CusTotalOrdersModel
                {
                    TotalOrders = row.Field<int>("TotalOrders")

                }).ToList();

                List<CusPreferredContractorModel> cusPreferredContractorModel = preferredContractorTable.AsEnumerable().Select(row =>
                new CusPreferredContractorModel
                {
                    PreferredContractor = row.Field<string>("PreferredContractor")

                }).ToList();

                List<CusPreferredVendorModel> cusPreferredVendorModel = preferredVendorTable.AsEnumerable().Select(row =>
                new CusPreferredVendorModel
                {
                    PreferredVendor = row.Field<string>("PreferredVendor")

                }).ToList();

                List<CusAdvertisementsModel> cusAdvertisementsModel = advertisementTable.AsEnumerable().Select(row =>
                new CusAdvertisementsModel
                {
                    AdvID = row.Field<int>("AdvID"),
                    ImageName = row.Field<string>("ImageName"),
                    ImageURL = row.Field<string>("ImageURL")
                }).ToList();

                List<CusRecentOrdersModel> cusRecentOrdersModel = recentOrdersTable.AsEnumerable().Select(row =>
                new CusRecentOrdersModel
                {
                    OrderNo = row.Field<string>("OrderNo"),
                    VendorName = row.Field<string>("VendorName"),
                    PlacedDate = row.Field<string>("PlacedDate")
                }).ToList();

                List<CusRecentTasksModel> cusRecentTasksModel = recentTasksTable.AsEnumerable().Select(row =>
                new CusRecentTasksModel
                {
                    TaskName = row.Field<string>("TaskName"),
                    ProjectTitle = row.Field<string>("ProjectTitle"),
                    ContractorName = row.Field<string>("ContractorName"),
                    TaskStatus = row.Field<int>("TaskStatus"),
                    TaskStatusName = row.Field<string>("TaskStatusName")
                }).ToList();

                CustomerDashboardModel customerDashboard = new CustomerDashboardModel();
                customerDashboard.cusTotalOrders = cusTotalOrdersModel;
                customerDashboard.cusPreferredContractors = cusPreferredContractorModel;
                customerDashboard.cusPreferredVendors = cusPreferredVendorModel;
                customerDashboard.cusAdvertisements = cusAdvertisementsModel;
                customerDashboard.cusRecentOrders = cusRecentOrdersModel;
                customerDashboard.cusRecentTasks = cusRecentTasksModel;
                return customerDashboard;
            }
            catch (Exception)
            {
                throw;
            }
        }

    }
}
