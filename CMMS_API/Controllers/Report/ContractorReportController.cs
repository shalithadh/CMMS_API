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
    public class ContractorReportController : ControllerBase
    {
        private readonly IContractorReportApplicationService _repo;
        private IHttpContextAccessor _accessor;

        public ContractorReportController(IContractorReportApplicationService repo, IHttpContextAccessor accessor)
        {
            _repo = repo;
            _accessor = accessor;
        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<ProjectOverviewModel>> GetProjectOverviewReportDetails(string StartDate, string EndDate)
        {
            try
            {
                int UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                List<ProjectOverviewModel> reportDetails = new List<ProjectOverviewModel>();
                reportDetails = _repo.GetProjectOverviewReportDetails(UserID, StartDate, EndDate);
                return Ok(reportDetails);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<ProjectProgressInitialModel> GetProjectProgressInitialData()
        {
            try
            {
                int UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                ProjectProgressInitialModel reportDetails = new ProjectProgressInitialModel();
                reportDetails = _repo.GetProjectProgressInitialData(UserID);
                return Ok(reportDetails);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<ProjectProgressModel>> GetProjectProgressDetails(int ProjectID)
        {
            try
            {
                int UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                List<ProjectProgressModel> reportDetails = new List<ProjectProgressModel>();
                reportDetails = _repo.GetProjectProgressDetails(ProjectID);
                return Ok(reportDetails);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<ContractorReviewInitialModel> GetContractorReviewInitialData()
        {
            try
            {
                int UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                ContractorReviewInitialModel reportDetails = new ContractorReviewInitialModel();
                reportDetails = _repo.GetContractorReviewInitialData();
                return Ok(reportDetails);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<ContractorReviewModel>> GetContractorReviewDetails(int Year, int Month)
        {
            try
            {
                int UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                List<ContractorReviewModel> reportDetails = new List<ContractorReviewModel>();
                reportDetails = _repo.GetContractorReviewDetails(Year, Month);
                return Ok(reportDetails);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

    }
}
