using CMMS_DataService.AdvMgnt;
using CMMS_Model.AdvMgnt;
using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.AdvMgnt
{
    public class AdvMgntApplicationService: IAdvMgntApplicationService
    {
        DB_Handle oDB_Handle = new DB_Handle();

        public List<AdvListViewModel> GetAdvListByUserID(int UserID, string StartDate, string EndDate)
        {
            AdvMgntDataService advMgntDataService = new AdvMgntDataService();
            List<AdvListViewModel> advLists = new List<AdvListViewModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                advLists = advMgntDataService.GetAdvListByUserID(oDB_Handle, UserID, StartDate, EndDate);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return advLists;
        }

        public List<AdvImgURLModel> GetAdvImgUrlsByAdvID(int AdvID)
        {
            AdvMgntDataService advMgntDataService = new AdvMgntDataService();
            List<AdvImgURLModel> advImgURLs = new List<AdvImgURLModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                advImgURLs = advMgntDataService.GetAdvImgUrlsByAdvID(oDB_Handle, AdvID);

                oDB_Handle.CommitTransaction();
                oDB_Handle.CloseConnection();
            }
            catch (Exception)
            {
                oDB_Handle.RollbackTransaction();
                oDB_Handle.CloseConnection();
                throw;
            }
            return advImgURLs;
        }

        public List<OutputMessageModel> SaveAdvDetails(AdvModel adv)
        {
            AdvMgntDataService advMgntDataService = new AdvMgntDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                msgModel = advMgntDataService.SaveAdvDetails(oDB_Handle, adv);

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

        public List<OutputMessageModel> UpdateAdvDetails(AdvModel adv)
        {
            AdvMgntDataService advMgntDataService = new AdvMgntDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                msgModel = advMgntDataService.UpdateAdvDetails(oDB_Handle, adv);

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

        public List<OutputMessageModel> SaveAdvImageURLs(int AdvID, List<AdvImgURLModel> advImgURLs, int UserID, string UserIP)
        {
            AdvMgntDataService advMgntDataService = new AdvMgntDataService();
            List<OutputMessageModel> msgModel = new List<OutputMessageModel>();

            try
            {
                oDB_Handle = new DB_Handle();
                oDB_Handle.OpenConnection();
                oDB_Handle.BeginTransaction();

                //Convert List object to JSON string
                var AdvImgURLJson = JsonConvert.SerializeObject(advImgURLs.Select(
                x => new
                {
                    x.ImageName,
                    x.ImageURL
                }
                ).ToList());

                msgModel = advMgntDataService.SaveAdvImageURLs(oDB_Handle, AdvID, AdvImgURLJson, UserID, UserIP);

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
