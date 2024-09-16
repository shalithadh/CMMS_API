using CMMS_DataService.UserMgnt;
using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using CMMS_Model.UserMgnt;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.UserMgnt
{
    public class PermissionApplicationService: IPermissionApplicationService
    {
        DB_Handle oDB_Handle = new DB_Handle();

        public List<PermissionModel> GetAllPermissionDetails()
        {
            PermissionDataService permissionDataService = new PermissionDataService();
            List<PermissionModel> permissions = new List<PermissionModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                permissions = permissionDataService.GetAllPermissionDetails(oDB_Handle);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return permissions;
        }

        public List<OutputMessageModel> AddPermissionDetails(PermissionModel permission)
        {
            PermissionDataService permissionDataService = new PermissionDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                msgModel = permissionDataService.AddPermissionDetails(oDB_Handle, permission);

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

        public List<OutputMessageModel> UpdatePermissionDetails(PermissionModel permission)
        {
            PermissionDataService permissionDataService = new PermissionDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                msgModel = permissionDataService.UpdatePermissionDetails(oDB_Handle, permission);

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
