using CMMS_ApplicationService.EStore;
using CMMS_Model.EStore;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CMMS_API.Controllers.EStore
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class EStoreItemController : ControllerBase
    {
        private readonly IEStoreItemApplicationService _repo;
        private IHttpContextAccessor _accessor;

        public EStoreItemController(IEStoreItemApplicationService repo, IHttpContextAccessor accessor)
        {
            _repo = repo;
            _accessor = accessor;
        }

        [Authorize]
        [HttpGet]
        public ActionResult<EStoreInitialDataModel> GetInitialEStoreItemData()
        {
            try
            {
                EStoreInitialDataModel initialData = new EStoreInitialDataModel();
                initialData = _repo.GetInitialEStoreItemData();
                return Ok(initialData);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<EStoreItemViewModel>> GetEStoreItemList(int VendorCategoryTypeID)
        {
            try
            {
                List<EStoreItemViewModel> eStoreItems = new List<EStoreItemViewModel>();
                eStoreItems = _repo.GetEStoreItemList(VendorCategoryTypeID);
                return Ok(eStoreItems);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<EStoreItemViewModel>> GetEStoreItemListByItemID(int ItemID)
        {
            try
            {
                List<EStoreItemViewModel> eStoreItem = new List<EStoreItemViewModel>();
                eStoreItem = _repo.GetEStoreItemListByItemID(ItemID);
                return Ok(eStoreItem);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<EStoreItemSearchModel>> GetEStoreItemSearch(string? searchKeyword)
        {
            try
            {
                List<EStoreItemSearchModel> eStoreItems = new List<EStoreItemSearchModel>();
                eStoreItems = _repo.GetEStoreItemSearch(searchKeyword);
                return Ok(eStoreItems);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

    }
}
