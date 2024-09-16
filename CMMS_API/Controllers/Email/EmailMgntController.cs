using CMMS_ApplicationService.Email;
using CMMS_ApplicationService.EStore;
using CMMS_ApplicationService.ProjectMgnt;
using CMMS_Model.Common;
using CMMS_Model.Email;
using CMMS_Model.EStore;
using CMMS_Model.ProjectMgnt;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CMMS_API.Controllers.Email
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class EmailMgntController : ControllerBase
    {
        private readonly IEmailMgntApplicationService _repo;
        private readonly IOrderEmailApplicationService _orderEmailAppService;
        private readonly IProjectMgntEmailApplicationService _proTaskEmailAppService;
        private readonly IEStoreOrderApplicationService _estoreRepo;
        private readonly ITaskMgntApplicationService _taskMgntRepo;
        private IHttpContextAccessor _accessor;

        public EmailMgntController(IEmailMgntApplicationService repo, 
            IOrderEmailApplicationService orderEmailAppService, IProjectMgntEmailApplicationService proTaskEmailAppService,
            IEStoreOrderApplicationService estoreRepo, ITaskMgntApplicationService taskMgntRepo, IHttpContextAccessor accessor)
        {
            _repo = repo;
            _orderEmailAppService = orderEmailAppService;
            _proTaskEmailAppService = proTaskEmailAppService;
            _estoreRepo = estoreRepo;
            _taskMgntRepo = taskMgntRepo;
            _accessor = accessor;
        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> SendGeneratedEmail(EmailModel email)
        {
            try
            {
                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                msgModel = _repo.SendGeneratedEmail(email);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> TestCusOrderConfirmationEmail(CusOrderTestModel testModel)
        {
            try
            {
                EStoreInvoiceViewModel invoiceViewModel = new EStoreInvoiceViewModel();
                invoiceViewModel = _estoreRepo.GetOrderDetailByOrderID(testModel.OrderID, testModel.CustomerID);

                OrderEmailModel orderEmailModel = new OrderEmailModel();
                orderEmailModel = _orderEmailAppService.GenerateCustomerOrderEmail(invoiceViewModel);

                EmailModel emailModel = new EmailModel();
                emailModel.ToEmail = testModel.Email;
                emailModel.MailSubject = orderEmailModel.OrderEmailSubject;
                emailModel.BodyContent = orderEmailModel.OrderEmailBody;

                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                msgModel = _repo.SendGeneratedEmail(emailModel);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> TestVendorOrderReceivedEmail(CusOrderTestModel testModel)
        {
            try
            {
                EStoreInvoiceViewModel invoiceViewModel = new EStoreInvoiceViewModel();
                invoiceViewModel = _estoreRepo.GetOrderDetailByOrderID(testModel.OrderID, testModel.CustomerID);

                OrderEmailModel orderEmailModel = new OrderEmailModel();
                //Take only 1st vendor
                var vendorWiseData = invoiceViewModel.OrderVendorInfo[0];
                orderEmailModel = _orderEmailAppService.GenerateVendorOrderReceivedEmail(invoiceViewModel, vendorWiseData);

                EmailModel emailModel = new EmailModel();
                emailModel.ToEmail = testModel.Email;
                emailModel.MailSubject = orderEmailModel.OrderEmailSubject;
                emailModel.BodyContent = orderEmailModel.OrderEmailBody;

                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                msgModel = _repo.SendGeneratedEmail(emailModel);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> TestTaskCompleteEmailToClient(ProTaskTestModel testModel)
        {
            try
            {
                List<TaskListViewModel> task = new List<TaskListViewModel>();
                task = _taskMgntRepo.GetProjectTaskDetailsByTaskID(testModel.TaskID);

                ProjectMgntEmailModel proEmailModel = new ProjectMgntEmailModel();
                proEmailModel = _proTaskEmailAppService.GenerateCompleteTaskEmailToClient(task[0]);

                EmailModel emailModel = new EmailModel();
                emailModel.ToEmail = testModel.Email;
                emailModel.MailSubject = proEmailModel.ProMgntEmailSubject;
                emailModel.BodyContent = proEmailModel.ProMgntEmailBody;

                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                msgModel = _repo.SendGeneratedEmail(emailModel);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> TestTaskApprovalEmailToContractor(ProTaskTestModel testModel)
        {
            try
            {
                List<TaskListViewModel> task = new List<TaskListViewModel>();
                task = _taskMgntRepo.GetProjectTaskDetailsByTaskID(testModel.TaskID);

                ProjectMgntEmailModel proEmailModel = new ProjectMgntEmailModel();
                proEmailModel = _proTaskEmailAppService.GenerateTaskApprovalEmailToContractor(task[0]);

                EmailModel emailModel = new EmailModel();
                emailModel.ToEmail = testModel.Email;
                emailModel.MailSubject = proEmailModel.ProMgntEmailSubject;
                emailModel.BodyContent = proEmailModel.ProMgntEmailBody;

                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                msgModel = _repo.SendGeneratedEmail(emailModel);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Authorize]
        [HttpPost]
        public ActionResult<List<OutputMessageModel>> TestTaskRejectedEmailToContractor(ProTaskTestModel testModel)
        {
            try
            {
                List<TaskListViewModel> task = new List<TaskListViewModel>();
                task = _taskMgntRepo.GetProjectTaskDetailsByTaskID(testModel.TaskID);

                ProjectMgntEmailModel proEmailModel = new ProjectMgntEmailModel();
                proEmailModel = _proTaskEmailAppService.GenerateTaskRejectedEmailToContractor(task[0]);

                EmailModel emailModel = new EmailModel();
                emailModel.ToEmail = testModel.Email;
                emailModel.MailSubject = proEmailModel.ProMgntEmailSubject;
                emailModel.BodyContent = proEmailModel.ProMgntEmailBody;

                List<OutputMessageModel> msgModel = new List<OutputMessageModel>();
                msgModel = _repo.SendGeneratedEmail(emailModel);
                return Ok(msgModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

    }
}