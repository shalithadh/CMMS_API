using CMMS_Model.Email;
using CMMS_Model.EStore;
using CMMS_Model.ProjectMgnt;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.Email
{
    public class ProjectMgntEmailApplicationService: IProjectMgntEmailApplicationService
    {

        public ProjectMgntEmailModel GenerateCompleteTaskEmailToClient(TaskListViewModel task)
        {

            ProjectMgntEmailModel orderEmailModel = new ProjectMgntEmailModel();
            var emailBody = "";

            try
            {
                var emailHead = "";

                var emailHeaderTableHead =
                  "<p>Below Task is <b>completed</b> by the contractor. Please approve the task by visiting CMMS.</p>" +
                  "<br/>" +
                  "<center>" +
                  "<table border=" + 0 + " cellpadding=" + 0 + " cellspacing=" + 0 + " width = '100%'>" +
                  //row1
                  "<tr>" +
                  "<td>Task Name: <b>" + task.TaskName + "</b></th> " +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "</tr>" +
                  //row2
                  "<tr>" +
                  "<td>Project Title: <b>" + task.ProjectTitle + "</b></th> " +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "</tr>" +
                  "</table>" +
                  "</center>" +
                  "<br/><br/>"
                  ;

                //Email Head
                emailHead = emailHeaderTableHead;

                //Email Footer
                var emailFooter = "<center><p><b>This is an auto-generated mail from CMMS.</b></p></center>";

                //Full Email
                emailBody = emailHead + emailFooter;

                orderEmailModel.ProMgntEmailSubject = "Task - " + task.TaskName + " is Completed";
                orderEmailModel.ProMgntEmailBody = emailBody;

                return orderEmailModel;
            }
            catch (Exception)
            {
                orderEmailModel.ProMgntEmailBody = "Failed";
                return orderEmailModel;
                throw;
            }
        }

        public ProjectMgntEmailModel GenerateTaskApprovalEmailToContractor(TaskListViewModel task)
        {

            ProjectMgntEmailModel orderEmailModel = new ProjectMgntEmailModel();
            var emailBody = "";

            try
            {
                var emailHead = "";

                var emailHeaderTableHead =
                  "<p>Below Task is <b>approved</b> by the client. Please check the task by visiting CMMS.</p>" +
                  "<br/>" +
                  "<center>" +
                  "<table border=" + 0 + " cellpadding=" + 0 + " cellspacing=" + 0 + " width = '100%'>" +
                  //row1
                  "<tr>" +
                  "<td>Task Name: <b>" + task.TaskName + "</b></th> " +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "</tr>" +
                  //row2
                  "<tr>" +
                  "<td>Project Title: <b>" + task.ProjectTitle + "</b></th> " +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "</tr>" +              
                  "</table>" +
                  "</center>" +
                  "<br/><br/>"
                  ;

                //Email Head
                emailHead = emailHeaderTableHead;

                //Email Footer
                var emailFooter = "<center><p><b>This is an auto-generated mail from CMMS.</b></p></center>";

                //Full Email
                emailBody = emailHead  + emailFooter;

                orderEmailModel.ProMgntEmailSubject = "Task - " + task.TaskName + " is Approved";
                orderEmailModel.ProMgntEmailBody = emailBody;

                return orderEmailModel;
            }
            catch (Exception)
            {
                orderEmailModel.ProMgntEmailBody = "Failed";
                return orderEmailModel;
                throw;
            }
        }

        public ProjectMgntEmailModel GenerateTaskRejectedEmailToContractor(TaskListViewModel task)
        {

            ProjectMgntEmailModel orderEmailModel = new ProjectMgntEmailModel();
            var emailBody = "";

            try
            {
                var emailHead = "";

                var emailHeaderTableHead =
                  "<p>Below Task is <b>rejected</b> by the client. Please check the task by visiting CMMS.</p>" +
                  "<br/>" +
                  "<center>" +
                  "<table border=" + 0 + " cellpadding=" + 0 + " cellspacing=" + 0 + " width = '100%'>" +
                  //row1
                  "<tr>" +
                  "<td>Task Name: <b>" + task.TaskName + "</b></th> " +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "</tr>" +
                  //row2
                  "<tr>" +
                  "<td>Project Title: <b>" + task.ProjectTitle + "</b></th> " +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "</tr>" +
                  "</table>" +
                  "</center>" +
                  "<br/><br/>"
                  ;

                //Email Head
                emailHead = emailHeaderTableHead;

                //Email Footer
                var emailFooter = "<center><p><b>This is an auto-generated mail from CMMS.</b></p></center>";

                //Full Email
                emailBody = emailHead + emailFooter;

                orderEmailModel.ProMgntEmailSubject = "Task - " + task.TaskName + " is Rejected";
                orderEmailModel.ProMgntEmailBody = emailBody;

                return orderEmailModel;
            }
            catch (Exception)
            {
                orderEmailModel.ProMgntEmailBody = "Failed";
                return orderEmailModel;
                throw;
            }
        }

    }
}