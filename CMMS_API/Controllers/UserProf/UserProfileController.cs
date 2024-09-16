using CMMS_ApplicationService.UserProf;
using CMMS_Model.Common;
using CMMS_Model.UserProf;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CMMS_API.Controllers.UserProf
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class UserProfileController : ControllerBase
    {
        private readonly IUserProfileApplicationService _repo;
        private IHttpContextAccessor _accessor;

        public UserProfileController(IUserProfileApplicationService repo, IHttpContextAccessor accessor)
        {
            _repo = repo;
            _accessor = accessor;
        }

        [Authorize]
        [HttpGet]
        public ActionResult<UserProfileMainViewModel> GetUserProfileDetails()
        {
            try
            {
                int UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                UserProfileMainViewModel userProfile = new UserProfileMainViewModel();
                userProfile = _repo.GetUserProfileDetails(UserID);
                return Ok(userProfile);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<UserProfImgURLModel>> GetUserProfImgUrlsByUserID()
        {
            try
            {
                int UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                List<UserProfImgURLModel> userImgURLs = new List<UserProfImgURLModel>();
                userImgURLs = _repo.GetUserProfImgUrlsByUserID(UserID);
                return Ok(userImgURLs);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> UpdateUserProfDetails([FromBody] UserProfUpdateModel user)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                user.UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                user.UserRoleID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Role));
                user.CreateUser = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                user.CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.UpdateUserProfDetails(user);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> SaveUserProfImageURLs([FromBody] UserProfImgURLViewModel userImgURL)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                userImgURL.UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                string CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.SaveUserProfImageURLs(userImgURL.UserID, userImgURL.UserImgURLs, CreateIP);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> UpdateUserProfPassword([FromBody] UserProfChangePasswordModel user)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                user.UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                user.CreateUser = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                user.CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.UpdateUserProfPassword(user);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

    }
}
