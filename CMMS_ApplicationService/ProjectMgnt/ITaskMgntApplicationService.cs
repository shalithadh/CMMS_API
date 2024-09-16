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
    public interface ITaskMgntApplicationService
    {
        TaskInitialDataModel GetInitialTaskMgntData();
        AssignToComboModel GetAssignToContractorList(int ServiceTypeID);
        List<TaskListViewModel> GetProjectTaskByProjectID(int ProjectID, int UserID, int TaskStatus, string StartDate, string EndDate);
        List<TaskListViewModel> GetProjectTaskDetailsByTaskID(int TaskID);
        List<TaskImgURLModel> GetProjectTaskImgUrlsByTaskID(int TaskID);
        List<OutputMessageModel> SaveTaskDetails(TaskModel task);
        List<OutputMessageModel> UpdateTaskDetails(TaskModel task);
        List<OutputMessageModel> SaveTaskImageURLs(int TaskID, List<TaskImgURLModel> taskImgURLs, int UserID, string UserIP);
        void SendAllProTaskRelatedEmails(int TaskID);
    }
}
