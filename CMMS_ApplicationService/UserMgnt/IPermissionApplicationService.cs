using CMMS_Model.Common;
using CMMS_Model.UserMgnt;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.UserMgnt
{
    public interface IPermissionApplicationService
    {
        List<PermissionModel> GetAllPermissionDetails();
        List<OutputMessageModel> AddPermissionDetails(PermissionModel permission);
        List<OutputMessageModel> UpdatePermissionDetails(PermissionModel permission);
    }
}
