using CMMS_Model.Common;
using CMMS_Model.ProjectMgnt;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.ProjectMgnt
{
    public interface IProjectMgntApplicationService
    {
        ProjectInitialDataModel GetInitialProjectData();
        List<ProjectModel> GetProjectDetailsByProjectID(int ProjectID, int UserID);
        List<ProjectListViewModel> GetProjectDetailsAllByUserID(int UserID, int ProjectStatus);
        List<CustomerSearchModel> GetSearchCustomers(string? searchKeyword);
        List<OutputMessageModel> SaveProjectDetails(ProjectModel project);
        List<OutputMessageModel> UpdateProjectDetails(ProjectModel project);
    }
}
