using CMMS_Model.Email;
using CMMS_Model.EStore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.Email
{
    public interface IOrderEmailApplicationService
    {
        OrderEmailModel GenerateCustomerOrderEmail(EStoreInvoiceViewModel cusEmailModel);
        OrderEmailModel GenerateVendorOrderReceivedEmail(EStoreInvoiceViewModel venEmailModel, EStoreOrderVendorWiseViewModel vendorModel);
    }
}
