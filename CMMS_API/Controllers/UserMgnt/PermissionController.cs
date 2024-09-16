using CMMS_ApplicationService.UserMgnt;
using CMMS_Model.Common;
using CMMS_Model.UserMgnt;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CMMS_API.Controllers.UserMgnt
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class PermissionController : ControllerBase
    {
        private readonly IPermissionApplicationService _repo;
        private IHttpContextAccessor _accessor;

        public PermissionController(IPermissionApplicationService repo, IHttpContextAccessor accessor)
        {
            _repo = repo;
            _accessor = accessor;
        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<PermissionModel>> GetAllPermissionDetails()
        {
            try
            {
                List<PermissionModel> permissions = new List<PermissionModel>();
                permissions = _repo.GetAllPermissionDetails();
                return Ok(permissions);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> AddPermissionDetails([FromBody] PermissionModel permission)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                permission.CreateUser = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                permission.CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.AddPermissionDetails(permission);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> UpdatePermissionDetails([FromBody] PermissionModel permission)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                permission.CreateUser = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                permission.CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.UpdatePermissionDetails(permission);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

    }
}
