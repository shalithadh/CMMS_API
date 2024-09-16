using CMMS_ApplicationService.ProjectMgnt;
using CMMS_Model.Common;
using CMMS_Model.ProjectMgnt;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CMMS_API.Controllers.ProjectMgnt
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class ProjectMgntApprovalController : ControllerBase
    {
        private readonly ITaskApprovalApplicationService _repo;
        private IHttpContextAccessor _accessor;

        public ProjectMgntApprovalController(ITaskApprovalApplicationService repo, IHttpContextAccessor accessor)
        {
            _repo = repo;
            _accessor = accessor;
        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<TaskListViewModel>> GetPendingApprovalTaskList()
        {
            try
            {
                int UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                List<TaskListViewModel> taskLists = new List<TaskListViewModel>();
                taskLists = _repo.GetPendingApprovalTaskList(UserID);
                return Ok(taskLists);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<TaskListViewModel>> GetPendingApprovalTaskListByTaskID(int TaskID)
        {
            try
            {
                int UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                List<TaskListViewModel> taskLists = new List<TaskListViewModel>();
                taskLists = _repo.GetPendingApprovalTaskListByTaskID(UserID, TaskID);
                return Ok(taskLists);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> SaveTaskReviewInfo([FromBody] TaskReviewModel taskReview)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                taskReview.CreateUser = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                taskReview.CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.SaveTaskReviewInfo(taskReview);

                //send emails
                if (msgModel[0].RsltType == 1)
                {
                    _repo.SendAllProTaskApprovalEmails((int)msgModel[0].SavedID);
                }

                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> SaveTaskRejectInfo([FromBody] TaskRejectInfoModel taskReject)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                taskReject.CreateUser = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                taskReject.CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.SaveTaskRejectInfo(taskReject);

                //send emails
                if (msgModel[0].RsltType == 1)
                {
                    _repo.SendAllProTaskRejectEmails((int)msgModel[0].SavedID);
                }

                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

    }
}
