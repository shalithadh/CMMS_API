using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.Dashboard
{
    public class ContractorDashboardModel
    {
        public List<ContractorTotalProjectsModel> contractorTotalProjects { get; set; }
        public List<ContractorBestClientModel> contractorBestClients { get; set; }
        public List<ContractorOverallRatingModel> contractorOverallRatings { get; set; }
        public List<ContractorRecentProjectModel> contractorRecentProjects { get; set; }
        public List<ContractorRecentCompletedTasksModel> contractorRecentCompletedTasks { get; set; }
    }

    public class ContractorTotalProjectsModel
    {
        public decimal? TotalProjects { get; set; }
    }

    public class ContractorBestClientModel
    {
        public string? BestClient { get; set; }
    }

    public class ContractorOverallRatingModel
    {
        public decimal? MyOverallRating { get; set; }
    }

    public class ContractorRecentProjectModel
    {
        public string? ProjectTitle { get; set; }
        public string? ClientName { get; set; }
        public decimal? ProjectProgress { get; set; }
    }

    public class ContractorRecentCompletedTasksModel
    {
        public string? TaskName { get; set; }
        public string? ProjectTitle { get; set; }
        public string? ClientName { get; set; }
        public string? CompletedDate { get; set; }
    }

}
