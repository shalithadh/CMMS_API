using CMMS_Model.Email;
using CMMS_Model.EStore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_ApplicationService.Email
{
    public class OrderEmailApplicationService: IOrderEmailApplicationService
    {
        public OrderEmailModel GenerateCustomerOrderEmail(EStoreInvoiceViewModel cusEmailModel) {

            OrderEmailModel orderEmailModel = new OrderEmailModel();
            var emailBody = "";

            try
            {
                var emailHead = "";

                var emailHeaderTableHead =
                  "<center>" +
                  "<table border=" + 0 + " cellpadding=" + 0 + " cellspacing=" + 0 + " width = '90%'>" +
                  //row1
                  "<tr>" +
                  "<td>Order No: <b>" + cusEmailModel.OrderInfo[0].OrderNo + "</b></td> " +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b>Customer: </b></td>" +
                  "</tr>"+
                  //row2
                  "<tr>" +
                  "<td>Placed Date: <b>" + cusEmailModel.OrderInfo[0].PlacedDate + "</b></td> " +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td>" + cusEmailModel.OrderInfo[0].ClientName + "</td>" +               
                  //row3
                  "<tr>" +
                  "<td>Estimated Delivery Date: <b>" + cusEmailModel.OrderInfo[0].EstDeliveryDate + "</b></td> " +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td>" + cusEmailModel.OrderInfo[0].Address1 + ", " + cusEmailModel.OrderInfo[0].Address2 + ", "
                  + cusEmailModel.OrderInfo[0].Address3 + "</td>" +
                  "</tr>" +
                  "</tr>" +
                  //row4
                  "<tr>" +
                  "<td>Payment Method: <b>" + cusEmailModel.OrderInfo[0].PayMethodName + "</b></td> " +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td>" + cusEmailModel.OrderInfo[0].District + ", " + cusEmailModel.OrderInfo[0].Province + "</td>" +                 
                  "</tr>" +
                  //row5
                  "<tr>" +
                  "<td><b></b></td> " +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td>" + cusEmailModel.OrderInfo[0].MobileNo + "</td>" +
                  "</tr>" +
                  //row6
                  "<tr>" +
                  "<td><b></b></td> " +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td>" + cusEmailModel.OrderInfo[0].Email + "</td>" +
                  "</tr>" +
                  "</table>" +
                  "</center>" +
                  "<br/><br/>"
                  ;


                //Email Head
                emailHead = emailHeaderTableHead;

                var emailItemTable = "";
                var emailItemTableHead = "<center>" +
                    "<table border=" + 1 + " cellpadding=" + 0 + " cellspacing=" + 0 + " width = '90%'>" +
                    "<tr>" +
                    "<th><b>Item Name</b></th> " +
                    "<th><b>Package</b></th>" +
                    "<th><b>Vendor Name</b></th>" +
                    "<th><b>Unit Price</b></th>" +
                    "<th><b>Quantity</b></th>" +
                    "<th><b>Total</b></th>" +
                    "</tr>"
                ;

                //Items Table
                var emailItemTableBody = "";
                foreach (var item in cusEmailModel.OrderItemInfo)
                {
                    var itemRow = "<tr>" +
                    "<td>" + item.ItemName + "</td> " +
                    "<td> Package - " + item.PackageID.ToString() + "</td> " +
                    "<td>" + item.VendorName + "</td> " +
                    "<td><p style='text-align:right'>Rs. " + (item.UnitAmount).ToString() + "  " + "</p></td>" +
                    "<td><p style='text-align:right'>" + (item.Quantity).ToString() + "  " + "</p></td>" +
                    "<td><p style='text-align:right'>Rs. " + (item.ItemWiseTotal).ToString() + "  " + "</p></td>" +
                    "</tr>"
                    ;

                    emailItemTableBody = emailItemTableBody + itemRow;
                }

                //Sub Total
                var emailItemTableSubTotal = "<tr>" +
                "<td>" + "</td> " +
                "<td>" + "</td> " +
                "<td>" + "</td> " +
                "<td>" + "</td> " +
                "<td>" + "<b>Sub Total</b>" + "</td> " +
                "<td><p style='text-align:right'> Rs." + cusEmailModel.OrderInfo[0].SubTotal + "</p></td> " +
                "</tr>"
                ;

                //Delivery Charges
                var emailItemTableDeliveryCharges = "<tr>" +
                "<td>" + "</td> " +
                "<td>" + "</td> " +
                "<td>" + "</td> " +
                "<td>" + "</td> " +
                "<td>" + "<b>Delivery Charges</b>" + "</td> " +
                "<td><p style='text-align:right'> Rs." + cusEmailModel.OrderInfo[0].DeliveryCharge + "</p></td> " +
                "</tr>"
                ;

                //Total
                var emailItemTableTotal = "<tr>" +
                "<td>" + "</td> " +
                "<td>" + "</td> " +
                "<td>" + "</td> " +
                "<td>" + "</td> " +
                "<td>" + "<b>Total</b>" + "</td> " +
                "<td><p style='text-align:right'> Rs." + cusEmailModel.OrderInfo[0].Total + "</p></td> " +
                "</tr>" +
                "</table></center>" +
                "<br/><br/>"
                ;

                //Email Body
                emailItemTable = emailItemTableHead + emailItemTableBody + emailItemTableSubTotal + emailItemTableDeliveryCharges + emailItemTableTotal;

                //Email Footer
                var emailFooter = "<center><p><b>Thank you for shopping on CMMS.</b></p></center>";

                //Full Email
                emailBody = emailHead + emailItemTable + emailFooter;

                orderEmailModel.OrderEmailSubject = cusEmailModel.OrderInfo[0].OrderNo + " - Order Confirmed";
                orderEmailModel.OrderEmailBody = emailBody;

                return orderEmailModel;
            }
            catch (Exception)
            {
                orderEmailModel.OrderEmailBody = "Failed";
                return orderEmailModel;
                throw;                
            }            
        }

        public OrderEmailModel GenerateVendorOrderReceivedEmail(EStoreInvoiceViewModel venEmailModel, EStoreOrderVendorWiseViewModel vendorModel)
        {

            OrderEmailModel orderEmailModel = new OrderEmailModel();
            var emailBody = "";

            try
            {
                var emailHead = "";

                var emailHeaderTableHead =
                  "<center>" +
                  "<table border=" + 0 + " cellpadding=" + 0 + " cellspacing=" + 0 + " width = '90%'>" +
                  //row1
                  "<tr>" +
                  "<td>Order No: <b>" + venEmailModel.OrderInfo[0].OrderNo + "</b></td> " +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b>Customer: </b></td>" +
                  "</tr>" +
                  //row2
                  "<tr>" +
                  "<td>Placed Date: <b>" + venEmailModel.OrderInfo[0].PlacedDate + "</b></td> " +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td>" + venEmailModel.OrderInfo[0].ClientName + "</td>" +
                  //row3
                  "<tr>" +
                  "<td>Estimated Delivery Date: <b>" + venEmailModel.OrderInfo[0].EstDeliveryDate + "</b></td> " +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td>" + venEmailModel.OrderInfo[0].Address1 + ", " + venEmailModel.OrderInfo[0].Address2 + ", "
                  + venEmailModel.OrderInfo[0].Address3 + "</td>" +
                  "</tr>" +
                  "</tr>" +
                  //row4
                  "<tr>" +
                  "<td>Payment Method: <b>" + venEmailModel.OrderInfo[0].PayMethodName + "</b></td> " +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td>" + venEmailModel.OrderInfo[0].District + ", " + venEmailModel.OrderInfo[0].Province + "</td>" +
                  "</tr>" +
                  //row5
                  "<tr>" +
                  "<td><b></b></td> " +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td>" + venEmailModel.OrderInfo[0].MobileNo + "</td>" +
                  "</tr>" +
                  //row6
                  "<tr>" +
                  "<td><b></b></td> " +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td><b></b></td>" +
                  "<td>" + venEmailModel.OrderInfo[0].Email + "</td>" +
                  "</tr>" +
                  "</table>" +
                  "</center>" +
                  "<br/><br/>"
                  ;


                //Email Head
                emailHead = emailHeaderTableHead;

                var emailItemTable = "";
                var emailItemTableHead = "<center>" +
                    "<table border=" + 1 + " cellpadding=" + 0 + " cellspacing=" + 0 + " width = '90%'>" +
                    "<tr>" +
                    "<th><b>Item Name</b></th> " +
                    "<th><b>Package</b></th>" +
                    "<th><b>Unit Price</b></th>" +
                    "<th><b>Quantity</b></th>" +
                    "<th><b>ItemWise Total</b></th>" +
                    "</tr>"
                ;

                //Items Table
                var emailItemTableBody = "";
                decimal vendorWiseTotal = 0;
                var vendorWiseFilteredItemInfo = venEmailModel.OrderItemInfo.Where(d => d.VendorID == vendorModel.VendorID).ToList();

                foreach (var item in vendorWiseFilteredItemInfo)
                {
                    var itemRow = "<tr>" +
                    "<td>" + item.ItemName + "</td> " +
                    "<td> Package - " + item.PackageID.ToString() + "</td> " +
                    "<td><p style='text-align:right'>Rs. " + (item.UnitAmount).ToString() + "  " + "</p></td>" +
                    "<td><p style='text-align:right'>" + (item.Quantity).ToString() + "  " + "</p></td>" +
                    "<td><p style='text-align:right'>Rs. " + (item.ItemWiseTotal).ToString() + "  " + "</p></td>" +
                    "</tr>"
                    ;

                    emailItemTableBody = emailItemTableBody + itemRow;

                    vendorWiseTotal = vendorWiseTotal + item.ItemWiseTotal;
                }

                //Total
                var emailItemTableTotal = "<tr>" +
                "<td>" + "</td> " +
                "<td>" + "</td> " +
                "<td>" + "</td> " +
                "<td>" + "<b>Total</b>" + "</td> " +
                "<td><p style='text-align:right'> Rs." + vendorWiseTotal.ToString() + "</p></td> " +
                "</tr>" +
                "</table></center>" +
                "<br/><br/>"
                ;

                //Email Body
                emailItemTable = emailItemTableHead + emailItemTableBody + emailItemTableTotal;

                //Email Footer
                var emailFooter = "<center><p><b>This is an auto-generated mail from CMMS.</b></p></center>";

                //Full Email
                emailBody = emailHead + emailItemTable + emailFooter;

                orderEmailModel.OrderEmailSubject = "You have Received a new Order " + venEmailModel.OrderInfo[0].OrderNo;
                orderEmailModel.OrderEmailBody = emailBody;

                return orderEmailModel;
            }
            catch (Exception)
            {
                orderEmailModel.OrderEmailBody = "Failed";
                return orderEmailModel;
                throw;
            }
        }

    }
}
