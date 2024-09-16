using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using CMMS_Model.EStore;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_DataService.EStore
{
    public class EStoreOrderDataService
    {
        public List<EStoreOrderCusDetail> GetEStoreCustomerDetails(DB_Handle oDB_Handle, int CustomerID)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_OrderCustomerAddress";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@CustomerID", CustomerID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<EStoreOrderCusDetail> orderCusDetails = oDataTable.AsEnumerable().Select(row =>
                new EStoreOrderCusDetail
                {
                    UserID = row.Field<int>("UserID"),
                    Username = row.Field<string>("Username"),
                    FirstName = row.Field<string>("FirstName"),
                    LastName = row.Field<string>("LastName"),
                    Address1 = row.Field<string>("Address1"),
                    Address2 = row.Field<string>("Address2"),
                    Address3 = row.Field<string>("Address3"),
                    District = row.Field<string>("District"),
                    Province = row.Field<string>("Province")
                }).ToList();

                return orderCusDetails;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<EStoreOrderHistoryMainViewModel> GetOrderCustomerHistory(DB_Handle oDB_Handle, int CustomerID)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_OrderCustomerHistory";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@CustomerID", CustomerID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<EStoreOrderHistoryMainViewModel> orderInfoModel = oDataTable.AsEnumerable().Select(row =>
                new EStoreOrderHistoryMainViewModel
                {
                    OrderID = row.Field<int>("OrderID"),
                    OrderNo = row.Field<string>("OrderNo"),
                    PlacedDate = row.Field<string>("PlacedDate"),
                    EstDeliveryDate = row.Field<string>("EstDeliveryDate"),
                    PaymentMethod = row.Field<int>("PaymentMethod"),
                    PayMethodName = row.Field<string>("PayMethodName"),
                    ClientName = row.Field<string>("ClientName"),
                    Address1 = row.Field<string>("Address1"),
                    Address2 = row.Field<string>("Address2"),
                    Address3 = row.Field<string>("Address3"),
                    District = row.Field<string>("District"),
                    Province = row.Field<string>("Province"),
                    MobileNo = row.Field<string>("MobileNo"),
                    Discount = row.Field<decimal>("Discount"),
                    SubTotal = row.Field<decimal>("SubTotal"),
                    DeliveryCharge = row.Field<decimal>("DeliveryCharge"),
                    Total = row.Field<decimal>("Total")
                }).ToList();

                return orderInfoModel;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public EStoreInvoiceViewModel GetOrderDetailByOrderID(DB_Handle oDB_Handle, int OrderID, int CustomerID)
        {
            string sqlQuery;
            DataSet oDataSet = new DataSet();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_OrderDetailsByOrderID";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@OrderID", OrderID);
                oSqlCommand.Parameters.AddWithValue("@CustomerID", CustomerID);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataSet);

                //order info table
                DataTable orderInfoTable = oDataSet.Tables[0];
                //order item info table
                DataTable itemInfoTable = oDataSet.Tables[1];
                //order vendor info table
                DataTable vendorInfoTable = oDataSet.Tables[2];

                List<EStoreOrderHistoryMainViewModel> orderInfoModel = orderInfoTable.AsEnumerable().Select(row =>
                new EStoreOrderHistoryMainViewModel
                {
                    OrderID = row.Field<int>("OrderID"),
                    OrderNo = row.Field<string>("OrderNo"),
                    PlacedDate = row.Field<string>("PlacedDate"),
                    EstDeliveryDate = row.Field<string>("EstDeliveryDate"),
                    PaymentMethod = row.Field<int>("PaymentMethod"),
                    PayMethodName = row.Field<string>("PayMethodName"),
                    ClientName = row.Field<string>("ClientName"),
                    Address1 = row.Field<string>("Address1"),
                    Address2 = row.Field<string>("Address2"),
                    Address3 = row.Field<string>("Address3"),
                    District = row.Field<string>("District"),
                    Province = row.Field<string>("Province"),
                    MobileNo = row.Field<string>("MobileNo"),
                    Email = row.Field<string>("Email"),
                    Discount = row.Field<decimal>("Discount"),
                    SubTotal = row.Field<decimal>("SubTotal"),
                    DeliveryCharge = row.Field<decimal>("DeliveryCharge"),
                    Total = row.Field<decimal>("Total")
                }).ToList();

                List<EStoreOrderWiseItemView> orderDetailModel = itemInfoTable.AsEnumerable().Select(row =>
                new EStoreOrderWiseItemView
                {
                    ItemID = row.Field<int>("ItemID"),
                    ItemName = row.Field<string>("ItemName"),
                    OrderID = row.Field<int>("OrderID"),
                    PackageID = row.Field<int>("PackageID"),
                    UnitAmount = row.Field<decimal>("UnitAmount"),
                    Quantity = row.Field<decimal>("Quantity"),
                    DiscountAmount = row.Field<decimal>("DiscountAmount"),
                    ItemWiseTotal = row.Field<decimal>("ItemWiseTotal"),
                    VendorID = row.Field<int>("VendorID"),
                    VendorName = row.Field<string>("VendorName"),
                    OrderDetailStatus = row.Field<int>("OrderDetailStatus"),
                    OrderStatusName = row.Field<string>("OrderStatusName")
                }).ToList();

                List<EStoreOrderVendorWiseViewModel> orderVendorModel = vendorInfoTable.AsEnumerable().Select(row =>
                new EStoreOrderVendorWiseViewModel
                {
                    VendorID = row.Field<int>("VendorID"),
                    VendorName = row.Field<string>("VendorName"),
                    Email = row.Field<string>("Email"),
                    OrderID = row.Field<int>("OrderID"),
                    PackageID = row.Field<int>("PackageID"),               
                    OrderDetailStatus = row.Field<int>("OrderDetailStatus"),
                    OrderStatusName = row.Field<string>("OrderStatusName")
                }).ToList();

                EStoreInvoiceViewModel eStoreInvoice = new EStoreInvoiceViewModel();
                eStoreInvoice.OrderInfo = orderInfoModel;
                eStoreInvoice.OrderItemInfo = orderDetailModel;
                eStoreInvoice.OrderVendorInfo = orderVendorModel;

                return eStoreInvoice;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<OutputMessageModel> SaveCusOrderDetails(DB_Handle oDB_Handle, EStoreOrderDetail eStoreOrder, string OrderDetailJson)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_ADD_OrderDetails";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@PaymentMethod", eStoreOrder.PaymentMethod);               
                oSqlCommand.Parameters.AddWithValue("@Address1", eStoreOrder.Address1);               
                oSqlCommand.Parameters.AddWithValue("@Address2", eStoreOrder.Address2);               
                oSqlCommand.Parameters.AddWithValue("@Address3", eStoreOrder.Address3);               
                oSqlCommand.Parameters.AddWithValue("@District", eStoreOrder.District);               
                oSqlCommand.Parameters.AddWithValue("@Province", eStoreOrder.Province);               
                oSqlCommand.Parameters.AddWithValue("@Remarks", eStoreOrder.Remarks);               
                oSqlCommand.Parameters.AddWithValue("@Discount", eStoreOrder.Discount);               
                oSqlCommand.Parameters.AddWithValue("@SubTotal", eStoreOrder.SubTotal);               
                oSqlCommand.Parameters.AddWithValue("@DeliveryCharge", eStoreOrder.DeliveryCharge);               
                oSqlCommand.Parameters.AddWithValue("@Total", eStoreOrder.Total);               
                oSqlCommand.Parameters.AddWithValue("@CreateUser", eStoreOrder.CreateUser);
                oSqlCommand.Parameters.AddWithValue("@CreateIP", eStoreOrder.CreateIP);
                oSqlCommand.Parameters.AddWithValue("@OrderDetailJson", OrderDetailJson);
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
                    RsltType = row.Field<int>("rsltType"),
                    SavedID = row.Field<int>("savedID")
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
