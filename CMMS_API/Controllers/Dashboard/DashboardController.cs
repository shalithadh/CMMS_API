using CMMS_ApplicationService.Dashboard;
using CMMS_Model.Dashboard;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CMMS_API.Controllers.Dashboard
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class DashboardController : ControllerBase
    {

        private readonly IDashboardApplicationService _repo;
        private IHttpContextAccessor _accessor;

        public DashboardController(IDashboardApplicationService repo, IHttpContextAccessor accessor)
        {
            _repo = repo;
            _accessor = accessor;
        }

        [Authorize]
        [HttpGet]
        public ActionResult<AdminDashboardModel> GetAdminDashboardDetails()
        {
            try
            {
                int UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                AdminDashboardModel adminDashboard = new AdminDashboardModel();
                adminDashboard = _repo.GetAdminDashboardDetails();
                return Ok(adminDashboard);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Authorize]
        [HttpGet]
        public ActionResult<ContractorDashboardModel> GetContractorDashboardDetails()
        {
            try
            {
                int UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                ContractorDashboardModel contractorDashboard = new ContractorDashboardModel();
                contractorDashboard = _repo.GetContractorDashboardDetails(UserID);
                return Ok(contractorDashboard);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<VendorDashboardModel> GetVendorDashboardDetails()
        {
            try
            {
                int UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                VendorDashboardModel vendorDashboard = new VendorDashboardModel();
                vendorDashboard = _repo.GetVendorDashboardDetails(UserID);
                return Ok(vendorDashboard);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<CustomerDashboardModel> GetCustomerDashboardDetails()
        {
            try
            {
                int UserID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                CustomerDashboardModel customerDashboard = new CustomerDashboardModel();
                customerDashboard = _repo.GetCustomerDashboardDetails(UserID);
                return Ok(customerDashboard);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

    }
}
