using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using CMMS_Model.ProjectMgnt;
using Microsoft.Data.SqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_DataService.ProjectMgnt
{
    public class TaskMgntDataService
    {
        public TaskInitialDataModel GetInitialTaskMgntData(DB_Handle oDB_Handle)
        {
            string sqlQuery;
            DataSet oDataSet = new DataSet();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_ProjectTaskInitialData";
                oSqlCommand = new SqlCommand();
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataSet);

                //project task rate types table
                DataTable taskRateTypeTable = oDataSet.Tables[0];
                //project task priorities table
                DataTable taskPriorityTable = oDataSet.Tables[1];
                //project task status table
                DataTable taskStatusTable = oDataSet.Tables[2];
                //service types table
                DataTable taskServiceTypeTable = oDataSet.Tables[3];

                List<TaskRateTypeModel> taskRateTypes = taskRateTypeTable.AsEnumerable().Select(row =>
                new TaskRateTypeModel
                {
                    ValueID = row.Field<int>("ValueID"),
                    Value = row.Field<string>("Value")
                }).ToList();

                List<TaskPriorityModel> taskPriorities = taskPriorityTable.AsEnumerable().Select(row =>
                new TaskPriorityModel
                {
                    ValueID = row.Field<int>("ValueID"),
                    Value = row.Field<string>("Value")
                }).ToList();

                List<TaskStatusModel> taskStatuses = taskStatusTable.AsEnumerable().Select(row =>
                new TaskStatusModel
                {
                    ValueID = row.Field<int>("ValueID"),
                    Value = row.Field<string>("Value")
                }).ToList();

                List<TaskServiceTypeModel> taskServiceTypes = taskServiceTypeTable.AsEnumerable().Select(row =>
                new TaskServiceTypeModel
                {
                    ValueID = row.Field<int>("ValueID"),
                    Value = row.Field<string>("Value")
                }).ToList();

                TaskInitialDataModel taskInitialData = new TaskInitialDataModel();
                taskInitialData.taskRateTypes = taskRateTypes;
                taskInitialData.taskPriorities = taskPriorities;
                taskInitialData.taskStatuses = taskStatuses;
                taskInitialData.taskServiceTypes = taskServiceTypes;

                return taskInitialData;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public AssignToComboModel GetAssignToContractorList(DB_Handle oDB_Handle, int ServiceTypeID)
        {
            string sqlQuery;
            DataSet oDataSet = new DataSet();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_ContractorsByServiceTypeID";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@ServiceTypeID", ServiceTypeID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataSet);

                //contactor list table
                DataTable assignToContactorTable = oDataSet.Tables[0];

                List<AssignToContactorList> assignToContactors = assignToContactorTable.AsEnumerable().Select(row =>
                new AssignToContactorList
                {
                    ValueID = row.Field<int>("ValueID"),
                    Value = row.Field<string>("Value")
                }).ToList();

                AssignToComboModel assignToCombo = new AssignToComboModel();
                assignToCombo.contactorList = assignToContactors;

                return assignToCombo;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<TaskListViewModel> GetProjectTaskByProjectID(DB_Handle oDB_Handle, int ProjectID, int UserID, int TaskStatus, string StartDate, string EndDate)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_ProjectTaskByProjectID";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@ProjectID", ProjectID);
                oSqlCommand.Parameters.AddWithValue("@UserID", UserID);
                oSqlCommand.Parameters.AddWithValue("@TaskStatus", TaskStatus);
                oSqlCommand.Parameters.AddWithValue("@StartDate", StartDate);
                oSqlCommand.Parameters.AddWithValue("@EndDate", EndDate);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<TaskListViewModel> taskLists = oDataTable.AsEnumerable().Select(row =>
                new TaskListViewModel
                {
                    TaskID = row.Field<int>("TaskID"),
                    ProjectID = row.Field<int>("ProjectID"),
                    ProjectTitle = row.Field<string>("ProjectTitle"),
                    TaskName = row.Field<string>("TaskName"),
                    TaskRate = row.Field<decimal>("TaskRate"),
                    TaskRateType = row.Field<int>("TaskRateType"),
                    TaskRateTypeName = row.Field<string>("TaskRateTypeName"),
                    TaskPriority = row.Field<int>("TaskPriority"),
                    PriorityName = row.Field<string>("PriorityName"),
                    TaskStatus = row.Field<int>("TaskStatus"),
                    TaskStatusName = row.Field<string>("TaskStatusName"),
                    Description = row.Field<string>("Description"),
                    StartDate = row.Field<string>("StartDate"),
                    StartTime = row.Field<string>("StartTime"),
                    EndDate = row.Field<string>("EndDate"),
                    EndTime = row.Field<string>("EndTime"),
                    ServiceType = row.Field<int>("ServiceType"),
                    AssignTo = row.Field<int>("AssignTo"),
                    ServiceTypeName = row.Field<string>("ServiceTypeName"),
                    AssignToName = row.Field<string>("AssignToName"),
                    ApprovalStatus = row.Field<int>("ApprovalStatus"),
                    CreateUser = row.Field<int>("CreateUser")
                }).ToList();

                return taskLists;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<TaskListViewModel> GetProjectTaskDetailsByTaskID(DB_Handle oDB_Handle, int TaskID)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_ProjectTaskDetailsByTaskID";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@TaskID", TaskID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<TaskListViewModel> taskLists = oDataTable.AsEnumerable().Select(row =>
                new TaskListViewModel
                {
                    TaskID = row.Field<int>("TaskID"),
                    ProjectID = row.Field<int>("ProjectID"),
                    ProjectTitle = row.Field<string>("ProjectTitle"),
                    TaskName = row.Field<string>("TaskName"),
                    TaskRate = row.Field<decimal>("TaskRate"),
                    TaskRateType = row.Field<int>("TaskRateType"),
                    TaskRateTypeName = row.Field<string>("TaskRateTypeName"),
                    TaskPriority = row.Field<int>("TaskPriority"),
                    PriorityName = row.Field<string>("PriorityName"),
                    TaskStatus = row.Field<int>("TaskStatus"),
                    TaskStatusName = row.Field<string>("TaskStatusName"),
                    Description = row.Field<string>("Description"),
                    StartDate = row.Field<string>("StartDate"),
                    StartTime = row.Field<string>("StartTime"),
                    EndDate = row.Field<string>("EndDate"),
                    EndTime = row.Field<string>("EndTime"),
                    ServiceType = row.Field<int>("ServiceType"),
                    AssignTo = row.Field<int>("AssignTo"),
                    ServiceTypeName = row.Field<string>("ServiceTypeName"),
                    ClientEmail = row.Field<string>("ClientEmail"),
                    AssignToName = row.Field<string>("AssignToName"),
                    ContractorEmail = row.Field<string>("ContractorEmail"),
                    ApprovalStatus = row.Field<int>("ApprovalStatus"),
                    CreateUser = row.Field<int>("CreateUser")
                }).ToList();

                return taskLists;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<TaskImgURLModel> GetProjectTaskImgUrlsByTaskID(DB_Handle oDB_Handle, int TaskID)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_ProjectTaskImgUrlsByTaskID";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@TaskID", TaskID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<TaskImgURLModel> taskImgURLs = oDataTable.AsEnumerable().Select(row =>
                new TaskImgURLModel
                {
                    ImageName = row.Field<string>("ImageName"),
                    ImageURL = row.Field<string>("ImageURL")
                }).ToList();

                return taskImgURLs;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<OutputMessageModel> SaveTaskDetails(DB_Handle oDB_Handle, TaskModel task)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_ADD_ProjectTask";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@ProjectID", task.ProjectID);
                oSqlCommand.Parameters.AddWithValue("@TaskName", task.TaskName);
                oSqlCommand.Parameters.AddWithValue("@TaskRate", task.TaskRate);
                oSqlCommand.Parameters.AddWithValue("@TaskRateType", task.TaskRateType);
                oSqlCommand.Parameters.AddWithValue("@TaskPriority", task.TaskPriority);
                oSqlCommand.Parameters.AddWithValue("@TaskStatus", task.TaskStatus);
                oSqlCommand.Parameters.AddWithValue("@Description", task.Description);
                oSqlCommand.Parameters.AddWithValue("@StartDate", task.StartDate);
                oSqlCommand.Parameters.AddWithValue("@StartTime", task.StartTime);
                oSqlCommand.Parameters.AddWithValue("@EndDate", task.EndDate);
                oSqlCommand.Parameters.AddWithValue("@EndTime", task.EndTime);
                oSqlCommand.Parameters.AddWithValue("@ServiceType", task.ServiceType);
                oSqlCommand.Parameters.AddWithValue("@AssignTo", task.AssignTo);
                oSqlCommand.Parameters.AddWithValue("@CreateUser", task.CreateUser);
                oSqlCommand.Parameters.AddWithValue("@CreateIP", task.CreateIP);
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
                    RsltType = row.Field<int>("rsltType"),
                    SavedID = row.Field<int>("savedID")
                }).ToList();

                return msgModel;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<OutputMessageModel> UpdateTaskDetails(DB_Handle oDB_Handle, TaskModel task)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_UPDATE_ProjectTask";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@TaskID", task.TaskID);
                oSqlCommand.Parameters.AddWithValue("@ProjectID", task.ProjectID);
                oSqlCommand.Parameters.AddWithValue("@TaskName", task.TaskName);
                oSqlCommand.Parameters.AddWithValue("@TaskRate", task.TaskRate);
                oSqlCommand.Parameters.AddWithValue("@TaskRateType", task.TaskRateType);
                oSqlCommand.Parameters.AddWithValue("@TaskPriority", task.TaskPriority);
                oSqlCommand.Parameters.AddWithValue("@TaskStatus", task.TaskStatus);
                oSqlCommand.Parameters.AddWithValue("@Description", task.Description);
                oSqlCommand.Parameters.AddWithValue("@StartDate", task.StartDate);
                oSqlCommand.Parameters.AddWithValue("@StartTime", task.StartTime);
                oSqlCommand.Parameters.AddWithValue("@EndDate", task.EndDate);
                oSqlCommand.Parameters.AddWithValue("@EndTime", task.EndTime);
                oSqlCommand.Parameters.AddWithValue("@ServiceType", task.ServiceType);
                oSqlCommand.Parameters.AddWithValue("@AssignTo", task.AssignTo);
                oSqlCommand.Parameters.AddWithValue("@CreateUser", task.CreateUser);
                oSqlCommand.Parameters.AddWithValue("@CreateIP", task.CreateIP);
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
                    RsltType = row.Field<int>("rsltType"),
                    SavedID = row.Field<int>("savedID")
                }).ToList();

                return msgModel;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<OutputMessageModel> SaveTaskImageURLs(DB_Handle oDB_Handle, int TaskID, string TaskImgURLJson, int UserID, string UserIP)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {             
                sqlQuery = "SP_ADD_ProjectTaskImgURL";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@TaskID", TaskID);
                oSqlCommand.Parameters.AddWithValue("@TaskImgURLJson", TaskImgURLJson);
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
    }
}
