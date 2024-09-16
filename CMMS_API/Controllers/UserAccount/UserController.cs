using CMMS_ApplicationService.UserAccount;
using CMMS_Model.Authentication.Contracts;
using CMMS_Model.Common;
using CMMS_Model.UserAccount;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CMMS_API.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly IUserAuthApplicationService _repo;
        private IHttpContextAccessor _accessor;
        private readonly IJWTTokenGenerator _jWTToken;

        public UserController(IUserAuthApplicationService repo, IHttpContextAccessor accessor,
            IJWTTokenGenerator jWTToken)
        {
            _repo = repo;
            _accessor = accessor;
            _jWTToken = jWTToken;
        }

        [AllowAnonymous]
        [HttpPost]
        public ActionResult<UserLogin> UserLogin ([FromBody] UserDetail loginViewModel)
        {
            try
            {
                UserLogin userLogin = new UserLogin();
                userLogin = _repo.AuthorizeUser(loginViewModel);

                //When User is Valid
                if(userLogin.outputMessage.RsltType == 1) 
                {
                    //Generate Token
                    var token = _jWTToken.GenerateUserToken(userLogin.userDetail.UserID, userLogin.userDetail.UserName,
                        userLogin.userDetail.Name, userLogin.userDetail.RoleID);
                    userLogin.userDetail.Token = token;

                    //User Permissions
                    string[] permissions = _repo.GetUserPermissions(userLogin.userDetail.UserID);

                    userLogin.userDetail.Permissions = permissions;
                }         

                return Ok(userLogin);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [AllowAnonymous]
        [HttpGet]
        public ActionResult<string[]> GetAllUserPermissions()
        {
            try
            {
                string[] userPermissions;
                userPermissions = _repo.GetAllUserPermissions();
                return Ok(userPermissions);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [AllowAnonymous]
        [HttpGet]
        public ActionResult<UserRegInitialDataModel> GetInitialUserRegData()
        {
            try
            {
                UserRegInitialDataModel initialData = new UserRegInitialDataModel();
                initialData = _repo.GetInitialUserRegData();
                return Ok(initialData);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [AllowAnonymous]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> SaveUserDetails([FromBody] UserRegistration user)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                user.CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.SaveUserDetails(user);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [AllowAnonymous]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> ResetUserLoginPassword([FromBody] UserPassResetModel user)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                user.CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.ResetUserLoginPassword(user);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }
    }
}
