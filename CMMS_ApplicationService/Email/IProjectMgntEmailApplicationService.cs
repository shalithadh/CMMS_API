using CMMS_Model.Email;
using CMMS_Model.ProjectMgnt;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.Email
{
    public interface IProjectMgntEmailApplicationService
    {
        ProjectMgntEmailModel GenerateCompleteTaskEmailToClient(TaskListViewModel task);
        ProjectMgntEmailModel GenerateTaskApprovalEmailToContractor(TaskListViewModel task);
        ProjectMgntEmailModel GenerateTaskRejectedEmailToContractor(TaskListViewModel task);
    }
}
