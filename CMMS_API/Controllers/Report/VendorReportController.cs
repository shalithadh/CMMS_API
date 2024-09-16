using CMMS_ApplicationService.Report;
using CMMS_Model.Report;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CMMS_API.Controllers.Report
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class VendorReportController : ControllerBase
    {
        private readonly IVendorReportApplicationService _repo;
        private IHttpContextAccessor _accessor;

        public VendorReportController(IVendorReportApplicationService repo, IHttpContextAccessor accessor)
        {
            _repo = repo;
            _accessor = accessor;
        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<SalesOverviewModel>> GetSalesOverviewDetails(int Year, int Month)
        {
            try
            {
                int UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                List<SalesOverviewModel> reportDetails = new List<SalesOverviewModel>();
                reportDetails = _repo.GetSalesOverviewDetails(UserID, Year, Month);
                return Ok(reportDetails);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<OrderStatusModel>> GetOrderStatusDetails(int Year, int Month)
        {
            try
            {
                int UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                List<OrderStatusModel> reportDetails = new List<OrderStatusModel>();
                reportDetails = _repo.GetOrderStatusDetails(UserID, Year, Month);
                return Ok(reportDetails);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<InventorySummaryModel>> GetInventorySummaryDetails(int VendorCategoryTypeID)
        {
            try
            {
                int UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                List<InventorySummaryModel> reportDetails = new List<InventorySummaryModel>();
                reportDetails = _repo.GetInventorySummaryDetails(VendorCategoryTypeID, UserID);
                return Ok(reportDetails);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<CustomerOverallModel>> GetCustomerOverallDetails(int Year, int Month)
        {
            try
            {
                int UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                List<CustomerOverallModel> reportDetails = new List<CustomerOverallModel>();
                reportDetails = _repo.GetCustomerOverallDetails(UserID, Year, Month);
                return Ok(reportDetails);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<PopularItemModel>> GetPopularItemDetails(int Year, int Month)
        {
            try
            {
                int UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                List<PopularItemModel> reportDetails = new List<PopularItemModel>();
                reportDetails = _repo.GetPopularItemDetails(UserID, Year, Month);
                return Ok(reportDetails);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

    }
}
