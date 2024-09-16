using CMMS_Model.Common;
using CMMS_Model.DbAccess;
using CMMS_Model.OrderMgnt;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_DataService.OrderMgnt
{
    public class OrderMgntDataService
    {
        public OrderMgntInitialDataModel GetInitialOrderMgntData(DB_Handle oDB_Handle)
        {
            string sqlQuery;
            DataSet oDataSet = new DataSet();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_OrderMgntInitialData";
                oSqlCommand = new SqlCommand();
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataSet);

                //order status types table
                DataTable orderStatusTypeTable = oDataSet.Tables[0];

                List<OrderMgntOrderStatusTypeModel> orderMgntOrderStatusTypes = orderStatusTypeTable.AsEnumerable().Select(row =>
                new OrderMgntOrderStatusTypeModel
                {
                    ValueID = row.Field<int>("ValueID"),
                    Value = row.Field<string>("Value")
                }).ToList();

                OrderMgntInitialDataModel orderMgntInitialData = new OrderMgntInitialDataModel();
                orderMgntInitialData.orderStatusTypes = orderMgntOrderStatusTypes;

                return orderMgntInitialData;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<OrderMgntOrderListViewModel> GetOrderMgntOrderList(DB_Handle oDB_Handle, int VendorID, int OrderStatusID,
            string StartDate, string EndDate)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_OrderMgntOrdersByVendorID";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@VendorID", VendorID);
                oSqlCommand.Parameters.AddWithValue("@OrderStatusID", OrderStatusID);
                oSqlCommand.Parameters.AddWithValue("@StartDate", StartDate);
                oSqlCommand.Parameters.AddWithValue("@EndDate", EndDate);
                oSqlCommand.CommandText = sqlQuery;
                oSqlCommand.CommandType = CommandType.StoredProcedure;
                oSqlCommand.Connection = oDB_Handle.GetConnection();
                oSqlCommand.Transaction = oDB_Handle.GetTransaction();
                oSqlDataAdapter = new SqlDataAdapter(oSqlCommand);
                oSqlDataAdapter.Fill(oDataTable);

                List<OrderMgntOrderListViewModel> orderListModel = oDataTable.AsEnumerable().Select(row =>
                new OrderMgntOrderListViewModel
                {
                    OrderID = row.Field<int>("OrderID"),
                    OrderNo = row.Field<string>("OrderNo"),
                    PlacedDate = row.Field<string>("PlacedDate"),
                    EstDeliveryDate = row.Field<string>("EstDeliveryDate"),
                    PaymentMethod = row.Field<int>("PaymentMethod"),
                    PayMethodName = row.Field<string>("PayMethodName"),
                    PackageID = row.Field<int>("PackageID"),
                    OrderStatus = row.Field<int>("OrderStatus"),
                    OrderStatusName = row.Field<string>("OrderStatusName"),
                    VendorID = row.Field<int>("VendorID"),
                    VendorName = row.Field<string>("VendorName"),
                    CustomerID = row.Field<int>("CustomerID"),
                    CustomerName = row.Field<string>("CustomerName")
                }).ToList();

                return orderListModel;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public OrderMgntOrderDetailViewModel GetOrderDetailByOrderID(DB_Handle oDB_Handle, int OrderID, int PackageID, int VendorID)
        {
            string sqlQuery;
            DataSet oDataSet = new DataSet();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_GET_OrderMgntOrderDetailsByOrderID";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@OrderID", OrderID);
                oSqlCommand.Parameters.AddWithValue("@PackageID", PackageID);
                oSqlCommand.Parameters.AddWithValue("@VendorID", VendorID);
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

                List<OrderMgntHeaderViewModel> orderInfoModel = orderInfoTable.AsEnumerable().Select(row =>
                new OrderMgntHeaderViewModel
                {
                    OrderID = row.Field<int>("OrderID"),
                    OrderNo = row.Field<string>("OrderNo"),
                    PackageID = row.Field<int>("PackageID"),
                    OrderDetailStatus = row.Field<int>("OrderDetailStatus"),
                    OrderStatusName = row.Field<string>("OrderStatusName"),
                    CustomerName = row.Field<string>("CustomerName"),
                    Total = row.Field<decimal>("Total")
                }).ToList();

                List<OrderMgntItemViewModel> orderDetailModel = itemInfoTable.AsEnumerable().Select(row =>
                new OrderMgntItemViewModel
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

                OrderMgntOrderDetailViewModel mgntOrderDetailViewModel = new OrderMgntOrderDetailViewModel();
                mgntOrderDetailViewModel.OrderHeaderInfo = orderInfoModel;
                mgntOrderDetailViewModel.OrderDetailInfo = orderDetailModel;

                return mgntOrderDetailViewModel;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<OutputMessageModel> UpdateOrderStatusDetails(DB_Handle oDB_Handle, OrderMgntStatusUpdateModel updateModel)
        {
            string sqlQuery;
            DataTable oDataTable = new DataTable();
            SqlCommand oSqlCommand;
            SqlDataAdapter oSqlDataAdapter;
            try
            {
                sqlQuery = "SP_UPDATE_OrderMgntStatusDetails";
                oSqlCommand = new SqlCommand();
                oSqlCommand.Parameters.AddWithValue("@OrderID", updateModel.OrderID);
                oSqlCommand.Parameters.AddWithValue("@PackageID", updateModel.PackageID);
                oSqlCommand.Parameters.AddWithValue("@OrderStatus", updateModel.OrderStatus);
                oSqlCommand.Parameters.AddWithValue("@CreateUser", updateModel.CreateUser);
                oSqlCommand.Parameters.AddWithValue("@CreateIP", updateModel.CreateIP);
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
