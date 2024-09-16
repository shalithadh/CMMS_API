using CMMS_Model.Common;
using CMMS_Model.UserMgnt;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.UserMgnt
{
    public interface IUserRoleApplicationService
    {
        UserRoleInitialDataModel GetInitialUserRolePermiData();
        List<UserRoleAllPermissionViewModel> GetUserRoleAllPermissions();
        List<UserRolePermiByRoleIDViewModel> GetUserRolePermissionsByRoleID(int RoleID);
        List<OutputMessageModel> SaveUserRolePermissionDetails(UserRoleWiseViewModel user, List<UserRoleWiseModel> userRoleWises);
    }
}
