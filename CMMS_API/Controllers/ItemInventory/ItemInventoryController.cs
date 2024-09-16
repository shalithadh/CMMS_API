using CMMS_ApplicationService.ItemInventory;
using CMMS_Model.Common;
using CMMS_Model.ItemInventory;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CMMS_API.Controllers.ItemInventory
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class ItemInventoryController : ControllerBase
    {
        private readonly IItemInventoryApplicationService _repo;
        private IHttpContextAccessor _accessor;

        public ItemInventoryController(IItemInventoryApplicationService repo, IHttpContextAccessor accessor)
        {
            _repo = repo;
            _accessor = accessor;
        }

        [Authorize]
        [HttpGet]
        public ActionResult<ItemInvInitialDataModel> GetInitialItemInventoryData()
        {
            try
            {
                int VendorID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                ItemInvInitialDataModel initialData = new ItemInvInitialDataModel();
                initialData = _repo.GetInitialItemInventoryData(VendorID);
                return Ok(initialData);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<ItemInvListViewModal>> GetItemInvListByUserID(int VendorCategoryTypeID)
        {
            try
            {
                int VendorID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                List<ItemInvListViewModal> itemInvLists = new List<ItemInvListViewModal>();
                itemInvLists = _repo.GetItemInvListByUserID(VendorCategoryTypeID, VendorID);
                return Ok(itemInvLists);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<ItemImgURLModel>> GetItemInvImgUrlsByItemID(int ItemID)
        {
            try
            {
                List<ItemImgURLModel> itemImgURLs = new List<ItemImgURLModel>();
                itemImgURLs = _repo.GetItemInvImgUrlsByItemID(ItemID);
                return Ok(itemImgURLs);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> SaveItemInvDetails([FromBody] ItemModel item)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                item.VendorID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                item.CreateUser = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                item.CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.SaveItemInvDetails(item);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> UpdateItemInvDetails([FromBody] ItemModel item)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                item.VendorID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                item.CreateUser = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                item.CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.UpdateItemInvDetails(item);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> SaveItemImageURLs([FromBody] ItemImgURLViewModel itemImgURL)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                int CreateUser = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                string CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.SaveItemImageURLs(itemImgURL.ItemID, itemImgURL.ItemImgURLs, CreateUser, CreateIP);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

    }
}
