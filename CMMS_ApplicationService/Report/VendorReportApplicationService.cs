using CMMS_DataService.Report;
using CMMS_Model.DbAccess;
using CMMS_Model.Report;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.Report
{
    public class VendorReportApplicationService: IVendorReportApplicationService
    {
        DB_Handle oDB_Handle = new DB_Handle();

        public List<SalesOverviewModel> GetSalesOverviewDetails(int UserID, int Year, int Month)
        {
            VendorReportDataService vendorReportDataService = new VendorReportDataService();
            List<SalesOverviewModel> reportDetails = new List<SalesOverviewModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                reportDetails = vendorReportDataService.GetSalesOverviewDetails(oDB_Handle, UserID, Year, Month);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return reportDetails;
        }

        public List<OrderStatusModel> GetOrderStatusDetails(int UserID, int Year, int Month)
        {
            VendorReportDataService vendorReportDataService = new VendorReportDataService();
            List<OrderStatusModel> reportDetails = new List<OrderStatusModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                reportDetails = vendorReportDataService.GetOrderStatusDetails(oDB_Handle, UserID, Year, Month);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return reportDetails;
        }

        public List<InventorySummaryModel> GetInventorySummaryDetails(int VendorCategoryTypeID, int UserID)
        {
            VendorReportDataService vendorReportDataService = new VendorReportDataService();
            List<InventorySummaryModel> reportDetails = new List<InventorySummaryModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                reportDetails = vendorReportDataService.GetInventorySummaryDetails(oDB_Handle, VendorCategoryTypeID, UserID);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return reportDetails;
        }

        public List<CustomerOverallModel> GetCustomerOverallDetails(int UserID, int Year, int Month)
        {
            VendorReportDataService vendorReportDataService = new VendorReportDataService();
            List<CustomerOverallModel> reportDetails = new List<CustomerOverallModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                reportDetails = vendorReportDataService.GetCustomerOverallDetails(oDB_Handle, UserID, Year, Month);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return reportDetails;
        }

        public List<PopularItemModel> GetPopularItemDetails(int UserID, int Year, int Month)
        {
            VendorReportDataService vendorReportDataService = new VendorReportDataService();
            List<PopularItemModel> reportDetails = new List<PopularItemModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                reportDetails = vendorReportDataService.GetPopularItemDetails(oDB_Handle, UserID, Year, Month);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return reportDetails;
        }

    }
}
