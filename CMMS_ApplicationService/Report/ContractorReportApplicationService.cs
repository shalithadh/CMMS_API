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
    public class ContractorReportApplicationService: IContractorReportApplicationService
    {
        DB_Handle oDB_Handle = new DB_Handle();

        public List<ProjectOverviewModel> GetProjectOverviewReportDetails(int UserID, string StartDate, string EndDate)
        {
            ContractorReportDataService contractorReportDataService = new ContractorReportDataService();
            List<ProjectOverviewModel> reportDetails = new List<ProjectOverviewModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                reportDetails = contractorReportDataService.GetProjectOverviewReportDetails(oDB_Handle, UserID, StartDate, EndDate);

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

        public ProjectProgressInitialModel GetProjectProgressInitialData(int UserID)
        {
            ContractorReportDataService contractorReportDataService = new ContractorReportDataService();
            ProjectProgressInitialModel reportDetails = new ProjectProgressInitialModel();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                reportDetails = contractorReportDataService.GetProjectProgressInitialData(oDB_Handle, UserID);

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

        public List<ProjectProgressModel> GetProjectProgressDetails(int ProjectID)
        {
            ContractorReportDataService contractorReportDataService = new ContractorReportDataService();
            List<ProjectProgressModel> reportDetails = new List<ProjectProgressModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                reportDetails = contractorReportDataService.GetProjectProgressDetails(oDB_Handle, ProjectID);

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

        public ContractorReviewInitialModel GetContractorReviewInitialData()
        {
            ContractorReportDataService contractorReportDataService = new ContractorReportDataService();
            ContractorReviewInitialModel reportDetails = new ContractorReviewInitialModel();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                reportDetails = contractorReportDataService.GetContractorReviewInitialData(oDB_Handle);

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

        public List<ContractorReviewModel> GetContractorReviewDetails(int Year, int Month)
        {
            ContractorReportDataService contractorReportDataService = new ContractorReportDataService();
            List<ContractorReviewModel> reportDetails = new List<ContractorReviewModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                reportDetails = contractorReportDataService.GetContractorReviewDetails(oDB_Handle, Year, Month);

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
