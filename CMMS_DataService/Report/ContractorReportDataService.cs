using CMMS_Model.DbAccess;
using CMMS_Model.Report;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_DataService.Report
{
    public class ContractorReportDataService
    {

        public List<ProjectOverviewModel> GetProjectOverviewReportDetails(DB_Handle oDB_Handle, int UserID, string StartDate, string EndDate)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_ReportMgntProjectOverview";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@UserID", UserID);
                oSqlCommand.Parameters.AddWithValue("@StartDate", StartDate);
                oSqlCommand.Parameters.AddWithValue("@EndDate", EndDate);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<ProjectOverviewModel> reportDetails = oDataTable.AsEnumerable().Select(row =>
                new ProjectOverviewModel
                {
                    ProjectID = row.Field<int>("ProjectID"),
                    ProjectTitle = row.Field<string>("ProjectTitle"),
                    ClientName = row.Field<string>("ClientName"),
                    PriorityName = row.Field<string>("PriorityName"),
                    StartDate = row.Field<string>("StartDate"),
                    EndDate = row.Field<string>("EndDate"),
                    ProjectStatusName = row.Field<string>("ProjectStatusName"),
                    NewTaskCount = row.Field<int>("NewTaskCount"),
                    InProgressTaskCount = row.Field<int>("InProgressTaskCount"),
                    CompleteTaskCount = row.Field<int>("CompleteTaskCount"),
                    ProjectProgress = row.Field<decimal>("ProjectProgress")
                }).ToList();

                return reportDetails;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public ProjectProgressInitialModel GetProjectProgressInitialData(DB_Handle oDB_Handle, int UserID)
        {
            string sqlQuery;
            DataSet oDataSet = new DataSet();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_ReportMgntProjectProgressLoadInitialData";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@UserID", UserID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataSet);

                //project detail table
                DataTable projectDetailTable = oDataSet.Tables[0];

                List<ProjectDetailModel> projectDetails = projectDetailTable.AsEnumerable().Select(row =>
                new ProjectDetailModel
                {
                    ValueID = row.Field<int>("ValueID"),
                    Value = row.Field<string>("Value")
                }).ToList();

                ProjectProgressInitialModel initialData = new ProjectProgressInitialModel();
                initialData.projectDetails = projectDetails;

                return initialData;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<ProjectProgressModel> GetProjectProgressDetails(DB_Handle oDB_Handle, int ProjectID)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_ReportMgntProjectProgress";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@ProjectID", ProjectID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<ProjectProgressModel> reportDetails = oDataTable.AsEnumerable().Select(row =>
                new ProjectProgressModel
                {
                    TaskID = row.Field<int>("TaskID"),
                    ProjectID = row.Field<int>("ProjectID"),
                    ProjectTitle = row.Field<string>("ProjectTitle"),
                    TaskName = row.Field<string>("TaskName"),
                    PriorityName = row.Field<string>("PriorityName"),
                    TaskStatus = row.Field<int>("TaskStatus"),
                    TaskStatusName = row.Field<string>("TaskStatusName"),
                    StartDate = row.Field<string>("StartDate"),
                    StartTime = row.Field<string>("StartTime"),
                    EndDate = row.Field<string>("EndDate"),
                    EndTime = row.Field<string>("EndTime"),
                    AssignTo = row.Field<int>("AssignTo"),
                    AssignToName = row.Field<string>("AssignToName")
                }).ToList();

                return reportDetails;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public ContractorReviewInitialModel GetContractorReviewInitialData(DB_Handle oDB_Handle)
        {
            string sqlQuery;
            DataSet oDataSet = new DataSet();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_ReportMgntContractorReviewLoadInitialData";
                oSqlCommand = new SqlCommand();
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataSet);

                //year table
                DataTable yearTable = oDataSet.Tables[0];
                //month table
                DataTable monthTable = oDataSet.Tables[1];

                List<YearMstrModel> years = yearTable.AsEnumerable().Select(row =>
                new YearMstrModel
                {
                    ValueID = row.Field<int>("ValueID"),
                    Value = row.Field<string>("Value")
                }).ToList();

                List<MonthMstrModel> months = monthTable.AsEnumerable().Select(row =>
                new MonthMstrModel
                {
                    ValueID = row.Field<int>("ValueID"),
                    Value = row.Field<string>("Value")
                }).ToList();

                ContractorReviewInitialModel initialData = new ContractorReviewInitialModel();
                initialData.years = years;
                initialData.months = months;

                return initialData;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<ContractorReviewModel> GetContractorReviewDetails(DB_Handle oDB_Handle, int Year, int Month)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_ReportMgntContractorReview";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@Year", Year);
                oSqlCommand.Parameters.AddWithValue("@Month", Month);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<ContractorReviewModel> reportDetails = oDataTable.AsEnumerable().Select(row =>
                new ContractorReviewModel
                {
                    ContractorID = row.Field<int>("ContractorID"),
                    ContractorName = row.Field<string>("ContractorName"),
                    OverallRating = row.Field<decimal>("OverallRating")
                }).ToList();

                return reportDetails;
            }
            catch (Exception)
            {
                throw;
            }
        }

    }
}
