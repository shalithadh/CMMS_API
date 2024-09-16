using CMMS_ApplicationService.ProjectMgnt;
using CMMS_Model.Common;
using CMMS_Model.ProjectMgnt;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CMMS_API.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class ProjectMgntTaskController : ControllerBase
    {
        private readonly ITaskMgntApplicationService _repo;
        private IHttpContextAccessor _accessor;

        public ProjectMgntTaskController(ITaskMgntApplicationService repo, IHttpContextAccessor accessor)
        {
            _repo = repo;
            _accessor = accessor;
        }

        [Authorize]
        [HttpGet]
        public ActionResult<TaskInitialDataModel> GetInitialTaskMgntData()
        {
            try
            {
                TaskInitialDataModel initialData = new TaskInitialDataModel();
                initialData = _repo.GetInitialTaskMgntData();
                return Ok(initialData);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<AssignToComboModel> GetAssignToContractorList(int ServiceTypeID)
        {
            try
            {
                AssignToComboModel assignToList = new AssignToComboModel();
                assignToList = _repo.GetAssignToContractorList(ServiceTypeID);
                return Ok(assignToList);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<TaskListViewModel>> GetProjectTaskByProjectID(int ProjectID, int TaskStatus, string StartDate, string EndDate)
        {
            try
            {
                int UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                List<TaskListViewModel> taskLists = new List<TaskListViewModel>();
                taskLists = _repo.GetProjectTaskByProjectID(ProjectID, UserID, TaskStatus, StartDate, EndDate);
                return Ok(taskLists);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<TaskListViewModel>> GetProjectTaskDetailsByTaskID(int TaskID)
        {
            try
            {
                List<TaskListViewModel> taskLists = new List<TaskListViewModel>();
                taskLists = _repo.GetProjectTaskDetailsByTaskID(TaskID);
                return Ok(taskLists);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<TaskImgURLModel>> GetProjectTaskImgUrlsByTaskID(int TaskID)
        {
            try
            {
                List<TaskImgURLModel> taskImgURLs = new List<TaskImgURLModel>();
                taskImgURLs = _repo.GetProjectTaskImgUrlsByTaskID(TaskID);
                return Ok(taskImgURLs);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> SaveTaskDetails([FromBody] TaskModel task)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                task.CreateUser = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                task.CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.SaveTaskDetails(task);

                //send emails
                if (msgModel[0].RsltType == 1)
                {
                    _repo.SendAllProTaskRelatedEmails((int)msgModel[0].SavedID);
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
        public ActionResult<List<OutputMessageModel>> UpdateTaskDetails([FromBody] TaskModel task)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                task.CreateUser = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                task.CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.UpdateTaskDetails(task);

                //send emails
                if (msgModel[0].RsltType == 1)
                {
                    _repo.SendAllProTaskRelatedEmails((int)msgModel[0].SavedID);
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
        public ActionResult<List<OutputMessageModel>> SaveTaskImageURLs([FromBody] TaskImgURLViewModel taskImgURLModel)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                int CreateUser = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                string CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.SaveTaskImageURLs(taskImgURLModel.TaskID, taskImgURLModel.TaskImgURLs, CreateUser, CreateIP);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

    }
}
