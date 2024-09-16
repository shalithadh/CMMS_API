using CMMS_ApplicationService.Email;
using CMMS_DataService.ProjectMgnt;
using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using CMMS_Model.Email;
using CMMS_Model.ProjectMgnt;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.ProjectMgnt
{
    public class TaskApprovalApplicationService: ITaskApprovalApplicationService
    {

        DB_Handle oDB_Handle = new DB_Handle();

        public List<TaskListViewModel> GetPendingApprovalTaskList(int UserID)
        {
            TaskApprovalDataService taskApprovalDataService = new TaskApprovalDataService();
            List<TaskListViewModel> tasks = new List<TaskListViewModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                tasks = taskApprovalDataService.GetPendingApprovalTaskList(oDB_Handle, UserID);

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

        public List<TaskListViewModel> GetPendingApprovalTaskListByTaskID(int UserID, int TaskID)
        {
            TaskApprovalDataService taskApprovalDataService = new TaskApprovalDataService();
            List<TaskListViewModel> tasks = new List<TaskListViewModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                tasks = taskApprovalDataService.GetPendingApprovalTaskListByTaskID(oDB_Handle, UserID, TaskID);

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

        public List<OutputMessageModel> SaveTaskReviewInfo(TaskReviewModel taskReview)
        {
            TaskApprovalDataService taskApprovalDataService = new TaskApprovalDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                msgModel = taskApprovalDataService.SaveTaskReviewInfo(oDB_Handle, taskReview);

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

        public List<OutputMessageModel> SaveTaskRejectInfo(TaskRejectInfoModel taskReject)
        {
            TaskApprovalDataService taskApprovalDataService = new TaskApprovalDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                msgModel = taskApprovalDataService.SaveTaskRejectInfo(oDB_Handle, taskReject);

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

        public void SendAllProTaskApprovalEmails(int TaskID)
        {

            ITaskMgntApplicationService taskMgntApplication = new TaskMgntApplicationService();
            IProjectMgntEmailApplicationService projectMgntEmailApplication = new ProjectMgntEmailApplicationService();
            IEmailMgntApplicationService emailMgntApplication = new EmailMgntApplicationService();

            List<TaskListViewModel> task = new List<TaskListViewModel>();
            task = taskMgntApplication.GetProjectTaskDetailsByTaskID(TaskID);

            #region Send Email to Customer
            ProjectMgntEmailModel projectMgntEmailModel = new ProjectMgntEmailModel();
            projectMgntEmailModel = projectMgntEmailApplication.GenerateTaskApprovalEmailToContractor(task[0]);

            EmailModel emailModel = new EmailModel();
            emailModel.ToEmail = task[0].ContractorEmail;
            emailModel.MailSubject = projectMgntEmailModel.ProMgntEmailSubject;
            emailModel.BodyContent = projectMgntEmailModel.ProMgntEmailBody;

            var output1 = emailMgntApplication.SendGeneratedEmail(emailModel);
            #endregion

        }

        public void SendAllProTaskRejectEmails(int TaskID)
        {

            ITaskMgntApplicationService taskMgntApplication = new TaskMgntApplicationService();
            IProjectMgntEmailApplicationService projectMgntEmailApplication = new ProjectMgntEmailApplicationService();
            IEmailMgntApplicationService emailMgntApplication = new EmailMgntApplicationService();

            List<TaskListViewModel> task = new List<TaskListViewModel>();
            task = taskMgntApplication.GetProjectTaskDetailsByTaskID(TaskID);

            #region Send Email to Customer
            ProjectMgntEmailModel projectMgntEmailModel = new ProjectMgntEmailModel();
            projectMgntEmailModel = projectMgntEmailApplication.GenerateTaskRejectedEmailToContractor(task[0]);

            EmailModel emailModel = new EmailModel();
            emailModel.ToEmail = task[0].ContractorEmail;
            emailModel.MailSubject = projectMgntEmailModel.ProMgntEmailSubject;
            emailModel.BodyContent = projectMgntEmailModel.ProMgntEmailBody;

            var output1 = emailMgntApplication.SendGeneratedEmail(emailModel);
            #endregion

        }

    }
}
