using CMMS_ApplicationService.Email;
using CMMS_DataService.ProjectMgnt;
using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using CMMS_Model.Email;
using CMMS_Model.ProjectMgnt;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.ProjectMgnt
{
    public class TaskMgntApplicationService : ITaskMgntApplicationService
    {
        DB_Handle oDB_Handle = new DB_Handle();

        public TaskInitialDataModel GetInitialTaskMgntData()
        {
            TaskMgntDataService taskMgntDataService = new TaskMgntDataService();
            TaskInitialDataModel taskInitialData = new TaskInitialDataModel();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                taskInitialData = taskMgntDataService.GetInitialTaskMgntData(oDB_Handle);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return taskInitialData;
        }

        public AssignToComboModel GetAssignToContractorList(int ServiceTypeID)
        {
            TaskMgntDataService taskMgntDataService = new TaskMgntDataService();
            AssignToComboModel assignToCombo = new AssignToComboModel();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                assignToCombo = taskMgntDataService.GetAssignToContractorList(oDB_Handle, ServiceTypeID);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return assignToCombo;
        }

        public List<TaskListViewModel> GetProjectTaskByProjectID(int ProjectID, int UserID, int TaskStatus, string StartDate, string EndDate)
        {
            TaskMgntDataService taskMgntDataService = new TaskMgntDataService();
            List<TaskListViewModel> tasks = new List<TaskListViewModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                tasks = taskMgntDataService.GetProjectTaskByProjectID(oDB_Handle, ProjectID, UserID, TaskStatus, StartDate, EndDate);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return tasks;
        }

        public List<TaskListViewModel> GetProjectTaskDetailsByTaskID(int TaskID)
        {
            TaskMgntDataService taskMgntDataService = new TaskMgntDataService();
            List<TaskListViewModel> tasks = new List<TaskListViewModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                tasks = taskMgntDataService.GetProjectTaskDetailsByTaskID(oDB_Handle, TaskID);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return tasks;
        }

        public List<TaskImgURLModel> GetProjectTaskImgUrlsByTaskID(int TaskID)
        {
            TaskMgntDataService taskMgntDataService = new TaskMgntDataService();
            List<TaskImgURLModel> taskImgURLs = new List<TaskImgURLModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                taskImgURLs = taskMgntDataService.GetProjectTaskImgUrlsByTaskID(oDB_Handle, TaskID);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return taskImgURLs;
        }

        public List<OutputMessageModel> SaveTaskDetails(TaskModel task)
        {
            TaskMgntDataService taskMgntDataService = new TaskMgntDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                msgModel = taskMgntDataService.SaveTaskDetails(oDB_Handle, task);

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

        public List<OutputMessageModel> UpdateTaskDetails(TaskModel task)
        {
            TaskMgntDataService taskMgntDataService = new TaskMgntDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                msgModel = taskMgntDataService.UpdateTaskDetails(oDB_Handle, task);

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

        public List<OutputMessageModel> SaveTaskImageURLs(int TaskID, List<TaskImgURLModel> taskImgURLs, int UserID, string UserIP)
        {
            TaskMgntDataService taskMgntDataService = new TaskMgntDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                //Convert List object to JSON string
                var TaskImgURLJson = JsonConvert.SerializeObject(taskImgURLs.Select(
                x => new
                {
                    x.ImageName,
                    x.ImageURL
                }
                ).ToList());

                msgModel = taskMgntDataService.SaveTaskImageURLs(oDB_Handle, TaskID, TaskImgURLJson, UserID, UserIP);

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

        public void SendAllProTaskRelatedEmails(int TaskID)
        {

            ITaskMgntApplicationService taskMgntApplication = new TaskMgntApplicationService();
            IProjectMgntEmailApplicationService projectMgntEmailApplication = new ProjectMgntEmailApplicationService();
            IEmailMgntApplicationService emailMgntApplication = new EmailMgntApplicationService();

            List<TaskListViewModel> task = new List<TaskListViewModel>();
            task = taskMgntApplication.GetProjectTaskDetailsByTaskID(TaskID);

            #region Send Email to Customer
            //when task is completed
            if (task[0].TaskStatus == 3) {
                ProjectMgntEmailModel projectMgntEmailModel = new ProjectMgntEmailModel();
                projectMgntEmailModel = projectMgntEmailApplication.GenerateCompleteTaskEmailToClient(task[0]);

                EmailModel emailModel = new EmailModel();
                emailModel.ToEmail = task[0].ClientEmail;
                emailModel.MailSubject = projectMgntEmailModel.ProMgntEmailSubject;
                emailModel.BodyContent = projectMgntEmailModel.ProMgntEmailBody;

                var output1 = emailMgntApplication.SendGeneratedEmail(emailModel);
            }           
            #endregion

        }

    }
}
