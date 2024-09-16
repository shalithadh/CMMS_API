using CMMS_ApplicationService.OrderMgnt;
using CMMS_Model.Common;
using CMMS_Model.OrderMgnt;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CMMS_API.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class OrderMgntController : ControllerBase
    {
        private readonly IOrderMgntApplicationService _repo;
        private IHttpContextAccessor _accessor;

        public OrderMgntController(IOrderMgntApplicationService repo, IHttpContextAccessor accessor)
        {
            _repo = repo;
            _accessor = accessor;
        }

        [Authorize]
        [HttpGet]
        public ActionResult<OrderMgntInitialDataModel> GetInitialOrderMgntData()
        {
            try
            {
                OrderMgntInitialDataModel initialDataModel = new OrderMgntInitialDataModel();
                initialDataModel = _repo.GetInitialOrderMgntData();
                return Ok(initialDataModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<List<OrderMgntOrderListViewModel>> GetOrderMgntOrderList(int OrderStatusID,
            string StartDate, string EndDate)
        {
            try
            {
                int VendorID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                List<OrderMgntOrderListViewModel> orderMgntOrderLists = new List<OrderMgntOrderListViewModel>();
                orderMgntOrderLists = _repo.GetOrderMgntOrderList(VendorID, OrderStatusID, StartDate, EndDate);
                return Ok(orderMgntOrderLists);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpGet]
        public ActionResult<OrderMgntOrderDetailViewModel> GetOrderDetailByOrderID(int OrderID, int PackageID)
        {
            try
            {
                int VendorID = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                OrderMgntOrderDetailViewModel orderDetailView = new OrderMgntOrderDetailViewModel();
                orderDetailView = _repo.GetOrderDetailByOrderID(OrderID, PackageID, VendorID);
                return Ok(orderDetailView);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> UpdateOrderStatusDetails([FromBody] OrderMgntStatusUpdateModel updateModel)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                updateModel.CreateUser = int.Parse(_accessor.HttpContext.User.FindFirstValue(ClaimTypes.Name));
                updateModel.CreateIP = _accessor.HttpContext.Connection.RemoteIpAddress.ToString();
                msgModel = _repo.UpdateOrderStatusDetails(updateModel);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

    }
}
