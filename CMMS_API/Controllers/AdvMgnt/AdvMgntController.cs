using CMMS_ApplicationService.AdvMgnt;
using CMMS_Model.AdvMgnt;
using CMMS_Model.Common;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CMMS_API.Controllers.AdvMgnt
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class AdvMgntController : ControllerBase
    {
        private readonly IAdvMgntApplicationService _repo;
        private IHttpContextAccessor _accessor;

        public AdvMgntController(IAdvMgntApplicationService repo, IHttpContextAccessor accessor)
        {
            _repo = repo;
            _accessor = accessor;
        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<AdvListViewModel>> GetAdvListByUserID(string StartDate, string EndDate)
        {
            try
            {
                int UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                List<AdvListViewModel> advLists = new List<AdvListViewModel>();
                advLists = _repo.GetAdvListByUserID(UserID, StartDate, EndDate);
                return Ok(advLists);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<AdvImgURLModel>> GetAdvImgUrlsByAdvID(int AdvID)
        {
            try
            {
                List<AdvImgURLModel> advImgURLs = new List<AdvImgURLModel>();
                advImgURLs = _repo.GetAdvImgUrlsByAdvID(AdvID);
                return Ok(advImgURLs);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> SaveAdvDetails([FromBody] AdvModel adv)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                adv.UserRoleID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Role));
                adv.CreateUser = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                adv.CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.SaveAdvDetails(adv);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> UpdateAdvDetails([FromBody] AdvModel adv)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                adv.UserRoleID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Role));
                adv.CreateUser = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                adv.CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.UpdateAdvDetails(adv);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> SaveAdvImageURLs([FromBody] AdvImgURLViewModel advImgURL)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                int CreateUser = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                string CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.SaveAdvImageURLs(advImgURL.AdvID, advImgURL.AdvImgURLs, CreateUser, CreateIP);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

    }
}
