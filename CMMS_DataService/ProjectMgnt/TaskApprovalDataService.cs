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
    public class TaskApprovalDataService
    {
        public List<TaskListViewModel> GetPendingApprovalTaskList(DB_Handle oDB_Handle, int UserID)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_ProjectTaskPendingApprovalList";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@UserID", UserID);
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

        public List<TaskListViewModel> GetPendingApprovalTaskListByTaskID(DB_Handle oDB_Handle, int UserID, int TaskID)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_ProjectTaskPendingApprovalListByTaskID";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@UserID", UserID);
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

        public List<OutputMessageModel> SaveTaskReviewInfo(DB_Handle oDB_Handle, TaskReviewModel taskReview)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_ADD_ProjectTaskReviews";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@TaskID", taskReview.TaskID);
                oSqlCommand.Parameters.AddWithValue("@Rating", taskReview.Rating);
                oSqlCommand.Parameters.AddWithValue("@Comment", taskReview.Comment);
                oSqlCommand.Parameters.AddWithValue("@ContractorID", taskReview.ContractorID);
                oSqlCommand.Parameters.AddWithValue("@IsVisitedSite", taskReview.IsVisitedSite);
                oSqlCommand.Parameters.AddWithValue("@CreateUser", taskReview.CreateUser);
                oSqlCommand.Parameters.AddWithValue("@CreateIP", taskReview.CreateIP);
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

        public List<OutputMessageModel> SaveTaskRejectInfo(DB_Handle oDB_Handle, TaskRejectInfoModel taskReject)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_ADD_ProjectTaskRejectInfo";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@TaskID", taskReject.TaskID);
                oSqlCommand.Parameters.AddWithValue("@Reason", taskReject.Reason);            
                oSqlCommand.Parameters.AddWithValue("@CreateUser", taskReject.CreateUser);
                oSqlCommand.Parameters.AddWithValue("@CreateIP", taskReject.CreateIP);
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

    }
}
