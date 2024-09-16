using CMMS_DataService.Dashboard;
using CMMS_Model.Dashboard;
using CMMS_Model.DbAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.Dashboard
{
    public class DashboardApplicationService: IDashboardApplicationService
    {
        DB_Handle oDB_Handle = new DB_Handle();

        public AdminDashboardModel GetAdminDashboardDetails()
        {
            DashboardDataService dashboardDataService = new DashboardDataService();
            AdminDashboardModel adminDashboard = new AdminDashboardModel();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                adminDashboard = dashboardDataService.GetAdminDashboardDetails(oDB_Handle);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return adminDashboard;
        }

        public ContractorDashboardModel GetContractorDashboardDetails(int UserID)
        {
            DashboardDataService dashboardDataService = new DashboardDataService();
            ContractorDashboardModel contractorDashboard = new ContractorDashboardModel();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                contractorDashboard = dashboardDataService.GetContractorDashboardDetails(oDB_Handle, UserID);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return contractorDashboard;
        }

        public VendorDashboardModel GetVendorDashboardDetails(int UserID)
        {
            DashboardDataService dashboardDataService = new DashboardDataService();
            VendorDashboardModel vendorDashboard = new VendorDashboardModel();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                vendorDashboard = dashboardDataService.GetVendorDashboardDetails(oDB_Handle, UserID);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return vendorDashboard;
        }

        public CustomerDashboardModel GetCustomerDashboardDetails(int UserID)
        {
            DashboardDataService dashboardDataService = new DashboardDataService();
            CustomerDashboardModel customerDashboard = new CustomerDashboardModel();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                customerDashboard = dashboardDataService.GetCustomerDashboardDetails(oDB_Handle, UserID);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return customerDashboard;
        }

    }
}
