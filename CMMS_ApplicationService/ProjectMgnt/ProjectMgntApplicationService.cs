using CMMS_DataService.ProjectMgnt;
using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using CMMS_Model.ProjectMgnt;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.ProjectMgnt
{
    public class ProjectMgntApplicationService: IProjectMgntApplicationService
    {
        DB_Handle oDB_Handle = new DB_Handle();

        public ProjectInitialDataModel GetInitialProjectData()
        {
            ProjectMgntDataService projectMgntDataService = new ProjectMgntDataService();
            ProjectInitialDataModel projectInitialData = new ProjectInitialDataModel();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                projectInitialData = projectMgntDataService.GetInitialProjectData(oDB_Handle);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return projectInitialData;
        }

        public List<ProjectModel> GetProjectDetailsByProjectID(int ProjectID, int UserID)
        {
            ProjectMgntDataService projectMgntDataService = new ProjectMgntDataService();
            List<ProjectModel> project = new List<ProjectModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                project = projectMgntDataService.GetProjectDetailsByProjectID(oDB_Handle, ProjectID, UserID);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return project;
        }

        public List<ProjectListViewModel> GetProjectDetailsAllByUserID(int UserID, int ProjectStatus)
        {
            ProjectMgntDataService projectMgntDataService = new ProjectMgntDataService();
            List<ProjectListViewModel> projects = new List<ProjectListViewModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                projects = projectMgntDataService.GetProjectDetailsAllByUserID(oDB_Handle, UserID, ProjectStatus);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return projects;
        }

        public List<CustomerSearchModel> GetSearchCustomers(string? searchKeyword)
        {
            ProjectMgntDataService projectMgntDataService = new ProjectMgntDataService();
            List<CustomerSearchModel> customerSearches = new List<CustomerSearchModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                customerSearches = projectMgntDataService.GetSearchCustomers(oDB_Handle, searchKeyword);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return customerSearches;
        }

        public List<OutputMessageModel> SaveProjectDetails(ProjectModel project)
        {
            ProjectMgntDataService projectMgntDataService = new ProjectMgntDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                msgModel = projectMgntDataService.SaveProjectDetails(oDB_Handle, project);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return msgModel;
        }

        public List<OutputMessageModel> UpdateProjectDetails(ProjectModel project)
        {
            ProjectMgntDataService projectMgntDataService = new ProjectMgntDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                msgModel = projectMgntDataService.UpdateProjectDetails(oDB_Handle, project);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return msgModel;
        }
    }
}
