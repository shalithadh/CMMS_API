using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using CMMS_Model.Email;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_DataService.Email
{
    public class EmailMgntDataService
    {
        public List<OutputMessageModel> SaveEmailLogDetails(DB_Handle oDB_Handle, EmailLogModel emailLog)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_ADD_EmailLogDetails";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@FromEmail", emailLog.FromEmail);
                oSqlCommand.Parameters.AddWithValue("@ToEmail", emailLog.ToEmail);
                oSqlCommand.Parameters.AddWithValue("@MailSubject", emailLog.MailSubject);
                oSqlCommand.Parameters.AddWithValue("@MailBody", emailLog.MailBody);
                oSqlCommand.Parameters.AddWithValue("@IsSent", emailLog.IsSent);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<OutputMessageModel> msgModel = oDataTable.AsEnumerable().Select(row =>
                new OutputMessageModel
                {
                    OutputInfo = row.Field<string>("outputInfo"),
                    RsltType = row.Field<int>("rsltType")
                }).ToList();

                return msgModel;
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}