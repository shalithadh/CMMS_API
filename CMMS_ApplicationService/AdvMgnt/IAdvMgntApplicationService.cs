using CMMS_Model.AdvMgnt;
using CMMS_Model.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.AdvMgnt
{
    public interface IAdvMgntApplicationService
    {
        List<AdvListViewModel> GetAdvListByUserID(int UserID, string StartDate, string EndDate);
        List<AdvImgURLModel> GetAdvImgUrlsByAdvID(int AdvID);
        List<OutputMessageModel> SaveAdvDetails(AdvModel adv);
        List<OutputMessageModel> UpdateAdvDetails(AdvModel adv);
        List<OutputMessageModel> SaveAdvImageURLs(int AdvID, List<AdvImgURLModel> advImgURLs, int UserID, string UserIP);
    }
}
