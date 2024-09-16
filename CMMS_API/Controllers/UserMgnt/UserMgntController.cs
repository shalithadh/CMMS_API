using CMMS_ApplicationService.UserMgnt;
using CMMS_Model.Authentication;
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
    public class UserMgntController : ControllerBase
    {
        private readonly IUserMgntApplicationService _repo;
        private IHttpContextAccessor _accessor;

        public UserMgntController(IUserMgntApplicationService repo, IHttpContextAccessor accessor)
        {
            _repo = repo;
            _accessor = accessor;
        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<UserMgntAllUserViewModel>> GetAllUserDetails()
        {
            try
            {
                List<UserMgntAllUserViewModel> users = new List<UserMgntAllUserViewModel>();
                users = _repo.GetAllUserDetails();
                return Ok(users);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<UserMgntAllUserViewModel>> GetUserDetailsByUserID(int UserID)
        {
            try
            {
                List<UserMgntAllUserViewModel> users = new List<UserMgntAllUserViewModel>();
                users = _repo.GetUserDetailsByUserID(UserID);
                return Ok(users);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> ResetUserPassword([FromBody] UserMgntResetPasswordModel user)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                RandomGenerator generator = new RandomGenerator();
                string tempPass = generator.RandomString(8, true);
                user.TempPassword = AESOperation.EncryptString(Constants.AESCustomKey, tempPass);
                user.CreateUser = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                user.CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.ResetUserPassword(user);

                //send emails
                if (msgModel[0].RsltType == 1)
                {
                    _repo.SendUserResetPasswordEmails((int)msgModel[0].SavedID, tempPass);
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
        public ActionResult<List<OutputMessageModel>> UpdateUserStatusDetails([FromBody] UserMgntChangeUserStatusModel user)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                user.CreateUser = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                user.CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.UpdateUserStatusDetails(user);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

    }
}
