using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using CMMS_Model.ProjectMgnt;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_DataService.ProjectMgnt
{
    public class ProjectMgntDataService
    {
        public ProjectInitialDataModel GetInitialProjectData(DB_Handle oDB_Handle)
        {
            string sqlQuery;
            DataSet oDataSet = new DataSet();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_ProjectInitialData";
                oSqlCommand = new SqlCommand();
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataSet);

                //project types table
                DataTable projectTypeTable = oDataSet.Tables[0];
                //project priorities table
                DataTable projectPriorityTable = oDataSet.Tables[1];
                //project sizes table
                DataTable projectSizeTable = oDataSet.Tables[2];
                //project status table
                DataTable projectStatusTable = oDataSet.Tables[3];

                List<ProjectTypeModel> projectTypes = projectTypeTable.AsEnumerable().Select(row =>
                new ProjectTypeModel
                {
                    ValueID = row.Field<int>("ValueID"),
                    Value = row.Field<string>("Value")
                }).ToList();

                List<ProjectPriorityModel> projectPriorities = projectPriorityTable.AsEnumerable().Select(row =>
                new ProjectPriorityModel
                {
                    ValueID = row.Field<int>("ValueID"),
                    Value = row.Field<string>("Value")
                }).ToList();

                List<ProjectSizeModel> projectSizes = projectSizeTable.AsEnumerable().Select(row =>
                new ProjectSizeModel
                {
                    ValueID = row.Field<int>("ValueID"),
                    Value = row.Field<string>("Value")
                }).ToList();

                List<ProjectStatusModel> projectStatuses = projectStatusTable.AsEnumerable().Select(row =>
                new ProjectStatusModel
                {
                    ValueID = row.Field<int>("ValueID"),
                    Value = row.Field<string>("Value")
                }).ToList();

                ProjectInitialDataModel projectInitialData = new ProjectInitialDataModel();
                projectInitialData.projectTypes = projectTypes;
                projectInitialData.projectPriorities = projectPriorities;
                projectInitialData.projectSizes = projectSizes;
                projectInitialData.ProjectStatuses = projectStatuses;

                return projectInitialData;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<ProjectModel> GetProjectDetailsByProjectID(DB_Handle oDB_Handle, int ProjectID, int UserID)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_ProjectDetailsByProjectID";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@ProjectID", ProjectID);
                oSqlCommand.Parameters.AddWithValue("@UserID", UserID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<ProjectModel> projectModel = oDataTable.AsEnumerable().Select(row =>
                new ProjectModel
                {
                    ProjectID = row.Field<int>("ProjectID"),
                    ProjectTitle = row.Field<string>("ProjectTitle"),
                    ClientID = row.Field<int>("ClientID"),
                    ClientName = row.Field<string>("ClientName"),
                    ProjectPriority = row.Field<int>("ProjectPriority"),
                    ProjectSize = row.Field<int>("ProjectSize"),
                    StartDate = row.Field<string>("StartDate"),
                    StartTime = row.Field<string>("StartTime"),
                    EndDate = row.Field<string>("EndDate"),
                    EndTime = row.Field<string>("EndTime"),
                    Description = row.Field<string>("Description"),
                    ProjectStatus = row.Field<int>("ProjectStatus")
                }).ToList();

                return projectModel;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<ProjectListViewModel> GetProjectDetailsAllByUserID(DB_Handle oDB_Handle, int UserID, int ProjectStatus)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_ProjectDetailsAllByUserID";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@UserID", UserID);
                oSqlCommand.Parameters.AddWithValue("@ProjectStatus", ProjectStatus);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<ProjectListViewModel> projects = oDataTable.AsEnumerable().Select(row =>
                new ProjectListViewModel
                {
                    ProjectID = row.Field<int>("ProjectID"),
                    ProjectTitle = row.Field<string>("ProjectTitle"),
                    ClientName = row.Field<string>("ClientName"),
                    StartDate = row.Field<string>("StartDate"),
                    EndDate = row.Field<string>("EndDate"),
                    Description = row.Field<string>("Description"),
                    ProjectStatusName = row.Field<string>("ProjectStatusName"),
                    NewTaskCount = row.Field<int>("NewTaskCount"),
                    InProgressTaskCount = row.Field<int>("InProgressTaskCount"),
                    CompleteTaskCount = row.Field<int>("CompleteTaskCount"),
                    ProjectProgress = row.Field<decimal>("ProjectProgress")
                }).ToList();

                return projects;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<CustomerSearchModel> GetSearchCustomers(DB_Handle oDB_Handle, string? searchKeyword)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_SearchCustomer";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@SearchKeyword", searchKeyword);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<CustomerSearchModel> customerSearches = oDataTable.AsEnumerable().Select(row =>
                new CustomerSearchModel
                {
                    Value = row.Field<int>("Value"),
                    Label = row.Field<string>("Label"),
                    Desc = row.Field<string>("Desc")
                }).ToList();

                return customerSearches;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<OutputMessageModel> SaveProjectDetails(DB_Handle oDB_Handle, ProjectModel project)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_ADD_ProjectDetails";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@ProjectTitle", project.ProjectTitle);
                oSqlCommand.Parameters.AddWithValue("@ClientID", project.ClientID);
                oSqlCommand.Parameters.AddWithValue("@ProjectPriority", project.ProjectPriority);
                oSqlCommand.Parameters.AddWithValue("@ProjectSize", project.ProjectSize);
                oSqlCommand.Parameters.AddWithValue("@StartDate", project.StartDate);
                oSqlCommand.Parameters.AddWithValue("@StartTime", project.StartTime);
                oSqlCommand.Parameters.AddWithValue("@EndDate", project.EndDate);
                oSqlCommand.Parameters.AddWithValue("@EndTime", project.EndTime);
                oSqlCommand.Parameters.AddWithValue("@Description", project.Description);
                oSqlCommand.Parameters.AddWithValue("@ProjectStatus", project.ProjectStatus);
                oSqlCommand.Parameters.AddWithValue("@CreateUser", project.CreateUser);
                oSqlCommand.Parameters.AddWithValue("@CreateIP", project.CreateIP);
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

        public List<OutputMessageModel> UpdateProjectDetails(DB_Handle oDB_Handle, ProjectModel project)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_UPDATE_ProjectDetails";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@ProjectID", project.ProjectID);
                oSqlCommand.Parameters.AddWithValue("@ProjectTitle", project.ProjectTitle);
                oSqlCommand.Parameters.AddWithValue("@ClientID", project.ClientID);
                oSqlCommand.Parameters.AddWithValue("@ProjectPriority", project.ProjectPriority);
                oSqlCommand.Parameters.AddWithValue("@ProjectSize", project.ProjectSize);
                oSqlCommand.Parameters.AddWithValue("@StartDate", project.StartDate);
                oSqlCommand.Parameters.AddWithValue("@StartTime", project.StartTime);
                oSqlCommand.Parameters.AddWithValue("@EndDate", project.EndDate);
                oSqlCommand.Parameters.AddWithValue("@EndTime", project.EndTime);
                oSqlCommand.Parameters.AddWithValue("@Description", project.Description);
                oSqlCommand.Parameters.AddWithValue("@ProjectStatus", project.ProjectStatus);
                oSqlCommand.Parameters.AddWithValue("@CreateUser", project.CreateUser);
                oSqlCommand.Parameters.AddWithValue("@CreateIP", project.CreateIP);
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
