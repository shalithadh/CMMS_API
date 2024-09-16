using CMMS_DataService.UserMgnt;
using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using CMMS_Model.UserMgnt;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.UserMgnt
{
    public class UserRoleApplicationService: IUserRoleApplicationService
    {
        DB_Handle oDB_Handle = new DB_Handle();

        public UserRoleInitialDataModel GetInitialUserRolePermiData()
        {
            UserRoleDataService userRoleDataService = new UserRoleDataService();
            UserRoleInitialDataModel userRoleInitialData = new UserRoleInitialDataModel();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                userRoleInitialData = userRoleDataService.GetInitialUserRolePermiData(oDB_Handle);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return userRoleInitialData;
        }

        public List<UserRoleAllPermissionViewModel> GetUserRoleAllPermissions()
        {
            UserRoleDataService userRoleDataService = new UserRoleDataService();
            List<UserRoleAllPermissionViewModel> userRoleAllPermissions = new List<UserRoleAllPermissionViewModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                userRoleAllPermissions = userRoleDataService.GetUserRoleAllPermissions(oDB_Handle);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return userRoleAllPermissions;
        }

        public List<UserRolePermiByRoleIDViewModel> GetUserRolePermissionsByRoleID(int RoleID)
        {
            UserRoleDataService userRoleDataService = new UserRoleDataService();
            List<UserRolePermiByRoleIDViewModel> userRoleAllPermissions = new List<UserRolePermiByRoleIDViewModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                userRoleAllPermissions = userRoleDataService.GetUserRolePermissionsByRoleID(oDB_Handle, RoleID);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return userRoleAllPermissions;
        }

        public List<OutputMessageModel> SaveUserRolePermissionDetails(UserRoleWiseViewModel user, List<UserRoleWiseModel> userRoleWises)
        {
            UserRoleDataService userRoleDataService = new UserRoleDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                //Convert List object to JSON string
                var UserRoleWiseJson = JsonConvert.SerializeObject(userRoleWises.Select(
                x => new
                {
                    x.PermissionID
                }
                ).ToList());

                msgModel = userRoleDataService.SaveUserRolePermissionDetails(oDB_Handle, user, UserRoleWiseJson);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return msgModel;
        }

    }
}
