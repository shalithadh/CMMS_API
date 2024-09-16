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
    public class UserRoleController : ControllerBase
    {
        private readonly IUserRoleApplicationService _repo;
        private IHttpContextAccessor _accessor;

        public UserRoleController(IUserRoleApplicationService repo, IHttpContextAccessor accessor)
        {
            _repo = repo;
            _accessor = accessor;
        }

        [Authorize]
        [HttpGet]
        public ActionResult<UserRoleInitialDataModel> GetInitialUserRolePermiData()
        {
            try
            {
                UserRoleInitialDataModel initialData = new UserRoleInitialDataModel();
                initialData = _repo.GetInitialUserRolePermiData();
                return Ok(initialData);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<UserRoleAllPermissionViewModel>> GetUserRoleAllPermissions()
        {
            try
            {
                List<UserRoleAllPermissionViewModel> userRoleAllPermissions = new List<UserRoleAllPermissionViewModel>();
                userRoleAllPermissions = _repo.GetUserRoleAllPermissions();
                return Ok(userRoleAllPermissions);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<UserRolePermiByRoleIDViewModel>> GetUserRolePermissionsByRoleID(int RoleID)
        {
            try
            {
                List<UserRolePermiByRoleIDViewModel> userRolePermis = new List<UserRolePermiByRoleIDViewModel>();
                userRolePermis = _repo.GetUserRolePermissionsByRoleID(RoleID);
                return Ok(userRolePermis);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> SaveUserRolePermissionDetails([FromBody] UserRoleWiseViewModel user)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                user.CreateUser = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                user.CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.SaveUserRolePermissionDetails(user, user.UserRolePermiList);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

    }
}
