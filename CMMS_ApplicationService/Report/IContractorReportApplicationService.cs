using CMMS_Model.Report;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.Report
{
    public interface IContractorReportApplicationService
    {
        List<ProjectOverviewModel> GetProjectOverviewReportDetails(int UserID, string StartDate, string EndDate);
        ProjectProgressInitialModel GetProjectProgressInitialData(int UserID);
        List<ProjectProgressModel> GetProjectProgressDetails(int ProjectID);
        ContractorReviewInitialModel GetContractorReviewInitialData();
        List<ContractorReviewModel> GetContractorReviewDetails(int Year, int Month);
    }
}
