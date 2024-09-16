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
    public class ProjectMgntController : ControllerBase
    {
        private readonly IProjectMgntApplicationService _repo;
        private IHttpContextAccessor _accessor;

        public ProjectMgntController(IProjectMgntApplicationService repo, IHttpContextAccessor accessor)
        {
            _repo = repo;
            _accessor = accessor;
        }

        [Authorize]
        [HttpGet]
        public ActionResult<ProjectInitialDataModel> LoadInitialData()
        {
            try
            {
                ProjectInitialDataModel initialData = new ProjectInitialDataModel();
                initialData = _repo.GetInitialProjectData();
                return Ok(initialData);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<ProjectModel>> GetProjectDetailsByProjectID(int ProjectID)
        {
            try
            {
                int UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                List<ProjectModel> projectModel = new List<ProjectModel>();
                projectModel = _repo.GetProjectDetailsByProjectID(ProjectID, UserID);
                return Ok(projectModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<ProjectListViewModel>> GetProjectDetailsAllByUserID(int ProjectStatus)
        {
            try
            {
                int UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                List<ProjectListViewModel> projects = new List<ProjectListViewModel>();
                projects = _repo.GetProjectDetailsAllByUserID(UserID, ProjectStatus);
                return Ok(projects);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<CustomerSearchModel>> GetSearchCustomers(string? searchKeyword)
        {
            try
            {
                List<CustomerSearchModel> customers = new List<CustomerSearchModel>();
                customers = _repo.GetSearchCustomers(searchKeyword);
                return Ok(customers);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }


        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> SaveProjectDetails([FromBody] ProjectModel project)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                project.CreateUser = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                project.CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.SaveProjectDetails(project);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> UpdateProjectDetails([FromBody] ProjectModel project)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                project.CreateUser = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                project.CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.UpdateProjectDetails(project);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

    }
}
