using CMMS_Model.Common;
using CMMS_Model.ProjectMgnt;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.ProjectMgnt
{
    public interface ITaskApprovalApplicationService
    {
        List<TaskListViewModel> GetPendingApprovalTaskList(int UserID);
        List<TaskListViewModel> GetPendingApprovalTaskListByTaskID(int UserID, int TaskID);
        List<OutputMessageModel> SaveTaskReviewInfo(TaskReviewModel taskReview);
        public List<OutputMessageModel> SaveTaskRejectInfo(TaskRejectInfoModel taskReject);
        void SendAllProTaskApprovalEmails(int TaskID);
        void SendAllProTaskRejectEmails(int TaskID);
    }
}
