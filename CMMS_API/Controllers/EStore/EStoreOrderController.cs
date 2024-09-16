using CMMS_ApplicationService.EStore;
using CMMS_Model.Common;
using CMMS_Model.EStore;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CMMS_API.Controllers.EStore
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class EStoreOrderController : ControllerBase
    {
        private readonly IEStoreOrderApplicationService _repo;
        private IHttpContextAccessor _accessor;

        public EStoreOrderController(IEStoreOrderApplicationService repo, IHttpContextAccessor accessor)
        {
            _repo = repo;
            _accessor = accessor;
        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<EStoreOrderCusDetail>> GetEStoreCustomerDetails()
        {
            try
            {
                int CustomerID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                List<EStoreOrderCusDetail> cusDetails = new List<EStoreOrderCusDetail>();
                cusDetails = _repo.GetEStoreCustomerDetails(CustomerID);
                return Ok(cusDetails);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<EStoreOrderHistoryMainViewModel>> GetOrderCustomerHistory()
        {
            try
            {
                int CustomerID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                List<EStoreOrderHistoryMainViewModel> eStoreOrderHistories = new List<EStoreOrderHistoryMainViewModel>();
                eStoreOrderHistories = _repo.GetOrderCustomerHistory(CustomerID);
                return Ok(eStoreOrderHistories);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<EStoreInvoiceViewModel> GetOrderDetailByOrderID(int OrderID)
        {
            try
            {
                int CustomerID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                EStoreInvoiceViewModel invoiceViewModel = new EStoreInvoiceViewModel();
                invoiceViewModel = _repo.GetOrderDetailByOrderID(OrderID, CustomerID);
                return Ok(invoiceViewModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> SaveCusOrderDetails([FromBody] EStoreOrderDetail eStoreOrder)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                eStoreOrder.CreateUser = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                eStoreOrder.CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.SaveCusOrderDetails(eStoreOrder);

                //send emails
                if (msgModel[0].RsltType == 1)
                {
                    _repo.SendAllOrderRelatedEmails((int)msgModel[0].SavedID, (int)eStoreOrder.CreateUser);
                }

                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

    }
}
