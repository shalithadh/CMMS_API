USE [master]
GO
/****** Object:  Database [MITProj_CMMS]    Script Date: 3/22/2024 11:19:50 PM ******/
CREATE DATABASE [MITProj_CMMS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MITProj_CMMS', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\MITProj_CMMS.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MITProj_CMMS_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\MITProj_CMMS_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [MITProj_CMMS] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MITProj_CMMS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MITProj_CMMS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MITProj_CMMS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MITProj_CMMS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MITProj_CMMS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MITProj_CMMS] SET ARITHABORT OFF 
GO
ALTER DATABASE [MITProj_CMMS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MITProj_CMMS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MITProj_CMMS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MITProj_CMMS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MITProj_CMMS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MITProj_CMMS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MITProj_CMMS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MITProj_CMMS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MITProj_CMMS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MITProj_CMMS] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MITProj_CMMS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MITProj_CMMS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MITProj_CMMS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MITProj_CMMS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MITProj_CMMS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MITProj_CMMS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MITProj_CMMS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MITProj_CMMS] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [MITProj_CMMS] SET  MULTI_USER 
GO
ALTER DATABASE [MITProj_CMMS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MITProj_CMMS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MITProj_CMMS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MITProj_CMMS] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MITProj_CMMS] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [MITProj_CMMS] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [MITProj_CMMS] SET QUERY_STORE = ON
GO
ALTER DATABASE [MITProj_CMMS] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [MITProj_CMMS]
GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_ItemInvPurchasedCount]    Script Date: 3/22/2024 11:19:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-11-20
-- Description:	Get Purchased Item Count
-- =============================================
CREATE FUNCTION [dbo].[FUNC_GET_ItemInvPurchasedCount]
(
	-- Add the parameters for the function here
	@ItemID int
)
RETURNS decimal(18,2)
AS
BEGIN
	
	declare @PurchasedCount decimal(18,2);

	select @PurchasedCount = isnull(-(SUM(i.Qty)), 0) 
	from [dbo].[ItemInventory] as i
	where i.ItemID = @ItemID and i.IsPurchased = 1;

	return @PurchasedCount;

END
GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_ItemPurchasedCountForPopItemReport]    Script Date: 3/22/2024 11:19:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2024-02-05
-- Description:	Get Purchased Item Count
-- =============================================
CREATE FUNCTION [dbo].[FUNC_GET_ItemPurchasedCountForPopItemReport]
(
	-- Add the parameters for the function here
	@ItemID int,
	@Year int,
	@Month int
)
RETURNS decimal(18,2)
AS
BEGIN
	
	declare @PurchasedCount decimal(18,2);

	--When user select all for month
	If (@Year != 0 and @Month = -1)
	Begin
		select @PurchasedCount = isnull(-(SUM(i.Qty)), 0) 
		from [dbo].[ItemInventory] as i
		where i.ItemID = @ItemID and i.IsPurchased = 1
		and Year(i.CreateDateTime) = @Year;		
	End

	Else
	Begin
		select @PurchasedCount = isnull(-(SUM(i.Qty)), 0) 
		from [dbo].[ItemInventory] as i
		where i.ItemID = @ItemID and i.IsPurchased = 1
		and Year(i.CreateDateTime) = @Year and Month(i.CreateDateTime) = @Month;
	End

	return @PurchasedCount;

END
GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_ProjectPercentageByProjectID]    Script Date: 3/22/2024 11:19:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-10-07
-- Description:	Get Project percentage By ProjectID
-- =============================================
CREATE FUNCTION [dbo].[FUNC_GET_ProjectPercentageByProjectID]
(
	-- Add the parameters for the function here
	@ProjectID int
)
RETURNS decimal(18,2)
AS
BEGIN
	
	declare @TotalTaskCount int;
	declare @TotalCompletedCount int;
	declare @ProjectPercentage decimal(18,2); 

	select @TotalTaskCount = isnull (COUNT(*), 0)
	from [dbo].[ProjectTask] as task
	where task.ProjectID = @ProjectID 

	select @TotalCompletedCount = isnull (COUNT(*), 0)
	from [dbo].[ProjectTask] as task
	where task.ProjectID = @ProjectID and task.TaskStatus = 3

	If(@TotalCompletedCount > 0)
	Begin
		select @ProjectPercentage = (cast(@TotalCompletedCount as decimal)/ cast(@TotalTaskCount as decimal)) * 100;
	End
	Else
	Begin
		set @ProjectPercentage = 0.00;
	End

	return @ProjectPercentage;

END
GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_ProjectTaskCountByProjectID]    Script Date: 3/22/2024 11:19:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-10-07
-- Description:	Get Task Count By ProjectID
-- =============================================
CREATE FUNCTION [dbo].[FUNC_GET_ProjectTaskCountByProjectID]
(
	-- Add the parameters for the function here
	@ProjectID int,
	@StatusID int
)
RETURNS int
AS
BEGIN
	
	declare @TaskCount int;

	select @TaskCount = isnull(COUNT(*), 0)
	from [dbo].[ProjectTask] as task
	where task.ProjectID = @ProjectID and task.TaskStatus = @StatusID;

	return @TaskCount;

END
GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_ReportMgntOrderStatusCountByDate]    Script Date: 3/22/2024 11:19:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2024-02-04
-- Description:	Get Order status count per date
-- =============================================
CREATE FUNCTION [dbo].[FUNC_GET_ReportMgntOrderStatusCountByDate]
(
	-- Add the parameters for the function here
	@UserID int,
	@OrderDate date,
	@OrderStatusID int
)
RETURNS int
AS
BEGIN
	
	declare @StatusCount int;

	declare @OrderFilterTable table (
		[OrderID] int,
		[OrderDetailStatus] int
	)

	insert into @OrderFilterTable ([OrderID], [OrderDetailStatus])
	select od.OrderID, od.OrderDetailStatus
	from [dbo].[OrderDetail] as od
	left join [dbo].[Order] as o on od.OrderID = o.OrderID
	where od.VendorID = @UserID and cast(o.PlacedDate as date) = @OrderDate and od.OrderDetailStatus = @OrderStatusID
	group by od.OrderID, od.OrderDetailStatus

	select @StatusCount = count(*)
	from @OrderFilterTable as oft

	return @StatusCount;

END
GO
/****** Object:  Table [dbo].[Advertisement]    Script Date: 3/22/2024 11:19:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Advertisement](
	[AdvID] [int] IDENTITY(1,1) NOT NULL,
	[CampaignName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[UserRoleID] [int] NOT NULL,
	[CreateUser] [int] NULL,
	[CreateIP] [nvarchar](100) NULL,
	[CreateDateTime] [datetime] NULL,
	[ModUser] [int] NULL,
	[ModIP] [nvarchar](100) NULL,
	[ModDateTime] [datetime] NULL,
 CONSTRAINT [PK_Advertisement] PRIMARY KEY CLUSTERED 
(
	[AdvID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AdvertisementImg]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AdvertisementImg](
	[AdvImgID] [int] IDENTITY(1,1) NOT NULL,
	[AdvID] [int] NOT NULL,
	[ImageName] [nvarchar](max) NOT NULL,
	[ImageURL] [nvarchar](max) NOT NULL,
	[CreateUser] [int] NULL,
	[CreateIP] [nvarchar](100) NULL,
	[CreateDateTime] [datetime] NULL,
 CONSTRAINT [PK_AdvertisementImg] PRIMARY KEY CLUSTERED 
(
	[AdvImgID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CMMSAppParameter]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CMMSAppParameter](
	[ParameterID] [int] NOT NULL,
	[ParameterName] [nvarchar](50) NOT NULL,
	[ParameterDescription] [nvarchar](100) NULL,
	[Value] [decimal](18, 2) NOT NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_CMMSAppParameter] PRIMARY KEY CLUSTERED 
(
	[ParameterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContractorService]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContractorService](
	[UserID] [int] NOT NULL,
	[ServiceTypeID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreateUser] [int] NULL,
	[CreateIP] [nvarchar](100) NULL,
	[CreateDateTime] [datetime] NULL,
	[ModUser] [int] NULL,
	[ModIP] [nvarchar](100) NULL,
	[ModDateTime] [datetime] NULL,
 CONSTRAINT [PK_ContractorService] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[ServiceTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmailLog]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailLog](
	[EmailLogID] [int] IDENTITY(1,1) NOT NULL,
	[FromEmail] [nvarchar](100) NOT NULL,
	[ToEmail] [nvarchar](100) NOT NULL,
	[MailSubject] [nvarchar](250) NOT NULL,
	[MailBody] [nvarchar](max) NOT NULL,
	[IsSent] [bit] NOT NULL,
	[CreateDateTime] [datetime] NULL,
 CONSTRAINT [PK_EmailLog] PRIMARY KEY CLUSTERED 
(
	[EmailLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Item]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Item](
	[ItemID] [int] IDENTITY(1,1) NOT NULL,
	[VendorCategoryTypeID] [int] NOT NULL,
	[ItemName] [nvarchar](50) NOT NULL,
	[ItemDescription] [nvarchar](100) NOT NULL,
	[ItemWeight] [decimal](18, 2) NOT NULL,
	[WeightUnit] [int] NOT NULL,
	[UOM] [int] NOT NULL,
	[UnitAmount] [decimal](18, 2) NOT NULL,
	[MinQty] [decimal](18, 2) NOT NULL,
	[MaxQty] [decimal](18, 2) NOT NULL,
	[VendorID] [int] NOT NULL,
	[IsSoldUnitWise] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreateUser] [int] NULL,
	[CreateIP] [nvarchar](100) NULL,
	[CreateDateTime] [datetime] NULL,
	[ModUser] [int] NULL,
	[ModIP] [nvarchar](100) NULL,
	[ModDateTime] [datetime] NULL,
 CONSTRAINT [PK_Item] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ItemInventory]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ItemInventory](
	[ItemInvID] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NOT NULL,
	[Qty] [decimal](18, 2) NOT NULL,
	[IsInvAdded] [bit] NOT NULL,
	[IsPurchased] [bit] NOT NULL,
	[OrderID] [int] NULL,
	[IsCurrent] [int] NOT NULL,
	[CreateUser] [int] NULL,
	[CreateIP] [nvarchar](100) NULL,
	[CreateDateTime] [datetime] NULL,
	[ModUser] [int] NULL,
	[ModIP] [nvarchar](100) NULL,
	[ModDateTime] [datetime] NULL,
 CONSTRAINT [PK_ItemInventory] PRIMARY KEY CLUSTERED 
(
	[ItemInvID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ItemInventoryImg]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ItemInventoryImg](
	[ItemInvID] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NOT NULL,
	[ImageName] [nvarchar](max) NOT NULL,
	[ImageURL] [nvarchar](max) NOT NULL,
	[CreateUser] [int] NULL,
	[CreateIP] [nvarchar](100) NULL,
	[CreateDateTime] [datetime] NULL,
 CONSTRAINT [PK_ItemInventoryImg] PRIMARY KEY CLUSTERED 
(
	[ItemInvID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ItemInventoryUOM]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ItemInventoryUOM](
	[ItemUOMID] [int] NOT NULL,
	[UOMName] [nvarchar](50) NOT NULL,
	[UOMUnit] [nvarchar](10) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_ItemInventoryUOM] PRIMARY KEY CLUSTERED 
(
	[ItemUOMID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ItemInvWeightUnit]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ItemInvWeightUnit](
	[ItemWeightUnitID] [int] IDENTITY(1,1) NOT NULL,
	[WeightUnitName] [nvarchar](50) NOT NULL,
	[WeightUnit] [nvarchar](10) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_ItemInvWeightUnit] PRIMARY KEY CLUSTERED 
(
	[ItemWeightUnitID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Month]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Month](
	[MonthID] [int] NOT NULL,
	[MonthName] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Month] PRIMARY KEY CLUSTERED 
(
	[MonthID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Order]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[OrderNo] [nvarchar](15) NULL,
	[PlacedDate] [datetime] NOT NULL,
	[EstDeliveryDate] [date] NOT NULL,
	[PaymentMethod] [int] NOT NULL,
	[Address1] [nvarchar](50) NOT NULL,
	[Address2] [nvarchar](50) NULL,
	[Address3] [nvarchar](50) NOT NULL,
	[District] [nvarchar](50) NOT NULL,
	[Province] [nvarchar](50) NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[Discount] [decimal](18, 2) NOT NULL,
	[SubTotal] [decimal](18, 2) NOT NULL,
	[DeliveryCharge] [decimal](18, 2) NOT NULL,
	[Total] [decimal](18, 2) NOT NULL,
	[CreateUser] [int] NULL,
	[CreateIP] [nvarchar](100) NULL,
	[CreateDateTime] [datetime] NULL,
	[ModUser] [int] NULL,
	[ModIP] [nvarchar](100) NULL,
	[ModDateTime] [datetime] NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetail]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetail](
	[OrderDetailID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NOT NULL,
	[PackageID] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[UnitAmount] [decimal](18, 2) NOT NULL,
	[Quantity] [decimal](18, 2) NOT NULL,
	[DiscountAmount] [decimal](18, 2) NOT NULL,
	[ItemWiseTotal] [decimal](18, 2) NOT NULL,
	[VendorID] [int] NOT NULL,
	[OrderDetailStatus] [int] NOT NULL,
	[CreateUser] [int] NULL,
	[CreateIP] [nvarchar](100) NULL,
	[CreateDateTime] [datetime] NULL,
	[ModUser] [int] NULL,
	[ModIP] [nvarchar](100) NULL,
	[ModDateTime] [datetime] NULL,
 CONSTRAINT [PK_OrderDetail] PRIMARY KEY CLUSTERED 
(
	[OrderDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderPaymentMethod]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderPaymentMethod](
	[OrderPayMethodID] [int] NOT NULL,
	[PayMethodName] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_OrderPaymentMethod] PRIMARY KEY CLUSTERED 
(
	[OrderPayMethodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderStatusHistory]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderStatusHistory](
	[OrderStatusHistoryID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NOT NULL,
	[PackageID] [int] NOT NULL,
	[OrderStatus] [int] NOT NULL,
	[IsCurrent] [bit] NOT NULL,
	[CreateUser] [int] NULL,
	[CreateIP] [nvarchar](100) NULL,
	[CreateDateTime] [datetime] NULL,
 CONSTRAINT [PK_OrderStatusHistory] PRIMARY KEY CLUSTERED 
(
	[OrderStatusHistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderStatusType]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderStatusType](
	[OrderStatusID] [int] NOT NULL,
	[OrderStatusName] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_OrderStatusType] PRIMARY KEY CLUSTERED 
(
	[OrderStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Permission]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Permission](
	[PermissionID] [int] IDENTITY(1,1) NOT NULL,
	[ScreenName] [nvarchar](50) NOT NULL,
	[PermissionName] [nvarchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreateUser] [int] NULL,
	[CreateIP] [nvarchar](100) NULL,
	[CreateDateTime] [datetime] NULL,
	[ModUser] [int] NULL,
	[ModIP] [nvarchar](100) NULL,
	[ModDateTime] [datetime] NULL,
 CONSTRAINT [PK_Permission] PRIMARY KEY CLUSTERED 
(
	[PermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Project]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Project](
	[ProjectID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectTitle] [nvarchar](100) NOT NULL,
	[ClientID] [int] NOT NULL,
	[ProjectPriority] [int] NOT NULL,
	[ProjectSize] [int] NOT NULL,
	[StartDate] [date] NOT NULL,
	[StartTime] [time](7) NULL,
	[EndDate] [date] NOT NULL,
	[EndTime] [time](7) NULL,
	[Description] [nvarchar](max) NULL,
	[ProjectStatus] [int] NOT NULL,
	[CreateUser] [int] NULL,
	[CreateIP] [nvarchar](100) NULL,
	[CreateDateTime] [datetime] NULL,
	[ModUser] [int] NULL,
	[ModIP] [nvarchar](100) NULL,
	[ModDateTime] [datetime] NULL,
 CONSTRAINT [PK_Project] PRIMARY KEY CLUSTERED 
(
	[ProjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectPriority]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectPriority](
	[ProjectPriorityID] [int] NOT NULL,
	[PriorityName] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_ProjectPriority] PRIMARY KEY CLUSTERED 
(
	[ProjectPriorityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectSize]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectSize](
	[ProjectSizeID] [int] NOT NULL,
	[SizeName] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_ProjectSize] PRIMARY KEY CLUSTERED 
(
	[ProjectSizeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectStatus]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectStatus](
	[ProjectStatusID] [int] NOT NULL,
	[StatusName] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_ProjectStatus] PRIMARY KEY CLUSTERED 
(
	[ProjectStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectTask]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectTask](
	[TaskID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectID] [int] NOT NULL,
	[TaskName] [nvarchar](100) NOT NULL,
	[TaskRate] [decimal](18, 2) NOT NULL,
	[TaskRateType] [int] NOT NULL,
	[TaskPriority] [int] NOT NULL,
	[TaskStatus] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[StartDate] [date] NOT NULL,
	[StartTime] [time](7) NULL,
	[EndDate] [date] NOT NULL,
	[EndTime] [time](7) NULL,
	[ServiceType] [int] NOT NULL,
	[AssignTo] [int] NOT NULL,
	[ApprovalStatus] [int] NOT NULL,
	[CreateUser] [int] NULL,
	[CreateIP] [nvarchar](100) NULL,
	[CreateDateTime] [datetime] NULL,
	[ModUser] [int] NULL,
	[ModIP] [nvarchar](100) NULL,
	[ModDateTime] [datetime] NULL,
 CONSTRAINT [PK_ProjectTask] PRIMARY KEY CLUSTERED 
(
	[TaskID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectTaskImg]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectTaskImg](
	[ProjectTaskImgID] [int] IDENTITY(1,1) NOT NULL,
	[TaskID] [int] NOT NULL,
	[ImageName] [nvarchar](max) NOT NULL,
	[ImageURL] [nvarchar](max) NOT NULL,
	[CreateUser] [int] NULL,
	[CreateIP] [nvarchar](100) NULL,
	[CreateDateTime] [datetime] NULL,
 CONSTRAINT [PK_ProjectTaskImg] PRIMARY KEY CLUSTERED 
(
	[ProjectTaskImgID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectTaskRateType]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectTaskRateType](
	[TaskRateTypeID] [int] NOT NULL,
	[TaskRateTypeName] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_ProjectTaskRateType] PRIMARY KEY CLUSTERED 
(
	[TaskRateTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectTaskRejectInfo]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectTaskRejectInfo](
	[RejectInfoID] [int] IDENTITY(1,1) NOT NULL,
	[TaskID] [int] NOT NULL,
	[Reason] [nvarchar](max) NOT NULL,
	[CreateUser] [int] NULL,
	[CreateIP] [nvarchar](100) NULL,
	[CreateDateTime] [datetime] NULL,
	[ModUser] [int] NULL,
	[ModIP] [nvarchar](100) NULL,
	[ModDateTime] [datetime] NULL,
 CONSTRAINT [PK_ProjectTaskRejectInfo] PRIMARY KEY CLUSTERED 
(
	[RejectInfoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectTaskReview]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectTaskReview](
	[ReviewID] [int] IDENTITY(1,1) NOT NULL,
	[TaskID] [int] NOT NULL,
	[Rating] [int] NOT NULL,
	[Comment] [nvarchar](max) NULL,
	[ContractorID] [int] NOT NULL,
	[IsVisitedSite] [bit] NOT NULL,
	[CreateUser] [int] NULL,
	[CreateIP] [nvarchar](100) NULL,
	[CreateDateTime] [datetime] NULL,
	[ModUser] [int] NULL,
	[ModIP] [nvarchar](100) NULL,
	[ModDateTime] [datetime] NULL,
 CONSTRAINT [PK_ProjectTaskReview] PRIMARY KEY CLUSTERED 
(
	[ReviewID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectTaskStatus]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectTaskStatus](
	[TaskStatusID] [int] NOT NULL,
	[TaskStatusName] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_ProjectTaskStatus] PRIMARY KEY CLUSTERED 
(
	[TaskStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ServiceType]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServiceType](
	[ServiceTypeID] [int] IDENTITY(1,1) NOT NULL,
	[ServiceTypeName] [nvarchar](100) NOT NULL,
	[IsActive] [int] NOT NULL,
 CONSTRAINT [PK_ServiceType] PRIMARY KEY CLUSTERED 
(
	[ServiceTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TaskApprovalStatusType]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaskApprovalStatusType](
	[TaskApprovalStatusID] [int] NOT NULL,
	[TaskApprovalStatusName] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_TaskApprovalStatusType] PRIMARY KEY CLUSTERED 
(
	[TaskApprovalStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](max) NOT NULL,
	[FirstName] [nvarchar](100) NOT NULL,
	[LastName] [nvarchar](100) NOT NULL,
	[UserRoleID] [int] NOT NULL,
	[NIC] [nvarchar](12) NOT NULL,
	[MobileNo] [nvarchar](10) NOT NULL,
	[Password] [nvarchar](max) NOT NULL,
	[AttemptCount] [int] NOT NULL,
	[IsTempPassword] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreateUser] [int] NULL,
	[CreateIP] [nvarchar](100) NULL,
	[CreateDateTime] [datetime] NULL,
	[ModUser] [int] NULL,
	[ModIP] [nvarchar](100) NULL,
	[ModDateTime] [datetime] NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserAddressDetail]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAddressDetail](
	[AddressID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[Address1] [nvarchar](50) NOT NULL,
	[Address2] [nvarchar](50) NOT NULL,
	[Address3] [nvarchar](50) NOT NULL,
	[District] [nvarchar](50) NOT NULL,
	[Province] [nvarchar](50) NOT NULL,
	[IsPrimary] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreateUser] [int] NULL,
	[CreateIP] [nvarchar](100) NULL,
	[CreateDateTime] [datetime] NULL,
	[ModUser] [int] NULL,
	[ModIP] [nvarchar](100) NULL,
	[ModDateTime] [datetime] NULL,
 CONSTRAINT [PK_UserAddressDetail] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserImg]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserImg](
	[UserImgID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[ImageName] [nvarchar](max) NOT NULL,
	[ImageURL] [nvarchar](max) NOT NULL,
	[CreateUser] [int] NULL,
	[CreateIP] [nvarchar](100) NULL,
	[CreateDateTime] [datetime] NULL,
 CONSTRAINT [PK_UserImg] PRIMARY KEY CLUSTERED 
(
	[UserImgID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRole]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRole](
	[UserRoleID] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](50) NOT NULL,
	[IsRegistrationViewAllowed] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED 
(
	[UserRoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRolePermission]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRolePermission](
	[UserPermissionID] [int] NOT NULL,
	[RoleID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreateUser] [int] NULL,
	[CreateIP] [nvarchar](100) NULL,
	[CreateDateTime] [datetime] NULL,
 CONSTRAINT [PK_UserRolePermission] PRIMARY KEY CLUSTERED 
(
	[UserPermissionID] ASC,
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VendorCategory]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VendorCategory](
	[UserID] [int] NOT NULL,
	[VendorCategoryTypeID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreateUser] [int] NULL,
	[CreateIP] [nvarchar](100) NULL,
	[CreateDateTime] [datetime] NULL,
	[ModUser] [int] NULL,
	[ModIP] [nvarchar](100) NULL,
	[ModDateTime] [datetime] NULL,
 CONSTRAINT [PK_VendorCategory] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[VendorCategoryTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VendorCategoryType]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VendorCategoryType](
	[VendorCategoryTypeID] [int] IDENTITY(1,1) NOT NULL,
	[VendorCategoryName] [nvarchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_VendorCategoryType] PRIMARY KEY CLUSTERED 
(
	[VendorCategoryTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Year]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Year](
	[YearID] [int] NOT NULL,
	[YearName] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Year] PRIMARY KEY CLUSTERED 
(
	[YearID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Advertisement] ON 
GO
INSERT [dbo].[Advertisement] ([AdvID], [CampaignName], [Description], [StartDate], [EndDate], [IsActive], [UserRoleID], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (1, N'Service Construction Ad 3', N'Service Construction Ad 3', CAST(N'2024-03-20' AS Date), CAST(N'2024-04-03' AS Date), 1, 3, 3, N'::1', CAST(N'2023-11-25T16:30:13.447' AS DateTime), 3, N'::1', CAST(N'2024-03-20T19:06:57.013' AS DateTime))
GO
INSERT [dbo].[Advertisement] ([AdvID], [CampaignName], [Description], [StartDate], [EndDate], [IsActive], [UserRoleID], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (2, N'Service Construction Ad 2', N'Service Construction Ad 2', CAST(N'2024-03-20' AS Date), CAST(N'2024-05-08' AS Date), 1, 3, 3, N'::1', CAST(N'2023-11-25T19:31:12.190' AS DateTime), 3, N'::1', CAST(N'2024-03-20T19:06:47.933' AS DateTime))
GO
INSERT [dbo].[Advertisement] ([AdvID], [CampaignName], [Description], [StartDate], [EndDate], [IsActive], [UserRoleID], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (3, N'Service Construction Ad', N'Service Construction Ad 1', CAST(N'2024-03-20' AS Date), CAST(N'2024-04-11' AS Date), 1, 3, 3, N'::1', CAST(N'2023-11-25T21:54:44.620' AS DateTime), 3, N'::1', CAST(N'2024-03-20T19:06:28.570' AS DateTime))
GO
INSERT [dbo].[Advertisement] ([AdvID], [CampaignName], [Description], [StartDate], [EndDate], [IsActive], [UserRoleID], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (4, N'Vendor Ad 1', N'Vendor Ad 1', CAST(N'2024-03-20' AS Date), CAST(N'2024-04-04' AS Date), 1, 4, 4, N'::1', CAST(N'2024-03-20T19:21:24.320' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Advertisement] ([AdvID], [CampaignName], [Description], [StartDate], [EndDate], [IsActive], [UserRoleID], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (5, N'Vendor Ad 2', N'Vendor Ad 2', CAST(N'2024-03-20' AS Date), CAST(N'2024-05-02' AS Date), 1, 4, 4, N'::1', CAST(N'2024-03-20T19:22:10.060' AS DateTime), 4, N'::1', CAST(N'2024-03-20T19:26:00.950' AS DateTime))
GO
INSERT [dbo].[Advertisement] ([AdvID], [CampaignName], [Description], [StartDate], [EndDate], [IsActive], [UserRoleID], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (6, N'Vendor Ad 3', N'Vendor Ad 3', CAST(N'2024-03-20' AS Date), CAST(N'2024-05-08' AS Date), 1, 4, 4, N'::1', CAST(N'2024-03-20T19:22:45.767' AS DateTime), 4, N'::1', CAST(N'2024-03-20T19:25:48.867' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Advertisement] OFF
GO
SET IDENTITY_INSERT [dbo].[AdvertisementImg] ON 
GO
INSERT [dbo].[AdvertisementImg] ([AdvImgID], [AdvID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (11, 1, N'adv_1_1_20240320T190253.png', N'/uploads/advmgnt/adv_1_1_20240320T190253.png', 3, N'::1', CAST(N'2024-03-20T19:02:53.667' AS DateTime))
GO
INSERT [dbo].[AdvertisementImg] ([AdvImgID], [AdvID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (12, 2, N'adv_2_1_20240320T190318.png', N'/uploads/advmgnt/adv_2_1_20240320T190318.png', 3, N'::1', CAST(N'2024-03-20T19:03:18.740' AS DateTime))
GO
INSERT [dbo].[AdvertisementImg] ([AdvImgID], [AdvID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (13, 3, N'adv_3_1_20240320T190330.png', N'/uploads/advmgnt/adv_3_1_20240320T190330.png', 3, N'::1', CAST(N'2024-03-20T19:03:30.033' AS DateTime))
GO
INSERT [dbo].[AdvertisementImg] ([AdvImgID], [AdvID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (14, 4, N'adv_4_1_20240320T192124.png', N'/uploads/advmgnt/adv_4_1_20240320T192124.png', 4, N'::1', CAST(N'2024-03-20T19:21:24.367' AS DateTime))
GO
INSERT [dbo].[AdvertisementImg] ([AdvImgID], [AdvID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (17, 6, N'adv_6_1_20240320T192548.png', N'/uploads/advmgnt/adv_6_1_20240320T192548.png', 4, N'::1', CAST(N'2024-03-20T19:25:48.910' AS DateTime))
GO
INSERT [dbo].[AdvertisementImg] ([AdvImgID], [AdvID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (18, 5, N'adv_5_1_20240320T192600.png', N'/uploads/advmgnt/adv_5_1_20240320T192600.png', 4, N'::1', CAST(N'2024-03-20T19:26:00.980' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[AdvertisementImg] OFF
GO
INSERT [dbo].[CMMSAppParameter] ([ParameterID], [ParameterName], [ParameterDescription], [Value], [IsActive]) VALUES (1, N'DeliveryCharge', N'Delivery Charge', CAST(300.00 AS Decimal(18, 2)), 1)
GO
INSERT [dbo].[ContractorService] ([UserID], [ServiceTypeID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (3, 1, 1, 3, N'::1', CAST(N'2024-03-22T08:31:50.913' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ContractorService] ([UserID], [ServiceTypeID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (3, 2, 1, 3, N'::1', CAST(N'2024-03-22T08:31:50.913' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ContractorService] ([UserID], [ServiceTypeID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (3, 3, 1, 3, N'::1', CAST(N'2024-03-22T08:31:50.913' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ContractorService] ([UserID], [ServiceTypeID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (3, 4, 1, 3, N'::1', CAST(N'2024-03-22T08:31:50.913' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ContractorService] ([UserID], [ServiceTypeID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (3, 7, 1, 3, N'::1', CAST(N'2024-03-22T08:31:50.913' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ContractorService] ([UserID], [ServiceTypeID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (3, 8, 1, 3, N'::1', CAST(N'2024-03-22T08:31:50.913' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ContractorService] ([UserID], [ServiceTypeID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (6, 2, 1, 6, N'::1', CAST(N'2024-03-22T10:29:14.257' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ContractorService] ([UserID], [ServiceTypeID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (6, 3, 1, 6, N'::1', CAST(N'2024-03-22T10:29:14.257' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ContractorService] ([UserID], [ServiceTypeID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (6, 4, 1, 6, N'::1', CAST(N'2024-03-22T10:29:14.257' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ContractorService] ([UserID], [ServiceTypeID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (6, 5, 1, 6, N'::1', CAST(N'2024-03-22T10:29:14.257' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ContractorService] ([UserID], [ServiceTypeID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (6, 7, 1, 6, N'::1', CAST(N'2024-03-22T10:29:14.257' AS DateTime), NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[EmailLog] ON 
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (1, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'Test12', N'Test Body', 1, CAST(N'2024-02-27T00:58:12.687' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (2, N'cmmsnoreply@gmail.com', N'shalithajoe2121@gmail.com', N'Test12', N'Test Body', 1, CAST(N'2024-02-27T00:59:30.557' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (3, N'cmmsnoreply@gmail.com', N'$%^dsdsd@gmail.com', N'Test12', N'Test Body', 1, CAST(N'2024-02-27T01:00:30.857' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (4, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'Test123', N'Test Body', 1, CAST(N'2024-02-27T01:02:49.193' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (5, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'C2023/000003 - Order Confirmed', N'<h3><b>Order No: C2023/000003</b></h3><br/><h6>Placed Date: 2023-11-18</h6><br/><h6>Estimated Delivery Date: 2023-11-21</h6><br/><h6><b>Payment Method: </b>Cash On Delivery</h6><br/><br/><br/><h3><b>Dushan Perera</b></h3><br/><h6>No- 34, Asiri Mawatha, Kesbewa</h6><br/><h6>Colombo, Western</h6><br/><h6>0754566788</h6><br/><h6>dushanpp@gmail.com</h6><br/><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Vendor Name</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>Total</b></th></tr><tr><td>Chains 10mmX40mm</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 1800.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 1800.00  </p></td></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>2.00  </p></td><td><p style=''text-align:right''>Rs. 4000.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Sub Total</b></td> <td> Rs.5800.00</td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Delivery Charges</b></td> <td> Rs.300.00</td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Total</b></td> <td> Rs.6100.00</td> </tr></table></center><br/><br/><center><p><b>Thank you for shopping on CMMS.</b></p></center>', 1, CAST(N'2024-03-15T00:53:42.403' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (6, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'C2023/000003 - Order Confirmed', N'<p><b>Order No: C2023/000003</b></p><br/><p>Placed Date: 2023-11-18</p><br/><p>Estimated Delivery Date: 2023-11-21</p><br/><p><b>Payment Method: </b>Cash On Delivery</p><br/><br/><br/><p><b>Dushan Perera</b></p><br/><p>No- 34, Asiri Mawatha, Kesbewa</p><br/><p>Colombo, Western</p><br/><p>0754566788</p><br/><p>dushanpp@gmail.com</p><br/><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Vendor Name</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>Total</b></th></tr><tr><td>Chains 10mmX40mm</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 1800.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 1800.00  </p></td></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>2.00  </p></td><td><p style=''text-align:right''>Rs. 4000.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Sub Total</b></td> <td><p style=''text-align:right''> Rs.5800.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Delivery Charges</b></td> <td><p style=''text-align:right''> Rs.300.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.6100.00</p></td> </tr></table></center><br/><br/><center><p><b>Thank you for shopping on CMMS.</b></p></center>', 1, CAST(N'2024-03-15T00:58:23.403' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (7, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'C2023/000003 - Order Confirmed', N'<table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td><b>Order No: C2023/000003</b></th> <td><b></b></th><td><b></b></th><td><b>Dushan Perera</b></th></tr><tr><td><b>Placed Date: 2023-11-18</b></th> <td><b></b></th><td><b></b></th><td><b>No- 34, Asiri Mawatha, Kesbewa</b></th></tr><tr><td><b>Estimated Delivery Date: 2023-11-21</b></th> <td><b></b></th><td><b></b></th><td><b>Colombo, Western</b></th></tr><tr><td><b>Payment Method: Cash On Delivery</b></th> <td><b></b></th><td><b></b></th><td><b>0754566788</b></th></tr><tr><td><b></b></th> <td><b></b></th><td><b></b></th><td><b>dushanpp@gmail.com</b></th></tr></table><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Vendor Name</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>Total</b></th></tr><tr><td>Chains 10mmX40mm</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 1800.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 1800.00  </p></td></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>2.00  </p></td><td><p style=''text-align:right''>Rs. 4000.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Sub Total</b></td> <td><p style=''text-align:right''> Rs.5800.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Delivery Charges</b></td> <td><p style=''text-align:right''> Rs.300.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.6100.00</p></td> </tr></table></center><br/><br/><center><p><b>Thank you for shopping on CMMS.</b></p></center>', 1, CAST(N'2024-03-15T09:53:04.877' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (8, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'C2023/000001 - Order Confirmed', N'<table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td><b>Order No: C2023/000001</b></th> <td><b></b></th><td><b></b></th><td><b>Dushan Perera</b></th></tr><tr><td><b>Placed Date: 2023-11-15</b></th> <td><b></b></th><td><b></b></th><td><b>No- 34, Asiri Mawatha, Kesbewa</b></th></tr><tr><td><b>Estimated Delivery Date: 2023-11-18</b></th> <td><b></b></th><td><b></b></th><td><b>Colombo, Western</b></th></tr><tr><td><b>Payment Method: Cash On Delivery</b></th> <td><b></b></th><td><b></b></th><td><b>0754566788</b></th></tr><tr><td><b></b></th> <td><b></b></th><td><b></b></th><td><b>dushanpp@gmail.com</b></th></tr></table><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Vendor Name</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>Total</b></th></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>2.00  </p></td><td><p style=''text-align:right''>Rs. 4000.00  </p></td></tr><tr><td>Chains 10mmX40mm</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 1800.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 1800.00  </p></td></tr><tr><td>Multilac White 4L</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 35000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 35000.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Sub Total</b></td> <td><p style=''text-align:right''> Rs.40800.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Delivery Charges</b></td> <td><p style=''text-align:right''> Rs.300.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.41100.00</p></td> </tr></table></center><br/><br/><center><p><b>Thank you for shopping on CMMS.</b></p></center>', 1, CAST(N'2024-03-15T09:54:06.720' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (9, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'C2023/000001 - Order Confirmed', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Order No: <b>C2023/000001</b></th> <td><b></b></th><td><b></b></th><td><b>Dushan Perera</b></th></tr><tr><td>Placed Date: <b>2023-11-15</b></th> <td><b></b></th><td><b></b></th><td><b>No- 34, Asiri Mawatha, Kesbewa</b></th></tr><tr><td>Estimated Delivery Date: <b>2023-11-18</b></th> <td><b></b></th><td><b></b></th><td><b>Colombo, Western</b></th></tr><tr><td><b>Payment Method: <b>Cash On Delivery</b></th> <td><b></b></th><td><b></b></th><td><b>0754566788</b></th></tr><tr><td><b></b></th> <td><b></b></th><td><b></b></th><td><b>dushanpp@gmail.com</b></th></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Vendor Name</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>Total</b></th></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>2.00  </p></td><td><p style=''text-align:right''>Rs. 4000.00  </p></td></tr><tr><td>Chains 10mmX40mm</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 1800.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 1800.00  </p></td></tr><tr><td>Multilac White 4L</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 35000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 35000.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Sub Total</b></td> <td><p style=''text-align:right''> Rs.40800.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Delivery Charges</b></td> <td><p style=''text-align:right''> Rs.300.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.41100.00</p></td> </tr></table></center><br/><br/><center><p><b>Thank you for shopping on CMMS.</b></p></center>', 1, CAST(N'2024-03-15T09:58:22.890' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (10, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'C2023/000001 - Order Confirmed', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Order No: <b>C2023/000001</b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td><b>Dushan Perera</b></th></tr><tr><td>Placed Date: <b>2023-11-15</b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td><b>No- 34, Asiri Mawatha, Kesbewa</b></th></tr><tr><td>Estimated Delivery Date: <b>2023-11-18</b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td><b>Colombo, Western</b></th></tr><tr><td><b>Payment Method: <b>Cash On Delivery</b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td><b>0754566788</b></th></tr><tr><td><b></b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td><b>dushanpp@gmail.com</b></th></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Vendor Name</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>Total</b></th></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>2.00  </p></td><td><p style=''text-align:right''>Rs. 4000.00  </p></td></tr><tr><td>Chains 10mmX40mm</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 1800.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 1800.00  </p></td></tr><tr><td>Multilac White 4L</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 35000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 35000.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Sub Total</b></td> <td><p style=''text-align:right''> Rs.40800.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Delivery Charges</b></td> <td><p style=''text-align:right''> Rs.300.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.41100.00</p></td> </tr></table></center><br/><br/><center><p><b>Thank you for shopping on CMMS.</b></p></center>', 1, CAST(N'2024-03-15T10:00:49.033' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (11, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'C2023/000001 - Order Confirmed', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2023/000001</b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td><b>Dushan Perera</b></th></tr><tr><td>Placed Date: <b>2023-11-15</b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td><b>No- 34, Asiri Mawatha, Kesbewa</b></th></tr><tr><td>Estimated Delivery Date: <b>2023-11-18</b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td><b>Colombo, Western</b></th></tr><tr><td><b>Payment Method: <b>Cash On Delivery</b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td><b>0754566788</b></th></tr><tr><td><b></b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td><b>dushanpp@gmail.com</b></th></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Vendor Name</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>Total</b></th></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>2.00  </p></td><td><p style=''text-align:right''>Rs. 4000.00  </p></td></tr><tr><td>Chains 10mmX40mm</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 1800.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 1800.00  </p></td></tr><tr><td>Multilac White 4L</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 35000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 35000.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Sub Total</b></td> <td><p style=''text-align:right''> Rs.40800.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Delivery Charges</b></td> <td><p style=''text-align:right''> Rs.300.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.41100.00</p></td> </tr></table></center><br/><br/><center><p><b>Thank you for shopping on CMMS.</b></p></center>', 1, CAST(N'2024-03-15T10:02:37.657' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (12, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'C2023/000001 - Order Confirmed', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2023/000001</b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b>Customer Name: </b></th><td><b>Dushan Perera</b></th></tr><tr><td>Placed Date: <b>2023-11-15</b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td><b>No- 34, Asiri Mawatha, Kesbewa</b></th></tr><tr><td>Estimated Delivery Date: <b>2023-11-18</b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td><b>Colombo, Western</b></th></tr><tr><td>Payment Method: <b>Cash On Delivery</b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td><b>0754566788</b></th></tr><tr><td><b></b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td><b>dushanpp@gmail.com</b></th></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Vendor Name</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>Total</b></th></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>2.00  </p></td><td><p style=''text-align:right''>Rs. 4000.00  </p></td></tr><tr><td>Chains 10mmX40mm</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 1800.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 1800.00  </p></td></tr><tr><td>Multilac White 4L</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 35000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 35000.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Sub Total</b></td> <td><p style=''text-align:right''> Rs.40800.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Delivery Charges</b></td> <td><p style=''text-align:right''> Rs.300.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.41100.00</p></td> </tr></table></center><br/><br/><center><p><b>Thank you for shopping on CMMS.</b></p></center>', 1, CAST(N'2024-03-15T10:05:27.987' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (13, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'C2023/000001 - Order Confirmed', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2023/000001</b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td><b>Customer: </b></th></tr><tr><td>Placed Date: <b>2023-11-15</b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td>Dushan Perera</th><tr><td>Estimated Delivery Date: <b>2023-11-18</b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td>No- 34, Asiri Mawatha, Kesbewa</th></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td>Colombo, Western</th></tr><tr><td><b></b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td>0754566788</th></tr><tr><td><b></b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td>dushanpp@gmail.com</th></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Vendor Name</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>Total</b></th></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>2.00  </p></td><td><p style=''text-align:right''>Rs. 4000.00  </p></td></tr><tr><td>Chains 10mmX40mm</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 1800.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 1800.00  </p></td></tr><tr><td>Multilac White 4L</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 35000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 35000.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Sub Total</b></td> <td><p style=''text-align:right''> Rs.40800.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Delivery Charges</b></td> <td><p style=''text-align:right''> Rs.300.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.41100.00</p></td> </tr></table></center><br/><br/><center><p><b>Thank you for shopping on CMMS.</b></p></center>', 1, CAST(N'2024-03-15T10:10:19.697' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (14, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'You have Received a new Order C2023/000001', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2023/000001</b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td><b>Customer: </b></th></tr><tr><td>Placed Date: <b>2023-11-15</b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td>Dushan Perera</th><tr><td>Estimated Delivery Date: <b>2023-11-18</b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td>No- 34, Asiri Mawatha, Kesbewa</th></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td>Colombo, Western</th></tr><tr><td><b></b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td>0754566788</th></tr><tr><td><b></b></th> <td><b></b></th><td><b></b></th><td><b></b></th><td><b></b></th><td>dushanpp@gmail.com</th></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>ItemWise Total</b></th></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>2.00  </p></td><td><p style=''text-align:right''>Rs. 4000.00  </p></td></tr><tr><td>Chains 10mmX40mm</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 1800.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 1800.00  </p></td></tr><tr><td>Multilac White 4L</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 35000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 35000.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.40800.00</p></td> </tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-15T13:54:18.050' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (15, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'Task - Wood Cutting and shaping new in project Furniture Workis Completed', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Task Name: <b>Furniture Work</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Furniture Work</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><tr><td>Above Task is <b>completed</b> by the contractor.</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-16T14:20:44.673' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (16, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'Task - Wood Cutting and shaping new in project Furniture Work is Completed', N'<center><p>Below Task is <b>completed</b> by the contractor. Please approve the task by visiting CMMS.</p></center><br/><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>Furniture Work</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Furniture Work</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-16T14:25:33.180' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (17, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'Task - Wood Cutting and shaping new in project Furniture Work&nbsp;is Completed', N'<p>Below Task is <b>completed</b> by the contractor. Please approve the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>Wood Cutting and shaping new</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Furniture Work</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-16T14:28:20.677' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (18, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'Task - Wood Cutting and shaping new in project Furniture Work is Completed', N'<p>Below Task is <b>completed</b> by the contractor. Please approve the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>Wood Cutting and shaping new</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Furniture Work</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-16T14:30:36.730' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (19, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'Task - Wood Cutting and shaping new is Completed', N'<p>Below Task is <b>completed</b> by the contractor. Please approve the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>Wood Cutting and shaping new</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Furniture Work</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-16T14:34:22.947' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (20, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'Task - Wood Cutting and shaping new is Approved', N'<p>Below Task is <b>approved</b> by the client. Please check the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Task Name: <b>Furniture Work</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Wood Cutting and shaping new</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-16T14:44:44.727' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (21, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'Task - Wood Cutting and shaping new is Approved', N'<p>Below Task is <b>approved</b> by the client. Please check the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>Furniture Work</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Wood Cutting and shaping new</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-16T14:45:34.340' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (22, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'Task - Wood Cutting and shaping new is Approved', N'<p>Below Task is <b>approved</b> by the client. Please check the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>Wood Cutting and shaping new</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Furniture Work</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-16T14:46:33.043' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (23, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'Task - Wood Cutting and shaping new is Rejected', N'<p>Below Task is <b>rejected</b> by the client. Please check the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>Wood Cutting and shaping new</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Furniture Work</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-16T14:47:39.113' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (24, N'cmmsnoreply@gmail.com', N'shalitha.dh@gmail.com', N'C2024/000005 - Order Confirmed', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000005</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-17</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Dushan Perera</td><tr><td>Estimated Delivery Date: <b>2024-03-20</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No- 37, Asiri Mawatha, Kesbewa</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0754566788</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>shalitha.dh@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Vendor Name</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>Total</b></th></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 2000.00  </p></td></tr><tr><td>Multilac White 4L</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 35000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 35000.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Sub Total</b></td> <td><p style=''text-align:right''> Rs.37000.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Delivery Charges</b></td> <td><p style=''text-align:right''> Rs.300.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.37300.00</p></td> </tr></table></center><br/><br/><center><p><b>Thank you for shopping on CMMS.</b></p></center>', 1, CAST(N'2024-03-17T00:28:40.950' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (25, N'cmmsnoreply@gmail.com', N'shalitha.dh@gmail.com', N'C2024/000005 - Order Confirmed', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000005</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-17</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Dushan Perera</td><tr><td>Estimated Delivery Date: <b>2024-03-20</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No- 37, Asiri Mawatha, Kesbewa</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0754566788</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>shalitha.dh@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Vendor Name</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>Total</b></th></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 2000.00  </p></td></tr><tr><td>Multilac White 4L</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 35000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 35000.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Sub Total</b></td> <td><p style=''text-align:right''> Rs.37000.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Delivery Charges</b></td> <td><p style=''text-align:right''> Rs.300.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.37300.00</p></td> </tr></table></center><br/><br/><center><p><b>Thank you for shopping on CMMS.</b></p></center>', 1, CAST(N'2024-03-17T00:29:06.487' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (26, N'cmmsnoreply@gmail.com', N'shalitha.dh@gmail.com', N'C2024/000006 - Order Confirmed', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000006</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-17</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Dushan Perera</td><tr><td>Estimated Delivery Date: <b>2024-03-20</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No- 37, Asiri Mawatha, Kesbewa</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0754566788</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>shalitha.dh@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Vendor Name</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>Total</b></th></tr><tr><td>Multilac White 4L</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 35000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 35000.00  </p></td></tr><tr><td>Chains 10mmX40mm</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 1800.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 1800.00  </p></td></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 2000.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Sub Total</b></td> <td><p style=''text-align:right''> Rs.38800.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Delivery Charges</b></td> <td><p style=''text-align:right''> Rs.300.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.39100.00</p></td> </tr></table></center><br/><br/><center><p><b>Thank you for shopping on CMMS.</b></p></center>', 1, CAST(N'2024-03-17T00:31:51.403' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (27, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'You have Received a new Order C2024/000006', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000006</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-17</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Dushan Perera</td><tr><td>Estimated Delivery Date: <b>2024-03-20</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No- 37, Asiri Mawatha, Kesbewa</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0754566788</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>shalitha.dh@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>ItemWise Total</b></th></tr><tr><td>Multilac White 4L</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 35000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 35000.00  </p></td></tr><tr><td>Chains 10mmX40mm</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 1800.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 1800.00  </p></td></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 2000.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.38800.00</p></td> </tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-17T00:31:57.127' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (28, N'cmmsnoreply@gmail.com', N'shalitha.dh@gmail.com', N'C2024/000007 - Order Confirmed', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000007</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-17</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Dushan Perera</td><tr><td>Estimated Delivery Date: <b>2024-03-20</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No- 37, Asiri Mawatha, Kesbewa</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0754566788</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>shalitha.dh@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Vendor Name</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>Total</b></th></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>3.00  </p></td><td><p style=''text-align:right''>Rs. 6000.00  </p></td></tr><tr><td>Chains 10mmX40mm</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 1800.00  </p></td><td><p style=''text-align:right''>2.00  </p></td><td><p style=''text-align:right''>Rs. 3600.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Sub Total</b></td> <td><p style=''text-align:right''> Rs.9600.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Delivery Charges</b></td> <td><p style=''text-align:right''> Rs.300.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.9900.00</p></td> </tr></table></center><br/><br/><center><p><b>Thank you for shopping on CMMS.</b></p></center>', 1, CAST(N'2024-03-17T00:37:14.227' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (29, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'You have Received a new Order C2024/000007', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000007</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-17</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Dushan Perera</td><tr><td>Estimated Delivery Date: <b>2024-03-20</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No- 37, Asiri Mawatha, Kesbewa</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0754566788</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>shalitha.dh@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>ItemWise Total</b></th></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>3.00  </p></td><td><p style=''text-align:right''>Rs. 6000.00  </p></td></tr><tr><td>Chains 10mmX40mm</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 1800.00  </p></td><td><p style=''text-align:right''>2.00  </p></td><td><p style=''text-align:right''>Rs. 3600.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.9600.00</p></td> </tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-17T00:37:19.450' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (30, N'cmmsnoreply@gmail.com', N'shalitha.dh@gmail.com', N'C2024/000008 - Order Confirmed', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000008</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-17</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Dushan Perera</td><tr><td>Estimated Delivery Date: <b>2024-03-20</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No- 37, Asiri Mawatha, Kesbewa</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0754566788</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>shalitha.dh@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Vendor Name</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>Total</b></th></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 2000.00  </p></td></tr><tr><td>Multilac White 12L</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 68000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 68000.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Sub Total</b></td> <td><p style=''text-align:right''> Rs.70000.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Delivery Charges</b></td> <td><p style=''text-align:right''> Rs.300.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.70300.00</p></td> </tr></table></center><br/><br/><center><p><b>Thank you for shopping on CMMS.</b></p></center>', 1, CAST(N'2024-03-17T00:47:56.627' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (31, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'You have Received a new Order C2024/000008', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000008</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-17</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Dushan Perera</td><tr><td>Estimated Delivery Date: <b>2024-03-20</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No- 37, Asiri Mawatha, Kesbewa</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0754566788</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>shalitha.dh@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>ItemWise Total</b></th></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 2000.00  </p></td></tr><tr><td>Multilac White 12L</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 68000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 68000.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.70000.00</p></td> </tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-17T00:47:59.193' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (32, N'cmmsnoreply@gmail.com', N'shalitha.dh@gmail.com', N'Task - TRD Boards is Completed', N'<p>Below Task is <b>completed</b> by the contractor. Please approve the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>TRD Boards</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Furniture Work</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-17T01:35:01.983' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (33, N'cmmsnoreply@gmail.com', N'shalitha.dh@hotmail.com', N'Task - Painting Wall is Approved', N'<p>Below Task is <b>approved</b> by the client. Please check the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>Painting Wall</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Redwork Building</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-17T02:08:12.863' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (34, N'cmmsnoreply@gmail.com', N'shalitha.dh@hotmail.com', N'Task - Painting Wall is Rejected', N'<p>Below Task is <b>rejected</b> by the client. Please check the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>Painting Wall</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>New Savoy Hall Painting</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-17T02:09:17.330' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (35, N'cmmsnoreply@gmail.com', N'shalitha.dh@hotmail.com', N'Task - TRD Boards is Approved', N'<p>Below Task is <b>approved</b> by the client. Please check the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>TRD Boards</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Furniture Work</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-17T13:25:50.610' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (36, N'cmmsnoreply@gmail.com', N'shalitha.dh@hotmail.com', N'Task - Wood Cutting and shaping new is Rejected', N'<p>Below Task is <b>rejected</b> by the client. Please check the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>Wood Cutting and shaping new</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Furniture Work</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-17T13:26:50.347' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (37, N'cmmsnoreply@gmail.com', N'shalitha.dh@gmail.com', N'Task - Wood Cutting and shaping is Completed', N'<p>Below Task is <b>completed</b> by the contractor. Please approve the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>Wood Cutting and shaping</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Furniture Work</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-17T13:49:54.503' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (38, N'cmmsnoreply@gmail.com', N'shalitha.dh@gmail.com', N'Task - Wood Cutting and shaping is Completed', N'<p>Below Task is <b>completed</b> by the contractor. Please approve the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>Wood Cutting and shaping</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Furniture Work</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-17T13:58:24.620' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (39, N'cmmsnoreply@gmail.com', N'shalitha.dh@gmail.com', N'Admin has reset your CMMS account password', N'<p>Hi! Dushan, </p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Please find the temporary password to access your account </td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Temporary Password: <b>DBnxV1lAFaFAI+nPyP9NIg==</b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-18T01:29:38.127' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (40, N'cmmsnoreply@gmail.com', N'shalitha.dh@gmail.com', N'Admin has reset your CMMS account password', N'<p>Hi! Dushan, </p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Please find the temporary password to access your account. </td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Temporary Password: <b>zyfqgima</b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-18T01:39:24.440' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (41, N'cmmsnoreply@gmail.com', N'shalitha.dh@hotmail.com', N'Admin has reset your CMMS account password', N'<p>Hi! Jagath, </p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Please find the temporary password to access your account. </td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Temporary Password: <b>verbzyli</b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-18T01:41:32.467' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (42, N'cmmsnoreply@gmail.com', N'shalitha.dh@gmail.com', N'Task - Test 109 is Completed', N'<p>Below Task is <b>completed</b> by the contractor. Please approve the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>Test 109</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Library Renovating Phase 1</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-20T14:37:09.633' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (43, N'cmmsnoreply@gmail.com', N'shalitha.dh@hotmail.com', N'Task - Test 109 is Approved', N'<p>Below Task is <b>approved</b> by the client. Please check the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>Test 109</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Library Renovating Phase 1</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-20T14:38:42.550' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (44, N'cmmsnoreply@gmail.com', N'shalitha.dh@gmail.com', N'C2024/000009 - Order Confirmed', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000009</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-20</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Dushan Perera</td><tr><td>Estimated Delivery Date: <b>2024-03-23</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No- 37, Asiri Mawatha, Kesbewa</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0754566788</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>shalitha.dh@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Vendor Name</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>Total</b></th></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 2000.00  </p></td></tr><tr><td>Multilac White 4L</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 35000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 35000.00  </p></td></tr><tr><td>Rocell  1/2 " GARDEN TAP</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 2200.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 2200.00  </p></td></tr><tr><td>Orange ECO LED Pin Type 7W Day Light</td> <td> Package - 2</td> <td>Janith Wijethunga</td> <td><p style=''text-align:right''>Rs. 1000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 1000.00  </p></td></tr><tr><td>Kevilton Wiring/Insulation Tape (Black)</td> <td> Package - 2</td> <td>Janith Wijethunga</td> <td><p style=''text-align:right''>Rs. 100.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 100.00  </p></td></tr><tr><td>ACL 13A Plug Base</td> <td> Package - 2</td> <td>Janith Wijethunga</td> <td><p style=''text-align:right''>Rs. 600.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 600.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Sub Total</b></td> <td><p style=''text-align:right''> Rs.40900.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Delivery Charges</b></td> <td><p style=''text-align:right''> Rs.300.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.41200.00</p></td> </tr></table></center><br/><br/><center><p><b>Thank you for shopping on CMMS.</b></p></center>', 1, CAST(N'2024-03-20T23:47:00.667' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (45, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'You have Received a new Order C2024/000009', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000009</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-20</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Dushan Perera</td><tr><td>Estimated Delivery Date: <b>2024-03-23</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No- 37, Asiri Mawatha, Kesbewa</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0754566788</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>shalitha.dh@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>ItemWise Total</b></th></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 2000.00  </p></td></tr><tr><td>Multilac White 4L</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 35000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 35000.00  </p></td></tr><tr><td>Rocell  1/2 " GARDEN TAP</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 2200.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 2200.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.39200.00</p></td> </tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-20T23:47:06.393' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (46, N'cmmsnoreply@gmail.com', N'janith456@hotmail.com', N'You have Received a new Order C2024/000009', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000009</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-20</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Dushan Perera</td><tr><td>Estimated Delivery Date: <b>2024-03-23</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No- 37, Asiri Mawatha, Kesbewa</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0754566788</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>shalitha.dh@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>ItemWise Total</b></th></tr><tr><td>Orange ECO LED Pin Type 7W Day Light</td> <td> Package - 2</td> <td><p style=''text-align:right''>Rs. 1000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 1000.00  </p></td></tr><tr><td>Kevilton Wiring/Insulation Tape (Black)</td> <td> Package - 2</td> <td><p style=''text-align:right''>Rs. 100.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 100.00  </p></td></tr><tr><td>ACL 13A Plug Base</td> <td> Package - 2</td> <td><p style=''text-align:right''>Rs. 600.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 600.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.1700.00</p></td> </tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-20T23:47:12.267' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (47, N'cmmsnoreply@gmail.com', N'shalitha.dh@gmail.com', N'Task - Fix Cupboard V2 is Completed', N'<p>Below Task is <b>completed</b> by the contractor. Please approve the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>Fix Cupboard V2</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Furniture Work</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-21T13:33:04.517' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (48, N'cmmsnoreply@gmail.com', N'sarthsilva11@gmail.com', N'Task - Fix Cupboard V2 is Approved', N'<p>Below Task is <b>approved</b> by the client. Please check the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>Fix Cupboard V2</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Furniture Work</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-21T13:33:49.427' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (49, N'cmmsnoreply@gmail.com', N'shalitha.dh@gmail.com', N'Task - Painting Wood Wall is Completed', N'<p>Below Task is <b>completed</b> by the contractor. Please approve the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>Painting Wood Wall</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Furniture Work</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-21T13:36:09.150' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (50, N'cmmsnoreply@gmail.com', N'shalitha.dh@hotmail.com', N'Task - Painting Wood Wall is Approved', N'<p>Below Task is <b>approved</b> by the client. Please check the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>Painting Wood Wall</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Furniture Work</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-21T13:36:52.550' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (51, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'Admin has reset your CMMS account password', N'<p>Hi! Kavindu, </p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Please find the temporary password to access your account. </td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Temporary Password: <b>defpmnxw</b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-21T13:42:16.083' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (52, N'cmmsnoreply@gmail.com', N'shalitha.dh@gmail.com', N'Task - TYU Gtdsds is Completed', N'<p>Below Task is <b>completed</b> by the contractor. Please approve the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>TYU Gtdsds</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Furniture Work</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-21T15:58:35.387' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (53, N'cmmsnoreply@gmail.com', N'shalitha.dh@hotmail.com', N'Task - Wood Cutting and shaping is Rejected', N'<p>Below Task is <b>rejected</b> by the client. Please check the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>Wood Cutting and shaping</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Furniture Work</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-21T15:59:33.703' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (54, N'cmmsnoreply@gmail.com', N'shalitha.dh@hotmail.com', N'Task - TYU Gtdsds is Approved', N'<p>Below Task is <b>approved</b> by the client. Please check the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>TYU Gtdsds</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Furniture Work</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-21T15:59:48.277' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (55, N'cmmsnoreply@gmail.com', N'cheranisilva11@gmail.com', N'C2024/000010 - Order Confirmed', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000010</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-21</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Cherani Silva</td><tr><td>Estimated Delivery Date: <b>2024-03-24</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No 23, Wattala, Colombo 7</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0783232323</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>cheranisilva11@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Vendor Name</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>Total</b></th></tr><tr><td>Orange ECO LED Pin Type 7W Day Light</td> <td> Package - 1</td> <td>Janith Wijethunga</td> <td><p style=''text-align:right''>Rs. 1000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 1000.00  </p></td></tr><tr><td>ACL 13A Plug Base</td> <td> Package - 1</td> <td>Janith Wijethunga</td> <td><p style=''text-align:right''>Rs. 600.00  </p></td><td><p style=''text-align:right''>2.00  </p></td><td><p style=''text-align:right''>Rs. 1200.00  </p></td></tr><tr><td>Kevilton Wiring/Insulation Tape (Black)</td> <td> Package - 1</td> <td>Janith Wijethunga</td> <td><p style=''text-align:right''>Rs. 100.00  </p></td><td><p style=''text-align:right''>3.00  </p></td><td><p style=''text-align:right''>Rs. 300.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Sub Total</b></td> <td><p style=''text-align:right''> Rs.2500.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Delivery Charges</b></td> <td><p style=''text-align:right''> Rs.300.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.2800.00</p></td> </tr></table></center><br/><br/><center><p><b>Thank you for shopping on CMMS.</b></p></center>', 1, CAST(N'2024-03-21T19:08:23.113' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (56, N'cmmsnoreply@gmail.com', N'janithwijethunga1995@gmail.com', N'You have Received a new Order C2024/000010', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000010</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-21</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Cherani Silva</td><tr><td>Estimated Delivery Date: <b>2024-03-24</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No 23, Wattala, Colombo 7</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0783232323</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>cheranisilva11@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>ItemWise Total</b></th></tr><tr><td>Orange ECO LED Pin Type 7W Day Light</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 1000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 1000.00  </p></td></tr><tr><td>ACL 13A Plug Base</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 600.00  </p></td><td><p style=''text-align:right''>2.00  </p></td><td><p style=''text-align:right''>Rs. 1200.00  </p></td></tr><tr><td>Kevilton Wiring/Insulation Tape (Black)</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 100.00  </p></td><td><p style=''text-align:right''>3.00  </p></td><td><p style=''text-align:right''>Rs. 300.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.2500.00</p></td> </tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-21T19:08:26.917' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (57, N'cmmsnoreply@gmail.com', N'cheranisilva11@gmail.com', N'C2024/000011 - Order Confirmed', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000011</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-21</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Cherani Silva</td><tr><td>Estimated Delivery Date: <b>2024-03-24</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No 23, Wattala, Colombo 7</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0783232323</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>cheranisilva11@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Vendor Name</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>Total</b></th></tr><tr><td>Multilac White 4L</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 35000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 35000.00  </p></td></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 2000.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Sub Total</b></td> <td><p style=''text-align:right''> Rs.37000.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Delivery Charges</b></td> <td><p style=''text-align:right''> Rs.300.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.37300.00</p></td> </tr></table></center><br/><br/><center><p><b>Thank you for shopping on CMMS.</b></p></center>', 1, CAST(N'2024-03-21T19:21:39.877' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (58, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'You have Received a new Order C2024/000011', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000011</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-21</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Cherani Silva</td><tr><td>Estimated Delivery Date: <b>2024-03-24</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No 23, Wattala, Colombo 7</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0783232323</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>cheranisilva11@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>ItemWise Total</b></th></tr><tr><td>Multilac White 4L</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 35000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 35000.00  </p></td></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 2000.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.37000.00</p></td> </tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-21T19:21:43.437' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (59, N'cmmsnoreply@gmail.com', N'shalitha.dh@gmail.com', N'C2024/000012 - Order Confirmed', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000012</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-21</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Dushan Perera</td><tr><td>Estimated Delivery Date: <b>2024-03-24</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No- 37, Asiri Mawatha, Kesbewa</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0754566788</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>shalitha.dh@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Vendor Name</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>Total</b></th></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 2000.00  </p></td></tr><tr><td>Rocell  1/2 " GARDEN TAP</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 2200.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 2200.00  </p></td></tr><tr><td>Orange ECO LED Pin Type 7W Day Light</td> <td> Package - 2</td> <td>Janith Wijethunga</td> <td><p style=''text-align:right''>Rs. 1000.00  </p></td><td><p style=''text-align:right''>2.00  </p></td><td><p style=''text-align:right''>Rs. 2000.00  </p></td></tr><tr><td>Kevilton Wiring/Insulation Tape (Black)</td> <td> Package - 2</td> <td>Janith Wijethunga</td> <td><p style=''text-align:right''>Rs. 100.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 100.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Sub Total</b></td> <td><p style=''text-align:right''> Rs.6300.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Delivery Charges</b></td> <td><p style=''text-align:right''> Rs.300.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.6600.00</p></td> </tr></table></center><br/><br/><center><p><b>Thank you for shopping on CMMS.</b></p></center>', 1, CAST(N'2024-03-21T22:20:32.140' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (60, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'You have Received a new Order C2024/000012', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000012</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-21</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Dushan Perera</td><tr><td>Estimated Delivery Date: <b>2024-03-24</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No- 37, Asiri Mawatha, Kesbewa</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0754566788</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>shalitha.dh@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>ItemWise Total</b></th></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 2000.00  </p></td></tr><tr><td>Rocell  1/2 " GARDEN TAP</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 2200.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 2200.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.4200.00</p></td> </tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-21T22:20:35.847' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (61, N'cmmsnoreply@gmail.com', N'janithwijethunga1995@gmail.com', N'You have Received a new Order C2024/000012', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000012</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-21</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Dushan Perera</td><tr><td>Estimated Delivery Date: <b>2024-03-24</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No- 37, Asiri Mawatha, Kesbewa</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0754566788</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>shalitha.dh@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>ItemWise Total</b></th></tr><tr><td>Orange ECO LED Pin Type 7W Day Light</td> <td> Package - 2</td> <td><p style=''text-align:right''>Rs. 1000.00  </p></td><td><p style=''text-align:right''>2.00  </p></td><td><p style=''text-align:right''>Rs. 2000.00  </p></td></tr><tr><td>Kevilton Wiring/Insulation Tape (Black)</td> <td> Package - 2</td> <td><p style=''text-align:right''>Rs. 100.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 100.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.2100.00</p></td> </tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-21T22:20:39.383' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (62, N'cmmsnoreply@gmail.com', N'shalitha.dh@gmail.com', N'Admin has reset your CMMS account password', N'<p>Hi! Dushan, </p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Please find the temporary password to access your account. </td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Temporary Password: <b>lmmnyhhe</b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-22T08:05:24.090' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (63, N'cmmsnoreply@gmail.com', N'shalitha.dh@hotmail.com', N'Admin has reset your CMMS account password', N'<p>Hi! Jagath, </p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Please find the temporary password to access your account. </td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Temporary Password: <b>wedwihaz</b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-22T08:08:06.823' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (64, N'cmmsnoreply@gmail.com', N'shalitha.dh@gmail.com', N'Task - Plastering Damaged Walls is Completed', N'<p>Below Task is <b>completed</b> by the contractor. Please approve the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>Plastering Damaged Walls</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Gonapola Building Renovation</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-22T10:01:58.660' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (65, N'cmmsnoreply@gmail.com', N'shalitha.dh@gmail.com', N'Task - Repair Children Seesaw is Completed', N'<p>Below Task is <b>completed</b> by the contractor. Please approve the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>Repair Children Seesaw</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Repair Play Ground in Wattala</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-22T10:15:15.597' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (66, N'cmmsnoreply@gmail.com', N'shalitha.dh@gmail.com', N'Task - Putty Works is Completed', N'<p>Below Task is <b>completed</b> by the contractor. Please approve the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>Putty Works</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>Jaffa Tower Building Painting </b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-22T10:20:04.337' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (67, N'cmmsnoreply@gmail.com', N'shalitha.dh@gmail.com', N'Task - New Wiring is Completed', N'<p>Below Task is <b>completed</b> by the contractor. Please approve the task by visiting CMMS.</p><br/><center><table border=0 cellpadding=0 cellspacing=0 width = ''100%''><tr><td>Task Name: <b>New Wiring</b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr><tr><td>Project Title: <b>New Apartment Electric Works </b></th> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td></tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-22T10:37:21.677' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (68, N'cmmsnoreply@gmail.com', N'shalitha.dh@gmail.com', N'C2024/000013 - Order Confirmed', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000013</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-22</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Dushan Perera</td><tr><td>Estimated Delivery Date: <b>2024-03-25</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No- 37, Asiri Mawatha, Kesbewa</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0754566788</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>shalitha.dh@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Vendor Name</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>Total</b></th></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 2000.00  </p></td></tr><tr><td>Multilac White 12L</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 68000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 68000.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Sub Total</b></td> <td><p style=''text-align:right''> Rs.70000.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Delivery Charges</b></td> <td><p style=''text-align:right''> Rs.300.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.70300.00</p></td> </tr></table></center><br/><br/><center><p><b>Thank you for shopping on CMMS.</b></p></center>', 1, CAST(N'2024-03-22T15:40:44.970' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (69, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'You have Received a new Order C2024/000013', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000013</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-22</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Dushan Perera</td><tr><td>Estimated Delivery Date: <b>2024-03-25</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No- 37, Asiri Mawatha, Kesbewa</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0754566788</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>shalitha.dh@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>ItemWise Total</b></th></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 2000.00  </p></td></tr><tr><td>Multilac White 12L</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 68000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 68000.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.70000.00</p></td> </tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-22T15:40:48.710' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (70, N'cmmsnoreply@gmail.com', N'shalitha.dh@gmail.com', N'C2024/000014 - Order Confirmed', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000014</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-22</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Dushan Perera</td><tr><td>Estimated Delivery Date: <b>2024-03-25</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No- 37, Asiri Mawatha, Kesbewa</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0754566788</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>shalitha.dh@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Vendor Name</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>Total</b></th></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 2000.00  </p></td></tr><tr><td>Chains 10mmX40mm</td> <td> Package - 1</td> <td>Kavindu Ambepala</td> <td><p style=''text-align:right''>Rs. 1800.00  </p></td><td><p style=''text-align:right''>2.00  </p></td><td><p style=''text-align:right''>Rs. 3600.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Sub Total</b></td> <td><p style=''text-align:right''> Rs.5600.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Delivery Charges</b></td> <td><p style=''text-align:right''> Rs.300.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.5900.00</p></td> </tr></table></center><br/><br/><center><p><b>Thank you for shopping on CMMS.</b></p></center>', 1, CAST(N'2024-03-22T19:59:41.943' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (71, N'cmmsnoreply@gmail.com', N'shalithajoe@gmail.com', N'You have Received a new Order C2024/000014', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000014</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-22</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Dushan Perera</td><tr><td>Estimated Delivery Date: <b>2024-03-25</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No- 37, Asiri Mawatha, Kesbewa</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0754566788</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>shalitha.dh@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>ItemWise Total</b></th></tr><tr><td>Tokyo Super Cement</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 2000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 2000.00  </p></td></tr><tr><td>Chains 10mmX40mm</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 1800.00  </p></td><td><p style=''text-align:right''>2.00  </p></td><td><p style=''text-align:right''>Rs. 3600.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.5600.00</p></td> </tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 1, CAST(N'2024-03-22T19:59:48.330' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (72, N'cmmsnoreply@gmail.com', N'cheranisilva11@gmail.com', N'C2024/000015 - Order Confirmed', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000015</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-22</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Cherani Silva</td><tr><td>Estimated Delivery Date: <b>2024-03-25</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No 23, Wattala, Colombo 7</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0783232323</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>cheranisilva11@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Vendor Name</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>Total</b></th></tr><tr><td>Orange ECO LED Pin Type 7W Day Light</td> <td> Package - 1</td> <td>Janith Wijethunga</td> <td><p style=''text-align:right''>Rs. 1000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 1000.00  </p></td></tr><tr><td>ACL 13A Plug Base</td> <td> Package - 1</td> <td>Janith Wijethunga</td> <td><p style=''text-align:right''>Rs. 600.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 600.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Sub Total</b></td> <td><p style=''text-align:right''> Rs.1600.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Delivery Charges</b></td> <td><p style=''text-align:right''> Rs.300.00</p></td> </tr><tr><td></td> <td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.1900.00</p></td> </tr></table></center><br/><br/><center><p><b>Thank you for shopping on CMMS.</b></p></center>', 0, CAST(N'2024-03-22T20:07:15.647' AS DateTime))
GO
INSERT [dbo].[EmailLog] ([EmailLogID], [FromEmail], [ToEmail], [MailSubject], [MailBody], [IsSent], [CreateDateTime]) VALUES (73, N'cmmsnoreply@gmail.com', N'janithwijethunga1995@gmail.com', N'You have Received a new Order C2024/000015', N'<center><table border=0 cellpadding=0 cellspacing=0 width = ''90%''><tr><td>Order No: <b>C2024/000015</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td><b>Customer: </b></td></tr><tr><td>Placed Date: <b>2024-03-22</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Cherani Silva</td><tr><td>Estimated Delivery Date: <b>2024-03-25</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>No 23, Wattala, Colombo 7</td></tr></tr><tr><td>Payment Method: <b>Cash On Delivery</b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>Colombo, Western</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>0783232323</td></tr><tr><td><b></b></td> <td><b></b></td><td><b></b></td><td><b></b></td><td><b></b></td><td>cheranisilva11@gmail.com</td></tr></table></center><br/><br/><center><table border=1 cellpadding=0 cellspacing=0 width = ''90%''><tr><th><b>Item Name</b></th> <th><b>Package</b></th><th><b>Unit Price</b></th><th><b>Quantity</b></th><th><b>ItemWise Total</b></th></tr><tr><td>Orange ECO LED Pin Type 7W Day Light</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 1000.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 1000.00  </p></td></tr><tr><td>ACL 13A Plug Base</td> <td> Package - 1</td> <td><p style=''text-align:right''>Rs. 600.00  </p></td><td><p style=''text-align:right''>1.00  </p></td><td><p style=''text-align:right''>Rs. 600.00  </p></td></tr><tr><td></td> <td></td> <td></td> <td><b>Total</b></td> <td><p style=''text-align:right''> Rs.1600.00</p></td> </tr></table></center><br/><br/><center><p><b>This is an auto-generated mail from CMMS.</b></p></center>', 0, CAST(N'2024-03-22T20:07:15.687' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[EmailLog] OFF
GO
SET IDENTITY_INSERT [dbo].[Item] ON 
GO
INSERT [dbo].[Item] ([ItemID], [VendorCategoryTypeID], [ItemName], [ItemDescription], [ItemWeight], [WeightUnit], [UOM], [UnitAmount], [MinQty], [MaxQty], [VendorID], [IsSoldUnitWise], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (1, 2, N'Tokyo Super Cement', N'dsds', CAST(50.00 AS Decimal(18, 2)), 1, 1, CAST(2000.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), 4, 1, 1, 4, N'::1', CAST(N'2023-10-22T00:46:31.583' AS DateTime), 4, N'::1', CAST(N'2023-11-09T07:52:15.347' AS DateTime))
GO
INSERT [dbo].[Item] ([ItemID], [VendorCategoryTypeID], [ItemName], [ItemDescription], [ItemWeight], [WeightUnit], [UOM], [UnitAmount], [MinQty], [MaxQty], [VendorID], [IsSoldUnitWise], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (2, 1, N'Chains 10mmX40mm', N'Chain 10mm', CAST(450.00 AS Decimal(18, 2)), 2, 2, CAST(1800.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), 4, 1, 1, 4, N'::1', CAST(N'2023-10-25T13:51:29.263' AS DateTime), 4, N'::1', CAST(N'2024-03-20T12:13:46.927' AS DateTime))
GO
INSERT [dbo].[Item] ([ItemID], [VendorCategoryTypeID], [ItemName], [ItemDescription], [ItemWeight], [WeightUnit], [UOM], [UnitAmount], [MinQty], [MaxQty], [VendorID], [IsSoldUnitWise], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (3, 8, N'Multilac White 4L', N'Multilac White 4L New', CAST(4.00 AS Decimal(18, 2)), 3, 2, CAST(35000.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(60.00 AS Decimal(18, 2)), 4, 1, 1, 4, N'::1', CAST(N'2023-10-27T23:57:51.883' AS DateTime), 4, N'::1', CAST(N'2023-11-08T08:02:41.090' AS DateTime))
GO
INSERT [dbo].[Item] ([ItemID], [VendorCategoryTypeID], [ItemName], [ItemDescription], [ItemWeight], [WeightUnit], [UOM], [UnitAmount], [MinQty], [MaxQty], [VendorID], [IsSoldUnitWise], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (4, 8, N'Multilac White 12L', N'Multilac White 12L New', CAST(12.00 AS Decimal(18, 2)), 3, 2, CAST(68000.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), 4, 1, 1, 4, N'::1', CAST(N'2023-10-28T00:16:32.140' AS DateTime), 4, N'::1', CAST(N'2023-11-08T08:02:31.493' AS DateTime))
GO
INSERT [dbo].[Item] ([ItemID], [VendorCategoryTypeID], [ItemName], [ItemDescription], [ItemWeight], [WeightUnit], [UOM], [UnitAmount], [MinQty], [MaxQty], [VendorID], [IsSoldUnitWise], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (5, 11, N'Rocell  1/2 " GARDEN TAP', N'Chrome finish', CAST(150.00 AS Decimal(18, 2)), 2, 2, CAST(2200.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), 4, 1, 1, 4, N'::1', CAST(N'2024-03-20T23:26:11.083' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Item] ([ItemID], [VendorCategoryTypeID], [ItemName], [ItemDescription], [ItemWeight], [WeightUnit], [UOM], [UnitAmount], [MinQty], [MaxQty], [VendorID], [IsSoldUnitWise], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (6, 4, N'ACL 13A Plug Base', N'Lifetime Warranty', CAST(150.00 AS Decimal(18, 2)), 2, 2, CAST(600.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), 5, 1, 1, 5, N'::1', CAST(N'2024-03-20T23:29:33.530' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Item] ([ItemID], [VendorCategoryTypeID], [ItemName], [ItemDescription], [ItemWeight], [WeightUnit], [UOM], [UnitAmount], [MinQty], [MaxQty], [VendorID], [IsSoldUnitWise], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (7, 4, N'Kevilton Wiring/Insulation Tape (Black)', N'Kevilton Wiring/Insulation Tape ', CAST(50.00 AS Decimal(18, 2)), 2, 2, CAST(100.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), 5, 1, 1, 5, N'::1', CAST(N'2024-03-20T23:43:39.160' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Item] ([ItemID], [VendorCategoryTypeID], [ItemName], [ItemDescription], [ItemWeight], [WeightUnit], [UOM], [UnitAmount], [MinQty], [MaxQty], [VendorID], [IsSoldUnitWise], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (8, 4, N'Orange ECO LED Pin Type 7W Day Light', N'	
2 Year Warranty', CAST(100.00 AS Decimal(18, 2)), 2, 2, CAST(1000.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), 5, 1, 1, 5, N'::1', CAST(N'2024-03-20T23:45:02.257' AS DateTime), NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Item] OFF
GO
SET IDENTITY_INSERT [dbo].[ItemInventory] ON 
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (1, 1, CAST(6000.00 AS Decimal(18, 2)), 1, 0, NULL, 0, 4, N'::1', CAST(N'2023-10-22T00:46:31.590' AS DateTime), 4, N'::1', CAST(N'2023-10-25T12:25:01.607' AS DateTime))
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (2, 1, CAST(6000.00 AS Decimal(18, 2)), 1, 0, NULL, 0, 4, N'::1', CAST(N'2023-10-25T12:25:01.607' AS DateTime), 4, N'::1', CAST(N'2023-10-25T12:31:43.330' AS DateTime))
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (3, 1, CAST(6500.00 AS Decimal(18, 2)), 1, 0, NULL, 0, 4, N'::1', CAST(N'2023-10-25T12:31:43.330' AS DateTime), 4, N'::1', CAST(N'2023-10-27T00:57:32.273' AS DateTime))
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (4, 2, CAST(5400.00 AS Decimal(18, 2)), 1, 0, NULL, 0, 4, N'::1', CAST(N'2023-10-25T13:51:29.263' AS DateTime), 4, N'::1', CAST(N'2023-10-27T20:46:07.047' AS DateTime))
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (5, 1, CAST(6500.00 AS Decimal(18, 2)), 1, 0, NULL, 0, 4, N'::1', CAST(N'2023-10-27T00:57:32.273' AS DateTime), 4, N'::1', CAST(N'2023-10-27T00:59:06.577' AS DateTime))
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (6, 1, CAST(6500.00 AS Decimal(18, 2)), 1, 0, NULL, 0, 4, N'::1', CAST(N'2023-10-27T00:59:06.577' AS DateTime), 4, N'::1', CAST(N'2023-11-08T08:01:48.930' AS DateTime))
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (7, 2, CAST(5400.00 AS Decimal(18, 2)), 1, 0, NULL, 0, 4, N'::1', CAST(N'2023-10-27T20:46:07.047' AS DateTime), 4, N'::1', CAST(N'2023-10-27T20:46:19.180' AS DateTime))
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (8, 2, CAST(5400.00 AS Decimal(18, 2)), 1, 0, NULL, 0, 4, N'::1', CAST(N'2023-10-27T20:46:19.180' AS DateTime), 4, N'::1', CAST(N'2023-11-08T08:02:11.970' AS DateTime))
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (9, 3, CAST(4200.00 AS Decimal(18, 2)), 1, 0, NULL, 0, 4, N'::1', CAST(N'2023-10-27T23:57:51.883' AS DateTime), 4, N'::1', CAST(N'2023-10-27T23:59:34.407' AS DateTime))
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (10, 3, CAST(4200.00 AS Decimal(18, 2)), 1, 0, NULL, 0, 4, N'::1', CAST(N'2023-10-27T23:59:34.407' AS DateTime), 4, N'::1', CAST(N'2023-10-28T00:15:15.280' AS DateTime))
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (11, 3, CAST(4200.00 AS Decimal(18, 2)), 1, 0, NULL, 0, 4, N'::1', CAST(N'2023-10-28T00:15:15.280' AS DateTime), 4, N'::1', CAST(N'2023-11-08T08:02:41.090' AS DateTime))
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (12, 4, CAST(380.00 AS Decimal(18, 2)), 1, 0, NULL, 0, 4, N'::1', CAST(N'2023-10-28T00:16:32.140' AS DateTime), 4, N'::1', CAST(N'2023-11-08T08:02:31.493' AS DateTime))
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (13, 1, CAST(6500.00 AS Decimal(18, 2)), 1, 0, NULL, 0, 4, N'::1', CAST(N'2023-11-08T08:01:48.933' AS DateTime), 4, N'::1', CAST(N'2023-11-09T07:52:15.347' AS DateTime))
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (14, 2, CAST(5400.00 AS Decimal(18, 2)), 1, 0, NULL, 0, 4, N'::1', CAST(N'2023-11-08T08:02:11.970' AS DateTime), 4, N'::1', CAST(N'2024-03-20T12:13:46.930' AS DateTime))
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (15, 4, CAST(380.00 AS Decimal(18, 2)), 1, 0, NULL, 1, 4, N'::1', CAST(N'2023-11-08T08:02:31.493' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (16, 3, CAST(4200.00 AS Decimal(18, 2)), 1, 0, NULL, 1, 4, N'::1', CAST(N'2023-11-08T08:02:41.090' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (17, 1, CAST(6500.00 AS Decimal(18, 2)), 1, 0, NULL, 1, 4, N'::1', CAST(N'2023-11-09T07:52:15.347' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (18, 1, CAST(-2.00 AS Decimal(18, 2)), 0, 1, 1, 0, 2, N'::1', CAST(N'2023-11-15T21:13:10.533' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (19, 2, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 1, 0, 2, N'::1', CAST(N'2023-11-15T21:13:10.533' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (20, 3, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 1, 0, 2, N'::1', CAST(N'2023-11-15T21:13:10.533' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (21, 2, CAST(-2.00 AS Decimal(18, 2)), 0, 1, 2, 0, 2, N'::1', CAST(N'2023-11-17T22:42:13.913' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (22, 4, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 2, 0, 2, N'::1', CAST(N'2023-11-17T22:42:13.913' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (23, 2, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 3, 0, 2, N'::1', CAST(N'2023-11-18T12:06:00.073' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (24, 1, CAST(-2.00 AS Decimal(18, 2)), 0, 1, 3, 0, 2, N'::1', CAST(N'2023-11-18T12:06:00.073' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (25, 2, CAST(-3.00 AS Decimal(18, 2)), 0, 1, 4, 0, 2, N'::1', CAST(N'2023-11-21T00:49:05.520' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (26, 2, CAST(2.00 AS Decimal(18, 2)), 0, 1, 2, 0, 4, N'::1', CAST(N'2023-11-21T01:09:03.930' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (27, 4, CAST(1.00 AS Decimal(18, 2)), 0, 1, 2, 0, 4, N'::1', CAST(N'2023-11-21T01:09:03.930' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (30, 1, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 5, 0, 2, N'::1', CAST(N'2024-03-17T00:27:56.793' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (31, 3, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 5, 0, 2, N'::1', CAST(N'2024-03-17T00:27:56.793' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (32, 3, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 6, 0, 2, N'::1', CAST(N'2024-03-17T00:31:42.397' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (33, 2, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 6, 0, 2, N'::1', CAST(N'2024-03-17T00:31:42.397' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (34, 1, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 6, 0, 2, N'::1', CAST(N'2024-03-17T00:31:42.397' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (35, 1, CAST(-3.00 AS Decimal(18, 2)), 0, 1, 7, 0, 2, N'::1', CAST(N'2024-03-17T00:37:08.003' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (36, 2, CAST(-2.00 AS Decimal(18, 2)), 0, 1, 7, 0, 2, N'::1', CAST(N'2024-03-17T00:37:08.003' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (37, 1, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 8, 0, 2, N'::1', CAST(N'2024-03-17T00:47:50.210' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (38, 4, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 8, 0, 2, N'::1', CAST(N'2024-03-17T00:47:50.210' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (39, 2, CAST(5400.00 AS Decimal(18, 2)), 1, 0, NULL, 1, 4, N'::1', CAST(N'2024-03-20T12:13:46.930' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (40, 5, CAST(250.00 AS Decimal(18, 2)), 1, 0, NULL, 1, 4, N'::1', CAST(N'2024-03-20T23:26:11.083' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (41, 6, CAST(600.00 AS Decimal(18, 2)), 1, 0, NULL, 1, 5, N'::1', CAST(N'2024-03-20T23:29:33.530' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (42, 7, CAST(1500.00 AS Decimal(18, 2)), 1, 0, NULL, 1, 5, N'::1', CAST(N'2024-03-20T23:43:39.160' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (43, 8, CAST(1000.00 AS Decimal(18, 2)), 1, 0, NULL, 1, 5, N'::1', CAST(N'2024-03-20T23:45:02.257' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (44, 1, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 9, 0, 2, N'::1', CAST(N'2024-03-20T23:46:54.517' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (45, 3, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 9, 0, 2, N'::1', CAST(N'2024-03-20T23:46:54.517' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (46, 5, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 9, 0, 2, N'::1', CAST(N'2024-03-20T23:46:54.517' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (47, 8, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 9, 0, 2, N'::1', CAST(N'2024-03-20T23:46:54.517' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (48, 7, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 9, 0, 2, N'::1', CAST(N'2024-03-20T23:46:54.517' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (49, 6, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 9, 0, 2, N'::1', CAST(N'2024-03-20T23:46:54.517' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (50, 8, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 10, 0, 7, N'::1', CAST(N'2024-03-21T19:08:18.810' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (51, 6, CAST(-2.00 AS Decimal(18, 2)), 0, 1, 10, 0, 7, N'::1', CAST(N'2024-03-21T19:08:18.810' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (52, 7, CAST(-3.00 AS Decimal(18, 2)), 0, 1, 10, 0, 7, N'::1', CAST(N'2024-03-21T19:08:18.810' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (53, 3, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 11, 0, 7, N'::1', CAST(N'2024-03-21T19:21:35.880' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (54, 1, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 11, 0, 7, N'::1', CAST(N'2024-03-21T19:21:35.880' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (55, 1, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 12, 0, 2, N'::1', CAST(N'2024-03-21T22:20:27.420' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (56, 5, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 12, 0, 2, N'::1', CAST(N'2024-03-21T22:20:27.420' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (57, 8, CAST(-2.00 AS Decimal(18, 2)), 0, 1, 12, 0, 2, N'::1', CAST(N'2024-03-21T22:20:27.420' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (58, 7, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 12, 0, 2, N'::1', CAST(N'2024-03-21T22:20:27.420' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (59, 1, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 13, 0, 2, N'::1', CAST(N'2024-03-22T15:40:40.627' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (60, 4, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 13, 0, 2, N'::1', CAST(N'2024-03-22T15:40:40.627' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (61, 1, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 14, 0, 2, N'::1', CAST(N'2024-03-22T19:59:35.233' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (62, 2, CAST(-2.00 AS Decimal(18, 2)), 0, 1, 14, 0, 2, N'::1', CAST(N'2024-03-22T19:59:35.233' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (63, 8, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 15, 0, 7, N'::1', CAST(N'2024-03-22T20:07:15.100' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ItemInventory] ([ItemInvID], [ItemID], [Qty], [IsInvAdded], [IsPurchased], [OrderID], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (64, 6, CAST(-1.00 AS Decimal(18, 2)), 0, 1, 15, 0, 7, N'::1', CAST(N'2024-03-22T20:07:15.100' AS DateTime), NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[ItemInventory] OFF
GO
SET IDENTITY_INSERT [dbo].[ItemInventoryImg] ON 
GO
INSERT [dbo].[ItemInventoryImg] ([ItemInvID], [ItemID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (6, 1, N'item_1_1_20231108T080148.png', N'/uploads/invmgnt/item_1_1_20231108T080148.png', 4, N'::1', CAST(N'2023-11-08T08:01:49.843' AS DateTime))
GO
INSERT [dbo].[ItemInventoryImg] ([ItemInvID], [ItemID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (7, 2, N'item_2_1_20231108T080211.jpg', N'/uploads/invmgnt/item_2_1_20231108T080211.jpg', 4, N'::1', CAST(N'2023-11-08T08:02:12.000' AS DateTime))
GO
INSERT [dbo].[ItemInventoryImg] ([ItemInvID], [ItemID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (8, 4, N'item_4_1_20231108T080231.png', N'/uploads/invmgnt/item_4_1_20231108T080231.png', 4, N'::1', CAST(N'2023-11-08T08:02:31.517' AS DateTime))
GO
INSERT [dbo].[ItemInventoryImg] ([ItemInvID], [ItemID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (9, 3, N'item_3_1_20231108T080241.png', N'/uploads/invmgnt/item_3_1_20231108T080241.png', 4, N'::1', CAST(N'2023-11-08T08:02:41.180' AS DateTime))
GO
INSERT [dbo].[ItemInventoryImg] ([ItemInvID], [ItemID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (10, 5, N'item_5_1_20240320T232611.jpg', N'/uploads/invmgnt/item_5_1_20240320T232611.jpg', 4, N'::1', CAST(N'2024-03-20T23:26:11.177' AS DateTime))
GO
INSERT [dbo].[ItemInventoryImg] ([ItemInvID], [ItemID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (11, 6, N'item_6_1_20240320T232933.png', N'/uploads/invmgnt/item_6_1_20240320T232933.png', 5, N'::1', CAST(N'2024-03-20T23:29:33.580' AS DateTime))
GO
INSERT [dbo].[ItemInventoryImg] ([ItemInvID], [ItemID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (12, 7, N'item_7_1_20240320T234339.jpg', N'/uploads/invmgnt/item_7_1_20240320T234339.jpg', 5, N'::1', CAST(N'2024-03-20T23:43:39.217' AS DateTime))
GO
INSERT [dbo].[ItemInventoryImg] ([ItemInvID], [ItemID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (13, 8, N'item_8_1_20240320T234502.jpg', N'/uploads/invmgnt/item_8_1_20240320T234502.jpg', 5, N'::1', CAST(N'2024-03-20T23:45:02.293' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[ItemInventoryImg] OFF
GO
INSERT [dbo].[ItemInventoryUOM] ([ItemUOMID], [UOMName], [UOMUnit], [IsActive]) VALUES (1, N'Packet', N'Pkt', 1)
GO
INSERT [dbo].[ItemInventoryUOM] ([ItemUOMID], [UOMName], [UOMUnit], [IsActive]) VALUES (2, N'Unit', N'U', 1)
GO
INSERT [dbo].[ItemInventoryUOM] ([ItemUOMID], [UOMName], [UOMUnit], [IsActive]) VALUES (3, N'Kilogram', N'kg', 1)
GO
INSERT [dbo].[ItemInventoryUOM] ([ItemUOMID], [UOMName], [UOMUnit], [IsActive]) VALUES (4, N'Grams', N'g', 1)
GO
INSERT [dbo].[ItemInventoryUOM] ([ItemUOMID], [UOMName], [UOMUnit], [IsActive]) VALUES (5, N'Pound', N'lbs', 1)
GO
SET IDENTITY_INSERT [dbo].[ItemInvWeightUnit] ON 
GO
INSERT [dbo].[ItemInvWeightUnit] ([ItemWeightUnitID], [WeightUnitName], [WeightUnit], [IsActive]) VALUES (1, N'Kilograms', N'kg', 1)
GO
INSERT [dbo].[ItemInvWeightUnit] ([ItemWeightUnitID], [WeightUnitName], [WeightUnit], [IsActive]) VALUES (2, N'Grams', N'g', 1)
GO
INSERT [dbo].[ItemInvWeightUnit] ([ItemWeightUnitID], [WeightUnitName], [WeightUnit], [IsActive]) VALUES (3, N'Liter', N'l', 1)
GO
INSERT [dbo].[ItemInvWeightUnit] ([ItemWeightUnitID], [WeightUnitName], [WeightUnit], [IsActive]) VALUES (5, N'Milliliter', N'ml', 1)
GO
SET IDENTITY_INSERT [dbo].[ItemInvWeightUnit] OFF
GO
INSERT [dbo].[Month] ([MonthID], [MonthName], [IsActive]) VALUES (1, N'January', 1)
GO
INSERT [dbo].[Month] ([MonthID], [MonthName], [IsActive]) VALUES (2, N'February', 1)
GO
INSERT [dbo].[Month] ([MonthID], [MonthName], [IsActive]) VALUES (3, N'March', 1)
GO
INSERT [dbo].[Month] ([MonthID], [MonthName], [IsActive]) VALUES (4, N'April', 1)
GO
INSERT [dbo].[Month] ([MonthID], [MonthName], [IsActive]) VALUES (5, N'May', 1)
GO
INSERT [dbo].[Month] ([MonthID], [MonthName], [IsActive]) VALUES (6, N'June', 1)
GO
INSERT [dbo].[Month] ([MonthID], [MonthName], [IsActive]) VALUES (7, N'July', 1)
GO
INSERT [dbo].[Month] ([MonthID], [MonthName], [IsActive]) VALUES (8, N'August', 1)
GO
INSERT [dbo].[Month] ([MonthID], [MonthName], [IsActive]) VALUES (9, N'September', 1)
GO
INSERT [dbo].[Month] ([MonthID], [MonthName], [IsActive]) VALUES (10, N'October', 1)
GO
INSERT [dbo].[Month] ([MonthID], [MonthName], [IsActive]) VALUES (11, N'November', 1)
GO
INSERT [dbo].[Month] ([MonthID], [MonthName], [IsActive]) VALUES (12, N'December', 1)
GO
SET IDENTITY_INSERT [dbo].[Order] ON 
GO
INSERT [dbo].[Order] ([OrderID], [OrderNo], [PlacedDate], [EstDeliveryDate], [PaymentMethod], [Address1], [Address2], [Address3], [District], [Province], [Remarks], [Discount], [SubTotal], [DeliveryCharge], [Total], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (1, N'C2023/000001', CAST(N'2023-11-15T21:13:10.510' AS DateTime), CAST(N'2023-11-18' AS Date), 1, N'No- 34', N'Asiri Mawatha', N'Kesbewa', N'Colombo', N'Western', N'sdsdsd', CAST(0.00 AS Decimal(18, 2)), CAST(40800.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(41100.00 AS Decimal(18, 2)), 2, N'::1', CAST(N'2023-11-15T21:13:10.510' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Order] ([OrderID], [OrderNo], [PlacedDate], [EstDeliveryDate], [PaymentMethod], [Address1], [Address2], [Address3], [District], [Province], [Remarks], [Discount], [SubTotal], [DeliveryCharge], [Total], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (2, N'C2023/000002', CAST(N'2023-11-17T22:42:13.893' AS DateTime), CAST(N'2023-11-20' AS Date), 1, N'No- 34', N'Asiri Mawatha', N'Kesbewa', N'Colombo', N'Western', N'Order 2 Test', CAST(0.00 AS Decimal(18, 2)), CAST(71600.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(71900.00 AS Decimal(18, 2)), 2, N'::1', CAST(N'2023-11-17T22:42:13.893' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Order] ([OrderID], [OrderNo], [PlacedDate], [EstDeliveryDate], [PaymentMethod], [Address1], [Address2], [Address3], [District], [Province], [Remarks], [Discount], [SubTotal], [DeliveryCharge], [Total], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (3, N'C2023/000003', CAST(N'2023-11-18T12:06:00.063' AS DateTime), CAST(N'2023-11-21' AS Date), 1, N'No- 34', N'Asiri Mawatha', N'Kesbewa', N'Colombo', N'Western', N'Test 3', CAST(0.00 AS Decimal(18, 2)), CAST(5800.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(6100.00 AS Decimal(18, 2)), 2, N'::1', CAST(N'2023-11-18T12:06:00.063' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Order] ([OrderID], [OrderNo], [PlacedDate], [EstDeliveryDate], [PaymentMethod], [Address1], [Address2], [Address3], [District], [Province], [Remarks], [Discount], [SubTotal], [DeliveryCharge], [Total], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (4, N'C2023/000004', CAST(N'2023-11-21T00:49:05.503' AS DateTime), CAST(N'2023-11-24' AS Date), 1, N'No- 34', N'Asiri Mawatha', N'Kesbewa', N'Colombo', N'Western', N'Order 4 test', CAST(0.00 AS Decimal(18, 2)), CAST(5400.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(5700.00 AS Decimal(18, 2)), 2, N'::1', CAST(N'2023-11-21T00:49:05.503' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Order] ([OrderID], [OrderNo], [PlacedDate], [EstDeliveryDate], [PaymentMethod], [Address1], [Address2], [Address3], [District], [Province], [Remarks], [Discount], [SubTotal], [DeliveryCharge], [Total], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (5, N'C2024/000005', CAST(N'2024-03-17T00:27:56.767' AS DateTime), CAST(N'2024-03-20' AS Date), 1, N'No- 37', N'Asiri Mawatha', N'Kesbewa', N'Colombo', N'Western', N'Test Email 1', CAST(0.00 AS Decimal(18, 2)), CAST(37000.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(37300.00 AS Decimal(18, 2)), 2, N'::1', CAST(N'2024-03-17T00:27:56.767' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Order] ([OrderID], [OrderNo], [PlacedDate], [EstDeliveryDate], [PaymentMethod], [Address1], [Address2], [Address3], [District], [Province], [Remarks], [Discount], [SubTotal], [DeliveryCharge], [Total], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (6, N'C2024/000006', CAST(N'2024-03-17T00:31:42.387' AS DateTime), CAST(N'2024-03-20' AS Date), 1, N'No- 37', N'Asiri Mawatha', N'Kesbewa', N'Colombo', N'Western', N'Email Test 2', CAST(0.00 AS Decimal(18, 2)), CAST(38800.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(39100.00 AS Decimal(18, 2)), 2, N'::1', CAST(N'2024-03-17T00:31:42.387' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Order] ([OrderID], [OrderNo], [PlacedDate], [EstDeliveryDate], [PaymentMethod], [Address1], [Address2], [Address3], [District], [Province], [Remarks], [Discount], [SubTotal], [DeliveryCharge], [Total], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (7, N'C2024/000007', CAST(N'2024-03-17T00:37:07.990' AS DateTime), CAST(N'2024-03-20' AS Date), 1, N'No- 37', N'Asiri Mawatha', N'Kesbewa', N'Colombo', N'Western', N'Test Email 3', CAST(0.00 AS Decimal(18, 2)), CAST(9600.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(9900.00 AS Decimal(18, 2)), 2, N'::1', CAST(N'2024-03-17T00:37:07.990' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Order] ([OrderID], [OrderNo], [PlacedDate], [EstDeliveryDate], [PaymentMethod], [Address1], [Address2], [Address3], [District], [Province], [Remarks], [Discount], [SubTotal], [DeliveryCharge], [Total], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (8, N'C2024/000008', CAST(N'2024-03-17T00:47:50.197' AS DateTime), CAST(N'2024-03-20' AS Date), 1, N'No- 37', N'Asiri Mawatha', N'Kesbewa', N'Colombo', N'Western', N'Email Test 4', CAST(0.00 AS Decimal(18, 2)), CAST(70000.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(70300.00 AS Decimal(18, 2)), 2, N'::1', CAST(N'2024-03-17T00:47:50.197' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Order] ([OrderID], [OrderNo], [PlacedDate], [EstDeliveryDate], [PaymentMethod], [Address1], [Address2], [Address3], [District], [Province], [Remarks], [Discount], [SubTotal], [DeliveryCharge], [Total], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (9, N'C2024/000009', CAST(N'2024-03-20T23:46:54.500' AS DateTime), CAST(N'2024-03-23' AS Date), 1, N'No- 37', N'Asiri Mawatha', N'Kesbewa', N'Colombo', N'Western', N'Test 2 Vendors', CAST(0.00 AS Decimal(18, 2)), CAST(40900.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(41200.00 AS Decimal(18, 2)), 2, N'::1', CAST(N'2024-03-20T23:46:54.500' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Order] ([OrderID], [OrderNo], [PlacedDate], [EstDeliveryDate], [PaymentMethod], [Address1], [Address2], [Address3], [District], [Province], [Remarks], [Discount], [SubTotal], [DeliveryCharge], [Total], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (10, N'C2024/000010', CAST(N'2024-03-21T19:08:18.790' AS DateTime), CAST(N'2024-03-24' AS Date), 1, N'No 23', N'Wattala', N'Colombo 7', N'Colombo', N'Western', N'Mew frerfsfdfd', CAST(0.00 AS Decimal(18, 2)), CAST(2500.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(2800.00 AS Decimal(18, 2)), 7, N'::1', CAST(N'2024-03-21T19:08:18.790' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Order] ([OrderID], [OrderNo], [PlacedDate], [EstDeliveryDate], [PaymentMethod], [Address1], [Address2], [Address3], [District], [Province], [Remarks], [Discount], [SubTotal], [DeliveryCharge], [Total], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (11, N'C2024/000011', CAST(N'2024-03-21T19:21:35.870' AS DateTime), CAST(N'2024-03-24' AS Date), 1, N'No 23', N'Wattala', N'Colombo 7', N'Colombo', N'Western', N'New ewewewe', CAST(0.00 AS Decimal(18, 2)), CAST(37000.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(37300.00 AS Decimal(18, 2)), 7, N'::1', CAST(N'2024-03-21T19:21:35.870' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Order] ([OrderID], [OrderNo], [PlacedDate], [EstDeliveryDate], [PaymentMethod], [Address1], [Address2], [Address3], [District], [Province], [Remarks], [Discount], [SubTotal], [DeliveryCharge], [Total], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (12, N'C2024/000012', CAST(N'2024-03-21T22:20:27.410' AS DateTime), CAST(N'2024-03-24' AS Date), 1, N'No- 37', N'Asiri Mawatha', N'Kesbewa', N'Colombo', N'Western', N'', CAST(0.00 AS Decimal(18, 2)), CAST(6300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(6600.00 AS Decimal(18, 2)), 2, N'::1', CAST(N'2024-03-21T22:20:27.410' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Order] ([OrderID], [OrderNo], [PlacedDate], [EstDeliveryDate], [PaymentMethod], [Address1], [Address2], [Address3], [District], [Province], [Remarks], [Discount], [SubTotal], [DeliveryCharge], [Total], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (13, N'C2024/000013', CAST(N'2024-03-22T15:40:40.613' AS DateTime), CAST(N'2024-03-25' AS Date), 1, N'No- 37', N'Asiri Mawatha', N'Kesbewa', N'Colombo', N'Western', N'', CAST(0.00 AS Decimal(18, 2)), CAST(70000.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(70300.00 AS Decimal(18, 2)), 2, N'::1', CAST(N'2024-03-22T15:40:40.613' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Order] ([OrderID], [OrderNo], [PlacedDate], [EstDeliveryDate], [PaymentMethod], [Address1], [Address2], [Address3], [District], [Province], [Remarks], [Discount], [SubTotal], [DeliveryCharge], [Total], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (14, N'C2024/000014', CAST(N'2024-03-22T19:59:35.220' AS DateTime), CAST(N'2024-03-25' AS Date), 1, N'No- 37', N'Asiri Mawatha', N'Kesbewa', N'Colombo', N'Western', N'', CAST(0.00 AS Decimal(18, 2)), CAST(5600.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(5900.00 AS Decimal(18, 2)), 2, N'::1', CAST(N'2024-03-22T19:59:35.220' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Order] ([OrderID], [OrderNo], [PlacedDate], [EstDeliveryDate], [PaymentMethod], [Address1], [Address2], [Address3], [District], [Province], [Remarks], [Discount], [SubTotal], [DeliveryCharge], [Total], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (15, N'C2024/000015', CAST(N'2024-03-22T20:07:15.087' AS DateTime), CAST(N'2024-03-25' AS Date), 1, N'No 23', N'Wattala', N'Colombo 7', N'Colombo', N'Western', N'', CAST(0.00 AS Decimal(18, 2)), CAST(1600.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), CAST(1900.00 AS Decimal(18, 2)), 7, N'::1', CAST(N'2024-03-22T20:07:15.087' AS DateTime), NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Order] OFF
GO
SET IDENTITY_INSERT [dbo].[OrderDetail] ON 
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (1, 1, 1, 1, CAST(2000.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(4000.00 AS Decimal(18, 2)), 4, 3, 2, N'::1', CAST(N'2023-11-15T21:13:10.530' AS DateTime), 4, N'::1', CAST(N'2024-03-21T19:10:01.740' AS DateTime))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (2, 1, 1, 2, CAST(1800.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(1800.00 AS Decimal(18, 2)), 4, 3, 2, N'::1', CAST(N'2023-11-15T21:13:10.530' AS DateTime), 4, N'::1', CAST(N'2024-03-21T19:10:01.740' AS DateTime))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (3, 1, 1, 3, CAST(35000.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(35000.00 AS Decimal(18, 2)), 4, 3, 2, N'::1', CAST(N'2023-11-15T21:13:10.530' AS DateTime), 4, N'::1', CAST(N'2024-03-21T19:10:01.740' AS DateTime))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (4, 2, 1, 2, CAST(1800.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(3600.00 AS Decimal(18, 2)), 4, 4, 2, N'::1', CAST(N'2023-11-17T22:42:13.907' AS DateTime), 4, N'::1', CAST(N'2023-11-21T21:40:13.093' AS DateTime))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (5, 2, 1, 4, CAST(68000.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(68000.00 AS Decimal(18, 2)), 4, 4, 2, N'::1', CAST(N'2023-11-17T22:42:13.907' AS DateTime), 4, N'::1', CAST(N'2023-11-21T21:40:13.093' AS DateTime))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (6, 3, 1, 2, CAST(1800.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(1800.00 AS Decimal(18, 2)), 4, 3, 2, N'::1', CAST(N'2023-11-18T12:06:00.070' AS DateTime), 4, N'::1', CAST(N'2023-11-21T22:30:13.140' AS DateTime))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (7, 3, 1, 1, CAST(2000.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(4000.00 AS Decimal(18, 2)), 4, 3, 2, N'::1', CAST(N'2023-11-18T12:06:00.070' AS DateTime), 4, N'::1', CAST(N'2023-11-21T22:30:13.140' AS DateTime))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (8, 4, 1, 2, CAST(1800.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(5400.00 AS Decimal(18, 2)), 4, 3, 2, N'::1', CAST(N'2023-11-21T00:49:05.520' AS DateTime), 4, N'::1', CAST(N'2024-03-21T19:10:08.390' AS DateTime))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (9, 5, 1, 1, CAST(2000.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), 4, 3, 2, N'::1', CAST(N'2024-03-17T00:27:56.787' AS DateTime), 4, N'::1', CAST(N'2024-03-21T19:10:15.420' AS DateTime))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (10, 5, 1, 3, CAST(35000.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(35000.00 AS Decimal(18, 2)), 4, 3, 2, N'::1', CAST(N'2024-03-17T00:27:56.787' AS DateTime), 4, N'::1', CAST(N'2024-03-21T19:10:15.420' AS DateTime))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (11, 6, 1, 3, CAST(35000.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(35000.00 AS Decimal(18, 2)), 4, 3, 2, N'::1', CAST(N'2024-03-17T00:31:42.393' AS DateTime), 4, N'::1', CAST(N'2024-03-22T08:15:15.480' AS DateTime))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (12, 6, 1, 2, CAST(1800.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(1800.00 AS Decimal(18, 2)), 4, 3, 2, N'::1', CAST(N'2024-03-17T00:31:42.393' AS DateTime), 4, N'::1', CAST(N'2024-03-22T08:15:15.480' AS DateTime))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (13, 6, 1, 1, CAST(2000.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), 4, 3, 2, N'::1', CAST(N'2024-03-17T00:31:42.393' AS DateTime), 4, N'::1', CAST(N'2024-03-22T08:15:15.480' AS DateTime))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (14, 7, 1, 1, CAST(2000.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(6000.00 AS Decimal(18, 2)), 4, 3, 2, N'::1', CAST(N'2024-03-17T00:37:08.000' AS DateTime), 4, N'::1', CAST(N'2024-03-22T08:15:09.847' AS DateTime))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (15, 7, 1, 2, CAST(1800.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(3600.00 AS Decimal(18, 2)), 4, 3, 2, N'::1', CAST(N'2024-03-17T00:37:08.000' AS DateTime), 4, N'::1', CAST(N'2024-03-22T08:15:09.847' AS DateTime))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (16, 8, 1, 1, CAST(2000.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), 4, 3, 2, N'::1', CAST(N'2024-03-17T00:47:50.207' AS DateTime), 4, N'::1', CAST(N'2024-03-22T19:41:47.507' AS DateTime))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (17, 8, 1, 4, CAST(68000.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(68000.00 AS Decimal(18, 2)), 4, 3, 2, N'::1', CAST(N'2024-03-17T00:47:50.207' AS DateTime), 4, N'::1', CAST(N'2024-03-22T19:41:47.507' AS DateTime))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (18, 9, 1, 1, CAST(2000.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), 4, 1, 2, N'::1', CAST(N'2024-03-20T23:46:54.510' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (19, 9, 1, 3, CAST(35000.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(35000.00 AS Decimal(18, 2)), 4, 1, 2, N'::1', CAST(N'2024-03-20T23:46:54.510' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (20, 9, 1, 5, CAST(2200.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(2200.00 AS Decimal(18, 2)), 4, 1, 2, N'::1', CAST(N'2024-03-20T23:46:54.510' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (21, 9, 2, 8, CAST(1000.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), 5, 2, 2, N'::1', CAST(N'2024-03-20T23:46:54.517' AS DateTime), 5, N'::1', CAST(N'2024-03-20T23:52:08.017' AS DateTime))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (22, 9, 2, 7, CAST(100.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), 5, 2, 2, N'::1', CAST(N'2024-03-20T23:46:54.517' AS DateTime), 5, N'::1', CAST(N'2024-03-20T23:52:08.017' AS DateTime))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (23, 9, 2, 6, CAST(600.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(600.00 AS Decimal(18, 2)), 5, 2, 2, N'::1', CAST(N'2024-03-20T23:46:54.517' AS DateTime), 5, N'::1', CAST(N'2024-03-20T23:52:08.017' AS DateTime))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (24, 10, 1, 8, CAST(1000.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), 5, 2, 7, N'::1', CAST(N'2024-03-21T19:08:18.807' AS DateTime), 5, N'::1', CAST(N'2024-03-21T19:11:54.910' AS DateTime))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (25, 10, 1, 6, CAST(600.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(1200.00 AS Decimal(18, 2)), 5, 2, 7, N'::1', CAST(N'2024-03-21T19:08:18.807' AS DateTime), 5, N'::1', CAST(N'2024-03-21T19:11:54.910' AS DateTime))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (26, 10, 1, 7, CAST(100.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), 5, 2, 7, N'::1', CAST(N'2024-03-21T19:08:18.807' AS DateTime), 5, N'::1', CAST(N'2024-03-21T19:11:54.910' AS DateTime))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (27, 11, 1, 3, CAST(35000.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(35000.00 AS Decimal(18, 2)), 4, 1, 7, N'::1', CAST(N'2024-03-21T19:21:35.880' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (28, 11, 1, 1, CAST(2000.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), 4, 1, 7, N'::1', CAST(N'2024-03-21T19:21:35.880' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (29, 12, 1, 1, CAST(2000.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), 4, 1, 2, N'::1', CAST(N'2024-03-21T22:20:27.417' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (30, 12, 1, 5, CAST(2200.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(2200.00 AS Decimal(18, 2)), 4, 1, 2, N'::1', CAST(N'2024-03-21T22:20:27.417' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (31, 12, 2, 8, CAST(1000.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), 5, 1, 2, N'::1', CAST(N'2024-03-21T22:20:27.420' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (32, 12, 2, 7, CAST(100.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), 5, 1, 2, N'::1', CAST(N'2024-03-21T22:20:27.420' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (33, 13, 1, 1, CAST(2000.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), 4, 1, 2, N'::1', CAST(N'2024-03-22T15:40:40.620' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (34, 13, 1, 4, CAST(68000.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(68000.00 AS Decimal(18, 2)), 4, 1, 2, N'::1', CAST(N'2024-03-22T15:40:40.620' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (35, 14, 1, 1, CAST(2000.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), 4, 1, 2, N'::1', CAST(N'2024-03-22T19:59:35.230' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (36, 14, 1, 2, CAST(1800.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(3600.00 AS Decimal(18, 2)), 4, 1, 2, N'::1', CAST(N'2024-03-22T19:59:35.230' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (37, 15, 1, 8, CAST(1000.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), 5, 1, 7, N'::1', CAST(N'2024-03-22T20:07:15.093' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [PackageID], [ItemID], [UnitAmount], [Quantity], [DiscountAmount], [ItemWiseTotal], [VendorID], [OrderDetailStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (38, 15, 1, 6, CAST(600.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(600.00 AS Decimal(18, 2)), 5, 1, 7, N'::1', CAST(N'2024-03-22T20:07:15.093' AS DateTime), NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[OrderDetail] OFF
GO
INSERT [dbo].[OrderPaymentMethod] ([OrderPayMethodID], [PayMethodName], [IsActive]) VALUES (1, N'Cash On Delivery', 1)
GO
INSERT [dbo].[OrderPaymentMethod] ([OrderPayMethodID], [PayMethodName], [IsActive]) VALUES (2, N'Online Payment', 1)
GO
SET IDENTITY_INSERT [dbo].[OrderStatusHistory] ON 
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (1, 1, 1, 1, 0, 2, N'::1', CAST(N'2023-11-15T21:13:10.530' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (2, 2, 1, 1, 0, 2, N'::1', CAST(N'2023-11-17T22:42:13.910' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (3, 3, 1, 1, 0, 2, N'::1', CAST(N'2023-11-18T12:06:00.070' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (4, 1, 1, 2, 0, 4, N'::1', CAST(N'2023-11-20T23:36:45.733' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (5, 4, 1, 1, 0, 2, N'::1', CAST(N'2023-11-21T00:49:05.520' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (6, 2, 1, 4, 0, 4, N'::1', CAST(N'2023-11-21T01:09:03.930' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (7, 4, 1, 3, 0, 4, N'::1', CAST(N'2023-11-21T20:48:48.693' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (8, 2, 1, 4, 1, 4, N'::1', CAST(N'2023-11-21T21:40:13.093' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (9, 4, 1, 1, 0, 4, N'::1', CAST(N'2023-11-21T22:29:58.840' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (10, 3, 1, 3, 1, 4, N'::1', CAST(N'2023-11-21T22:30:13.140' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (11, 4, 1, 2, 0, 4, N'::1', CAST(N'2023-11-21T22:58:38.830' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (12, 4, 1, 1, 0, 4, N'::1', CAST(N'2023-11-21T22:58:52.567' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (13, 5, 1, 1, 0, 2, N'::1', CAST(N'2024-03-17T00:27:56.787' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (14, 6, 1, 1, 0, 2, N'::1', CAST(N'2024-03-17T00:31:42.393' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (15, 7, 1, 1, 0, 2, N'::1', CAST(N'2024-03-17T00:37:08.000' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (16, 8, 1, 1, 0, 2, N'::1', CAST(N'2024-03-17T00:47:50.207' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (17, 9, 1, 1, 1, 2, N'::1', CAST(N'2024-03-20T23:46:54.510' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (18, 9, 2, 1, 0, 2, N'::1', CAST(N'2024-03-20T23:46:54.517' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (19, 9, 2, 2, 1, 5, N'::1', CAST(N'2024-03-20T23:52:08.020' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (20, 10, 1, 1, 0, 7, N'::1', CAST(N'2024-03-21T19:08:18.807' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (21, 1, 1, 3, 1, 4, N'::1', CAST(N'2024-03-21T19:10:01.740' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (22, 4, 1, 3, 1, 4, N'::1', CAST(N'2024-03-21T19:10:08.390' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (23, 5, 1, 3, 1, 4, N'::1', CAST(N'2024-03-21T19:10:15.420' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (24, 7, 1, 2, 0, 4, N'::1', CAST(N'2024-03-21T19:10:20.363' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (25, 6, 1, 2, 0, 4, N'::1', CAST(N'2024-03-21T19:10:27.233' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (26, 10, 1, 2, 1, 5, N'::1', CAST(N'2024-03-21T19:11:54.913' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (27, 11, 1, 1, 1, 7, N'::1', CAST(N'2024-03-21T19:21:35.880' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (28, 12, 1, 1, 1, 2, N'::1', CAST(N'2024-03-21T22:20:27.417' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (29, 12, 2, 1, 1, 2, N'::1', CAST(N'2024-03-21T22:20:27.420' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (30, 7, 1, 3, 1, 4, N'::1', CAST(N'2024-03-22T08:15:09.847' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (31, 6, 1, 3, 1, 4, N'::1', CAST(N'2024-03-22T08:15:15.480' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (32, 13, 1, 1, 1, 2, N'::1', CAST(N'2024-03-22T15:40:40.620' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (33, 8, 1, 3, 1, 4, N'::1', CAST(N'2024-03-22T19:41:47.507' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (34, 14, 1, 1, 1, 2, N'::1', CAST(N'2024-03-22T19:59:35.230' AS DateTime))
GO
INSERT [dbo].[OrderStatusHistory] ([OrderStatusHistoryID], [OrderID], [PackageID], [OrderStatus], [IsCurrent], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (35, 15, 1, 1, 1, 7, N'::1', CAST(N'2024-03-22T20:07:15.097' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[OrderStatusHistory] OFF
GO
INSERT [dbo].[OrderStatusType] ([OrderStatusID], [OrderStatusName], [IsActive]) VALUES (1, N'Processing', 1)
GO
INSERT [dbo].[OrderStatusType] ([OrderStatusID], [OrderStatusName], [IsActive]) VALUES (2, N'Shipped', 1)
GO
INSERT [dbo].[OrderStatusType] ([OrderStatusID], [OrderStatusName], [IsActive]) VALUES (3, N'Delivered', 1)
GO
INSERT [dbo].[OrderStatusType] ([OrderStatusID], [OrderStatusName], [IsActive]) VALUES (4, N'Cancelled', 1)
GO
SET IDENTITY_INSERT [dbo].[Permission] ON 
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (1, N'Dashboard', N'ViewDashboardV1', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (2, N'Dashboard', N'ViewDashboardV2', 1, NULL, NULL, NULL, 1, N'::1', CAST(N'2023-12-10T15:42:04.857' AS DateTime))
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (3, N'ProjectMgnt', N'ViewProjectList', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (4, N'ProjectMgnt', N'AddNewProject', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (6, N'TaskMgnt', N'AddNewTask', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (7, N'ProjectMgnt', N'EditNewProject', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (9, N'TaskMgnt', N'EditNewTask', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (10, N'TaskMgnt', N'ViewTasksList', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (11, N'TaskApproval', N'ViewTaskApprovalList', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (13, N'TaskApproval', N'ViewTaskApprovalSingleView', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (14, N'TaskApproval', N'ApprovePendingApprovalTask', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (15, N'TaskApproval', N'RejectPendingApprovalTask', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (16, N'ItemInventoryMgnt', N'ViewItemInventory', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (17, N'ItemInventoryMgnt', N'AddItemInventory', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (18, N'ItemInventoryMgnt', N'EditItemInventory', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (19, N'Store', N'ViewEStore', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (20, N'OrderMgnt', N'ViewOrderManagement', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (21, N'OrderMgnt', N'AddOrderManagement', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (22, N'OrderMgnt', N'EditOrderManagement', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (23, N'AdvertisementMgnt', N'ViewAdvMgnt', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (24, N'AdvertisementMgnt', N'AddAdvMgnt', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (25, N'AdvertisementMgnt', N'EditAdvMgnt', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (26, N'UserProfile', N'ViewUserProfile', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (27, N'UserProfile', N'EditUserProfile', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (28, N'UserChangePassword', N'ViewUserChangePassword', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (29, N'UserChangePassword', N'EditUserChangePassword', 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (30, N'UserManagement', N'ViewUserManagement', 1, 1, N'::1', CAST(N'2023-12-10T15:43:24.207' AS DateTime), 1, N'::1', CAST(N'2023-12-10T15:43:34.883' AS DateTime))
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (31, N'UserManagement', N'EditUserManagement', 1, 1, N'::1', CAST(N'2023-12-10T16:14:31.147' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (32, N'UserPermission', N'ViewUserPermission', 1, 1, N'::1', CAST(N'2023-12-21T20:36:07.387' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (33, N'UserPermission', N'AddUserPermission', 1, 1, N'::1', CAST(N'2023-12-21T20:36:16.040' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (34, N'UserPermission', N'EditUserPermission', 1, 1, N'::1', CAST(N'2023-12-21T20:36:23.430' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (35, N'UserRolePermission', N'ViewUserRolePermission', 1, 1, N'::1', CAST(N'2023-12-21T20:37:19.297' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (36, N'UserRolePermission', N'EditUserRolePermission', 1, 1, N'::1', CAST(N'2023-12-21T20:37:31.367' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (37, N'ReportProjectOverview', N'ViewReportProjectOverview', 1, 1, N'::1', CAST(N'2024-02-23T00:52:35.780' AS DateTime), 1, N'::1', CAST(N'2024-02-23T00:53:21.260' AS DateTime))
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (38, N'ReportProjectProgress', N'ViewReportProjectProgress', 1, 1, N'::1', CAST(N'2024-02-23T00:53:51.600' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (39, N'ReportContractorReview', N'ViewReportContractorReview', 1, 1, N'::1', CAST(N'2024-02-23T00:54:29.660' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (40, N'ReportSales', N'ViewReportSales', 1, 1, N'::1', CAST(N'2024-02-23T00:55:37.850' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (41, N'ReportOrderStatus', N'ViewReportOrderStatus', 1, 1, N'::1', CAST(N'2024-02-23T00:55:57.250' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (42, N'ReportInventory', N'ViewReportInventory', 1, 1, N'::1', CAST(N'2024-02-23T00:56:38.513' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (43, N'ReportCustomer', N'ViewReportCustomer', 1, 1, N'::1', CAST(N'2024-02-23T01:29:40.403' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (44, N'ReportPopularItem', N'ViewReportPopularItem', 1, 1, N'::1', CAST(N'2024-02-23T01:30:00.920' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (45, N'Dashboard', N'ViewAdminDashboard', 1, 1, N'::1', CAST(N'2024-03-09T10:13:32.043' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (46, N'Dashboard', N'ViewCustomerDashboard', 1, 1, N'::1', CAST(N'2024-03-09T10:13:48.070' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (47, N'Dashboard', N'ViewContractorDashboard', 1, 1, N'::1', CAST(N'2024-03-09T10:14:04.717' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[Permission] ([PermissionID], [ScreenName], [PermissionName], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (48, N'Dashboard', N'ViewVendorDashboard', 1, 1, N'::1', CAST(N'2024-03-09T10:18:27.560' AS DateTime), NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Permission] OFF
GO
SET IDENTITY_INSERT [dbo].[Project] ON 
GO
INSERT [dbo].[Project] ([ProjectID], [ProjectTitle], [ClientID], [ProjectPriority], [ProjectSize], [StartDate], [StartTime], [EndDate], [EndTime], [Description], [ProjectStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (1, N'Furniture Work', 2, 4, 1, CAST(N'2023-09-03' AS Date), CAST(N'00:00:00' AS Time), CAST(N'2023-09-16' AS Date), CAST(N'20:30:00' AS Time), N'Rtdsds dgffd ewew rwewew 123', 2, 3, N'::1', CAST(N'2023-09-02T20:32:21.263' AS DateTime), 3, N'::1', CAST(N'2024-03-21T15:58:48.883' AS DateTime))
GO
INSERT [dbo].[Project] ([ProjectID], [ProjectTitle], [ClientID], [ProjectPriority], [ProjectSize], [StartDate], [StartTime], [EndDate], [EndTime], [Description], [ProjectStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (2, N'Redwork Building', 2, 2, 2, CAST(N'2023-09-03' AS Date), CAST(N'18:00:00' AS Time), CAST(N'2023-09-07' AS Date), CAST(N'18:00:00' AS Time), N'dsds fdfdf eferre fdfdfe rt43 fd', 2, 3, N'::1', CAST(N'2023-09-02T23:08:29.077' AS DateTime), 1, N'::1', CAST(N'2023-10-08T13:21:40.237' AS DateTime))
GO
INSERT [dbo].[Project] ([ProjectID], [ProjectTitle], [ClientID], [ProjectPriority], [ProjectSize], [StartDate], [StartTime], [EndDate], [EndTime], [Description], [ProjectStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (3, N'Jaffa Tower Building Painting ', 2, 2, 1, CAST(N'2024-03-20' AS Date), CAST(N'00:00:00' AS Time), CAST(N'2024-04-19' AS Date), CAST(N'00:00:00' AS Time), N'Jaffa Tower Painting Buliding New Work', 1, 3, N'::1', CAST(N'2023-09-15T03:59:58.030' AS DateTime), 3, N'::1', CAST(N'2024-03-22T09:10:28.797' AS DateTime))
GO
INSERT [dbo].[Project] ([ProjectID], [ProjectTitle], [ClientID], [ProjectPriority], [ProjectSize], [StartDate], [StartTime], [EndDate], [EndTime], [Description], [ProjectStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (4, N'Library Renovating Phase 1', 2, 2, 2, CAST(N'2023-09-19' AS Date), CAST(N'06:30:00' AS Time), CAST(N'2023-09-30' AS Date), CAST(N'18:00:00' AS Time), N'Test Project Library Renovating Phase 1', 2, 3, N'::1', CAST(N'2023-09-17T00:47:23.500' AS DateTime), 3, N'::1', CAST(N'2024-03-20T14:37:24.850' AS DateTime))
GO
INSERT [dbo].[Project] ([ProjectID], [ProjectTitle], [ClientID], [ProjectPriority], [ProjectSize], [StartDate], [StartTime], [EndDate], [EndTime], [Description], [ProjectStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (5, N'Repair Play Ground in Wattala', 2, 3, 3, CAST(N'2024-03-21' AS Date), CAST(N'00:00:00' AS Time), CAST(N'2024-04-26' AS Date), CAST(N'00:00:00' AS Time), N'Repair Play Ground in Wattala New', 1, 3, N'::1', CAST(N'2023-09-18T23:42:30.720' AS DateTime), 3, N'::1', CAST(N'2024-03-21T15:48:49.690' AS DateTime))
GO
INSERT [dbo].[Project] ([ProjectID], [ProjectTitle], [ClientID], [ProjectPriority], [ProjectSize], [StartDate], [StartTime], [EndDate], [EndTime], [Description], [ProjectStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (6, N'Gonapola Building Renovation', 2, 3, 1, CAST(N'2024-03-21' AS Date), CAST(N'00:00:00' AS Time), CAST(N'2024-05-02' AS Date), CAST(N'00:00:00' AS Time), N'Gonapola Building Renovation New Work', 1, 3, N'::1', CAST(N'2023-09-19T00:38:58.730' AS DateTime), 3, N'::1', CAST(N'2024-03-21T15:57:55.377' AS DateTime))
GO
INSERT [dbo].[Project] ([ProjectID], [ProjectTitle], [ClientID], [ProjectPriority], [ProjectSize], [StartDate], [StartTime], [EndDate], [EndTime], [Description], [ProjectStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (7, N'New Savoy Hall Painting', 2, 3, 2, CAST(N'2023-11-30' AS Date), CAST(N'00:00:00' AS Time), CAST(N'2023-12-15' AS Date), CAST(N'00:00:00' AS Time), N'', 2, 3, N'::1', CAST(N'2023-11-25T13:02:44.133' AS DateTime), 3, N'::1', CAST(N'2024-03-20T14:36:27.340' AS DateTime))
GO
INSERT [dbo].[Project] ([ProjectID], [ProjectTitle], [ClientID], [ProjectPriority], [ProjectSize], [StartDate], [StartTime], [EndDate], [EndTime], [Description], [ProjectStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (8, N'New Apartment Electric Works ', 2, 3, 2, CAST(N'2024-03-20' AS Date), CAST(N'00:00:00' AS Time), CAST(N'2024-04-03' AS Date), CAST(N'20:30:00' AS Time), N'', 1, 6, N'::1', CAST(N'2024-03-20T13:59:20.537' AS DateTime), NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Project] OFF
GO
INSERT [dbo].[ProjectPriority] ([ProjectPriorityID], [PriorityName], [IsActive]) VALUES (1, N'Low', 1)
GO
INSERT [dbo].[ProjectPriority] ([ProjectPriorityID], [PriorityName], [IsActive]) VALUES (2, N'Medium', 1)
GO
INSERT [dbo].[ProjectPriority] ([ProjectPriorityID], [PriorityName], [IsActive]) VALUES (3, N'High', 1)
GO
INSERT [dbo].[ProjectPriority] ([ProjectPriorityID], [PriorityName], [IsActive]) VALUES (4, N'Urgent', 1)
GO
INSERT [dbo].[ProjectSize] ([ProjectSizeID], [SizeName], [IsActive]) VALUES (1, N'Small', 1)
GO
INSERT [dbo].[ProjectSize] ([ProjectSizeID], [SizeName], [IsActive]) VALUES (2, N'Medium', 1)
GO
INSERT [dbo].[ProjectSize] ([ProjectSizeID], [SizeName], [IsActive]) VALUES (3, N'Big', 1)
GO
INSERT [dbo].[ProjectStatus] ([ProjectStatusID], [StatusName], [IsActive]) VALUES (1, N'Doing', 1)
GO
INSERT [dbo].[ProjectStatus] ([ProjectStatusID], [StatusName], [IsActive]) VALUES (2, N'Done', 1)
GO
INSERT [dbo].[ProjectStatus] ([ProjectStatusID], [StatusName], [IsActive]) VALUES (3, N'Reject', 1)
GO
SET IDENTITY_INSERT [dbo].[ProjectTask] ON 
GO
INSERT [dbo].[ProjectTask] ([TaskID], [ProjectID], [TaskName], [TaskRate], [TaskRateType], [TaskPriority], [TaskStatus], [Description], [StartDate], [StartTime], [EndDate], [EndTime], [ServiceType], [AssignTo], [ApprovalStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (1, 1, N'Fix Cupboard', CAST(2500.00 AS Decimal(18, 2)), 2, 3, 3, N'Repair damaged cupboards.', CAST(N'2023-09-06' AS Date), CAST(N'09:00:00' AS Time), CAST(N'2023-09-09' AS Date), CAST(N'18:00:00' AS Time), 1, 3, 1, 3, NULL, NULL, 1, N'::1', CAST(N'2023-09-26T19:40:59.847' AS DateTime))
GO
INSERT [dbo].[ProjectTask] ([TaskID], [ProjectID], [TaskName], [TaskRate], [TaskRateType], [TaskPriority], [TaskStatus], [Description], [StartDate], [StartTime], [EndDate], [EndTime], [ServiceType], [AssignTo], [ApprovalStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (2, 1, N'TRD Boards', CAST(3000.00 AS Decimal(18, 2)), 2, 4, 3, N'fdfdf 1234', CAST(N'2023-09-08' AS Date), CAST(N'00:00:00' AS Time), CAST(N'2023-09-14' AS Date), CAST(N'00:00:00' AS Time), 1, 3, 1, 3, N'::1', CAST(N'2023-09-08T01:03:48.000' AS DateTime), 3, N'::1', CAST(N'2024-03-17T01:34:54.710' AS DateTime))
GO
INSERT [dbo].[ProjectTask] ([TaskID], [ProjectID], [TaskName], [TaskRate], [TaskRateType], [TaskPriority], [TaskStatus], [Description], [StartDate], [StartTime], [EndDate], [EndTime], [ServiceType], [AssignTo], [ApprovalStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (3, 2, N'Painting Wall', CAST(3450.00 AS Decimal(18, 2)), 2, 1, 3, N'xdsdsd', CAST(N'2023-09-08' AS Date), CAST(N'00:00:00' AS Time), CAST(N'2023-09-22' AS Date), CAST(N'00:00:00' AS Time), 3, 3, 1, 3, N'::1', CAST(N'2023-09-08T01:04:46.030' AS DateTime), 1, N'::1', CAST(N'2023-10-08T13:21:29.243' AS DateTime))
GO
INSERT [dbo].[ProjectTask] ([TaskID], [ProjectID], [TaskName], [TaskRate], [TaskRateType], [TaskPriority], [TaskStatus], [Description], [StartDate], [StartTime], [EndDate], [EndTime], [ServiceType], [AssignTo], [ApprovalStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (4, 1, N'TYU Gtdsds', CAST(3000.00 AS Decimal(18, 2)), 2, 2, 3, N'dsdsd', CAST(N'2023-09-09' AS Date), CAST(N'00:00:00' AS Time), CAST(N'2023-09-22' AS Date), CAST(N'00:00:00' AS Time), 3, 3, 1, 3, N'::1', CAST(N'2023-09-09T00:21:43.443' AS DateTime), 3, N'::1', CAST(N'2024-03-21T15:58:31.393' AS DateTime))
GO
INSERT [dbo].[ProjectTask] ([TaskID], [ProjectID], [TaskName], [TaskRate], [TaskRateType], [TaskPriority], [TaskStatus], [Description], [StartDate], [StartTime], [EndDate], [EndTime], [ServiceType], [AssignTo], [ApprovalStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (5, 1, N'Polishing', CAST(10000.00 AS Decimal(18, 2)), 3, 2, 3, N'Polishing furniture', CAST(N'2023-09-16' AS Date), CAST(N'00:00:00' AS Time), CAST(N'2023-09-23' AS Date), CAST(N'00:00:00' AS Time), 3, 3, 2, 3, N'::1', CAST(N'2023-09-16T18:44:22.890' AS DateTime), 1, N'::1', CAST(N'2023-09-27T21:47:07.977' AS DateTime))
GO
INSERT [dbo].[ProjectTask] ([TaskID], [ProjectID], [TaskName], [TaskRate], [TaskRateType], [TaskPriority], [TaskStatus], [Description], [StartDate], [StartTime], [EndDate], [EndTime], [ServiceType], [AssignTo], [ApprovalStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (6, 1, N'Wood Cutting and shaping', CAST(1500.00 AS Decimal(18, 2)), 2, 3, 3, N'Test task 123', CAST(N'2023-09-17' AS Date), CAST(N'06:00:00' AS Time), CAST(N'2023-09-22' AS Date), CAST(N'18:00:00' AS Time), 7, 3, 2, 3, N'::1', CAST(N'2023-09-16T20:46:56.647' AS DateTime), 3, N'::1', CAST(N'2024-03-17T13:58:20.887' AS DateTime))
GO
INSERT [dbo].[ProjectTask] ([TaskID], [ProjectID], [TaskName], [TaskRate], [TaskRateType], [TaskPriority], [TaskStatus], [Description], [StartDate], [StartTime], [EndDate], [EndTime], [ServiceType], [AssignTo], [ApprovalStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (7, 1, N'Floor Repair', CAST(3000.00 AS Decimal(18, 2)), 2, 3, 3, N'Test 2', CAST(N'2023-09-21' AS Date), CAST(N'00:00:00' AS Time), CAST(N'2023-09-30' AS Date), CAST(N'00:00:00' AS Time), 7, 3, 1, 3, N'::1', CAST(N'2023-09-16T22:49:35.873' AS DateTime), 1, N'::1', CAST(N'2023-10-08T23:24:04.433' AS DateTime))
GO
INSERT [dbo].[ProjectTask] ([TaskID], [ProjectID], [TaskName], [TaskRate], [TaskRateType], [TaskPriority], [TaskStatus], [Description], [StartDate], [StartTime], [EndDate], [EndTime], [ServiceType], [AssignTo], [ApprovalStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (8, 1, N'Wood Cutting and shaping new', CAST(10000.00 AS Decimal(18, 2)), 3, 4, 3, N'', CAST(N'2023-09-22' AS Date), CAST(N'00:00:00' AS Time), CAST(N'2023-09-30' AS Date), CAST(N'00:00:00' AS Time), 2, 3, 2, 3, N'::1', CAST(N'2023-09-22T00:27:13.370' AS DateTime), 3, N'::1', CAST(N'2023-12-12T23:58:40.870' AS DateTime))
GO
INSERT [dbo].[ProjectTask] ([TaskID], [ProjectID], [TaskName], [TaskRate], [TaskRateType], [TaskPriority], [TaskStatus], [Description], [StartDate], [StartTime], [EndDate], [EndTime], [ServiceType], [AssignTo], [ApprovalStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (9, 4, N'Test 109', CAST(10000.00 AS Decimal(18, 2)), 3, 3, 3, N'wewe', CAST(N'2023-11-03' AS Date), CAST(N'00:00:00' AS Time), CAST(N'2023-11-23' AS Date), CAST(N'00:00:00' AS Time), 1, 3, 1, 3, N'::1', CAST(N'2023-11-03T23:22:59.503' AS DateTime), 3, N'::1', CAST(N'2024-03-20T14:37:02.860' AS DateTime))
GO
INSERT [dbo].[ProjectTask] ([TaskID], [ProjectID], [TaskName], [TaskRate], [TaskRateType], [TaskPriority], [TaskStatus], [Description], [StartDate], [StartTime], [EndDate], [EndTime], [ServiceType], [AssignTo], [ApprovalStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (10, 7, N'Painting Wall', CAST(3000.00 AS Decimal(18, 2)), 2, 3, 3, N'Painting Test Task', CAST(N'2023-11-25' AS Date), CAST(N'00:00:00' AS Time), CAST(N'2023-12-01' AS Date), CAST(N'00:00:00' AS Time), 7, 3, 2, 3, N'::1', CAST(N'2023-11-25T13:04:15.793' AS DateTime), 3, N'::1', CAST(N'2024-03-10T12:23:15.220' AS DateTime))
GO
INSERT [dbo].[ProjectTask] ([TaskID], [ProjectID], [TaskName], [TaskRate], [TaskRateType], [TaskPriority], [TaskStatus], [Description], [StartDate], [StartTime], [EndDate], [EndTime], [ServiceType], [AssignTo], [ApprovalStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (11, 1, N'Painting Wood Wall', CAST(10000.00 AS Decimal(18, 2)), 3, 3, 3, N'Tfswfrg fdfd', CAST(N'2024-03-17' AS Date), CAST(N'00:00:00' AS Time), CAST(N'2024-03-28' AS Date), CAST(N'18:15:00' AS Time), 2, 3, 1, 3, N'::1', CAST(N'2024-03-17T13:35:22.837' AS DateTime), 3, N'::1', CAST(N'2024-03-21T13:36:05.337' AS DateTime))
GO
INSERT [dbo].[ProjectTask] ([TaskID], [ProjectID], [TaskName], [TaskRate], [TaskRateType], [TaskPriority], [TaskStatus], [Description], [StartDate], [StartTime], [EndDate], [EndTime], [ServiceType], [AssignTo], [ApprovalStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (12, 1, N'Fix Cupboard V2', CAST(2500.00 AS Decimal(18, 2)), 2, 2, 3, N'Fix Cupboard V2 - Dff', CAST(N'2024-03-20' AS Date), CAST(N'09:00:00' AS Time), CAST(N'2024-03-28' AS Date), CAST(N'18:00:00' AS Time), 2, 6, 1, 3, N'::1', CAST(N'2024-03-20T12:41:32.060' AS DateTime), 3, N'::1', CAST(N'2024-03-21T13:33:00.490' AS DateTime))
GO
INSERT [dbo].[ProjectTask] ([TaskID], [ProjectID], [TaskName], [TaskRate], [TaskRateType], [TaskPriority], [TaskStatus], [Description], [StartDate], [StartTime], [EndDate], [EndTime], [ServiceType], [AssignTo], [ApprovalStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (13, 3, N'Putty Works', CAST(3000.00 AS Decimal(18, 2)), 2, 3, 3, N'Repair damaged walls', CAST(N'2024-03-22' AS Date), CAST(N'06:00:00' AS Time), CAST(N'2024-04-02' AS Date), CAST(N'18:00:00' AS Time), 1, 3, 0, 3, N'::1', CAST(N'2024-03-22T09:06:21.543' AS DateTime), 3, N'::1', CAST(N'2024-03-22T10:20:00.703' AS DateTime))
GO
INSERT [dbo].[ProjectTask] ([TaskID], [ProjectID], [TaskName], [TaskRate], [TaskRateType], [TaskPriority], [TaskStatus], [Description], [StartDate], [StartTime], [EndDate], [EndTime], [ServiceType], [AssignTo], [ApprovalStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (14, 3, N'Wall Filler Works', CAST(2500.00 AS Decimal(18, 2)), 1, 3, 2, N'Wall Filler works on new', CAST(N'2024-04-01' AS Date), CAST(N'00:00:00' AS Time), CAST(N'2024-04-11' AS Date), CAST(N'00:00:00' AS Time), 1, 3, 0, 3, N'::1', CAST(N'2024-03-22T09:08:55.440' AS DateTime), 3, N'::1', CAST(N'2024-03-22T21:25:21.520' AS DateTime))
GO
INSERT [dbo].[ProjectTask] ([TaskID], [ProjectID], [TaskName], [TaskRate], [TaskRateType], [TaskPriority], [TaskStatus], [Description], [StartDate], [StartTime], [EndDate], [EndTime], [ServiceType], [AssignTo], [ApprovalStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (15, 3, N'Wall Painting', CAST(3500.00 AS Decimal(18, 2)), 1, 3, 1, N'Wall Painting New', CAST(N'2024-04-11' AS Date), CAST(N'00:00:00' AS Time), CAST(N'2024-05-09' AS Date), CAST(N'00:00:00' AS Time), 1, 3, 0, 3, N'::1', CAST(N'2024-03-22T09:10:04.907' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ProjectTask] ([TaskID], [ProjectID], [TaskName], [TaskRate], [TaskRateType], [TaskPriority], [TaskStatus], [Description], [StartDate], [StartTime], [EndDate], [EndTime], [ServiceType], [AssignTo], [ApprovalStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (16, 3, N'Painting Rusted H- Iron Bars', CAST(10000.00 AS Decimal(18, 2)), 3, 4, 1, N'Painting Rusted or tear off  H- Iron Bars', CAST(N'2024-04-10' AS Date), CAST(N'00:00:00' AS Time), CAST(N'2024-04-18' AS Date), CAST(N'00:00:00' AS Time), 1, 3, 0, 3, N'::1', CAST(N'2024-03-22T09:12:48.240' AS DateTime), 3, N'::1', CAST(N'2024-03-22T09:13:22.487' AS DateTime))
GO
INSERT [dbo].[ProjectTask] ([TaskID], [ProjectID], [TaskName], [TaskRate], [TaskRateType], [TaskPriority], [TaskStatus], [Description], [StartDate], [StartTime], [EndDate], [EndTime], [ServiceType], [AssignTo], [ApprovalStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (17, 5, N'Repair Children Seesaw', CAST(15000.00 AS Decimal(18, 2)), 3, 2, 3, N'', CAST(N'2024-03-27' AS Date), CAST(N'00:00:00' AS Time), CAST(N'2024-04-11' AS Date), CAST(N'00:00:00' AS Time), 8, 3, 0, 3, N'::1', CAST(N'2024-03-22T09:28:31.507' AS DateTime), 3, N'::1', CAST(N'2024-03-22T10:15:11.800' AS DateTime))
GO
INSERT [dbo].[ProjectTask] ([TaskID], [ProjectID], [TaskName], [TaskRate], [TaskRateType], [TaskPriority], [TaskStatus], [Description], [StartDate], [StartTime], [EndDate], [EndTime], [ServiceType], [AssignTo], [ApprovalStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (18, 5, N'Repair Children Roundabout', CAST(20000.00 AS Decimal(18, 2)), 3, 2, 1, N'Repair Children Roundabout', CAST(N'2024-04-01' AS Date), CAST(N'00:00:00' AS Time), CAST(N'2024-04-25' AS Date), CAST(N'00:00:00' AS Time), 8, 3, 0, 3, N'::1', CAST(N'2024-03-22T09:30:29.597' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ProjectTask] ([TaskID], [ProjectID], [TaskName], [TaskRate], [TaskRateType], [TaskPriority], [TaskStatus], [Description], [StartDate], [StartTime], [EndDate], [EndTime], [ServiceType], [AssignTo], [ApprovalStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (19, 5, N'Repair Cracks in Jogging Path', CAST(40000.00 AS Decimal(18, 2)), 3, 3, 1, N'Repair Cracks in Jogging Path New', CAST(N'2024-04-14' AS Date), CAST(N'00:00:00' AS Time), CAST(N'2024-04-20' AS Date), CAST(N'00:00:00' AS Time), 8, 3, 0, 3, N'::1', CAST(N'2024-03-22T09:31:45.610' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ProjectTask] ([TaskID], [ProjectID], [TaskName], [TaskRate], [TaskRateType], [TaskPriority], [TaskStatus], [Description], [StartDate], [StartTime], [EndDate], [EndTime], [ServiceType], [AssignTo], [ApprovalStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (20, 6, N'Plastering Damaged Walls', CAST(3000.00 AS Decimal(18, 2)), 2, 3, 3, N'Plastering Damaged Walls New', CAST(N'2024-03-23' AS Date), CAST(N'00:00:00' AS Time), CAST(N'2024-03-29' AS Date), CAST(N'00:00:00' AS Time), 1, 3, 0, 3, N'::1', CAST(N'2024-03-22T09:41:22.087' AS DateTime), 3, N'::1', CAST(N'2024-03-22T10:01:54.550' AS DateTime))
GO
INSERT [dbo].[ProjectTask] ([TaskID], [ProjectID], [TaskName], [TaskRate], [TaskRateType], [TaskPriority], [TaskStatus], [Description], [StartDate], [StartTime], [EndDate], [EndTime], [ServiceType], [AssignTo], [ApprovalStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (21, 6, N'Build New Wall', CAST(3000.00 AS Decimal(18, 2)), 2, 2, 1, N'', CAST(N'2024-04-03' AS Date), CAST(N'06:00:00' AS Time), CAST(N'2024-04-30' AS Date), CAST(N'18:00:00' AS Time), 1, 3, 0, 3, N'::1', CAST(N'2024-03-22T09:58:24.473' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ProjectTask] ([TaskID], [ProjectID], [TaskName], [TaskRate], [TaskRateType], [TaskPriority], [TaskStatus], [Description], [StartDate], [StartTime], [EndDate], [EndTime], [ServiceType], [AssignTo], [ApprovalStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (22, 8, N'New Wiring', CAST(4000.00 AS Decimal(18, 2)), 2, 3, 3, N'New Wiring in Apartment', CAST(N'2024-03-23' AS Date), CAST(N'00:00:00' AS Time), CAST(N'2024-04-05' AS Date), CAST(N'00:00:00' AS Time), 4, 6, 0, 6, N'::1', CAST(N'2024-03-22T10:29:03.150' AS DateTime), 6, N'::1', CAST(N'2024-03-22T10:37:17.783' AS DateTime))
GO
INSERT [dbo].[ProjectTask] ([TaskID], [ProjectID], [TaskName], [TaskRate], [TaskRateType], [TaskPriority], [TaskStatus], [Description], [StartDate], [StartTime], [EndDate], [EndTime], [ServiceType], [AssignTo], [ApprovalStatus], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (23, 8, N'Fix new Lightning', CAST(3500.00 AS Decimal(18, 2)), 2, 3, 1, N'Fix new Lightning in Apartment', CAST(N'2024-04-01' AS Date), CAST(N'06:00:00' AS Time), CAST(N'2024-04-18' AS Date), CAST(N'18:30:00' AS Time), 4, 6, 0, 6, N'::1', CAST(N'2024-03-22T10:31:43.643' AS DateTime), NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[ProjectTask] OFF
GO
SET IDENTITY_INSERT [dbo].[ProjectTaskImg] ON 
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (11, 1, N'task_1_1_20230924T210958.png', N'/uploads/taskmgnt/task_1_1_20230924T210958.png', 1, N'::1', CAST(N'2023-09-24T21:17:09.010' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (12, 1, N'task_1_2_20230924T210958.png', N'/uploads/taskmgnt/task_1_2_20230924T210958.png', 1, N'::1', CAST(N'2023-09-24T21:17:09.010' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (13, 1, N'task_1_3_20230924T210958.png', N'/uploads/taskmgnt/task_1_3_20230924T210958.png', 1, N'::1', CAST(N'2023-09-24T21:17:09.010' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (14, 1, N'task_1_1_20230924T211708.png', N'/uploads/taskmgnt/task_1_1_20230924T211708.png', 1, N'::1', CAST(N'2023-09-24T21:17:09.010' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (15, 1, N'task_1_2_20230924T211708.png', N'/uploads/taskmgnt/task_1_2_20230924T211708.png', 1, N'::1', CAST(N'2023-09-24T21:17:09.010' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (16, 1, N'task_1_3_20230924T211708.png', N'/uploads/taskmgnt/task_1_3_20230924T211708.png', 1, N'::1', CAST(N'2023-09-24T21:17:09.010' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (17, 5, N'task_5_1_20230924T151017.png', N'/uploads/taskmgnt/task_5_1_20230924T151017.png', 1, N'::1', CAST(N'2023-09-24T21:19:00.683' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (18, 5, N'task_5_2_20230924T151017.png', N'/uploads/taskmgnt/task_5_2_20230924T151017.png', 1, N'::1', CAST(N'2023-09-24T21:19:00.683' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (19, 5, N'task_5_3_20230924T151017.png', N'/uploads/taskmgnt/task_5_3_20230924T151017.png', 1, N'::1', CAST(N'2023-09-24T21:19:00.683' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (20, 5, N'task_5_1_20230924T211900.png', N'/uploads/taskmgnt/task_5_1_20230924T211900.png', 1, N'::1', CAST(N'2023-09-24T21:19:00.683' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (21, 3, N'task_3_1_20231008T132129.png', N'/uploads/taskmgnt/task_3_1_20231008T132129.png', 1, N'::1', CAST(N'2023-10-08T13:21:30.133' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (22, 3, N'task_3_2_20231008T132129.png', N'/uploads/taskmgnt/task_3_2_20231008T132129.png', 1, N'::1', CAST(N'2023-10-08T13:21:30.133' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (27, 7, N'task_7_1_20231008T232404.png', N'/uploads/taskmgnt/task_7_1_20231008T232404.png', 1, N'::1', CAST(N'2023-10-08T23:24:04.493' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (28, 7, N'task_7_2_20231008T232404.png', N'/uploads/taskmgnt/task_7_2_20231008T232404.png', 1, N'::1', CAST(N'2023-10-08T23:24:04.493' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (29, 7, N'task_7_3_20231008T232404.png', N'/uploads/taskmgnt/task_7_3_20231008T232404.png', 1, N'::1', CAST(N'2023-10-08T23:24:04.493' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (35, 8, N'task_8_1_20231212T235840.jpg', N'/uploads/taskmgnt/task_8_1_20231212T235840.jpg', 3, N'::1', CAST(N'2023-12-12T23:58:40.913' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (36, 8, N'task_8_2_20231212T235840.jpg', N'/uploads/taskmgnt/task_8_2_20231212T235840.jpg', 3, N'::1', CAST(N'2023-12-12T23:58:40.913' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (37, 10, N'task_10_1_20240310T122315.png', N'/uploads/taskmgnt/task_10_1_20240310T122315.png', 3, N'::1', CAST(N'2024-03-10T12:23:16.137' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (38, 10, N'task_10_2_20240310T122315.jpg', N'/uploads/taskmgnt/task_10_2_20240310T122315.jpg', 3, N'::1', CAST(N'2024-03-10T12:23:16.137' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (39, 2, N'task_2_1_20240317T013516.jpg', N'/uploads/taskmgnt/task_2_1_20240317T013516.jpg', 3, N'::1', CAST(N'2024-03-17T01:35:17.423' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (40, 2, N'task_2_2_20240317T013517.png', N'/uploads/taskmgnt/task_2_2_20240317T013517.png', 3, N'::1', CAST(N'2024-03-17T01:35:17.423' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (41, 6, N'task_6_1_20240317T134954.png', N'/uploads/taskmgnt/task_6_1_20240317T134954.png', 3, N'::1', CAST(N'2024-03-17T13:49:55.600' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (42, 6, N'task_6_2_20240317T134954.jpg', N'/uploads/taskmgnt/task_6_2_20240317T134954.jpg', 3, N'::1', CAST(N'2024-03-17T13:49:55.600' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (43, 6, N'task_6_3_20240317T134954.png', N'/uploads/taskmgnt/task_6_3_20240317T134954.png', 3, N'::1', CAST(N'2024-03-17T13:49:55.600' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (44, 9, N'task_9_1_20240320T143709.png', N'/uploads/taskmgnt/task_9_1_20240320T143709.png', 3, N'::1', CAST(N'2024-03-20T14:37:10.530' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (45, 12, N'task_12_1_20240321T133249.png', N'/uploads/taskmgnt/task_12_1_20240321T133249.png', 3, N'::1', CAST(N'2024-03-21T13:32:50.843' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (46, 12, N'task_12_2_20240321T133249.png', N'/uploads/taskmgnt/task_12_2_20240321T133249.png', 3, N'::1', CAST(N'2024-03-21T13:32:50.843' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (47, 11, N'task_11_1_20240321T133609.png', N'/uploads/taskmgnt/task_11_1_20240321T133609.png', 3, N'::1', CAST(N'2024-03-21T13:36:09.207' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (48, 4, N'task_4_1_20240321T155835.png', N'/uploads/taskmgnt/task_4_1_20240321T155835.png', 3, N'::1', CAST(N'2024-03-21T15:58:35.427' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (49, 20, N'task_20_1_20240322T100158.jpg', N'/uploads/taskmgnt/task_20_1_20240322T100158.jpg', 3, N'::1', CAST(N'2024-03-22T10:01:58.717' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (50, 17, N'task_17_1_20240322T101459.jpg', N'/uploads/taskmgnt/task_17_1_20240322T101459.jpg', 3, N'::1', CAST(N'2024-03-22T10:14:59.660' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (51, 13, N'task_13_1_20240322T102004.png', N'/uploads/taskmgnt/task_13_1_20240322T102004.png', 3, N'::1', CAST(N'2024-03-22T10:20:04.397' AS DateTime))
GO
INSERT [dbo].[ProjectTaskImg] ([ProjectTaskImgID], [TaskID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (52, 22, N'task_22_1_20240322T103721.jpg', N'/uploads/taskmgnt/task_22_1_20240322T103721.jpg', 6, N'::1', CAST(N'2024-03-22T10:37:21.723' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[ProjectTaskImg] OFF
GO
INSERT [dbo].[ProjectTaskRateType] ([TaskRateTypeID], [TaskRateTypeName], [IsActive]) VALUES (1, N'Hourly', 1)
GO
INSERT [dbo].[ProjectTaskRateType] ([TaskRateTypeID], [TaskRateTypeName], [IsActive]) VALUES (2, N'Daily', 1)
GO
INSERT [dbo].[ProjectTaskRateType] ([TaskRateTypeID], [TaskRateTypeName], [IsActive]) VALUES (3, N'Fixed', 1)
GO
SET IDENTITY_INSERT [dbo].[ProjectTaskRejectInfo] ON 
GO
INSERT [dbo].[ProjectTaskRejectInfo] ([RejectInfoID], [TaskID], [Reason], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (1, 5, N'Not Satisfied', 2, N'::1', CAST(N'2023-10-04T00:11:23.747' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ProjectTaskRejectInfo] ([RejectInfoID], [TaskID], [Reason], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (2, 10, N'Change color', 2, N'::1', CAST(N'2024-03-17T02:09:11.513' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ProjectTaskRejectInfo] ([RejectInfoID], [TaskID], [Reason], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (3, 8, N'Incorrect placement', 2, N'::1', CAST(N'2024-03-17T13:26:46.727' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ProjectTaskRejectInfo] ([RejectInfoID], [TaskID], [Reason], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (4, 6, N'Incorrect work', 2, N'::1', CAST(N'2024-03-21T15:59:29.530' AS DateTime), NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[ProjectTaskRejectInfo] OFF
GO
SET IDENTITY_INSERT [dbo].[ProjectTaskReview] ON 
GO
INSERT [dbo].[ProjectTaskReview] ([ReviewID], [TaskID], [Rating], [Comment], [ContractorID], [IsVisitedSite], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (1, 1, 5, N'Very Good', 3, 1, 2, N'::1', CAST(N'2023-10-04T00:09:12.623' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ProjectTaskReview] ([ReviewID], [TaskID], [Rating], [Comment], [ContractorID], [IsVisitedSite], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (2, 7, 4, N'Overall Good Work', 3, 1, 2, N'::1', CAST(N'2024-02-04T13:07:13.640' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ProjectTaskReview] ([ReviewID], [TaskID], [Rating], [Comment], [ContractorID], [IsVisitedSite], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (3, 3, 5, N'Good Work', 3, 1, 2, N'::1', CAST(N'2024-03-17T02:08:05.947' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ProjectTaskReview] ([ReviewID], [TaskID], [Rating], [Comment], [ContractorID], [IsVisitedSite], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (4, 2, 4, N'Good', 3, 1, 2, N'::1', CAST(N'2024-03-17T13:25:46.430' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ProjectTaskReview] ([ReviewID], [TaskID], [Rating], [Comment], [ContractorID], [IsVisitedSite], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (5, 9, 5, N'Yewew', 3, 1, 2, N'::1', CAST(N'2024-03-20T14:38:36.630' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ProjectTaskReview] ([ReviewID], [TaskID], [Rating], [Comment], [ContractorID], [IsVisitedSite], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (6, 12, 4, N'Overall Good', 6, 1, 2, N'::1', CAST(N'2024-03-21T13:33:45.567' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ProjectTaskReview] ([ReviewID], [TaskID], [Rating], [Comment], [ContractorID], [IsVisitedSite], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (7, 11, 4, N'Tds 1212', 3, 1, 2, N'::1', CAST(N'2024-03-21T13:36:47.660' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ProjectTaskReview] ([ReviewID], [TaskID], [Rating], [Comment], [ContractorID], [IsVisitedSite], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (8, 4, 5, N'Great!', 3, 1, 2, N'::1', CAST(N'2024-03-21T15:59:44.710' AS DateTime), NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[ProjectTaskReview] OFF
GO
INSERT [dbo].[ProjectTaskStatus] ([TaskStatusID], [TaskStatusName], [IsActive]) VALUES (1, N'New ', 1)
GO
INSERT [dbo].[ProjectTaskStatus] ([TaskStatusID], [TaskStatusName], [IsActive]) VALUES (2, N'In Progress', 1)
GO
INSERT [dbo].[ProjectTaskStatus] ([TaskStatusID], [TaskStatusName], [IsActive]) VALUES (3, N'Completed', 1)
GO
INSERT [dbo].[ProjectTaskStatus] ([TaskStatusID], [TaskStatusName], [IsActive]) VALUES (4, N'Cancelled', 1)
GO
SET IDENTITY_INSERT [dbo].[ServiceType] ON 
GO
INSERT [dbo].[ServiceType] ([ServiceTypeID], [ServiceTypeName], [IsActive]) VALUES (1, N'Masonry', 1)
GO
INSERT [dbo].[ServiceType] ([ServiceTypeID], [ServiceTypeName], [IsActive]) VALUES (2, N'Carpentry', 1)
GO
INSERT [dbo].[ServiceType] ([ServiceTypeID], [ServiceTypeName], [IsActive]) VALUES (3, N'Plumbing', 1)
GO
INSERT [dbo].[ServiceType] ([ServiceTypeID], [ServiceTypeName], [IsActive]) VALUES (4, N'Electrical', 1)
GO
INSERT [dbo].[ServiceType] ([ServiceTypeID], [ServiceTypeName], [IsActive]) VALUES (5, N'Air Conditioning', 1)
GO
INSERT [dbo].[ServiceType] ([ServiceTypeID], [ServiceTypeName], [IsActive]) VALUES (6, N'Roofing', 1)
GO
INSERT [dbo].[ServiceType] ([ServiceTypeID], [ServiceTypeName], [IsActive]) VALUES (7, N'Flooring', 1)
GO
INSERT [dbo].[ServiceType] ([ServiceTypeID], [ServiceTypeName], [IsActive]) VALUES (8, N'Restoration', 1)
GO
SET IDENTITY_INSERT [dbo].[ServiceType] OFF
GO
INSERT [dbo].[TaskApprovalStatusType] ([TaskApprovalStatusID], [TaskApprovalStatusName], [IsActive]) VALUES (0, N'Pending', 1)
GO
INSERT [dbo].[TaskApprovalStatusType] ([TaskApprovalStatusID], [TaskApprovalStatusName], [IsActive]) VALUES (1, N'Approved', 1)
GO
INSERT [dbo].[TaskApprovalStatusType] ([TaskApprovalStatusID], [TaskApprovalStatusName], [IsActive]) VALUES (2, N'Rejected', 1)
GO
SET IDENTITY_INSERT [dbo].[User] ON 
GO
INSERT [dbo].[User] ([UserID], [Username], [Email], [FirstName], [LastName], [UserRoleID], [NIC], [MobileNo], [Password], [AttemptCount], [IsTempPassword], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (1, N'admin', N'cmmsnoreply@gmail.com', N'System', N'Administrator', 1, N'962083056V', N'0768880028', N'ZcGA07ykjpff/YfJgSjbcQ==', 0, 0, 1, NULL, NULL, NULL, 1, N'::1', CAST(N'2024-03-22T21:20:24.320' AS DateTime))
GO
INSERT [dbo].[User] ([UserID], [Username], [Email], [FirstName], [LastName], [UserRoleID], [NIC], [MobileNo], [Password], [AttemptCount], [IsTempPassword], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (2, N'dushan96', N'shalitha.dh@gmail.com', N'Dushan', N'Perera', 2, N'982083056V', N'0754566788', N'ZcGA07ykjpff/YfJgSjbcQ==', 0, 0, 1, 2, N'::1', CAST(N'2023-09-10T19:27:29.570' AS DateTime), NULL, N'::1', CAST(N'2024-03-22T08:06:05.607' AS DateTime))
GO
INSERT [dbo].[User] ([UserID], [Username], [Email], [FirstName], [LastName], [UserRoleID], [NIC], [MobileNo], [Password], [AttemptCount], [IsTempPassword], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (3, N'jagathweera56', N'shalitha.dh@hotmail.com', N'Jagath', N'Weerasekara', 3, N'6732323232V', N'0765322323', N'ZcGA07ykjpff/YfJgSjbcQ==', 0, 0, 1, 3, N'::1', CAST(N'2023-09-12T23:44:48.140' AS DateTime), 3, N'::1', CAST(N'2024-03-22T08:31:50.910' AS DateTime))
GO
INSERT [dbo].[User] ([UserID], [Username], [Email], [FirstName], [LastName], [UserRoleID], [NIC], [MobileNo], [Password], [AttemptCount], [IsTempPassword], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (4, N'kavinduamp', N'shalithajoe@gmail.com', N'Kavindu', N'Ambepala', 4, N'962032232V', N'0788866666', N'ZcGA07ykjpff/YfJgSjbcQ==', 0, 0, 1, 4, N'::1', CAST(N'2023-09-12T23:49:42.210' AS DateTime), NULL, N'::1', CAST(N'2024-03-21T13:45:15.560' AS DateTime))
GO
INSERT [dbo].[User] ([UserID], [Username], [Email], [FirstName], [LastName], [UserRoleID], [NIC], [MobileNo], [Password], [AttemptCount], [IsTempPassword], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (5, N'janith1995', N'janithwijethunga1995@gmail.com', N'Janith', N'Wijethunga', 4, N'954673237V', N'0786783232', N'ZcGA07ykjpff/YfJgSjbcQ==', 0, 0, 1, 5, N'::1', CAST(N'2024-03-19T09:48:21.857' AS DateTime), 5, N'::1', CAST(N'2024-03-21T15:37:36.927' AS DateTime))
GO
INSERT [dbo].[User] ([UserID], [Username], [Email], [FirstName], [LastName], [UserRoleID], [NIC], [MobileNo], [Password], [AttemptCount], [IsTempPassword], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (6, N'sarthsilva11', N'sarthsilva11@gmail.com', N'Sarath', N'De Silva', 3, N'689900010V', N'0783422323', N'ZcGA07ykjpff/YfJgSjbcQ==', 0, 0, 1, 6, N'::1', CAST(N'2024-03-19T13:31:51.647' AS DateTime), 6, N'::1', CAST(N'2024-03-22T10:29:14.253' AS DateTime))
GO
INSERT [dbo].[User] ([UserID], [Username], [Email], [FirstName], [LastName], [UserRoleID], [NIC], [MobileNo], [Password], [AttemptCount], [IsTempPassword], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (7, N'cheranisilva11', N'cheranisilva11@gmail.com', N'Cherani', N'Silva', 2, N'946783458V', N'0783232323', N'ZcGA07ykjpff/YfJgSjbcQ==', 0, 0, 1, 7, N'::1', CAST(N'2024-03-21T15:44:33.853' AS DateTime), 7, N'::1', CAST(N'2024-03-21T23:19:09.310' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[User] OFF
GO
SET IDENTITY_INSERT [dbo].[UserAddressDetail] ON 
GO
INSERT [dbo].[UserAddressDetail] ([AddressID], [UserID], [Address1], [Address2], [Address3], [District], [Province], [IsPrimary], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (1, 1, N'No:-126', N'Samagi Mawatha', N'Polgasowita', N'Colombo', N'Western', 1, 1, NULL, NULL, NULL, 1, N'::1', CAST(N'2024-03-22T21:20:24.320' AS DateTime))
GO
INSERT [dbo].[UserAddressDetail] ([AddressID], [UserID], [Address1], [Address2], [Address3], [District], [Province], [IsPrimary], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (2, 2, N'No- 37', N'Asiri Mawatha', N'Kesbewa', N'Colombo', N'Western', 1, 1, 2, N'::1', CAST(N'2023-09-10T19:27:29.573' AS DateTime), 2, N'::1', CAST(N'2023-12-04T00:18:28.527' AS DateTime))
GO
INSERT [dbo].[UserAddressDetail] ([AddressID], [UserID], [Address1], [Address2], [Address3], [District], [Province], [IsPrimary], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (3, 3, N'No 19', N'Kuruwita Street', N'Halpita', N'Kaluthara', N'Western', 1, 1, 3, N'::1', CAST(N'2023-09-12T23:44:48.140' AS DateTime), 3, N'::1', CAST(N'2024-03-22T08:31:50.910' AS DateTime))
GO
INSERT [dbo].[UserAddressDetail] ([AddressID], [UserID], [Address1], [Address2], [Address3], [District], [Province], [IsPrimary], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (4, 4, N'No- 34', N'Grama Road', N'Ihalawatte', N'Gampaha', N'Wetern', 1, 1, 4, N'::1', CAST(N'2023-09-12T23:49:42.210' AS DateTime), 4, N'::1', CAST(N'2023-12-04T00:12:01.700' AS DateTime))
GO
INSERT [dbo].[UserAddressDetail] ([AddressID], [UserID], [Address1], [Address2], [Address3], [District], [Province], [IsPrimary], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (5, 5, N'No 56', N'Wethara', N'Polgasowita', N'Colombo', N'Western', 1, 1, 5, N'::1', CAST(N'2024-03-19T09:48:21.857' AS DateTime), 5, N'::1', CAST(N'2024-03-21T15:37:36.927' AS DateTime))
GO
INSERT [dbo].[UserAddressDetail] ([AddressID], [UserID], [Address1], [Address2], [Address3], [District], [Province], [IsPrimary], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (6, 6, N'No 23/A', N'Kubuka', N'Gonapola', N'Kalutara', N'Western', 1, 1, 6, N'::1', CAST(N'2024-03-19T13:31:51.647' AS DateTime), 6, N'::1', CAST(N'2024-03-22T10:29:14.253' AS DateTime))
GO
INSERT [dbo].[UserAddressDetail] ([AddressID], [UserID], [Address1], [Address2], [Address3], [District], [Province], [IsPrimary], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (7, 7, N'No 23', N'Wattala', N'Colombo 7', N'Colombo', N'Western', 1, 1, 7, N'::1', CAST(N'2024-03-21T15:44:33.853' AS DateTime), 7, N'::1', CAST(N'2024-03-21T23:19:09.310' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[UserAddressDetail] OFF
GO
SET IDENTITY_INSERT [dbo].[UserImg] ON 
GO
INSERT [dbo].[UserImg] ([UserImgID], [UserID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (1, 2, N'user_2_1_20231203T211519.png', N'/uploads/usermgnt/user_2_1_20231203T211519.png', 2, N'::1', CAST(N'2023-12-03T21:15:20.010' AS DateTime))
GO
INSERT [dbo].[UserImg] ([UserImgID], [UserID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (8, 7, N'user_7_1_20240321T231909.png', N'/uploads/usermgnt/user_7_1_20240321T231909.png', 7, N'::1', CAST(N'2024-03-21T23:19:09.340' AS DateTime))
GO
INSERT [dbo].[UserImg] ([UserImgID], [UserID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (12, 3, N'user_3_1_20240321T233053.png', N'/uploads/usermgnt/user_3_1_20240321T233053.png', 3, N'::1', CAST(N'2024-03-21T23:30:53.707' AS DateTime))
GO
INSERT [dbo].[UserImg] ([UserImgID], [UserID], [ImageName], [ImageURL], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (18, 1, N'user_1_1_20240322T212024.png', N'/uploads/usermgnt/user_1_1_20240322T212024.png', 1, N'::1', CAST(N'2024-03-22T21:20:24.340' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[UserImg] OFF
GO
SET IDENTITY_INSERT [dbo].[UserRole] ON 
GO
INSERT [dbo].[UserRole] ([UserRoleID], [RoleName], [IsRegistrationViewAllowed], [IsActive]) VALUES (1, N'Admin', 0, 1)
GO
INSERT [dbo].[UserRole] ([UserRoleID], [RoleName], [IsRegistrationViewAllowed], [IsActive]) VALUES (2, N'Customer', 1, 1)
GO
INSERT [dbo].[UserRole] ([UserRoleID], [RoleName], [IsRegistrationViewAllowed], [IsActive]) VALUES (3, N'Contractor', 1, 1)
GO
INSERT [dbo].[UserRole] ([UserRoleID], [RoleName], [IsRegistrationViewAllowed], [IsActive]) VALUES (4, N'Vendor', 1, 1)
GO
SET IDENTITY_INSERT [dbo].[UserRole] OFF
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (1, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (1, 2, 1, 1, N'::1', CAST(N'2024-03-22T19:52:42.197' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (1, 3, 1, 1, N'::1', CAST(N'2024-03-09T10:28:44.537' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (1, 4, 1, 1, N'::1', CAST(N'2024-03-09T10:23:18.220' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (2, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (3, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (3, 2, 1, 1, N'::1', CAST(N'2024-03-22T19:52:42.197' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (3, 3, 1, 1, N'::1', CAST(N'2024-03-09T10:28:44.537' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (4, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (4, 3, 1, 1, N'::1', CAST(N'2024-03-09T10:28:44.537' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (6, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (6, 3, 1, 1, N'::1', CAST(N'2024-03-09T10:28:44.537' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (7, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (7, 3, 1, 1, N'::1', CAST(N'2024-03-09T10:28:44.537' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (9, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (9, 3, 1, 1, N'::1', CAST(N'2024-03-09T10:28:44.537' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (10, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (10, 2, 1, 1, N'::1', CAST(N'2024-03-22T19:52:42.197' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (10, 3, 1, 1, N'::1', CAST(N'2024-03-09T10:28:44.537' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (11, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (11, 2, 1, 1, N'::1', CAST(N'2024-03-22T19:52:42.197' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (13, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (13, 2, 1, 1, N'::1', CAST(N'2024-03-22T19:52:42.197' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (14, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (14, 2, 1, 1, N'::1', CAST(N'2024-03-22T19:52:42.197' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (15, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (15, 2, 1, 1, N'::1', CAST(N'2024-03-22T19:52:42.197' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (16, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (16, 4, 1, 1, N'::1', CAST(N'2024-03-09T10:23:18.220' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (17, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (17, 4, 1, 1, N'::1', CAST(N'2024-03-09T10:23:18.220' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (18, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (18, 4, 1, 1, N'::1', CAST(N'2024-03-09T10:23:18.220' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (19, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (19, 2, 1, 1, N'::1', CAST(N'2024-03-22T19:52:42.197' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (20, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (20, 4, 1, 1, N'::1', CAST(N'2024-03-09T10:23:18.220' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (21, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (21, 4, 1, 1, N'::1', CAST(N'2024-03-09T10:23:18.220' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (22, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (22, 4, 1, 1, N'::1', CAST(N'2024-03-09T10:23:18.220' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (23, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (23, 3, 1, 1, N'::1', CAST(N'2024-03-09T10:28:44.537' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (23, 4, 1, 1, N'::1', CAST(N'2024-03-09T10:23:18.220' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (24, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (24, 3, 1, 1, N'::1', CAST(N'2024-03-09T10:28:44.537' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (24, 4, 1, 1, N'::1', CAST(N'2024-03-09T10:23:18.220' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (25, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (25, 3, 1, 1, N'::1', CAST(N'2024-03-09T10:28:44.537' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (25, 4, 1, 1, N'::1', CAST(N'2024-03-09T10:23:18.220' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (26, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (26, 2, 1, 1, N'::1', CAST(N'2024-03-22T19:52:42.197' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (26, 3, 1, 1, N'::1', CAST(N'2024-03-09T10:28:44.537' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (26, 4, 1, 1, N'::1', CAST(N'2024-03-09T10:23:18.220' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (27, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (27, 2, 1, 1, N'::1', CAST(N'2024-03-22T19:52:42.197' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (27, 3, 1, 1, N'::1', CAST(N'2024-03-09T10:28:44.537' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (27, 4, 1, 1, N'::1', CAST(N'2024-03-09T10:23:18.220' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (28, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (28, 2, 1, 1, N'::1', CAST(N'2024-03-22T19:52:42.197' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (28, 3, 1, 1, N'::1', CAST(N'2024-03-09T10:28:44.537' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (28, 4, 1, 1, N'::1', CAST(N'2024-03-09T10:23:18.220' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (29, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (29, 2, 1, 1, N'::1', CAST(N'2024-03-22T19:52:42.197' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (29, 3, 1, 1, N'::1', CAST(N'2024-03-09T10:28:44.537' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (29, 4, 1, 1, N'::1', CAST(N'2024-03-09T10:23:18.220' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (30, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (31, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (32, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (33, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (34, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (35, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (36, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (37, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (37, 3, 1, 1, N'::1', CAST(N'2024-03-09T10:28:44.537' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (38, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (38, 3, 1, 1, N'::1', CAST(N'2024-03-09T10:28:44.537' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (39, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (39, 3, 1, 1, N'::1', CAST(N'2024-03-09T10:28:44.537' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (40, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (40, 4, 1, 1, N'::1', CAST(N'2024-03-09T10:23:18.220' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (41, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (41, 4, 1, 1, N'::1', CAST(N'2024-03-09T10:23:18.220' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (42, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (42, 4, 1, 1, N'::1', CAST(N'2024-03-09T10:23:18.220' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (43, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (43, 4, 1, 1, N'::1', CAST(N'2024-03-09T10:23:18.220' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (44, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (44, 4, 1, 1, N'::1', CAST(N'2024-03-09T10:23:18.220' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (45, 1, 1, 1, N'::1', CAST(N'2024-03-09T10:19:18.470' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (46, 2, 1, 1, N'::1', CAST(N'2024-03-22T19:52:42.197' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (47, 3, 1, 1, N'::1', CAST(N'2024-03-09T10:28:44.537' AS DateTime))
GO
INSERT [dbo].[UserRolePermission] ([UserPermissionID], [RoleID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime]) VALUES (48, 4, 1, 1, N'::1', CAST(N'2024-03-09T10:23:18.220' AS DateTime))
GO
INSERT [dbo].[VendorCategory] ([UserID], [VendorCategoryTypeID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (4, 1, 1, 4, N'::1', CAST(N'2023-12-04T00:12:01.703' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[VendorCategory] ([UserID], [VendorCategoryTypeID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (4, 2, 1, 4, N'::1', CAST(N'2023-12-04T00:12:01.703' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[VendorCategory] ([UserID], [VendorCategoryTypeID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (4, 5, 1, 4, N'::1', CAST(N'2023-12-04T00:12:01.703' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[VendorCategory] ([UserID], [VendorCategoryTypeID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (4, 7, 1, 4, N'::1', CAST(N'2023-12-04T00:12:01.703' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[VendorCategory] ([UserID], [VendorCategoryTypeID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (4, 8, 1, 4, N'::1', CAST(N'2023-12-04T00:12:01.703' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[VendorCategory] ([UserID], [VendorCategoryTypeID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (4, 11, 1, 4, N'::1', CAST(N'2023-12-04T00:12:01.703' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[VendorCategory] ([UserID], [VendorCategoryTypeID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (5, 2, 1, 5, N'::1', CAST(N'2024-03-21T15:37:36.930' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[VendorCategory] ([UserID], [VendorCategoryTypeID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (5, 4, 1, 5, N'::1', CAST(N'2024-03-21T15:37:36.930' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[VendorCategory] ([UserID], [VendorCategoryTypeID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (5, 5, 1, 5, N'::1', CAST(N'2024-03-21T15:37:36.930' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[VendorCategory] ([UserID], [VendorCategoryTypeID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (5, 9, 1, 5, N'::1', CAST(N'2024-03-21T15:37:36.930' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[VendorCategory] ([UserID], [VendorCategoryTypeID], [IsActive], [CreateUser], [CreateIP], [CreateDateTime], [ModUser], [ModIP], [ModDateTime]) VALUES (5, 12, 1, 5, N'::1', CAST(N'2024-03-21T15:37:36.930' AS DateTime), NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[VendorCategoryType] ON 
GO
INSERT [dbo].[VendorCategoryType] ([VendorCategoryTypeID], [VendorCategoryName], [IsActive]) VALUES (1, N'Steel', 1)
GO
INSERT [dbo].[VendorCategoryType] ([VendorCategoryTypeID], [VendorCategoryName], [IsActive]) VALUES (2, N'Concrete', 1)
GO
INSERT [dbo].[VendorCategoryType] ([VendorCategoryTypeID], [VendorCategoryName], [IsActive]) VALUES (3, N'Furniture', 1)
GO
INSERT [dbo].[VendorCategoryType] ([VendorCategoryTypeID], [VendorCategoryName], [IsActive]) VALUES (4, N'Electrical', 1)
GO
INSERT [dbo].[VendorCategoryType] ([VendorCategoryTypeID], [VendorCategoryName], [IsActive]) VALUES (5, N'Roofs', 1)
GO
INSERT [dbo].[VendorCategoryType] ([VendorCategoryTypeID], [VendorCategoryName], [IsActive]) VALUES (6, N'Ceilings', 1)
GO
INSERT [dbo].[VendorCategoryType] ([VendorCategoryTypeID], [VendorCategoryName], [IsActive]) VALUES (7, N'Floors', 1)
GO
INSERT [dbo].[VendorCategoryType] ([VendorCategoryTypeID], [VendorCategoryName], [IsActive]) VALUES (8, N'Paints', 1)
GO
INSERT [dbo].[VendorCategoryType] ([VendorCategoryTypeID], [VendorCategoryName], [IsActive]) VALUES (9, N'Masonry', 1)
GO
INSERT [dbo].[VendorCategoryType] ([VendorCategoryTypeID], [VendorCategoryName], [IsActive]) VALUES (10, N'Plastics', 1)
GO
INSERT [dbo].[VendorCategoryType] ([VendorCategoryTypeID], [VendorCategoryName], [IsActive]) VALUES (11, N'Plumbing', 1)
GO
INSERT [dbo].[VendorCategoryType] ([VendorCategoryTypeID], [VendorCategoryName], [IsActive]) VALUES (12, N'Security', 1)
GO
INSERT [dbo].[VendorCategoryType] ([VendorCategoryTypeID], [VendorCategoryName], [IsActive]) VALUES (13, N'Woodworking', 1)
GO
SET IDENTITY_INSERT [dbo].[VendorCategoryType] OFF
GO
INSERT [dbo].[Year] ([YearID], [YearName], [IsActive]) VALUES (1, N'2023', 1)
GO
INSERT [dbo].[Year] ([YearID], [YearName], [IsActive]) VALUES (2, N'2024', 1)
GO
ALTER TABLE [dbo].[Advertisement]  WITH CHECK ADD  CONSTRAINT [FK_Advertisement_User] FOREIGN KEY([CreateUser])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Advertisement] CHECK CONSTRAINT [FK_Advertisement_User]
GO
ALTER TABLE [dbo].[Advertisement]  WITH CHECK ADD  CONSTRAINT [FK_Advertisement_UserRole] FOREIGN KEY([UserRoleID])
REFERENCES [dbo].[UserRole] ([UserRoleID])
GO
ALTER TABLE [dbo].[Advertisement] CHECK CONSTRAINT [FK_Advertisement_UserRole]
GO
ALTER TABLE [dbo].[AdvertisementImg]  WITH CHECK ADD  CONSTRAINT [FK_AdvertisementImg_Advertisement] FOREIGN KEY([AdvID])
REFERENCES [dbo].[Advertisement] ([AdvID])
GO
ALTER TABLE [dbo].[AdvertisementImg] CHECK CONSTRAINT [FK_AdvertisementImg_Advertisement]
GO
ALTER TABLE [dbo].[ContractorService]  WITH CHECK ADD  CONSTRAINT [FK_ContractorService_ServiceType] FOREIGN KEY([ServiceTypeID])
REFERENCES [dbo].[ServiceType] ([ServiceTypeID])
GO
ALTER TABLE [dbo].[ContractorService] CHECK CONSTRAINT [FK_ContractorService_ServiceType]
GO
ALTER TABLE [dbo].[ContractorService]  WITH CHECK ADD  CONSTRAINT [FK_ContractorService_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[ContractorService] CHECK CONSTRAINT [FK_ContractorService_User]
GO
ALTER TABLE [dbo].[Item]  WITH CHECK ADD  CONSTRAINT [FK_Item_ItemInventoryUOM] FOREIGN KEY([UOM])
REFERENCES [dbo].[ItemInventoryUOM] ([ItemUOMID])
GO
ALTER TABLE [dbo].[Item] CHECK CONSTRAINT [FK_Item_ItemInventoryUOM]
GO
ALTER TABLE [dbo].[Item]  WITH CHECK ADD  CONSTRAINT [FK_Item_ItemInvWeightUnit] FOREIGN KEY([WeightUnit])
REFERENCES [dbo].[ItemInvWeightUnit] ([ItemWeightUnitID])
GO
ALTER TABLE [dbo].[Item] CHECK CONSTRAINT [FK_Item_ItemInvWeightUnit]
GO
ALTER TABLE [dbo].[Item]  WITH CHECK ADD  CONSTRAINT [FK_Item_User] FOREIGN KEY([VendorID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Item] CHECK CONSTRAINT [FK_Item_User]
GO
ALTER TABLE [dbo].[Item]  WITH CHECK ADD  CONSTRAINT [FK_Item_VendorCategoryType] FOREIGN KEY([VendorCategoryTypeID])
REFERENCES [dbo].[VendorCategoryType] ([VendorCategoryTypeID])
GO
ALTER TABLE [dbo].[Item] CHECK CONSTRAINT [FK_Item_VendorCategoryType]
GO
ALTER TABLE [dbo].[ItemInventory]  WITH CHECK ADD  CONSTRAINT [FK_ItemInventory_Item] FOREIGN KEY([ItemID])
REFERENCES [dbo].[Item] ([ItemID])
GO
ALTER TABLE [dbo].[ItemInventory] CHECK CONSTRAINT [FK_ItemInventory_Item]
GO
ALTER TABLE [dbo].[ItemInventory]  WITH CHECK ADD  CONSTRAINT [FK_ItemInventory_Order] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Order] ([OrderID])
GO
ALTER TABLE [dbo].[ItemInventory] CHECK CONSTRAINT [FK_ItemInventory_Order]
GO
ALTER TABLE [dbo].[ItemInventoryImg]  WITH CHECK ADD  CONSTRAINT [FK_ItemInventoryImg_Item] FOREIGN KEY([ItemID])
REFERENCES [dbo].[Item] ([ItemID])
GO
ALTER TABLE [dbo].[ItemInventoryImg] CHECK CONSTRAINT [FK_ItemInventoryImg_Item]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_OrderPaymentMethod] FOREIGN KEY([PaymentMethod])
REFERENCES [dbo].[OrderPaymentMethod] ([OrderPayMethodID])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_OrderPaymentMethod]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetail_Item] FOREIGN KEY([ItemID])
REFERENCES [dbo].[Item] ([ItemID])
GO
ALTER TABLE [dbo].[OrderDetail] CHECK CONSTRAINT [FK_OrderDetail_Item]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetail_Order] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Order] ([OrderID])
GO
ALTER TABLE [dbo].[OrderDetail] CHECK CONSTRAINT [FK_OrderDetail_Order]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetail_OrderStatusType] FOREIGN KEY([OrderDetailStatus])
REFERENCES [dbo].[OrderStatusType] ([OrderStatusID])
GO
ALTER TABLE [dbo].[OrderDetail] CHECK CONSTRAINT [FK_OrderDetail_OrderStatusType]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetail_User] FOREIGN KEY([VendorID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[OrderDetail] CHECK CONSTRAINT [FK_OrderDetail_User]
GO
ALTER TABLE [dbo].[OrderStatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_OrderStatusHistory_Order] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Order] ([OrderID])
GO
ALTER TABLE [dbo].[OrderStatusHistory] CHECK CONSTRAINT [FK_OrderStatusHistory_Order]
GO
ALTER TABLE [dbo].[OrderStatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_OrderStatusHistory_OrderStatusType] FOREIGN KEY([OrderStatus])
REFERENCES [dbo].[OrderStatusType] ([OrderStatusID])
GO
ALTER TABLE [dbo].[OrderStatusHistory] CHECK CONSTRAINT [FK_OrderStatusHistory_OrderStatusType]
GO
ALTER TABLE [dbo].[Project]  WITH CHECK ADD  CONSTRAINT [FK_Project_ProjectPriority] FOREIGN KEY([ProjectPriority])
REFERENCES [dbo].[ProjectPriority] ([ProjectPriorityID])
GO
ALTER TABLE [dbo].[Project] CHECK CONSTRAINT [FK_Project_ProjectPriority]
GO
ALTER TABLE [dbo].[Project]  WITH CHECK ADD  CONSTRAINT [FK_Project_ProjectSize] FOREIGN KEY([ProjectSize])
REFERENCES [dbo].[ProjectSize] ([ProjectSizeID])
GO
ALTER TABLE [dbo].[Project] CHECK CONSTRAINT [FK_Project_ProjectSize]
GO
ALTER TABLE [dbo].[Project]  WITH CHECK ADD  CONSTRAINT [FK_Project_ProjectStatus] FOREIGN KEY([ProjectStatus])
REFERENCES [dbo].[ProjectStatus] ([ProjectStatusID])
GO
ALTER TABLE [dbo].[Project] CHECK CONSTRAINT [FK_Project_ProjectStatus]
GO
ALTER TABLE [dbo].[ProjectTask]  WITH CHECK ADD  CONSTRAINT [FK_ProjectTask_Project] FOREIGN KEY([ProjectID])
REFERENCES [dbo].[Project] ([ProjectID])
GO
ALTER TABLE [dbo].[ProjectTask] CHECK CONSTRAINT [FK_ProjectTask_Project]
GO
ALTER TABLE [dbo].[ProjectTask]  WITH CHECK ADD  CONSTRAINT [FK_ProjectTask_ProjectPriority] FOREIGN KEY([TaskPriority])
REFERENCES [dbo].[ProjectPriority] ([ProjectPriorityID])
GO
ALTER TABLE [dbo].[ProjectTask] CHECK CONSTRAINT [FK_ProjectTask_ProjectPriority]
GO
ALTER TABLE [dbo].[ProjectTask]  WITH CHECK ADD  CONSTRAINT [FK_ProjectTask_ProjectTaskRateType] FOREIGN KEY([TaskRateType])
REFERENCES [dbo].[ProjectTaskRateType] ([TaskRateTypeID])
GO
ALTER TABLE [dbo].[ProjectTask] CHECK CONSTRAINT [FK_ProjectTask_ProjectTaskRateType]
GO
ALTER TABLE [dbo].[ProjectTask]  WITH CHECK ADD  CONSTRAINT [FK_ProjectTask_ProjectTaskStatus] FOREIGN KEY([TaskStatus])
REFERENCES [dbo].[ProjectTaskStatus] ([TaskStatusID])
GO
ALTER TABLE [dbo].[ProjectTask] CHECK CONSTRAINT [FK_ProjectTask_ProjectTaskStatus]
GO
ALTER TABLE [dbo].[ProjectTask]  WITH CHECK ADD  CONSTRAINT [FK_ProjectTask_ServiceType] FOREIGN KEY([ServiceType])
REFERENCES [dbo].[ServiceType] ([ServiceTypeID])
GO
ALTER TABLE [dbo].[ProjectTask] CHECK CONSTRAINT [FK_ProjectTask_ServiceType]
GO
ALTER TABLE [dbo].[ProjectTask]  WITH CHECK ADD  CONSTRAINT [FK_ProjectTask_TaskApprovalStatusType] FOREIGN KEY([ApprovalStatus])
REFERENCES [dbo].[TaskApprovalStatusType] ([TaskApprovalStatusID])
GO
ALTER TABLE [dbo].[ProjectTask] CHECK CONSTRAINT [FK_ProjectTask_TaskApprovalStatusType]
GO
ALTER TABLE [dbo].[ProjectTask]  WITH CHECK ADD  CONSTRAINT [FK_ProjectTask_User] FOREIGN KEY([AssignTo])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[ProjectTask] CHECK CONSTRAINT [FK_ProjectTask_User]
GO
ALTER TABLE [dbo].[ProjectTaskImg]  WITH CHECK ADD  CONSTRAINT [FK_ProjectTaskImg_ProjectTask] FOREIGN KEY([TaskID])
REFERENCES [dbo].[ProjectTask] ([TaskID])
GO
ALTER TABLE [dbo].[ProjectTaskImg] CHECK CONSTRAINT [FK_ProjectTaskImg_ProjectTask]
GO
ALTER TABLE [dbo].[ProjectTaskRejectInfo]  WITH CHECK ADD  CONSTRAINT [FK_ProjectTaskRejectInfo_ProjectTask] FOREIGN KEY([TaskID])
REFERENCES [dbo].[ProjectTask] ([TaskID])
GO
ALTER TABLE [dbo].[ProjectTaskRejectInfo] CHECK CONSTRAINT [FK_ProjectTaskRejectInfo_ProjectTask]
GO
ALTER TABLE [dbo].[ProjectTaskReview]  WITH CHECK ADD  CONSTRAINT [FK_ProjectTaskReview_ProjectTask] FOREIGN KEY([TaskID])
REFERENCES [dbo].[ProjectTask] ([TaskID])
GO
ALTER TABLE [dbo].[ProjectTaskReview] CHECK CONSTRAINT [FK_ProjectTaskReview_ProjectTask]
GO
ALTER TABLE [dbo].[ProjectTaskReview]  WITH CHECK ADD  CONSTRAINT [FK_ProjectTaskReview_User] FOREIGN KEY([ContractorID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[ProjectTaskReview] CHECK CONSTRAINT [FK_ProjectTaskReview_User]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_UserRole] FOREIGN KEY([UserRoleID])
REFERENCES [dbo].[UserRole] ([UserRoleID])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_UserRole]
GO
ALTER TABLE [dbo].[UserAddressDetail]  WITH CHECK ADD  CONSTRAINT [FK_UserAddressDetail_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[UserAddressDetail] CHECK CONSTRAINT [FK_UserAddressDetail_User]
GO
ALTER TABLE [dbo].[UserImg]  WITH CHECK ADD  CONSTRAINT [FK_UserImg_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[UserImg] CHECK CONSTRAINT [FK_UserImg_User]
GO
ALTER TABLE [dbo].[UserRolePermission]  WITH CHECK ADD  CONSTRAINT [FK_UserRolePermission_Permission] FOREIGN KEY([UserPermissionID])
REFERENCES [dbo].[Permission] ([PermissionID])
GO
ALTER TABLE [dbo].[UserRolePermission] CHECK CONSTRAINT [FK_UserRolePermission_Permission]
GO
ALTER TABLE [dbo].[UserRolePermission]  WITH CHECK ADD  CONSTRAINT [FK_UserRolePermission_UserRole] FOREIGN KEY([RoleID])
REFERENCES [dbo].[UserRole] ([UserRoleID])
GO
ALTER TABLE [dbo].[UserRolePermission] CHECK CONSTRAINT [FK_UserRolePermission_UserRole]
GO
ALTER TABLE [dbo].[VendorCategory]  WITH CHECK ADD  CONSTRAINT [FK_VendorCategory_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[VendorCategory] CHECK CONSTRAINT [FK_VendorCategory_User]
GO
ALTER TABLE [dbo].[VendorCategory]  WITH CHECK ADD  CONSTRAINT [FK_VendorCategory_VendorCategoryType] FOREIGN KEY([VendorCategoryTypeID])
REFERENCES [dbo].[VendorCategoryType] ([VendorCategoryTypeID])
GO
ALTER TABLE [dbo].[VendorCategory] CHECK CONSTRAINT [FK_VendorCategory_VendorCategoryType]
GO
/****** Object:  StoredProcedure [dbo].[SP_ADD_AdvMgntDetails]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-11-24
-- Description:	Save Advertisement details
-- =============================================
CREATE PROCEDURE [dbo].[SP_ADD_AdvMgntDetails] 
	-- Add the parameters for the stored procedure here
	@CampaignName nvarchar(50),
	@Description nvarchar(max),
	@StartDate date,
	@EndDate date,
	@IsActive bit,
	@UserRoleID int,
	@CreateUser int,
	@CreateIP nvarchar(100)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Insert into [dbo].[Advertisement]([CampaignName],[Description],
    [StartDate],[EndDate],[IsActive],[UserRoleID],
    [CreateUser],[CreateIP],[CreateDateTime])
	values (@CampaignName, @Description,
	@StartDate, @EndDate,@IsActive,@UserRoleID,
	@CreateUser, @CreateIP, GETDATE())

	--get saved AdvID
	declare @AdvID int;
	set @AdvID = SCOPE_IDENTITY();

	select 'New Advertisement Saved Successfully' as outputInfo, 1 as rsltType, @AdvID as savedID;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADD_AdvMgntImgURL]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-11-24
-- Description:	Save Advertisement Img Url Paths 
-- =============================================
CREATE PROCEDURE [dbo].[SP_ADD_AdvMgntImgURL]
	-- Add the parameters for the stored procedure here
	@AdvID int,
	@AdvImgURLJson NVARCHAR(MAX) = '[]',
	@CreateUser int,
	@CreateIP nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @TempAdvImgURLTable TABLE 
	(
		ImageName nvarchar(max),
		ImageURL nvarchar(max)
	);

    IF( @AdvImgURLJson <> '[]' )
	BEGIN
		
		Insert into @TempAdvImgURLTable (ImageName, ImageURL)
		Select ImageName, ImageURL
		From OPENJSON(@AdvImgURLJson) 
		WITH
		(
			ImageName nvarchar(max),
			ImageURL nvarchar(max)
		)

		--Delete all previous records
		delete from [dbo].[AdvertisementImg]
		where [AdvID] = @AdvID;

		insert into [dbo].[AdvertisementImg] ([AdvID],[ImageName],[ImageURL],
        [CreateUser],[CreateIP],[CreateDateTime])
		select @AdvID, s.ImageName, s.ImageURL,
		@CreateUser, @CreateIP, GETDATE()
		from @TempAdvImgURLTable as s

		select 'Advertisement Images Uploaded' as outputInfo, 1 as rsltType;

	END

END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADD_EmailLogDetails]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2024-02-26
-- Description:	Save Email Log
-- =============================================
CREATE PROCEDURE [dbo].[SP_ADD_EmailLogDetails] 
	-- Add the parameters for the stored procedure here
	@FromEmail nvarchar(100),
	@ToEmail nvarchar(100),
	@MailSubject nvarchar(250),
	@MailBody nvarchar(max),
	@IsSent bit

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Insert into [dbo].[EmailLog]([FromEmail], [ToEmail],
    [MailSubject], [MailBody],
    [IsSent], [CreateDateTime])
	values (@FromEmail, @ToEmail,
	@MailSubject, @MailBody,
	@IsSent, GETDATE())

	IF(@IsSent = 1)
	Begin
		select 'Email Generated Successfully' as outputInfo, 1 as rsltType;
	End
	Else
	Begin
		select 'Email Generating Failed' as outputInfo, 0 as rsltType;
	End
	

END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADD_ItemInventory]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-10-18
-- Description:	Add items to Item Inventory
-- =============================================
CREATE PROCEDURE [dbo].[SP_ADD_ItemInventory]
	-- Add the parameters for the stored procedure here
	@VendorCategoryTypeID int,
	@ItemName nvarchar(50),
	@ItemDescription nvarchar(100),
	@ItemWeight decimal(18,2),
	@WeightUnit int,
	@UOM int,
	@UnitAmount decimal(18,2),
	@MinQty decimal(18,2),
	@MaxQty decimal(18,2),
	@Qty decimal(18,2),
	@VendorID int,
	@IsSoldUnitWise bit,
	@IsActive bit,	
	@CreateUser int,
	@CreateIP nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--Header
    Insert into [dbo].[Item]([VendorCategoryTypeID],[ItemName],
    [ItemDescription],[ItemWeight],[WeightUnit],[UOM],[UnitAmount],
    [MinQty],[MaxQty],[VendorID],
    [IsSoldUnitWise],[IsActive],
    [CreateUser],[CreateIP],[CreateDateTime])
	values (@VendorCategoryTypeID, @ItemName,
	@ItemDescription, @ItemWeight, @WeightUnit, @UOM, @UnitAmount,
	@MinQty, @MaxQty, @VendorID,
	@IsSoldUnitWise, @IsActive,
	@CreateUser, @CreateIP, GETDATE())

	--get saved ItemID
	declare @ItemID int;
	set @ItemID = SCOPE_IDENTITY();

	--Detail
	Insert into [dbo].[ItemInventory] ([ItemID],[Qty],
    [IsInvAdded],[IsPurchased],[IsCurrent],
    [CreateUser],[CreateIP],[CreateDateTime])
	values(@ItemID, @Qty,
	1, 0, 1,
	@CreateUser, @CreateIP, GETDATE())

	select 'New Item Saved Successfully' as outputInfo, 1 as rsltType, @ItemID as savedID;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADD_ItemInventoryImgURL]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-10-25
-- Description:	Save Item Inv Img Url Paths 
-- =============================================
CREATE PROCEDURE [dbo].[SP_ADD_ItemInventoryImgURL]
	-- Add the parameters for the stored procedure here
	@ItemID int,
	@ItemImgURLJson NVARCHAR(MAX) = '[]',
	@CreateUser int,
	@CreateIP nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @TempItemImgURLTable TABLE 
	(
		ImageName nvarchar(max),
		ImageURL nvarchar(max)
	);

    IF( @ItemImgURLJson <> '[]' )
	BEGIN
		
		Insert into @TempItemImgURLTable (ImageName, ImageURL)
		Select ImageName, ImageURL
		From OPENJSON(@ItemImgURLJson) 
		WITH
		(
			ImageName nvarchar(max),
			ImageURL nvarchar(max)
		)

		--Delete all previous records
		delete from [dbo].[ItemInventoryImg]
		where [ItemID] = @ItemID;

		insert into [dbo].[ItemInventoryImg] ([ItemID],[ImageName],[ImageURL],
        [CreateUser],[CreateIP],[CreateDateTime])
		select @ItemID, s.ImageName, s.ImageURL,
		@CreateUser, @CreateIP, GETDATE()
		from @TempItemImgURLTable as s

		select 'Item Images Uploaded' as outputInfo, 1 as rsltType;

	END

END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADD_OrderDetails]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-11-13
-- Description:	Save Customer Order Details
-- =============================================
CREATE PROCEDURE [dbo].[SP_ADD_OrderDetails]
	-- Add the parameters for the stored procedure here
	@PaymentMethod int,
	@Address1 nvarchar(50),
	@Address2 nvarchar(50),
	@Address3 nvarchar(50),
	@District nvarchar(50),
	@Province nvarchar(50),
	@Remarks nvarchar(max),
	@Discount decimal(18,2),
	@SubTotal decimal(18,2),
	@DeliveryCharge decimal(18,2),
	@Total decimal(18,2),
	@CreateUser int,
	@CreateIP nvarchar(100),
	@OrderDetailJson NVARCHAR(MAX) = '[]'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @OrderDetailTable TABLE 
	(
		ItemID int,
		UnitAmount decimal(18,2),
		Quantity decimal(18,2),
		DiscountAmount decimal(18,2),
	    ItemWiseTotal decimal(18,2),
		VendorID int
	);

	IF( @OrderDetailJson <> '[]' )
	BEGIN
		
		Insert into @OrderDetailTable (ItemID, UnitAmount, Quantity, DiscountAmount, ItemWiseTotal, VendorID)
		Select ItemID, UnitAmount, Quantity, DiscountAmount, ItemWiseTotal, VendorID
		From OPENJSON(@OrderDetailJson) 
		WITH
		(
			ItemID int,
			UnitAmount decimal(18,2),
			Quantity decimal(18,2),
			DiscountAmount decimal(18,2),
			ItemWiseTotal decimal(18,2),
			VendorID int
		)

		--Order Header
		Insert into [dbo].[Order] ([PlacedDate],[EstDeliveryDate],[PaymentMethod],
        [Address1],[Address2],[Address3],[District],[Province],
        [Remarks],[Discount],[SubTotal],[DeliveryCharge],[Total],
        [CreateUser],[CreateIP],[CreateDateTime])
		values (getdate(), DATEADD(day, 3, getdate()), @PaymentMethod,
		@Address1, @Address2, @Address3, @District, @Province,
		@Remarks, @Discount, @SubTotal, @DeliveryCharge, @Total,
		@CreateUser, @CreateIP, getdate())

		--get saved OrderID
		declare @OrderID int;
		set @OrderID = SCOPE_IDENTITY();

		declare @OrderNumber nvarchar(max);

		--Generate order number
		select @OrderNumber = 'C'+''+cast(DATEPART(yyyy,GETDATE()) as varchar(4))+'/'+cast(REPLICATE('0',6 - len(@OrderID)) as nvarchar(6))+cast (@OrderID as nvarchar(6))

		Update [dbo].[Order]
		set [OrderNo] = @OrderNumber
		Where [OrderID] = @OrderID;

		--Vendor details
		Declare @VendorTable table(
			VendorID int
		)
		Insert into @VendorTable ([VendorID])
		Select d.VendorID
		From @OrderDetailTable as d
		Group by d.VendorID

		--Cursor (Start here)
		declare @selectedVendorID int;
		declare @PackageID int = 1;

	    declare orderDetailsCursor cursor local  for 
		select VendorID  from @VendorTable

		open orderDetailsCursor 
		fetch next from orderDetailsCursor into @selectedVendorID

		while @@FETCH_STATUS = 0  
        begin	   			

			--Order Details
			Insert into [dbo].[OrderDetail] ([OrderID],[PackageID],[ItemID],
			[UnitAmount],[Quantity],[DiscountAmount],[ItemWiseTotal],[VendorID],
			[OrderDetailStatus],[CreateUser],[CreateIP],[CreateDateTime])
			select @OrderID, @PackageID, o.ItemID,
			o.UnitAmount, o.Quantity, o.DiscountAmount, o.ItemWiseTotal, o.VendorID,
			1, @CreateUser, @CreateIP, getdate()
			from @OrderDetailTable as o
			where o.VendorID = @selectedVendorID;

			--Order Status History
			Insert into [dbo].[OrderStatusHistory] ([OrderID],[PackageID],[OrderStatus],[IsCurrent],
			[CreateUser],[CreateIP],[CreateDateTime])
			Values (@OrderID, @PackageID,1,1,
			@CreateUser,@CreateIP, getdate())

			--Update Inventory Table
			Insert into [dbo].[ItemInventory] ([ItemID],[Qty],
			[IsInvAdded],[IsPurchased],[OrderID],[IsCurrent],
			[CreateUser],[CreateIP],[CreateDateTime])
			select d.ItemID, -(d.Quantity), 
			0, 1, @OrderID, 0,
			@CreateUser,@CreateIP, getdate()
			from @OrderDetailTable as d
			where d.VendorID = @selectedVendorID;

			set @PackageID = @PackageID + 1;

			fetch next from orderDetailsCursor into @selectedVendorID

		end

		close orderDetailsCursor  
        deallocate orderDetailsCursor
		--Cursor (End here)

		select 'Order Saved Successfully' as outputInfo, 1 as rsltType, @OrderID as savedID;

	END

END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADD_PermissionDetails]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-12-10
-- Description:	Save Permission details
-- =============================================
CREATE PROCEDURE [dbo].[SP_ADD_PermissionDetails] 
	-- Add the parameters for the stored procedure here
	@ScreenName nvarchar(50),
	@PermissionName nvarchar(100),
	@IsActive bit,
	@CreateUser int,
	@CreateIP nvarchar(100)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @IsPermiAvailable int;
	select @IsPermiAvailable = COUNT(*)
	from [dbo].[Permission] as p
	where lower(p.PermissionName) = lower(@PermissionName);

	--when entered permission already available
	If(@IsPermiAvailable > 0)
	Begin
		select 'Entered Permission already available' as outputInfo, 0 as rsltType;
	End

	Else
	Begin

		Insert into [dbo].[Permission]([ScreenName],[PermissionName],[IsActive],
		[CreateUser],[CreateIP],[CreateDateTime])
		values (@ScreenName, @PermissionName,@IsActive,
		@CreateUser, @CreateIP, GETDATE());

		select 'New Permission Saved Successfully' as outputInfo, 1 as rsltType;

	End

 

END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADD_ProjectDetails]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-09-02
-- Description:	Save Contruction Project Details
-- =============================================
CREATE PROCEDURE [dbo].[SP_ADD_ProjectDetails]
	-- Add the parameters for the stored procedure here
	@ProjectTitle nvarchar(100),
	@ClientID int,
	@ProjectPriority int,
	@ProjectSize int,
	@StartDate date,
	@StartTime time(7),
	@EndDate date,
	@EndTime time(7),
	@Description nvarchar(max),
	@ProjectStatus int,
	@CreateUser int,
	@CreateIP nvarchar(100)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Insert into [dbo].[Project]([ProjectTitle],[ClientID],
	[ProjectPriority],[ProjectSize],
	[StartDate],[StartTime],
	[EndDate],[EndTime],
	[Description],[ProjectStatus],
	[CreateUser],[CreateIP],[CreateDateTime])
	values (@ProjectTitle, @ClientID,
	@ProjectPriority, @ProjectSize,
	@StartDate, @StartTime,
	@EndDate, @EndTime,
	@Description, @ProjectStatus,
	@CreateUser, @CreateIP, GETDATE())

	select 'New Project Details Saved Successfully' as outputInfo, 1 as rsltType;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADD_ProjectTask]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-09-05
-- Description:	Save Project Task
-- =============================================
CREATE PROCEDURE [dbo].[SP_ADD_ProjectTask] 
	-- Add the parameters for the stored procedure here
	@ProjectID int,
	@TaskName nvarchar(100),
	@TaskRate decimal(18,2),
	@TaskRateType int,
	@TaskPriority int,
	@TaskStatus int,
	@Description nvarchar(max),
	@StartDate date,
	@StartTime time(7),
	@EndDate date,
	@EndTime time(7),
	@ServiceType int,
	@AssignTo int,
	@CreateUser int,
	@CreateIP nvarchar(100)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Insert into [dbo].[ProjectTask]([ProjectID],[TaskName],
	[TaskRate],[TaskRateType],
	[TaskPriority],[TaskStatus],[Description],
    [StartDate],[StartTime],
    [EndDate],[EndTime],
    [ServiceType],[AssignTo],[ApprovalStatus],
    [CreateUser],[CreateIP],[CreateDateTime])
	values (@ProjectID, @TaskName,
	@TaskRate, @TaskRateType,
	@TaskPriority, @TaskStatus, @Description,
	@StartDate, @StartTime,
	@EndDate, @EndTime,
	@ServiceType, @AssignTo, 0,
	@CreateUser, @CreateIP, GETDATE())

	--get saved TaskID
	declare @TaskID int;
	set @TaskID = SCOPE_IDENTITY();

	select 'New Task Saved Successfully' as outputInfo, 1 as rsltType, @TaskID as savedID;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADD_ProjectTaskImgURL]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-09-24
-- Description:	Save task Img Url Paths 
-- =============================================
CREATE PROCEDURE [dbo].[SP_ADD_ProjectTaskImgURL]
	-- Add the parameters for the stored procedure here
	@TaskID int,
	@TaskImgURLJson NVARCHAR(MAX) = '[]',
	@CreateUser int,
	@CreateIP nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @TempTaskImgURLTable TABLE 
	(
		ImageName nvarchar(max),
		ImageURL nvarchar(max)
	);

    IF( @TaskImgURLJson <> '[]' )
	BEGIN
		
		Insert into @TempTaskImgURLTable (ImageName, ImageURL)
		Select ImageName, ImageURL
		From OPENJSON(@TaskImgURLJson) 
		WITH
		(
			ImageName nvarchar(max),
			ImageURL nvarchar(max)
		)

		--Delete all previous records
		delete from [dbo].[ProjectTaskImg]
		where [TaskID] = @TaskID;

		insert into [dbo].[ProjectTaskImg] ([TaskID],[ImageName],[ImageURL],
		[CreateUser],[CreateIP],[CreateDateTime])
		select @TaskID, s.ImageName, s.ImageURL,
		@CreateUser, @CreateIP, GETDATE()
		from @TempTaskImgURLTable as s

		select 'Project Images Uploaded' as outputInfo, 1 as rsltType;

	END

END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADD_ProjectTaskRejectInfo]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-10-03
-- Description:	Save task related user reject reasons 
-- =============================================
CREATE PROCEDURE [dbo].[SP_ADD_ProjectTaskRejectInfo]
	-- Add the parameters for the stored procedure here
	@TaskID int,
	@Reason nvarchar(max),
	@CreateUser int,
	@CreateIP nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --update task approval status
    Update [dbo].[ProjectTask] 
	Set [ApprovalStatus] = 2
	Where [TaskID] = @TaskID;

	Insert into [dbo].[ProjectTaskRejectInfo] ([TaskID],[Reason],
    [CreateUser],[CreateIP],[CreateDateTime])
	values (@TaskID, @Reason,
	@CreateUser, @CreateIP, GETDATE());

	select 'Task Rejected Successfully' as outputInfo, 1 as rsltType, @TaskID as savedID;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADD_ProjectTaskReviews]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-10-03
-- Description:	Save task related user reviews 
-- =============================================
CREATE PROCEDURE [dbo].[SP_ADD_ProjectTaskReviews]
	-- Add the parameters for the stored procedure here
	@TaskID int,
	@Rating int,
	@Comment nvarchar(max),
	@ContractorID int,
	@IsVisitedSite bit,
	@CreateUser int,
	@CreateIP nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--update task approval status
    Update [dbo].[ProjectTask] 
	Set [ApprovalStatus] = 1
	Where [TaskID] = @TaskID;

	Insert into [dbo].[ProjectTaskReview] ([TaskID],[Rating],[Comment],
	[ContractorID],[IsVisitedSite],
	[CreateUser],[CreateIP],[CreateDateTime])
	values (@TaskID, @Rating, @Comment,
	@ContractorID, @IsVisitedSite,
	@CreateUser, @CreateIP, GETDATE());

	select 'Task Approved Successfully' as outputInfo, 1 as rsltType, @TaskID as savedID;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADD_UserDetails]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-09-10
-- Description:	Register a new User
-- =============================================
CREATE PROCEDURE [dbo].[SP_ADD_UserDetails]
	-- Add the parameters for the stored procedure here
	@FirstName nvarchar(100),
	@LastName nvarchar(100),
	@Username nvarchar(50),
	@Email nvarchar(max),
	@Password nvarchar(max),
	@NIC nvarchar(12),
	@MobileNo nvarchar(10),
	@Address1 nvarchar(50),
	@Address2 nvarchar(50),
	@Address3 nvarchar(50),
	@District nvarchar(50),
	@Province nvarchar(50),
	@UserRoleID int,
	@ContractorServiceList nvarchar(MAX) = '',
	@VendorCategoryList nvarchar(MAX) = '',
	@CreateIP nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--Username validation
	declare @IsUsernameAvailable int;
	select @IsUsernameAvailable = COUNT(*)
	from [dbo].[User] as u
	where u.Username =  @Username;

	--Email validation
	declare @IsEmailAvailable int;
	select @IsEmailAvailable = COUNT(*)
	from [dbo].[User] as u
	where u.Email =  @Email;

	If(@IsUsernameAvailable > 0)
	Begin
		select 'Entered Username already registered in the system. Please enter a new Username' as outputInfo, 0 as rsltType;
	End
	Else If(@IsEmailAvailable > 0)
	Begin
		select 'Entered Email already registered in the system. Please enter a new Email' as outputInfo, 0 as rsltType;
	End
	Else
	Begin
		Insert into [dbo].[User] ([Username],[Email],
		[FirstName],[LastName],[UserRoleID],
		[NIC],[MobileNo],
		[Password],[AttemptCount],[IsTempPassword],[IsActive],
		[CreateUser],[CreateIP],[CreateDateTime])
		Values (@Username, @Email,
		@FirstName, @LastName, @UserRoleID,
		@NIC, @MobileNo,
		@Password, 0, 0, 1,
		0, @CreateIP, GETDATE());
	
		--get saved UserID
		declare @UserID int;
		set @UserID = SCOPE_IDENTITY();

		--update create user
		update [dbo].[User]
		set [CreateUser] = @UserID
		where UserID = @UserID;

		--Add User Address Details
		Insert into [dbo].[UserAddressDetail] ([UserID],
		[Address1],[Address2],[Address3],
		[District],[Province],
		[IsPrimary],[IsActive],
		[CreateUser],[CreateIP],[CreateDateTime])
		Values (@UserID,
		@Address1, @Address2, @Address3,
		@District, @Province,
		1, 1,
		@UserID, @CreateIP, GETDATE());

		--When User is a Contractor
		If(@UserRoleID = 3)
		Begin
			
			DECLARE @ContractorServiceTable TABLE (ServiceTypeID int);
			Insert into @ContractorServiceTable 
			Select CAST([value] AS int) 
			From STRING_SPLIT(@ContractorServiceList, ','); 

			Insert into [dbo].[ContractorService] ([UserID],[ServiceTypeID],[IsActive],
			[CreateUser],[CreateIP],[CreateDateTime])
			Select @UserID, c.ServiceTypeID,1,
			@UserID,@CreateIP,GETDATE()
			From @ContractorServiceTable as c

		End
		--When User is a Vendor
		Else If(@UserRoleID = 4)
		Begin

			DECLARE @VendorCategoryTable TABLE (VendorCategoryTypeID int);
			Insert into @VendorCategoryTable 
			Select CAST([value] AS int) 
			From STRING_SPLIT(@VendorCategoryList, ','); 

			Insert into [dbo].[VendorCategory] ([UserID],[VendorCategoryTypeID],[IsActive],
			[CreateUser],[CreateIP],[CreateDateTime])
			Select @UserID, v.VendorCategoryTypeID,1,
			@UserID,@CreateIP,GETDATE()
			From @VendorCategoryTable as v

		End

		select 'User Registered Successfully' as outputInfo, 1 as rsltType;

	End

END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADD_UserProfImgURL]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-12-02
-- Description:	Save User Img Url Paths 
-- =============================================
CREATE PROCEDURE [dbo].[SP_ADD_UserProfImgURL]
	-- Add the parameters for the stored procedure here
	@UserID int,
	@UserImgURLJson NVARCHAR(MAX) = '[]',
	@CreateUser int,
	@CreateIP nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @TempUserImgURLTable TABLE 
	(
		ImageName nvarchar(max),
		ImageURL nvarchar(max)
	);

    IF( @UserImgURLJson <> '[]' )
	BEGIN
		
		Insert into @TempUserImgURLTable (ImageName, ImageURL)
		Select ImageName, ImageURL
		From OPENJSON(@UserImgURLJson) 
		WITH
		(
			ImageName nvarchar(max),
			ImageURL nvarchar(max)
		)

		--Delete all previous records
		delete from [dbo].[UserImg]
		where [UserID] = @UserID;

		insert into [dbo].[UserImg] ([UserID],[ImageName],[ImageURL],
        [CreateUser],[CreateIP],[CreateDateTime])
		select @UserID, s.ImageName, s.ImageURL,
		@CreateUser, @CreateIP, GETDATE()
		from @TempUserImgURLTable as s

		select 'User Image Uploaded' as outputInfo, 1 as rsltType;

	END

END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADD_UserRolePermissionDetails]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-12-19
-- Description:	Save User role wise permissions
-- =============================================
CREATE PROCEDURE [dbo].[SP_ADD_UserRolePermissionDetails]
	-- Add the parameters for the stored procedure here
	@RoleID int,
	@RoleWisePermissionJson NVARCHAR(MAX) = '[]',
	@CreateUser int,
	@CreateIP nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @TempRoleWisePermissionTable TABLE 
	(
		PermissionID int
	);

    IF( @RoleWisePermissionJson <> '[]' )
	BEGIN
		
		Insert into @TempRoleWisePermissionTable (PermissionID)
		Select PermissionID
		From OPENJSON(@RoleWisePermissionJson) 
		WITH
		(
			PermissionID int
		)

		--Delete all previous records
		delete from [dbo].[UserRolePermission]
		where [RoleID] = @RoleID;

		insert into [dbo].[UserRolePermission] ([UserPermissionID],[RoleID],[IsActive],
        [CreateUser],[CreateIP],[CreateDateTime])
		select s.PermissionID, @RoleID, 1,
		@CreateUser, @CreateIP, GETDATE()
		from @TempRoleWisePermissionTable as s

		select 'User Role Permissions saved successfully.' as outputInfo, 1 as rsltType;

	END

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_AdvMgntDetails]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-11-24
-- Description:	Load Advertisement details by UserID
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_AdvMgntDetails]
	-- Add the parameters for the stored procedure here
	@UserID int,
	@StartDate nvarchar(20),
	@EndDate nvarchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @StartDateFormatted date;
	Declare @EndDateFormatted date;

	--initial load
	If(@StartDate = 'null' and @EndDate = 'null')
	Begin
		select ad.[AdvID],ad.[CampaignName],ad.[Description],
		convert(varchar(10), ad.[StartDate], 101) as [StartDate], convert(varchar(10), ad.[EndDate], 101) as [EndDate], ad.[IsActive]
		From [dbo].[Advertisement] as ad
		Where ad.CreateUser = @UserID
		order by ad.[AdvID] desc;
	End
	--with date filter
	Else
	Begin
		set @StartDateFormatted = @StartDate;
		set @EndDateFormatted = @EndDate;

		select ad.[AdvID],ad.[CampaignName],ad.[Description],
		convert(varchar(10), ad.[StartDate], 101) as [StartDate], convert(varchar(10), ad.[EndDate], 101) as [EndDate], ad.[IsActive]
		From [dbo].[Advertisement] as ad
		Where ad.CreateUser = @UserID 
		and ((ad.[StartDate] between @StartDateFormatted and @EndDateFormatted) or (ad.[EndDate] between @StartDateFormatted and @EndDateFormatted)
		or (@StartDateFormatted between ad.[StartDate] and ad.[EndDate]) or (@EndDateFormatted between  ad.[StartDate] and ad.[EndDate]))
		order by ad.[AdvID] desc;
	End

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_AdvMgntImgUrlsByAdvID]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-11-24
-- Description:	Get Img Urls by AdvID
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_AdvMgntImgUrlsByAdvID]
	-- Add the parameters for the stored procedure here
	@AdvID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Select ti.ImageName, ti.ImageURL
	From [dbo].[AdvertisementImg] as ti
	Where ti.AdvID = @AdvID;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_AuthorizeUser]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-08-26
-- Description:	Authorize User
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_AuthorizeUser]
	-- Add the parameters for the stored procedure here
	@Username nvarchar(50),
	@Password nvarchar(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--Authenticate User
	Declare @IsAuthorized int;
	Declare @AuthUserDetails table(
		[UserID] [int] NULL,
		[Username] [nvarchar](50) NULL,
		[FullName] [nvarchar](max) NULL,
		[UserRoleID] [int] NULL,
		[UserRoleName] [nvarchar](max) NULL,
		[AttemptCount] [int] NULL,
		[IsTempPassword] [bit] NULL,
		--common parameters
		[DeliveryCharge] [decimal](18,2)
	);
	
	Select @IsAuthorized = COUNT(*)
	From [dbo].[User] as u
	Where u.[Username] = @Username and u.[Password] = @Password and u.[IsActive] = 1;

	--common parameters
	Declare @DeliveryCharge decimal(18,2);
	Select @DeliveryCharge = p.[Value]
    From [dbo].[CMMSAppParameter] as p
	Where p.ParameterName = 'DeliveryCharge';

	If(@IsAuthorized = 1)
	Begin
		
		Insert into @AuthUserDetails ([UserID], [Username], [FullName], [UserRoleID], [UserRoleName], [AttemptCount], [IsTempPassword],
		--common parameters
		[DeliveryCharge])
		Select u.[UserID], u.[Username], CONCAT(u.[FirstName],' ',u.[LastName]) as [FullName],
		u.[UserRoleID], ur.[RoleName], u.[AttemptCount], u.[IsTempPassword],
		--common parameters
		@DeliveryCharge
		From [dbo].[User] as u
		left join [dbo].[UserRole] as ur on u.UserRoleID = ur.UserRoleID
		Where u.[Username] = @Username and u.[IsActive] = 1;

		--update login attempts
		Update [dbo].[User]
		set [AttemptCount] = 0
		where [Username] = @Username;

		--User details
		select * from @AuthUserDetails;
		--Msg
		select 'User Authorized Successfully' as outputInfo, 1 as rsltType;

	End
	Else
	Begin
		
		declare @ValidationMsg nvarchar(max);	

		declare @CurrentAttemptCount int;
		--current attempt count
		select @CurrentAttemptCount = u.[AttemptCount]
		from [dbo].[User] as u
		where u.[Username] = @Username;

		--User details
		select * from @AuthUserDetails;

		If(@CurrentAttemptCount >= 5)
		Begin			
			Update [dbo].[User]
			set [IsActive] = 0
			where [Username] = @Username;

			set @ValidationMsg = 'Your account has been locked because of consecutive failed login attempts. Please contact System Administrator.';
		End
		Else
		Begin
			--update login attempts
			Update [dbo].[User]
			set [AttemptCount] = [AttemptCount] + 1
			where [Username] = @Username;

			set @ValidationMsg = 'Entered Username and Password is Invalid';
		End
		
		--Msg
		select @ValidationMsg as outputInfo, 0 as rsltType;

	End
    

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ContractorsByServiceTypeID]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-09-16
-- Description:	Get Contractors by ServiceTypeID
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_ContractorsByServiceTypeID]
	-- Add the parameters for the stored procedure here
	@ServiceTypeID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Select cs.UserID as [ValueID], concat(u.FirstName,' ',u.LastName) as [Value] 
	from [dbo].[ContractorService] as cs
	left join [dbo].[User] as u on cs.UserID = u.UserID
	where cs.ServiceTypeID = @ServiceTypeID;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_DashBoardAdminDetails]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2024-02-28
-- Description:	Get Admin Dashboard Details
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_DashBoardAdminDetails]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --Total Sales Amount
	select isnull(SUM(t.Total + t.DeliveryCharge),0) as TotalSales
	from
	(select SUM(od.ItemWiseTotal) as Total, max(o.DeliveryCharge) as DeliveryCharge
	from [dbo].[Order] as o
	left join [dbo].[OrderDetail] as od on o.OrderID = od.OrderID
	where od.OrderDetailStatus <> 4 -- 4 is Cancelled Orders
	group by o.OrderID) as t

	--Total Items
	select isnull(COUNT(i.ItemID),0) as TotalItems
	from [dbo].[Item] as i
	where i.IsActive = 1;

	--Total Orders
	select isnull(COUNT(*),0) as TotalOrders
	from
	(select o.OrderID
	from [dbo].[Order] as o
	left join [dbo].[OrderDetail] as od on o.OrderID = od.OrderID
	where od.OrderDetailStatus <> 4 -- 4 is Cancelled Orders
	group by o.OrderID) as t

	--Total Users
	select isnull(COUNT(u.UserID),0) as TotalUsers
	from [dbo].[User] as u
	where u.IsActive = 1

	--Best Contractor
	select top (1) isnull(t.ContractorName, ' - ') as BestContractor
	from
	(select pr.ContractorID, concat(u.FirstName,' ',u.LastName) as ContractorName,
	cast(ROUND(AVG(cast(Rating as decimal(18,2))), 2) as decimal(18,2)) as OverallRating
	from [dbo].[ProjectTaskReview] as pr
	left join [dbo].[User] as u on u.UserID = pr.ContractorID
	group by pr.ContractorID, concat(u.FirstName,' ',u.LastName) ) as t
	order by t.OverallRating desc

	--Best Customer
	select top (1) isnull(t.CustomerName, ' - ') as BestCustomer
	from
	(select o.OrderID, concat(u.FirstName,' ',u.LastName) as CustomerName
	from [dbo].[Order] as o
	left join [dbo].[OrderDetail] as od on o.OrderID = od.OrderID
	left join [dbo].[User] as u on u.UserID = o.CreateUser
	where od.OrderDetailStatus <> 4 -- 4 is Cancelled Orders
	group by o.OrderID,concat(u.FirstName,' ',u.LastName)) as t
	group by t.CustomerName
	order by COUNT(t.OrderID) desc

	--Best Vendor
	select top (1) isnull(t.VendorName, ' - ') as BestVendor
	from
	(select od.OrderID, concat(u.FirstName,' ',u.LastName) as VendorName
	from [dbo].[Order] as o
	left join [dbo].[OrderDetail] as od on o.OrderID = od.OrderID
	left join [dbo].[User] as u on u.UserID = od.VendorID
	where od.OrderDetailStatus <> 4 -- 4 is Cancelled Orders
	group by od.OrderID,concat(u.FirstName,' ',u.LastName) ) as t
	group by t.VendorName
	order by COUNT(t.OrderID) desc

	--Recent All Projects
	select top (5) p.ProjectTitle, concat(con.FirstName,' ',con.LastName) as ContractorName, 
	concat(u.FirstName,' ',u.LastName) as ClientName,
	[dbo].[FUNC_GET_ProjectPercentageByProjectID](p.ProjectID) as ProjectProgress
	from [dbo].[Project] as p
	left join [dbo].[User] as con on p.CreateUser = con.UserID
	left join [dbo].[User] as u on p.ClientID = u.UserID
	left join [dbo].[ProjectStatus] as ps on p.ProjectStatus = ps.ProjectStatusID
	and ProjectStatus in (1,2)
	order by [dbo].[FUNC_GET_ProjectPercentageByProjectID](p.ProjectID), p.StartDate desc;

	--Recent All Orders
	select top (5) o.OrderNo, concat(ven.FirstName,' ',ven.LastName) as VendorName, 
	concat(u.FirstName,' ',u.LastName) as CustomerName, convert(varchar(10), o.PlacedDate, 120) as PlacedDate
	from [dbo].[Order] as o
	left join [dbo].[OrderDetail] as od on o.OrderID = od.OrderID
	left join [dbo].[User] as ven on od.VendorID = ven.UserID
	left join [dbo].[User] as u on o.CreateUser = u.UserID
	where od.OrderDetailStatus <> 4 -- 4 is Cancelled Orders
	group by o.OrderNo, o.CreateDateTime, concat(ven.FirstName,' ',ven.LastName), concat(u.FirstName,' ',u.LastName),
	convert(varchar(10), o.PlacedDate, 120)
	order by o.CreateDateTime desc

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_DashBoardContractorDetails]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2024-02-28
-- Description:	Get Contractor Dashboard Details
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_DashBoardContractorDetails]
(
	@UserID int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--Total Projects
	select isnull(count(p.ProjectID),0) as TotalProjects
	from [dbo].[Project] as p
	where p.CreateUser = @UserID and p.ProjectStatus in (1,2)

	--My Best Client
	select top(1) isnull(t.ClientName, ' - ') as BestClient
	from
	(select p.ClientID, concat(u.FirstName,' ',u.LastName) as ClientName, COUNT(*) as TotalProjects
	from [dbo].[Project] as p
	left join [dbo].[User] as u on u.UserID = p.ClientID
	where p.CreateUser = @UserID and p.ProjectStatus in (1,2)
	group by p.ClientID, concat(u.FirstName,' ',u.LastName) ) as t
	order by t.TotalProjects desc

	--My Overall Rating
	select top (1) isnull(t.OverallRating, 0) as MyOverallRating
	from
	(select pr.ContractorID, concat(u.FirstName,' ',u.LastName) as ContractorName,
	cast(ROUND(AVG(cast(Rating as decimal(18,2))), 2) as decimal(18,2)) as OverallRating
	from [dbo].[ProjectTaskReview] as pr
	left join [dbo].[User] as u on u.UserID = pr.ContractorID
	where pr.ContractorID = @UserID
	group by pr.ContractorID, concat(u.FirstName,' ',u.LastName) ) as t
	order by t.OverallRating desc

	--My Recent Projects 
	select top (5) p.ProjectTitle,
	concat(u.FirstName,' ',u.LastName) as ClientName,
	[dbo].[FUNC_GET_ProjectPercentageByProjectID](p.ProjectID) as ProjectProgress
	from [dbo].[Project] as p
	left join [dbo].[User] as con on p.CreateUser = con.UserID
	left join [dbo].[User] as u on p.ClientID = u.UserID
	left join [dbo].[ProjectStatus] as ps on p.ProjectStatus = ps.ProjectStatusID
	where  p.CreateUser = @UserID and ProjectStatus in (1,2)
	order by [dbo].[FUNC_GET_ProjectPercentageByProjectID](p.ProjectID), p.StartDate desc;

	--My Recent Completed Tasks
	select top(5) tsk.TaskName, pro.ProjectTitle, 
	concat(cl.FirstName,' ', cl.LastName) as ClientName,
	convert(varchar(10), tsk.ModDateTime, 120) as CompletedDate
	from [dbo].[ProjectTask] as tsk
	left join [dbo].[Project] as pro on tsk.ProjectID = pro.ProjectID
	left join [dbo].[User] as u on tsk.AssignTo = u.UserID
	left join [dbo].[User] as cl on pro.ClientID = cl.UserID
	where tsk.CreateUser = @UserID
	and tsk.TaskStatus = 3 -- 3 is Completed Status
	order by tsk.CreateDateTime desc

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_DashBoardCustomerDetails]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2024-02-28
-- Description:	Get Customer Dashboard Details
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_DashBoardCustomerDetails]
(
	@UserID int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--Total Orders
	select isnull(COUNT(*),0) as TotalOrders
	from
	(select o.OrderID
	from [dbo].[Order] as o
	left join [dbo].[OrderDetail] as od on o.OrderID = od.OrderID
	where od.OrderDetailStatus <> 4 -- 4 is Cancelled Orders
	and o.CreateUser = @UserID
	group by o.OrderID) as t

	--Most Preferred Contractor
	select top (1) isnull(t.ContractorName, ' - ') as PreferredContractor
	from 
	(select p.CreateUser,
	concat(con.FirstName,' ',con.LastName) as ContractorName,
	count(*) as ProjectCount
	from [dbo].[Project] as p
	left join [dbo].[User] as con on p.CreateUser = con.UserID
	where p.ClientID = @UserID and p.ProjectStatus in (1,2)
	group by p.CreateUser, concat(con.FirstName,' ',con.LastName) ) as t
	order by t.ProjectCount desc

	--Most Preferred Vendor
	select top (1) isnull(t.VendorName, ' - ') as PreferredVendor
	from
	(select od.OrderID, concat(u.FirstName,' ',u.LastName) as VendorName
	from [dbo].[Order] as o
	left join [dbo].[OrderDetail] as od on o.OrderID = od.OrderID
	left join [dbo].[User] as u on u.UserID = od.VendorID
	where od.OrderDetailStatus <> 4 -- 4 is Cancelled Orders
	and o.CreateUser = @UserID
	group by od.OrderID,concat(u.FirstName,' ',u.LastName) ) as t
	group by t.VendorName
	order by COUNT(t.OrderID) desc

	--Advertisement
	select top (10) adv.AdvID, img.ImageName, img.ImageURL
	from [dbo].[Advertisement] as adv
	left join [dbo].[AdvertisementImg] as img on adv.AdvID = img.AdvID 
	where adv.IsActive = 1 and (cast(GETDATE() as date) between adv.StartDate and adv.Enddate)
	order by adv.CreateDateTime desc

	--Recent Orders
	select top (5) o.OrderNo, concat(ven.FirstName,' ',ven.LastName) as VendorName, 
	convert(varchar(10), o.PlacedDate, 120) as PlacedDate
	from [dbo].[Order] as o
	left join [dbo].[OrderDetail] as od on o.OrderID = od.OrderID
	left join [dbo].[User] as ven on od.VendorID = ven.UserID
	where od.OrderDetailStatus <> 4 -- 4 is Cancelled Orders
	and o.CreateUser = @UserID
	group by o.OrderNo, o.CreateDateTime, concat(ven.FirstName,' ',ven.LastName),
	convert(varchar(10), o.PlacedDate, 120)
	order by o.CreateDateTime desc

	--Recent Tasks
	select top(5) tsk.TaskName, pro.ProjectTitle, 
	concat(u.FirstName,' ', u.LastName) as ContractorName,
	tsk.TaskStatus,  ts.TaskStatusName
	from [dbo].[ProjectTask] as tsk
	left join [dbo].[Project] as pro on tsk.ProjectID = pro.ProjectID
	left join [dbo].[User] as u on tsk.CreateUser = u.UserID
	left join [dbo].[ProjectTaskStatus] as ts on tsk.TaskStatus = ts.TaskStatusID
	where pro.ClientID = @UserID 
	order by tsk.CreateDateTime desc

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_DashBoardVendorDetails]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2024-02-28
-- Description:	Get Vendor Dashboard Details
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_DashBoardVendorDetails]
(
	@UserID int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--Total Orders
	select isnull(COUNT(*),0) as TotalOrders
	from
	(select o.OrderID
	from [dbo].[Order] as o
	left join [dbo].[OrderDetail] as od on o.OrderID = od.OrderID
	where od.OrderDetailStatus <> 4 -- 4 is Cancelled Orders
	and od.VendorID = @UserID
	group by o.OrderID) as t

	--Best Customer
	select top (1) isnull(t.CustomerName,' - ') as BestCustomer
	from
	(select o.OrderID, concat(u.FirstName,' ',u.LastName) as CustomerName
	from [dbo].[Order] as o
	left join [dbo].[OrderDetail] as od on o.OrderID = od.OrderID
	left join [dbo].[User] as u on u.UserID = o.CreateUser
	where od.OrderDetailStatus <> 4 -- 4 is Cancelled Orders
	and od.VendorID = @UserID
	group by o.OrderID,concat(u.FirstName,' ',u.LastName)) as t
	group by t.CustomerName
	order by COUNT(t.OrderID) desc

	--Total Items
	select isnull(COUNT(i.ItemID),0) as TotalItems
	from [dbo].[Item] as i
	where i.CreateUser = @UserID and i.IsActive = 1;

	--Recent Orders
	select top (5) o.OrderNo, 
	concat(u.FirstName,' ',u.LastName) as CustomerName, convert(varchar(10), o.PlacedDate, 120) as PlacedDate
	from [dbo].[Order] as o
	left join [dbo].[OrderDetail] as od on o.OrderID = od.OrderID
	left join [dbo].[User] as u on o.CreateUser = u.UserID
	where od.OrderDetailStatus <> 4 -- 4 is Cancelled Orders
	and od.VendorID = @UserID
	group by o.OrderNo, o.CreateDateTime, concat(u.FirstName,' ',u.LastName),
	convert(varchar(10), o.PlacedDate, 120)
	order by o.CreateDateTime desc

	--Recent Items
	select t.ItemName, t.Category, t.AddedDate,
	case
		when t.AvailableQty > 0 then 'Available'
		else 'Out of Stock'
	end as StockAvailability
	from
	(Select top(5) i.ItemName, vct.VendorCategoryName as Category, convert(varchar(10), i.CreateDateTime , 120)as AddedDate,
	(it.Qty - [dbo].[FUNC_GET_ItemInvPurchasedCount](i.ItemID)) as AvailableQty
	From [MITProj_CMMS].[dbo].[Item] as i
	left join [dbo].[ItemInventory] as it on i.ItemID = it.ItemID and it.[IsInvAdded] = 1 and it.[IsCurrent] = 1
	left join [dbo].[VendorCategory] as vc on i.VendorCategoryTypeID = vc.VendorCategoryTypeID and vc.UserID = @UserID and vc.IsActive = 1
	left join [dbo].[VendorCategoryType] as vct on vc.VendorCategoryTypeID = vct.VendorCategoryTypeID
	Where i.CreateUser = @UserID and i.IsActive = 1
	order by i.CreateDateTime desc) as t

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_EStoreItemsForProductList]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-11-06
-- Description:	Load Items for ProductList
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_EStoreItemsForProductList] 
	-- Add the parameters for the stored procedure here
	@VendorCategoryTypeID int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--Default
    IF(@VendorCategoryTypeID = 0)
	Begin

		Select i.ItemID,i.VendorCategoryTypeID, vct.VendorCategoryName,
		i.ItemName,i.ItemDescription, img.ImageURL as ItemImageURL,
		i.VendorID, concat(ven.FirstName,' ', ven.LastName) as VendorName,
		i.ItemWeight,i.WeightUnit, concat(iw.[WeightUnitName], ' - ', iw.[WeightUnit]) as WeightUnitName,
		i.UOM, concat(uom.[UOMName], ' - ', uom.[UOMUnit]) as UOMName,
		i.UnitAmount,i.MinQty,i.MaxQty,
		it.Qty as TotalQty, [dbo].[FUNC_GET_ItemInvPurchasedCount](i.ItemID) as SoldQty,
		(it.Qty - [dbo].[FUNC_GET_ItemInvPurchasedCount](i.ItemID)) as AvailableQty,
		i.IsSoldUnitWise,i.IsActive
		From [MITProj_CMMS].[dbo].[Item] as i
		left join [dbo].[ItemInventory] as it on i.ItemID = it.ItemID and it.[IsInvAdded] = 1 and it.[IsCurrent] = 1
		--left join [dbo].[VendorCategory] as vc on i.VendorCategoryTypeID = vc.VendorCategoryTypeID and vc.IsActive = 1
		left join [dbo].[VendorCategoryType] as vct on i.VendorCategoryTypeID = vct.VendorCategoryTypeID
		left join [dbo].[ItemInvWeightUnit] as iw on i.WeightUnit = iw.[ItemWeightUnitID]
		left join [dbo].[ItemInventoryUOM] as uom on i.UOM = uom.ItemUOMID
		left join [dbo].[ItemInventoryImg] as img on i.ItemID = img.ItemID
		left join [dbo].[User] as ven on i.VendorID = ven.UserID
		Where i.IsActive = 1
		Order by i.VendorID, i.ItemID

	End

	ELSE
	Begin

		Select i.ItemID,i.VendorCategoryTypeID, vct.VendorCategoryName,
		i.ItemName,i.ItemDescription, img.ImageURL as ItemImageURL,
		i.VendorID, concat(ven.FirstName,' ', ven.LastName) as VendorName,
		i.ItemWeight,i.WeightUnit, concat(iw.[WeightUnitName], ' - ', iw.[WeightUnit]) as WeightUnitName,
		i.UOM, concat(uom.[UOMName], ' - ', uom.[UOMUnit]) as UOMName,
		i.UnitAmount,i.MinQty,i.MaxQty,
		it.Qty as TotalQty, [dbo].[FUNC_GET_ItemInvPurchasedCount](i.ItemID) as SoldQty,
		(it.Qty - [dbo].[FUNC_GET_ItemInvPurchasedCount](i.ItemID)) as AvailableQty,
		i.IsSoldUnitWise,i.IsActive
		From [MITProj_CMMS].[dbo].[Item] as i
		left join [dbo].[ItemInventory] as it on i.ItemID = it.ItemID and it.[IsInvAdded] = 1 and it.[IsCurrent] = 1
		--left join [dbo].[VendorCategory] as vc on i.VendorCategoryTypeID = vc.VendorCategoryTypeID and vc.IsActive = 1
		left join [dbo].[VendorCategoryType] as vct on i.VendorCategoryTypeID = vct.VendorCategoryTypeID
		left join [dbo].[ItemInvWeightUnit] as iw on i.WeightUnit = iw.[ItemWeightUnitID]
		left join [dbo].[ItemInventoryUOM] as uom on i.UOM = uom.ItemUOMID
		left join [dbo].[ItemInventoryImg] as img on i.ItemID = img.ItemID
		left join [dbo].[User] as ven on i.VendorID = ven.UserID
		Where i.IsActive = 1 and i.VendorCategoryTypeID = @VendorCategoryTypeID
		Order by i.VendorID, i.ItemID
		
	End

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_EStoreItemsForProductPageByItemID]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-11-06
-- Description:	Load Item for Product Page by ItemID
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_EStoreItemsForProductPageByItemID] 
	-- Add the parameters for the stored procedure here
	@ItemID int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Select i.ItemID,i.VendorCategoryTypeID, vct.VendorCategoryName,
	i.ItemName,i.ItemDescription, img.ImageURL as ItemImageURL,
	i.VendorID, concat(ven.FirstName,' ', ven.LastName) as VendorName,
	i.ItemWeight,i.WeightUnit, concat(iw.[WeightUnitName], ' - ', iw.[WeightUnit]) as WeightUnitName,
	i.UOM, concat(uom.[UOMName], ' - ', uom.[UOMUnit]) as UOMName,
	i.UnitAmount,i.MinQty,i.MaxQty,
	it.Qty as TotalQty, [dbo].[FUNC_GET_ItemInvPurchasedCount](i.ItemID) as SoldQty,
	(it.Qty - [dbo].[FUNC_GET_ItemInvPurchasedCount](i.ItemID)) as AvailableQty,
	i.IsSoldUnitWise,i.IsActive
	From [MITProj_CMMS].[dbo].[Item] as i
	left join [dbo].[ItemInventory] as it on i.ItemID = it.ItemID and it.[IsInvAdded] = 1 and it.[IsCurrent] = 1
	--left join [dbo].[VendorCategory] as vc on i.VendorCategoryTypeID = vc.VendorCategoryTypeID and vc.IsActive = 1
	left join [dbo].[VendorCategoryType] as vct on i.VendorCategoryTypeID = vct.VendorCategoryTypeID
	left join [dbo].[ItemInvWeightUnit] as iw on i.WeightUnit = iw.[ItemWeightUnitID]
	left join [dbo].[ItemInventoryUOM] as uom on i.UOM = uom.ItemUOMID
	left join [dbo].[ItemInventoryImg] as img on i.ItemID = img.ItemID
	left join [dbo].[User] as ven on i.VendorID = ven.UserID
	Where i.IsActive = 1 and i.ItemID = @ItemID;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_EStoreItemsInitialData]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-11-06
-- Description:	Get EStore initial data
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_EStoreItemsInitialData] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   	--vendor category types
    select a.[VendorCategoryTypeID] as [ValueID], a.[VendorCategoryName] as [Value]
	from [dbo].[VendorCategoryType] as a
	where a.IsActive = 1 

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_EStoreItemsSearchItem]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-11-06
-- Description:	Search Item
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_EStoreItemsSearchItem]
	-- Add the parameters for the stored procedure here
	@SearchKeyword nvarchar(MAX) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select i.ItemID as [Value], i.ItemName as [Label], i.ItemDescription as [Desc]
	from [dbo].[Item] as i
	where i.IsActive = 1
	and ((i.ItemName like @SearchKeyword + '%') or (i.ItemName like  '%' + @SearchKeyword + '%') or (i.ItemName like '%' + @SearchKeyword));

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ItemInvImgUrlsByItemID]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-10-26
-- Description:	Get Img Urls by ItemID
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_ItemInvImgUrlsByItemID]
	-- Add the parameters for the stored procedure here
	@ItemID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Select ti.ImageName, ti.ImageURL
	From [dbo].[ItemInventoryImg] as ti
	Where ti.ItemID = @ItemID;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ItemInvInitialData]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-10-22
-- Description:	Get Item Inventory initial data
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_ItemInvInitialData] 
	@VendorID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   	--vendor category types
    select b.[VendorCategoryTypeID] as [ValueID], b.[VendorCategoryName] as [Value]
	from [dbo].[VendorCategory] as a
	left join [dbo].[VendorCategoryType] as b on a.VendorCategoryTypeID = b.VendorCategoryTypeID
	where a.UserID = @VendorID  and b.IsActive = 1 

	--weight unit
	select a.[ItemWeightUnitID] as [ValueID], concat(a.[WeightUnitName], ' - ', a.[WeightUnit]) as [Value]
	from [dbo].[ItemInvWeightUnit] as a

	--uom
	select a.[ItemUOMID] as [ValueID], concat(a.[UOMName], ' - ', a.[UOMUnit]) as [Value]
	from [dbo].[ItemInventoryUOM] as a

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ItemInvListByUserID]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-10-22
-- Description:	Get all inventory list items by UserID
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_ItemInvListByUserID]
	-- Add the parameters for the stored procedure here
	@VendorCategoryTypeID int,
	@VendorID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF(@VendorCategoryTypeID = 0)
	Begin
		Select i.ItemID,i.VendorCategoryTypeID, vct.VendorCategoryName,
		i.ItemName,i.ItemDescription,
		i.ItemWeight,i.WeightUnit, concat(iw.[WeightUnitName], ' - ', iw.[WeightUnit]) as WeightUnitName,
		i.UOM, concat(uom.[UOMName], ' - ', uom.[UOMUnit]) as UOMName,
		i.UnitAmount,i.MinQty,i.MaxQty,
		it.Qty as TotalQty, [dbo].[FUNC_GET_ItemInvPurchasedCount](i.ItemID) as SoldQty,
		(it.Qty - [dbo].[FUNC_GET_ItemInvPurchasedCount](i.ItemID)) as AvailableQty,
		i.IsSoldUnitWise,i.IsActive,
		CASE
		WHEN i.IsActive = 1 THEN 'Active'
		ELSE 'Inactive'
		END AS IsActiveStatusName
		From [MITProj_CMMS].[dbo].[Item] as i
		left join [dbo].[ItemInventory] as it on i.ItemID = it.ItemID and it.[IsInvAdded] = 1 and it.[IsCurrent] = 1
		left join [dbo].[VendorCategory] as vc on i.VendorCategoryTypeID = vc.VendorCategoryTypeID and vc.UserID = @VendorID and vc.IsActive = 1
		left join [dbo].[VendorCategoryType] as vct on vc.VendorCategoryTypeID = vct.VendorCategoryTypeID
		left join [dbo].[ItemInvWeightUnit] as iw on i.WeightUnit = iw.[ItemWeightUnitID]
		left join [dbo].[ItemInventoryUOM] as uom on i.UOM = uom.ItemUOMID
		Where i.VendorID = @VendorID;
	End
	Else
	Begin
		Select i.ItemID,i.VendorCategoryTypeID, vct.VendorCategoryName,
		i.ItemName,i.ItemDescription,
		i.ItemWeight,i.WeightUnit, concat(iw.[WeightUnitName], ' - ', iw.[WeightUnit]) as WeightUnitName,
		i.UOM, concat(uom.[UOMName], ' - ', uom.[UOMUnit]) as UOMName,
		i.UnitAmount,i.MinQty,i.MaxQty,
		it.Qty as TotalQty, [dbo].[FUNC_GET_ItemInvPurchasedCount](i.ItemID) as SoldQty,
		(it.Qty - [dbo].[FUNC_GET_ItemInvPurchasedCount](i.ItemID)) as AvailableQty,
		i.IsSoldUnitWise,i.IsActive,
		CASE
		WHEN i.IsActive = 1 THEN 'Active'
		ELSE 'Inactive'
		END AS IsActiveStatusName
		From [MITProj_CMMS].[dbo].[Item] as i
		left join [dbo].[ItemInventory] as it on i.ItemID = it.ItemID and it.[IsInvAdded] = 1 and it.[IsCurrent] = 1
		left join [dbo].[VendorCategory] as vc on i.VendorCategoryTypeID = vc.VendorCategoryTypeID and vc.UserID = @VendorID and vc.IsActive = 1
		left join [dbo].[VendorCategoryType] as vct on vc.VendorCategoryTypeID = vct.VendorCategoryTypeID
		left join [dbo].[ItemInvWeightUnit] as iw on i.WeightUnit = iw.[ItemWeightUnitID]
		left join [dbo].[ItemInventoryUOM] as uom on i.UOM = uom.ItemUOMID
		Where i.VendorID = @VendorID and i.VendorCategoryTypeID = @VendorCategoryTypeID;

	End

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_OrderCustomerAddress]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-11-13
-- Description:	Load Customer Address details for CheckoutPage
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_OrderCustomerAddress] 
	-- Add the parameters for the stored procedure here
	@CustomerID int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Select u.UserID, u.Username, u.FirstName, u.LastName,
	ua.Address1, ua.Address2, ua.Address3,
    ua.District, ua.Province
	From [dbo].[User] as u
	left join [dbo].[UserAddressDetail] as ua on u.UserID = ua.UserID and ua.IsPrimary = 1 and ua.IsActive = 1
	Where u.UserID = @CustomerID

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_OrderCustomerHistory]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-11-17
-- Description:	Load Order Customer History
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_OrderCustomerHistory] 
	-- Add the parameters for the stored procedure here
	@CustomerID int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--Order Info
	Select o.OrderID, o.OrderNo, convert(varchar(10), o.PlacedDate, 120) as PlacedDate , convert(varchar(10), o.EstDeliveryDate, 120) as EstDeliveryDate,
	o.PaymentMethod, pm.PayMethodName, concat(u.FirstName,' ', u.LastName) as ClientName,
	o.Address1, o.Address2, o.Address3, o.District, o.Province, u.MobileNo,
	o.Discount, o.SubTotal, o.DeliveryCharge, o.Total
	From [dbo].[Order] as o
	left join [dbo].[OrderPaymentMethod] as pm on o.PaymentMethod = pm.OrderPayMethodID
	left join [dbo].[User] as u on o.CreateUser = u.UserID
	Where o.CreateUser = @CustomerID
	Order by o.OrderNo desc

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_OrderDetailsByOrderID]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-11-17
-- Description:	Load Order details by OrderID
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_OrderDetailsByOrderID] 
	-- Add the parameters for the stored procedure here
	@OrderID int, 
	@CustomerID int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--Order Info
	Select o.OrderID, o.OrderNo, convert(varchar(10), o.PlacedDate, 120) as PlacedDate , convert(varchar(10), o.EstDeliveryDate, 120) as EstDeliveryDate,
	o.PaymentMethod, pm.PayMethodName, concat(u.FirstName,' ', u.LastName) as ClientName,
	o.Address1, o.Address2, o.Address3, o.District, o.Province, u.MobileNo, u.Email,
	o.Discount, o.SubTotal, o.DeliveryCharge, o.Total
	From [dbo].[Order] as o
	left join [dbo].[OrderPaymentMethod] as pm on o.PaymentMethod = pm.OrderPayMethodID
	left join [dbo].[User] as u on o.CreateUser = u.UserID
	Where o.OrderID = @OrderID and o.CreateUser = @CustomerID

	--Item Info
	Select od.ItemID, item.ItemName, od.OrderID, od.PackageID,
	od.UnitAmount, od.Quantity, od.DiscountAmount, od.ItemWiseTotal,
	od.VendorID, concat(u.FirstName,' ', u.LastName) as VendorName,
	od.OrderDetailStatus, st.OrderStatusName
	From [dbo].[OrderDetail] as od
	left join [dbo].[Item] as item on od.ItemID = item.ItemID
	left join [dbo].[User] as u on od.VendorID = u.UserID
	left join [dbo].[OrderStatusType] as st on od.OrderDetailStatus = st.OrderStatusID
	Where od.OrderID = @OrderID and od.CreateUser = @CustomerID

	--Vendor Info
	Select 	od.VendorID, concat(u.FirstName,' ', u.LastName) as VendorName, u.Email,
	od.OrderID, od.PackageID,
	od.OrderDetailStatus, st.OrderStatusName
	From [dbo].[OrderDetail] as od
	left join [dbo].[Item] as item on od.ItemID = item.ItemID
	left join [dbo].[User] as u on od.VendorID = u.UserID
	left join [dbo].[OrderStatusType] as st on od.OrderDetailStatus = st.OrderStatusID
	Where od.OrderID = @OrderID and od.CreateUser = @CustomerID
	Group By  od.VendorID, concat(u.FirstName,' ', u.LastName), u.Email,
	od.OrderID, od.PackageID,
	od.OrderDetailStatus, st.OrderStatusName

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_OrderMgntInitialData]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-11-20
-- Description:	Get Order Mgnt initial data
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_OrderMgntInitialData] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   	--order status types
    select a.OrderStatusID as [ValueID], a.OrderStatusName as [Value]
	from [dbo].[OrderStatusType] as a
	where a.IsActive = 1 

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_OrderMgntOrderDetailsByOrderID]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-11-19
-- Description:	Load Order Details
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_OrderMgntOrderDetailsByOrderID] 
	-- Add the parameters for the stored procedure here
	 @OrderID int,
	 @PackageID int,
	 @VendorID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--Item Header Info
	select od.OrderID, o.OrderNo, od.PackageID, 
	od.OrderDetailStatus, st.OrderStatusName, concat(u.FirstName,' ', u.LastName) as CustomerName,
	SUM(od.ItemWiseTotal) as Total
	from [dbo].[OrderDetail] as od
	left join [dbo].[Order] as o on od.OrderID = o.OrderID
	left join [dbo].[User] as u on od.CreateUser = u.UserID
	left join [dbo].[OrderStatusType] as st on od.OrderDetailStatus = st.OrderStatusID
	where od.OrderID = @OrderID and od.PackageID = @PackageID and od.VendorID = @VendorID
	group by od.OrderID, o.OrderNo, od.PackageID,
	od.OrderDetailStatus, st.OrderStatusName, concat(u.FirstName,' ', u.LastName)

	--Item Info
	Select od.ItemID, item.ItemName, od.OrderID, od.PackageID,
	od.UnitAmount, od.Quantity, od.DiscountAmount, od.ItemWiseTotal,
	od.VendorID, concat(u.FirstName,' ', u.LastName) as VendorName,
	od.OrderDetailStatus, st.OrderStatusName
	From [dbo].[OrderDetail] as od
	left join [dbo].[Item] as item on od.ItemID = item.ItemID
	left join [dbo].[User] as u on od.VendorID = u.UserID
	left join [dbo].[OrderStatusType] as st on od.OrderDetailStatus = st.OrderStatusID
	Where od.OrderID = @OrderID and od.PackageID = @PackageID and od.VendorID = @VendorID

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_OrderMgntOrdersByVendorID]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-11-19
-- Description:	Load Orders for Order Management by VendorID
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_OrderMgntOrdersByVendorID] 
	-- Add the parameters for the stored procedure here
	 @VendorID int,
	 @OrderStatusID int,
	 @StartDate nvarchar(20),
	 @EndDate nvarchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @StartDateFormatted date;
	Declare @EndDateFormatted date;

	--initial load
	If(@OrderStatusID = 0 and @StartDate = 'null' and @EndDate = 'null')
	Begin
		With
		#vendorWiseOrder as 
		( 
			Select oh.OrderID, o.OrderNo,convert(varchar(10), o.PlacedDate, 101) as PlacedDate , convert(varchar(10), o.EstDeliveryDate, 101) as EstDeliveryDate,
			o.PaymentMethod, oh.PackageID, oh.OrderStatus, max(od.VendorID) as VendorID, max(od.CreateUser) as CustomerID
			From [dbo].[OrderStatusHistory] as oh
			left join [dbo].[Order] as o on oh.OrderID = o.OrderID and oh.IsCurrent = 1
			left join [dbo].[OrderDetail] as od on oh.OrderID = od.OrderID and oh.PackageID = od.PackageID and oh.IsCurrent = 1
			Where od.VendorID = @VendorID
			group by oh.OrderID, o.OrderNo, o.PlacedDate, o.EstDeliveryDate,
			o.PaymentMethod, oh.PackageID, oh.OrderStatus

		)

		select vo.OrderID, vo.OrderNo, vo.PlacedDate, vo.EstDeliveryDate,
		vo.PaymentMethod, p.PayMethodName, vo.PackageID, vo.OrderStatus, concat(cast(vo.OrderStatus as nvarchar(10)),' - ',st.OrderStatusName) as OrderStatusName,
		vo.VendorID, concat(u.FirstName,' ', u.LastName) as VendorName,
		vo.CustomerID, concat(c.FirstName,' ', c.LastName) as CustomerName
		from #vendorWiseOrder as vo
		left join [dbo].[OrderPaymentMethod] as p on vo.PaymentMethod = p.OrderPayMethodID
		left join [dbo].[OrderStatusType] as st on vo.OrderStatus = st.OrderStatusID
		left join [dbo].[User] as u on vo.VendorID = u.UserID 
		left join [dbo].[User] as c on vo.CustomerID = c.UserID 
		Where vo.OrderStatus in (1,2) -- Processing and Shipped
	End
	--initial load with date filter
	Else If(@OrderStatusID = 0 and @StartDate <> 'null' and @EndDate <> 'null')
	Begin
		set @StartDateFormatted = @StartDate;
		set @EndDateFormatted = @EndDate;
		With
		#vendorWiseOrder as 
		( 
			Select oh.OrderID, o.OrderNo,convert(varchar(10), o.PlacedDate, 101) as PlacedDate , convert(varchar(10), o.EstDeliveryDate, 101) as EstDeliveryDate,
			o.PaymentMethod, oh.PackageID, oh.OrderStatus, max(od.VendorID) as VendorID, max(od.CreateUser) as CustomerID
			From [dbo].[OrderStatusHistory] as oh
			left join [dbo].[Order] as o on oh.OrderID = o.OrderID and oh.IsCurrent = 1
			left join [dbo].[OrderDetail] as od on oh.OrderID = od.OrderID and oh.PackageID = od.PackageID and oh.IsCurrent = 1
			Where od.VendorID = @VendorID
			group by oh.OrderID, o.OrderNo, o.PlacedDate, o.EstDeliveryDate,
			o.PaymentMethod, oh.PackageID, oh.OrderStatus

		)

		select vo.OrderID, vo.OrderNo, vo.PlacedDate, vo.EstDeliveryDate,
		vo.PaymentMethod, p.PayMethodName, vo.PackageID, vo.OrderStatus, concat(cast(vo.OrderStatus as nvarchar(10)),' - ',st.OrderStatusName) as OrderStatusName,
		vo.VendorID, concat(u.FirstName,' ', u.LastName) as VendorName,
		vo.CustomerID, concat(c.FirstName,' ', c.LastName) as CustomerName
		from #vendorWiseOrder as vo
		left join [dbo].[OrderPaymentMethod] as p on vo.PaymentMethod = p.OrderPayMethodID
		left join [dbo].[OrderStatusType] as st on vo.OrderStatus = st.OrderStatusID
		left join [dbo].[User] as u on vo.VendorID = u.UserID 
		left join [dbo].[User] as c on vo.CustomerID = c.UserID 
		Where vo.OrderStatus in (1,2) -- Processing and Shipped
		and (vo.PlacedDate between @StartDateFormatted and @EndDateFormatted) 
	End
	--Filtered Order List
	Else
	Begin	
		IF(@StartDate <> 'null' and @EndDate <> 'null')
		Begin
			set @StartDateFormatted = @StartDate;
			set @EndDateFormatted = @EndDate;

			With
			#vendorWiseOrder as 
			( 
				Select oh.OrderID, o.OrderNo,convert(varchar(10), o.PlacedDate, 101) as PlacedDate , convert(varchar(10), o.EstDeliveryDate, 101) as EstDeliveryDate,
				o.PaymentMethod, oh.PackageID, oh.OrderStatus, max(od.VendorID) as VendorID, max(od.CreateUser) as CustomerID
				From [dbo].[OrderStatusHistory] as oh
				left join [dbo].[Order] as o on oh.OrderID = o.OrderID and oh.IsCurrent = 1
				left join [dbo].[OrderDetail] as od on oh.OrderID = od.OrderID and oh.PackageID = od.PackageID and oh.IsCurrent = 1
				Where od.VendorID = @VendorID
				group by oh.OrderID, o.OrderNo, o.PlacedDate, o.EstDeliveryDate,
				o.PaymentMethod, oh.PackageID, oh.OrderStatus

			)

			select vo.OrderID, vo.OrderNo, vo.PlacedDate, vo.EstDeliveryDate,
			vo.PaymentMethod, p.PayMethodName, vo.PackageID, vo.OrderStatus, concat(cast(vo.OrderStatus as nvarchar(10)),' - ',st.OrderStatusName) as OrderStatusName,
			vo.VendorID, concat(u.FirstName,' ', u.LastName) as VendorName,
			vo.CustomerID, concat(c.FirstName,' ', c.LastName) as CustomerName
			from #vendorWiseOrder as vo
			left join [dbo].[OrderPaymentMethod] as p on vo.PaymentMethod = p.OrderPayMethodID
			left join [dbo].[OrderStatusType] as st on vo.OrderStatus = st.OrderStatusID
			left join [dbo].[User] as u on vo.VendorID = u.UserID 
			left join [dbo].[User] as c on vo.CustomerID = c.UserID 
			Where vo.OrderStatus = @OrderStatusID and (vo.PlacedDate between @StartDateFormatted and @EndDateFormatted) 
		End
		Else
		Begin
			With
			#vendorWiseOrder as 
			( 
				Select oh.OrderID, o.OrderNo,convert(varchar(10), o.PlacedDate, 101) as PlacedDate , convert(varchar(10), o.EstDeliveryDate, 101) as EstDeliveryDate,
				o.PaymentMethod, oh.PackageID, oh.OrderStatus, max(od.VendorID) as VendorID, max(od.CreateUser) as CustomerID
				From [dbo].[OrderStatusHistory] as oh
				left join [dbo].[Order] as o on oh.OrderID = o.OrderID and oh.IsCurrent = 1
				left join [dbo].[OrderDetail] as od on oh.OrderID = od.OrderID and oh.PackageID = od.PackageID and oh.IsCurrent = 1
				Where od.VendorID = @VendorID
				group by oh.OrderID, o.OrderNo, o.PlacedDate, o.EstDeliveryDate,
				o.PaymentMethod, oh.PackageID, oh.OrderStatus

			)

			select vo.OrderID, vo.OrderNo, vo.PlacedDate, vo.EstDeliveryDate,
			vo.PaymentMethod, p.PayMethodName, vo.PackageID, vo.OrderStatus, concat(cast(vo.OrderStatus as nvarchar(10)),' - ',st.OrderStatusName) as OrderStatusName,
			vo.VendorID, concat(u.FirstName,' ', u.LastName) as VendorName,
			vo.CustomerID, concat(c.FirstName,' ', c.LastName) as CustomerName
			from #vendorWiseOrder as vo
			left join [dbo].[OrderPaymentMethod] as p on vo.PaymentMethod = p.OrderPayMethodID
			left join [dbo].[OrderStatusType] as st on vo.OrderStatus = st.OrderStatusID
			left join [dbo].[User] as u on vo.VendorID = u.UserID 
			left join [dbo].[User] as c on vo.CustomerID = c.UserID 
			Where vo.OrderStatus = @OrderStatusID 
		End		
	End

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_PermissionDetails]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-12-10
-- Description:	Load Permissions
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_PermissionDetails]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select p.PermissionID, p.ScreenName, p.PermissionName, p.IsActive
	From [dbo].[Permission] as p
	order by p.PermissionID asc;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ProjectDetailsAllByUserID]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-09-03
-- Description:	Get All Project Details by UserID
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_ProjectDetailsAllByUserID]
	-- Add the parameters for the stored procedure here
	@UserID int,
	@ProjectStatus int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	If(@ProjectStatus = 0)
	Begin
		select p.ProjectID, p.ProjectTitle, concat(u.FirstName,' ',u.LastName) as ClientName,
		convert(varchar, p.StartDate, 101) as StartDate,
		convert(varchar, p.EndDate, 101) as EndDate,
		p.[Description], ps.StatusName as ProjectStatusName,
		[dbo].[FUNC_GET_ProjectTaskCountByProjectID](p.ProjectID, 1) as NewTaskCount, -- 1 is New
		[dbo].[FUNC_GET_ProjectTaskCountByProjectID](p.ProjectID, 2) as InProgressTaskCount, -- 2 is In Progress
		[dbo].[FUNC_GET_ProjectTaskCountByProjectID](p.ProjectID, 3) as CompleteTaskCount, -- 3 is completed
		[dbo].[FUNC_GET_ProjectPercentageByProjectID](p.ProjectID) as ProjectProgress
		from [dbo].[Project] as p
		left join [dbo].[User] as u on p.ClientID = u.UserID
		left join [dbo].[ProjectStatus] as ps on p.ProjectStatus = ps.ProjectStatusID
		where (p.CreateUser = @UserID or p.ClientID = @UserID
		--To View For Assigned To contractor
		or  p.ProjectID in  
		 (
			select p.ProjectID 
			from [dbo].[Project] as p
			left join [dbo].[ProjectTask] as t on t.ProjectID = p.ProjectID
			where t.AssignTo = @UserID
			group by  p.ProjectID
		 )
		)
		and ProjectStatus in (1,2)
		order by ProjectStatus asc;
	End
	Else
	Begin
		select p.ProjectID, p.ProjectTitle, concat(u.FirstName,' ',u.LastName) as ClientName,
		convert(varchar, p.StartDate, 101) as StartDate,
		convert(varchar, p.EndDate, 101) as EndDate,
		p.[Description], ps.StatusName as ProjectStatusName,
		[dbo].[FUNC_GET_ProjectTaskCountByProjectID](p.ProjectID, 1) as NewTaskCount, -- 1 is New
		[dbo].[FUNC_GET_ProjectTaskCountByProjectID](p.ProjectID, 2) as InProgressTaskCount, -- 2 is In Progress
		[dbo].[FUNC_GET_ProjectTaskCountByProjectID](p.ProjectID, 3) as CompleteTaskCount, -- 3 is completed
		[dbo].[FUNC_GET_ProjectPercentageByProjectID](p.ProjectID) as ProjectProgress
		from [dbo].[Project] as p
		left join [dbo].[User] as u on p.ClientID = u.UserID
		left join [dbo].[ProjectStatus] as ps on p.ProjectStatus = ps.ProjectStatusID
		where (p.CreateUser = @UserID or p.ClientID = @UserID
		--To View For Assigned To contractor
		or  p.ProjectID in  
		 (
			select p.ProjectID 
			from [dbo].[Project] as p
			left join [dbo].[ProjectTask] as t on t.ProjectID = p.ProjectID
			where t.AssignTo = @UserID
			group by  p.ProjectID
		 )
		)
		and ProjectStatus = @ProjectStatus
		order by ProjectStatus asc;
	End
	

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ProjectDetailsByProjectID]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-09-03
-- Description:	Get Project Details by ProjectID
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_ProjectDetailsByProjectID]
	-- Add the parameters for the stored procedure here
	@ProjectID int,
	@UserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   select p.ProjectID, p.ProjectTitle, p.ClientID, concat(u.FirstName,' ',u.LastName) as ClientName,
   p.ProjectPriority, p.ProjectSize,
   convert(varchar, p.StartDate, 101) as StartDate, convert(varchar(5), p.StartTime, 8) as StartTime,
   convert(varchar, p.EndDate, 101) as EndDate, convert(varchar(5), p.EndTime, 8) as EndTime,
   p.[Description], p.ProjectStatus
   from [dbo].[Project] as p
   left join [dbo].[User] as u on p.ClientID = u.UserID
   where p.ProjectID = @ProjectID 
   and  (p.CreateUser = @UserID or  p.ClientID = @UserID
   --To View For Assigned To contractor
	or  p.ProjectID in  
		(
			select p.ProjectID 
			from [dbo].[Project] as p
			left join [dbo].[ProjectTask] as t on t.ProjectID = p.ProjectID
			where t.AssignTo = @UserID
			group by  p.ProjectID
		)
	);


END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ProjectInitialData]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-09-02
-- Description:	Get project initial data
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_ProjectInitialData]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--project types (removed and moved to ProjectTask Table)
    select 1 as [ValueID], 'Removed' as [Value]

	--project priorities
	select a.ProjectPriorityID as [ValueID], a.PriorityName as [Value]
	from [dbo].[ProjectPriority] as a

	--project sizes
	select a.ProjectSizeID as [ValueID], a.SizeName as [Value]
	from [dbo].[ProjectSize] as a

	--project status
	select a.ProjectStatusID as [ValueID], a.StatusName as [Value]
	from [dbo].[ProjectStatus] as a

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ProjectTaskByProjectID]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-09-06
-- Description:	Get all tasks by ProjectID
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_ProjectTaskByProjectID]
	-- Add the parameters for the stored procedure here
	@ProjectID int,
	@UserID int,
	@TaskStatus int,
	@StartDate nvarchar(20),
	@EndDate nvarchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--initial load
	If(@TaskStatus = 0 and @StartDate = 'null' and @EndDate = 'null')
	Begin
		select tsk.TaskID, tsk.ProjectID, pro.ProjectTitle, tsk.TaskName,
		tsk.TaskRate, tsk.TaskRateType, tr.TaskRateTypeName,
		tsk.TaskPriority, p.PriorityName,
		tsk.TaskStatus, ts.TaskStatusName, tsk.Description,
		convert(varchar, tsk.StartDate, 101) as StartDate, convert(varchar(5), tsk.StartTime, 8) as StartTime,
		convert(varchar, tsk.EndDate, 101) as EndDate, convert(varchar(5), tsk.EndTime, 8) as EndTime,
		tsk.ServiceType, st.ServiceTypeName,
		tsk.AssignTo, concat(u.FirstName,' ', u.LastName) as AssignToName,
		tsk.ApprovalStatus,
		tsk.CreateUser
		from [dbo].[ProjectTask] as tsk
		left join [dbo].[Project] as pro on tsk.ProjectID = pro.ProjectID
		left join [dbo].[ProjectTaskRateType] as tr on tsk.TaskRateType = tr.TaskRateTypeID
		left join [dbo].[ProjectPriority] as p on tsk.TaskPriority = p.ProjectPriorityID
		left join [dbo].[ProjectTaskStatus] as ts on tsk.TaskStatus = ts.TaskStatusID
		left join [dbo].[ServiceType] as st on tsk.ServiceType = st.ServiceTypeID
		left join [dbo].[User] as u on tsk.AssignTo = u.UserID
		where tsk.ProjectID = @ProjectID
		and tsk.TaskStatus != 3 -- 3 is Completed status
		order by tsk.TaskStatus asc
	End
	--Filtered Task List
	Else
	Begin	
		IF(@StartDate <> 'null' and @EndDate <> 'null')
		Begin

			Declare @StartDateFormatted date;
			Declare @EndDateFormatted date;

			set @StartDateFormatted = @StartDate;
			set @EndDateFormatted = @EndDate;

			select tsk.TaskID, tsk.ProjectID, pro.ProjectTitle, tsk.TaskName,
			tsk.TaskRate, tsk.TaskRateType, tr.TaskRateTypeName,
			tsk.TaskPriority, p.PriorityName,
			tsk.TaskStatus, ts.TaskStatusName, tsk.Description,
			convert(varchar, tsk.StartDate, 101) as StartDate, convert(varchar(5), tsk.StartTime, 8) as StartTime,
			convert(varchar, tsk.EndDate, 101) as EndDate, convert(varchar(5), tsk.EndTime, 8) as EndTime,
			tsk.ServiceType, st.ServiceTypeName,
			tsk.AssignTo, concat(u.FirstName,' ', u.LastName) as AssignToName,
			tsk.ApprovalStatus,
			tsk.CreateUser
			from [dbo].[ProjectTask] as tsk
			left join [dbo].[Project] as pro on tsk.ProjectID = pro.ProjectID
			left join [dbo].[ProjectTaskRateType] as tr on tsk.TaskRateType = tr.TaskRateTypeID
			left join [dbo].[ProjectPriority] as p on tsk.TaskPriority = p.ProjectPriorityID
			left join [dbo].[ProjectTaskStatus] as ts on tsk.TaskStatus = ts.TaskStatusID
			left join [dbo].[ServiceType] as st on tsk.ServiceType = st.ServiceTypeID
			left join [dbo].[User] as u on tsk.AssignTo = u.UserID
			where tsk.ProjectID = @ProjectID
			and tsk.TaskStatus = @TaskStatus
			and ((tsk.[StartDate] between @StartDateFormatted and @EndDateFormatted) or (tsk.[EndDate] between @StartDateFormatted and @EndDateFormatted)
			or (@StartDateFormatted between tsk.[StartDate] and tsk.[EndDate]) or (@EndDateFormatted between  tsk.[StartDate] and tsk.[EndDate]))
			order by tsk.TaskStatus asc
		End
		Else
		Begin
			select tsk.TaskID, tsk.ProjectID, pro.ProjectTitle, tsk.TaskName,
			tsk.TaskRate, tsk.TaskRateType, tr.TaskRateTypeName,
			tsk.TaskPriority, p.PriorityName,
			tsk.TaskStatus, ts.TaskStatusName, tsk.Description,
			convert(varchar, tsk.StartDate, 101) as StartDate, convert(varchar(5), tsk.StartTime, 8) as StartTime,
			convert(varchar, tsk.EndDate, 101) as EndDate, convert(varchar(5), tsk.EndTime, 8) as EndTime,
			tsk.ServiceType, st.ServiceTypeName,
			tsk.AssignTo, concat(u.FirstName,' ', u.LastName) as AssignToName,
			tsk.ApprovalStatus,
			tsk.CreateUser
			from [dbo].[ProjectTask] as tsk
			left join [dbo].[Project] as pro on tsk.ProjectID = pro.ProjectID
			left join [dbo].[ProjectTaskRateType] as tr on tsk.TaskRateType = tr.TaskRateTypeID
			left join [dbo].[ProjectPriority] as p on tsk.TaskPriority = p.ProjectPriorityID
			left join [dbo].[ProjectTaskStatus] as ts on tsk.TaskStatus = ts.TaskStatusID
			left join [dbo].[ServiceType] as st on tsk.ServiceType = st.ServiceTypeID
			left join [dbo].[User] as u on tsk.AssignTo = u.UserID
			where tsk.ProjectID = @ProjectID
			and tsk.TaskStatus = @TaskStatus
			order by tsk.TaskStatus asc
		End		
	End

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ProjectTaskDetailsByTaskID]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-09-26
-- Description:	Load Project task details by TaskID
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_ProjectTaskDetailsByTaskID]
	-- Add the parameters for the stored procedure here
	@TaskID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select tsk.TaskID, tsk.ProjectID, pro.ProjectTitle, tsk.TaskName,
	tsk.TaskRate, tsk.TaskRateType, tr.TaskRateTypeName,
	tsk.TaskPriority, p.PriorityName,
	tsk.TaskStatus, ts.TaskStatusName, tsk.Description,
	convert(varchar, tsk.StartDate, 101) as StartDate, convert(varchar(5), tsk.StartTime, 8) as StartTime,
	convert(varchar, tsk.EndDate, 101) as EndDate, convert(varchar(5), tsk.EndTime, 8) as EndTime,
	tsk.ServiceType, st.ServiceTypeName,
	cl.Email as ClientEmail,
	tsk.AssignTo, concat(u.FirstName,' ', u.LastName) as AssignToName, u.Email as ContractorEmail,
	tsk.ApprovalStatus,
	tsk.CreateUser
	from [dbo].[ProjectTask] as tsk
	left join [dbo].[Project] as pro on tsk.ProjectID = pro.ProjectID
	left join [dbo].[ProjectTaskRateType] as tr on tsk.TaskRateType = tr.TaskRateTypeID
	left join [dbo].[ProjectPriority] as p on tsk.TaskPriority = p.ProjectPriorityID
	left join [dbo].[ProjectTaskStatus] as ts on tsk.TaskStatus = ts.TaskStatusID
	left join [dbo].[ServiceType] as st on tsk.ServiceType = st.ServiceTypeID
	left join [dbo].[User] as u on tsk.AssignTo = u.UserID
	left join [dbo].[User] as cl on pro.ClientID = cl.UserID
	where tsk.TaskID = @TaskID

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ProjectTaskImgUrlsByTaskID]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-09-24
-- Description:	Get Img Urls by TaskID
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_ProjectTaskImgUrlsByTaskID]
	-- Add the parameters for the stored procedure here
	@TaskID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Select ti.ImageName, ti.ImageURL
	From [dbo].[ProjectTaskImg] as ti
	Where ti.TaskID = @TaskID;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ProjectTaskInitialData]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-09-02
-- Description:	Get task mgnt initial data
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_ProjectTaskInitialData]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--project task rate types
    select a.TaskRateTypeID as [ValueID], a.TaskRateTypeName as [Value]
	from [dbo].[ProjectTaskRateType] as a

	--project task priorities
	select a.ProjectPriorityID as [ValueID], a.PriorityName as [Value]
	from [dbo].[ProjectPriority] as a

	--project task status
	select a.TaskStatusID as [ValueID], a.TaskStatusName as [Value]
	from [dbo].[ProjectTaskStatus] as a

	--service types
	select a.ServiceTypeID as [ValueID], a.ServiceTypeName as [Value]
	from [dbo].[ServiceType] as a
	where a.IsActive = 1

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ProjectTaskPendingApprovalList]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-09-26
-- Description:	Load pending approval task list
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_ProjectTaskPendingApprovalList]
	-- Add the parameters for the stored procedure here
	@UserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select tsk.TaskID, tsk.ProjectID, pro.ProjectTitle, tsk.TaskName,
	tsk.TaskRate, tsk.TaskRateType, tr.TaskRateTypeName,
	tsk.TaskPriority, p.PriorityName,
	tsk.TaskStatus, ts.TaskStatusName, tsk.Description,
	convert(varchar, tsk.StartDate, 101) as StartDate, convert(varchar(5), tsk.StartTime, 8) as StartTime,
	convert(varchar, tsk.EndDate, 101) as EndDate, convert(varchar(5), tsk.EndTime, 8) as EndTime,
	tsk.ServiceType, st.ServiceTypeName,
	tsk.AssignTo, concat(u.FirstName,' ', u.LastName) as AssignToName,
	tsk.ApprovalStatus,
	tsk.CreateUser
	from [dbo].[ProjectTask] as tsk
	left join [dbo].[Project] as pro on tsk.ProjectID = pro.ProjectID
	left join [dbo].[ProjectTaskRateType] as tr on tsk.TaskRateType = tr.TaskRateTypeID
	left join [dbo].[ProjectPriority] as p on tsk.TaskPriority = p.ProjectPriorityID
	left join [dbo].[ProjectTaskStatus] as ts on tsk.TaskStatus = ts.TaskStatusID
	left join [dbo].[ServiceType] as st on tsk.ServiceType = st.ServiceTypeID
	left join [dbo].[User] as u on tsk.AssignTo = u.UserID
	where pro.ClientID = @UserID 
	and tsk.TaskStatus = 3 -- 3 is Completed
	and tsk.ApprovalStatus = 0 -- 0 is Approval Pending

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ProjectTaskPendingApprovalListByTaskID]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-09-26
-- Description:	Load pending approval task list
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_ProjectTaskPendingApprovalListByTaskID]
	-- Add the parameters for the stored procedure here
	@UserID int,
	@TaskID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select tsk.TaskID, tsk.ProjectID, pro.ProjectTitle, tsk.TaskName,
	tsk.TaskRate, tsk.TaskRateType, tr.TaskRateTypeName,
	tsk.TaskPriority, p.PriorityName,
	tsk.TaskStatus, ts.TaskStatusName, tsk.Description,
	convert(varchar, tsk.StartDate, 101) as StartDate, convert(varchar(5), tsk.StartTime, 8) as StartTime,
	convert(varchar, tsk.EndDate, 101) as EndDate, convert(varchar(5), tsk.EndTime, 8) as EndTime,
	tsk.ServiceType, st.ServiceTypeName,
	cl.Email as ClientEmail,
	tsk.AssignTo, concat(u.FirstName,' ', u.LastName) as AssignToName, u.Email as ContractorEmail,
	tsk.ApprovalStatus,
	tsk.CreateUser
	from [dbo].[ProjectTask] as tsk
	left join [dbo].[Project] as pro on tsk.ProjectID = pro.ProjectID
	left join [dbo].[ProjectTaskRateType] as tr on tsk.TaskRateType = tr.TaskRateTypeID
	left join [dbo].[ProjectPriority] as p on tsk.TaskPriority = p.ProjectPriorityID
	left join [dbo].[ProjectTaskStatus] as ts on tsk.TaskStatus = ts.TaskStatusID
	left join [dbo].[ServiceType] as st on tsk.ServiceType = st.ServiceTypeID
	left join [dbo].[User] as u on tsk.AssignTo = u.UserID
	left join [dbo].[User] as cl on pro.ClientID = cl.UserID
	where tsk.TaskID = @TaskID
	and pro.ClientID = @UserID 
	and tsk.TaskStatus = 3 -- 3 is Completed
	and tsk.ApprovalStatus = 0 -- 0 is Approval Pending

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ReportMgntContractorReview]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2024-02-04
-- Description:	Load data for Contractor Review Report
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_ReportMgntContractorReview] 
	@Year int,
	@Month int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--When user select all for year and all for month
	If (@Year = -1 and @Month = -1)
	Begin

		select pr.ContractorID, concat(u.FirstName,' ',u.LastName) as ContractorName,
		cast(ROUND(AVG(cast(Rating as decimal(18,2))), 2) as decimal(18,2)) as OverallRating
		from [dbo].[ProjectTaskReview] as pr
		left join [dbo].[User] as u on u.UserID = pr.ContractorID
		group by pr.ContractorID, concat(u.FirstName,' ',u.LastName)

	End

	--When user select all for year and select a month
	Else If (@Year = -1 and @Month != -1)
	Begin
		select pr.ContractorID, concat(u.FirstName,' ',u.LastName) as ContractorName,
		cast(ROUND(AVG(cast(Rating as decimal(18,2))), 2) as decimal(18,2)) as OverallRating
		from [dbo].[ProjectTaskReview] as pr
		left join [dbo].[User] as u on u.UserID = pr.ContractorID
		where Month (pr.CreateDateTime) = @Month
		group by pr.ContractorID, concat(u.FirstName,' ',u.LastName)
	End

	--When user select a year and all for month
	Else If (@Year != -1 and @Month = -1)
	Begin

		select pr.ContractorID, concat(u.FirstName,' ',u.LastName) as ContractorName,
		cast(ROUND(AVG(cast(Rating as decimal(18,2))), 2) as decimal(18,2)) as OverallRating
		from [dbo].[ProjectTaskReview] as pr
		left join [dbo].[User] as u on u.UserID = pr.ContractorID
		where Year(pr.CreateDateTime) = @Year
		group by pr.ContractorID, concat(u.FirstName,' ',u.LastName)

	End

	Else
	Begin
		select pr.ContractorID, concat(u.FirstName,' ',u.LastName) as ContractorName,
		cast(ROUND(AVG(cast(Rating as decimal(18,2))), 2) as decimal(18,2)) as OverallRating
		from [dbo].[ProjectTaskReview] as pr
		left join [dbo].[User] as u on u.UserID = pr.ContractorID
		where Year(pr.CreateDateTime) = @Year and Month (pr.CreateDateTime) = @Month
		group by pr.ContractorID, concat(u.FirstName,' ',u.LastName)
	End

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ReportMgntContractorReviewLoadInitialData]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2024-02-04
-- Description:	Get Initial data for Contractor Review Report
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_ReportMgntContractorReviewLoadInitialData] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--Years
    select a.[YearID] as [ValueID], a.[YearName] as [Value]
	from [dbo].[Year] as a
	where a.IsActive = 1
	order by  a.[YearID] desc

	--Months
	select a.[MonthID] as [ValueID], a.[MonthName] as [Value]
	from [dbo].[Month] as a
	where a.IsActive = 1

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ReportMgntCustomerOverall]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2024-02-05
-- Description:	Load data for Customer Overall Report
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_ReportMgntCustomerOverall] 
	@UserID int,
	@Year int,
	@Month int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--When user select all for month
	If (@Year != 0 and @Month = -1)
	Begin
		select o.CreateUser as CustomerID, concat(u.FirstName,' ',u.LastName) as CustomerName,
		SUM(od.ItemWiseTotal) as Total
		from [dbo].[Order] as o
		left join [dbo].[OrderDetail] as od on o.OrderID = od.OrderID
		left join [dbo].[OrderPaymentMethod] as p on o.PaymentMethod = p.OrderPayMethodID
		left join [dbo].[User] as u on o.CreateUser = u.UserID
		where od.VendorID = @UserID and Year(o.PlacedDate) = @Year 
		group by o.CreateUser, concat(u.FirstName,' ',u.LastName)

	End

	Else
	Begin
		select o.CreateUser as CustomerID, concat(u.FirstName,' ',u.LastName) as CustomerName,
		SUM(od.ItemWiseTotal) as Total
		from [dbo].[Order] as o
		left join [dbo].[OrderDetail] as od on o.OrderID = od.OrderID
		left join [dbo].[OrderPaymentMethod] as p on o.PaymentMethod = p.OrderPayMethodID
		left join [dbo].[User] as u on o.CreateUser = u.UserID
		where od.VendorID = @UserID and Year(o.PlacedDate) = @Year and Month(o.PlacedDate) = @Month
		group by o.CreateUser, concat(u.FirstName,' ',u.LastName)
	End

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ReportMgntInventory]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2024-02-05
-- Description:	Inventory Report
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_ReportMgntInventory]
	-- Add the parameters for the stored procedure here
	@VendorCategoryTypeID int,
	@UserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--When User select 'All' Option
	IF(@VendorCategoryTypeID = -1)
	Begin
		Select i.ItemID,i.VendorCategoryTypeID, vct.VendorCategoryName,
		i.ItemName,i.UnitAmount,
		it.Qty as TotalQty, [dbo].[FUNC_GET_ItemInvPurchasedCount](i.ItemID) as SoldQty,
		(it.Qty - [dbo].[FUNC_GET_ItemInvPurchasedCount](i.ItemID)) as AvailableQty,
		CASE
		WHEN i.IsActive = 1 THEN 'Active'
		ELSE 'Inactive'
		END AS IsActiveStatusName
		From [MITProj_CMMS].[dbo].[Item] as i
		left join [dbo].[ItemInventory] as it on i.ItemID = it.ItemID and it.[IsInvAdded] = 1 and it.[IsCurrent] = 1
		left join [dbo].[VendorCategory] as vc on i.VendorCategoryTypeID = vc.VendorCategoryTypeID and vc.UserID = @UserID and vc.IsActive = 1
		left join [dbo].[VendorCategoryType] as vct on vc.VendorCategoryTypeID = vct.VendorCategoryTypeID
		Where i.VendorID = @UserID
		Order by i.IsActive desc, i.ItemName;
	End
	Else
	Begin
		Select i.ItemID,i.VendorCategoryTypeID, vct.VendorCategoryName,
		i.ItemName,i.UnitAmount,
		it.Qty as TotalQty, [dbo].[FUNC_GET_ItemInvPurchasedCount](i.ItemID) as SoldQty,
		(it.Qty - [dbo].[FUNC_GET_ItemInvPurchasedCount](i.ItemID)) as AvailableQty,
		CASE
		WHEN i.IsActive = 1 THEN 'Active'
		ELSE 'Inactive'
		END AS IsActiveStatusName
		From [MITProj_CMMS].[dbo].[Item] as i
		left join [dbo].[ItemInventory] as it on i.ItemID = it.ItemID and it.[IsInvAdded] = 1 and it.[IsCurrent] = 1
		left join [dbo].[VendorCategory] as vc on i.VendorCategoryTypeID = vc.VendorCategoryTypeID and vc.UserID = @UserID and vc.IsActive = 1
		left join [dbo].[VendorCategoryType] as vct on vc.VendorCategoryTypeID = vct.VendorCategoryTypeID
		Where i.VendorID = @UserID and i.VendorCategoryTypeID = @VendorCategoryTypeID
		Order by i.IsActive desc, i.ItemName;

	End

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ReportMgntOrderStatus]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2024-02-04
-- Description:	Order Status Report
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_ReportMgntOrderStatus]
	-- Add the parameters for the stored procedure here
	@UserID int,
	@Year int,
	@Month int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @OrderDateTable table (
		[PlacedDate] date
	)

	insert into @OrderDateTable ([PlacedDate])
	select cast(o.PlacedDate as date) as PlacedDate
	from [dbo].[Order] as o
	left join [dbo].[OrderDetail] as od on o.OrderID = od.OrderID
	left join [dbo].[OrderPaymentMethod] as p on o.PaymentMethod = p.OrderPayMethodID
	where od.VendorID = @UserID and Year(o.PlacedDate) = @Year and Month(o.PlacedDate) = @Month
	group by cast(o.PlacedDate as date), o.PaymentMethod, p.PayMethodName

	select convert(varchar, d.PlacedDate, 101) as PlacedDate, [dbo].[FUNC_GET_ReportMgntOrderStatusCountByDate](@UserID, d.PlacedDate, 1) as ProcessingCount,
	[dbo].[FUNC_GET_ReportMgntOrderStatusCountByDate](@UserID, d.PlacedDate, 2) as ShippedCount,
	[dbo].[FUNC_GET_ReportMgntOrderStatusCountByDate](@UserID, d.PlacedDate, 3) as DeliveredCount,
	[dbo].[FUNC_GET_ReportMgntOrderStatusCountByDate](@UserID, d.PlacedDate, 4) as CancelledCount
	from @OrderDateTable as d
	order by d.PlacedDate desc 

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ReportMgntPopularItem]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2024-02-05
-- Description:	Popular Item Report
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_ReportMgntPopularItem]
	-- Add the parameters for the stored procedure here
	@UserID int,
	@Year int,
	@Month int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @PopularItem table (
		ItemName nvarchar(100),
		VendorCategoryName nvarchar(100),
		SoldQty decimal(18,2)
	)

	Insert into @PopularItem(ItemName, VendorCategoryName, SoldQty)
	Select i.ItemName, vct.VendorCategoryName,
	[dbo].[FUNC_GET_ItemPurchasedCountForPopItemReport](i.ItemID,@Year,@Month) as SoldQty
	From [MITProj_CMMS].[dbo].[Item] as i
	left join [dbo].[ItemInventory] as it on i.ItemID = it.ItemID and it.[IsInvAdded] = 1 and it.[IsCurrent] = 1
	left join [dbo].[Order] as o on it.OrderID = o.OrderID and it.OrderID is not null 
	left join [dbo].[VendorCategory] as vc on i.VendorCategoryTypeID = vc.VendorCategoryTypeID and vc.UserID = @UserID and vc.IsActive = 1
	left join [dbo].[VendorCategoryType] as vct on vc.VendorCategoryTypeID = vct.VendorCategoryTypeID
	Where i.VendorID = @UserID

	Select *
	From @PopularItem as pt
	Order by pt.SoldQty desc;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ReportMgntProjectOverview]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2024-01-22
-- Description:	Project Overview Report
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_ReportMgntProjectOverview]
	-- Add the parameters for the stored procedure here
	@UserID int,
	@StartDate nvarchar(20),
	@EndDate nvarchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @StartDateFormatted date;
	Declare @EndDateFormatted date;

	set @StartDateFormatted = @StartDate;
	set @EndDateFormatted = @EndDate;

	select p.ProjectID, p.ProjectTitle, concat(u.FirstName,' ',u.LastName) as ClientName, pr.PriorityName,
	convert(varchar, p.StartDate, 101) as StartDate,convert(varchar, p.EndDate, 101) as EndDate,
	ps.StatusName as ProjectStatusName,
	[dbo].[FUNC_GET_ProjectTaskCountByProjectID](p.ProjectID, 1) as NewTaskCount, -- 1 is New
	[dbo].[FUNC_GET_ProjectTaskCountByProjectID](p.ProjectID, 2) as InProgressTaskCount, -- 2 is In Progress
	[dbo].[FUNC_GET_ProjectTaskCountByProjectID](p.ProjectID, 3) as CompleteTaskCount, -- 3 is completed
	[dbo].[FUNC_GET_ProjectPercentageByProjectID](p.ProjectID) as ProjectProgress
	from [dbo].[Project] as p
	left join [dbo].[User] as u on p.ClientID = u.UserID
	left join [dbo].[ProjectStatus] as ps on p.ProjectStatus = ps.ProjectStatusID
	left join [dbo].[ProjectPriority] as pr on p.ProjectPriority = pr.ProjectPriorityID
	where (p.CreateUser = @UserID)
	--and ((@StartDateFormatted between p.StartDate and p.EndDate) or (@EndDateFormatted between p.StartDate and p.EndDate))
	and ((p.[StartDate] between @StartDateFormatted and @EndDateFormatted) or (p.[EndDate] between @StartDateFormatted and @EndDateFormatted)
	or (@StartDateFormatted between p.[StartDate] and p.[EndDate]) or (@EndDateFormatted between  p.[StartDate] and p.[EndDate]))
	order by ProjectStatus asc;
	

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ReportMgntProjectProgress]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2024-02-04
-- Description:	Get User's Project details
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_ReportMgntProjectProgress] 
	@ProjectID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select tsk.TaskID, tsk.ProjectID, pro.ProjectTitle, tsk.TaskName,
	p.PriorityName,
	tsk.TaskStatus, ts.TaskStatusName,
	convert(varchar, tsk.StartDate, 101) as StartDate, convert(varchar(5), tsk.StartTime, 8) as StartTime,
	convert(varchar, tsk.EndDate, 101) as EndDate, convert(varchar(5), tsk.EndTime, 8) as EndTime,
	tsk.AssignTo, concat(u.FirstName,' ', u.LastName) as AssignToName
	from [dbo].[ProjectTask] as tsk
	left join [dbo].[Project] as pro on tsk.ProjectID = pro.ProjectID
	left join [dbo].[ProjectTaskRateType] as tr on tsk.TaskRateType = tr.TaskRateTypeID
	left join [dbo].[ProjectPriority] as p on tsk.TaskPriority = p.ProjectPriorityID
	left join [dbo].[ProjectTaskStatus] as ts on tsk.TaskStatus = ts.TaskStatusID
	left join [dbo].[ServiceType] as st on tsk.ServiceType = st.ServiceTypeID
	left join [dbo].[User] as u on tsk.AssignTo = u.UserID
	where tsk.ProjectID = @ProjectID
	order by tsk.TaskStatus asc

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ReportMgntProjectProgressLoadInitialData]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2024-02-04
-- Description:	Get User's Projects for dropdown
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_ReportMgntProjectProgressLoadInitialData] 
	@UserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--project details
	select p.ProjectID as [ValueID], p.ProjectTitle as [Value]
	from [dbo].[Project] as p
	left join [dbo].[User] as u on p.ClientID = u.UserID
	left join [dbo].[ProjectStatus] as ps on p.ProjectStatus = ps.ProjectStatusID
	where (p.CreateUser = @UserID or p.ClientID = @UserID)
	order by ProjectStatus asc;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ReportMgntSalesOverview]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2024-02-04
-- Description:	Sales Overview Report
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_ReportMgntSalesOverview]
	-- Add the parameters for the stored procedure here
	@UserID int,
	@Year int,
	@Month int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select convert(varchar, o.PlacedDate, 101) as PlacedDate, o.PaymentMethod, p.PayMethodName,
	SUM(od.ItemWiseTotal) as Total
	from [dbo].[Order] as o
	left join [dbo].[OrderDetail] as od on o.OrderID = od.OrderID
	left join [dbo].[OrderPaymentMethod] as p on o.PaymentMethod = p.OrderPayMethodID
	where od.VendorID = @UserID and Year(o.PlacedDate) = @Year and Month(o.PlacedDate) = @Month
	and od.OrderDetailStatus <> 4 -- 4 is Cancelled Orders
	group by convert(varchar, o.PlacedDate, 101), o.PaymentMethod, p.PayMethodName

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_SearchCustomer]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-09-14
-- Description:	Search Customers
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_SearchCustomer]
	-- Add the parameters for the stored procedure here
	@SearchKeyword nvarchar(MAX) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select u.UserID as [Value], u.Username as [Label], concat(u.FirstName,' ',u.LastName) as [Desc]
	from [dbo].[User] as u
	where u.UserRoleID = 2 -- UserRoleID = 2 is Customers
	and (( concat(u.FirstName,' ',u.LastName) like @SearchKeyword + '%') or ( concat(u.FirstName,' ',u.LastName) like  '%' + @SearchKeyword + '%') 
	or ( concat(u.FirstName,' ',u.LastName) like '%' + @SearchKeyword));

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_UserAllPermissionList]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-08-27
-- Description:	Get All User Permission List
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_UserAllPermissionList]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Select distinct pe.PermissionName as PermissionName
	from [dbo].[Permission] as pe;
  
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_UserMgntLoadAllUsers]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-12-05
-- Description:	Load all user details
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_UserMgntLoadAllUsers] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select u.UserID, u.Username, u.Email, u.FirstName, u.LastName,
	u.UserRoleID, ur.RoleName, u.IsActive,
	CASE
	WHEN u.IsActive = 1 THEN 'Active'
	ELSE 'Inactive'
	END AS IsActiveStatusName
	from [dbo].[User] as u
	left join [dbo].[UserRole] as ur on u.UserRoleID = ur.UserRoleID

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_UserMgntLoadUserByUserID]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-12-05
-- Description:	Load all user details by UserID
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_UserMgntLoadUserByUserID] 
(
	@UserID int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select u.UserID, u.Username, u.Email, u.FirstName, u.LastName,
	u.UserRoleID, ur.RoleName, u.IsActive,
	CASE
	WHEN u.IsActive = 1 THEN 'Active'
	ELSE 'Inactive'
	END AS IsActiveStatusName
	from [dbo].[User] as u
	left join [dbo].[UserRole] as ur on u.UserRoleID = ur.UserRoleID
	where u.UserID = @UserID;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_UserPermissionList]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-08-27
-- Description:	Get User Permission List
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_UserPermissionList]
	-- Add the parameters for the stored procedure here
	@UserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @RoleID int;

	--select user's role
	select @RoleID = u.UserRoleID
	from [dbo].[User] as u
	where u.UserID = @UserID and u.IsActive = 1

	Select pe.PermissionName
	from [dbo].[UserRolePermission] as up
	left join [dbo].[Permission] as pe on up.UserPermissionID = pe.PermissionID
	Where up.RoleID = @RoleID and up.IsActive = 1
    
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_UserProfDetails]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-12-02
-- Description:	Get User Info to User Profile
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_UserProfDetails] 
	-- Add the parameters for the stored procedure here
	@UserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --user primary details
	select u.UserID, u.Username, u.Email, u.FirstName, u.LastName,
	u.UserRoleID, ur.RoleName, u.NIC, u.MobileNo
	from [dbo].[User] as u
	left join [dbo].[UserRole] as ur on u.UserRoleID = ur.UserRoleID
	where u.UserID = @UserID

	--user address details
	select a.AddressID, a.UserID, u.Username, a.Address1, a.Address2, a.Address3,
	a.District, a.Province
	from [dbo].[UserAddressDetail] as a
	left join [dbo].[User] as u on a.UserID = u.UserID 
	where a.UserID = @UserID and a.IsPrimary = 1 and a.IsActive = 1

	--user contractor service info
	select cs.UserID, cs.ServiceTypeID, s.ServiceTypeName
	from [dbo].[ContractorService] as cs
	left join [dbo].[ServiceType] as s on cs.ServiceTypeID = s.ServiceTypeID
	where cs.UserID = @UserID and cs.IsActive = 1

	--user vendor category info
	select vc.UserID, vc.VendorCategoryTypeID, vt.VendorCategoryName
	from [dbo].[VendorCategory] as vc
	left join [dbo].[VendorCategoryType] as vt on vc.VendorCategoryTypeID = vt.VendorCategoryTypeID
	where vc.UserID = @UserID and vc.IsActive = 1

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_UserProfImgUrlsByUserID]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-12-02
-- Description:	Get Img Urls by UserID
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_UserProfImgUrlsByUserID]
	-- Add the parameters for the stored procedure here
	@UserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Select ti.ImageName, ti.ImageURL
	From [dbo].[UserImg] as ti
	Where ti.UserID = @UserID;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_UserRegInitialData]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-09-12
-- Description:	Get initial data for user registration
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_UserRegInitialData]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --user roles
    select a.UserRoleID as [ValueID], a.RoleName as [Value]
	from [dbo].[UserRole] as a
	where a.IsRegistrationViewAllowed = 1 and a.IsActive = 1

	--service types
	select a.ServiceTypeID as [ValueID], a.ServiceTypeName as [Value]
	from [dbo].[ServiceType] as a
	where a.IsActive = 1

	--vendor category types
	select a.VendorCategoryTypeID as [ValueID], a.VendorCategoryName as [Value]
	from [dbo].[VendorCategoryType] as a
	where a.IsActive = 1

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_UserRoleAllPermissions]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-12-15
-- Description:	Load all Permissions
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_UserRoleAllPermissions]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @PermiTable table (
		[RowNo] int,
		[PermissionID] int,
		[ScreenName] nvarchar(50),
		[PermissionName] nvarchar(100)
	)

	insert into @PermiTable ([RowNo], [PermissionID], [ScreenName], [PermissionName])
	select (row_number() over (order by p.PermissionID asc)) - 1 as RowNo, 
	p.PermissionID, p.ScreenName, p.PermissionName
	From [dbo].[Permission] as p
	where p.IsActive = 1
	order by p.PermissionID asc;

	select *
	from @PermiTable;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_UserRoleInitialData]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-12-15
-- Description:	Load all initial data
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_UserRoleInitialData]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--user roles 
    select a.UserRoleID as [ValueID], a.RoleName as [Value]
	from [dbo].[UserRole] as a

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_UserRolePermissionsByRoleID]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-12-15
-- Description:	Load all Permissions by RoleID
-- =============================================
CREATE PROCEDURE [dbo].[SP_GET_UserRolePermissionsByRoleID]
	@RoleID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select up.UserPermissionID as PermissionID, p.ScreenName, p.PermissionName
	From [dbo].[UserRolePermission] as up
	left join [Permission] as p on up.UserPermissionID = p.PermissionID and p.IsActive = 1
	where up.RoleID = @RoleID;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_AdvMgntDetails]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-11-24
-- Description:	Update Advertisement details
-- =============================================
CREATE PROCEDURE [dbo].[SP_UPDATE_AdvMgntDetails]
	-- Add the parameters for the stored procedure here
	@AdvID int,
	@CampaignName nvarchar(50),
	@Description nvarchar(max),
	@StartDate date,
	@EndDate date,
	@IsActive bit,
	@UserRoleID int,
	@CreateUser int,
	@CreateIP nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Update [dbo].[Advertisement]
	set [CampaignName] = @CampaignName, [Description] = @Description,
	[StartDate] = @StartDate, [EndDate] = @EndDate,
	[IsActive] = @IsActive, [UserRoleID] = @UserRoleID,
	[ModUser] = @CreateUser, [ModIP] = @CreateIP, [ModDateTime] = GETDATE()
	where [AdvID] = @AdvID;

	select 'Advertisement Updated Successfully' as outputInfo, 1 as rsltType;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_ItemInventory]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-10-18
-- Description:	Update items to Item Inventory
-- =============================================
CREATE PROCEDURE [dbo].[SP_UPDATE_ItemInventory]
	-- Add the parameters for the stored procedure here
	@ItemID int,
	@VendorCategoryTypeID int,
	@ItemName nvarchar(50),
	@ItemDescription nvarchar(100),
	@ItemWeight decimal(18,2),
	@WeightUnit int,
	@UOM int,
	@UnitAmount decimal(18,2),
	@MinQty decimal(18,2),
	@MaxQty decimal(18,2),
	@Qty decimal(18,2),
	@VendorID int,
	@IsSoldUnitWise bit,
	@IsActive bit,	
	@CreateUser int,
	@CreateIP nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --Header
	Update [dbo].[Item]
	set [VendorCategoryTypeID] = @VendorCategoryTypeID, 
	[ItemName] = @ItemName, [ItemDescription] = @ItemDescription, [ItemWeight] = @ItemWeight, [WeightUnit] = @WeightUnit,
	[UOM] = @UOM, [UnitAmount] = @UnitAmount, [MinQty] = @MinQty,
	[MaxQty] = @MaxQty, [IsSoldUnitWise] = @IsSoldUnitWise, [IsActive] = @IsActive,
	[ModUser] = @CreateUser, [ModIP] = @CreateIP, [ModDateTime] = GETDATE()
	where [ItemID] = @ItemID;

	--Deactivate previous main inv detail
	Update [dbo].[ItemInventory]
	set [IsCurrent] = 0,
	[ModUser] = @CreateUser, [ModIP] = @CreateIP, [ModDateTime] = GETDATE()
	where [ItemID] = @ItemID and [IsInvAdded] = 1 and [IsCurrent]=1;

	--Add new Detail record
	Insert into [dbo].[ItemInventory] ([ItemID],[Qty],
    [IsInvAdded],[IsPurchased],[IsCurrent],
    [CreateUser],[CreateIP],[CreateDateTime])
	values(@ItemID, @Qty,
	1, 0, 1,
	@CreateUser, @CreateIP, GETDATE())

	select 'Item Updated Successfully' as outputInfo, 1 as rsltType;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_OrderMgntStatusDetails]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-11-20
-- Description:	Update order status in Order Mgnt
-- =============================================
CREATE PROCEDURE [dbo].[SP_UPDATE_OrderMgntStatusDetails]
	-- Add the parameters for the stored procedure here
	@OrderID int, 
	@PackageID int,
	@OrderStatus int,
	@CreateUser int,
	@CreateIP nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @CurrentOrderStatus int;
	declare @CurrentOrderStatName nvarchar(20);
	Select @CurrentOrderStatus = OrderStatus 
	From [dbo].[OrderStatusHistory]
	Where [OrderID] = @OrderID and [PackageID] = @PackageID and [IsCurrent]=1;

	--Check whether order is already in same state
	IF(@CurrentOrderStatus = @OrderStatus)
	Begin
		select @CurrentOrderStatName = OrderStatusName
		from [dbo].[OrderStatusType]
		where OrderStatusID = @CurrentOrderStatus

		select concat('Selected Order already ', @CurrentOrderStatName) as outputInfo, 0 as rsltType;
	End
	Else
	Begin
		If(@OrderStatus = 4) --when order is cancelled
		Begin
			--Update Order Detail
			Update [dbo].[OrderDetail]
			Set [OrderDetailStatus] = @OrderStatus, [ModUser] = @CreateUser, 
			[ModIP] = @CreateIP, [ModDateTime] = getdate()
			Where [OrderID] = @OrderID and [PackageID] = @PackageID and [VendorID] = @CreateUser;

			--Add new record to OrderStatusHistory by deactivating current record
			Update [dbo].[OrderStatusHistory]
			Set [IsCurrent] = 0
			Where [OrderID] = @OrderID and [PackageID] = @PackageID and [IsCurrent]=1;

			Insert into [dbo].[OrderStatusHistory] ([OrderID],[PackageID],[OrderStatus],
			[IsCurrent],[CreateUser],[CreateIP],[CreateDateTime])
			Values(@OrderID, @PackageID, @OrderStatus,
			1, @CreateUser, @CreateIP, getdate());

			--Add records to ItemInventory
			Insert into [dbo].[ItemInventory] ([ItemID],[Qty],[IsInvAdded],[IsPurchased],
			[OrderID],[IsCurrent],[CreateUser],[CreateIP],[CreateDateTime])
			select od.ItemID, od.Quantity, 0, 1,
			@OrderID, 0, @CreateUser, @CreateIP, getdate()
			from [dbo].[OrderDetail] as od
			where [OrderID] = @OrderID and [PackageID] = @PackageID and [VendorID] = @CreateUser;

			select 'Order Updated Successfully' as outputInfo, 1 as rsltType;
		End
		Else
		Begin
			--Update Order Detail
			Update [dbo].[OrderDetail]
			Set [OrderDetailStatus] = @OrderStatus, [ModUser] = @CreateUser, 
			[ModIP] = @CreateIP, [ModDateTime] = getdate()
			Where [OrderID] = @OrderID and [PackageID] = @PackageID and [VendorID] = @CreateUser;

			--Add new record to OrderStatusHistory by deactivating current record
			Update [dbo].[OrderStatusHistory]
			Set [IsCurrent] = 0
			Where [OrderID] = @OrderID and [PackageID] = @PackageID and [IsCurrent]=1;

			Insert into [dbo].[OrderStatusHistory] ([OrderID],[PackageID],[OrderStatus],
			[IsCurrent],[CreateUser],[CreateIP],[CreateDateTime])
			Values(@OrderID, @PackageID, @OrderStatus,
			1, @CreateUser, @CreateIP, getdate());

			select 'Order Updated Successfully' as outputInfo, 1 as rsltType;
		End
	End
	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_PermissionDetails]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-12-10
-- Description:	Update Permission details
-- =============================================
CREATE PROCEDURE [dbo].[SP_UPDATE_PermissionDetails]
	-- Add the parameters for the stored procedure here
	@PermissionID int,
	@ScreenName nvarchar(50),
	@PermissionName nvarchar(100),
	@IsActive bit,
	@CreateUser int,
	@CreateIP nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Update [dbo].[Permission]
	set [ScreenName] = @ScreenName, [PermissionName] = @PermissionName,
	[IsActive] = @IsActive,
	[ModUser] = @CreateUser, [ModIP] = @CreateIP, [ModDateTime] = GETDATE()
	where [PermissionID] = @PermissionID;

	select 'Permission Updated Successfully' as outputInfo, 1 as rsltType;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_ProjectDetails]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-09-03
-- Description:	Update Contruction Project Details
-- =============================================
CREATE PROCEDURE [dbo].[SP_UPDATE_ProjectDetails]
	-- Add the parameters for the stored procedure here
	@ProjectID int,
	@ProjectTitle nvarchar(100),
	@ClientID int,
	@ProjectPriority int,
	@ProjectSize int,
	@StartDate date,
	@StartTime time(7),
	@EndDate date,
	@EndTime time(7),
	@Description nvarchar(max),
	@ProjectStatus int,
	@CreateUser int,
	@CreateIP nvarchar(100)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Update [dbo].[Project]
	set [ProjectTitle] = @ProjectTitle, [ClientID] = ClientID, 
	[ProjectPriority] = @ProjectPriority, [ProjectSize] = @ProjectSize,
	[StartDate] = @StartDate, [StartTime] = @StartTime,
	[EndDate] = @EndDate, [EndTime] = @EndTime,
	[Description] = @Description, [ProjectStatus] = @ProjectStatus,
	[ModUser] = @CreateUser, [ModIP] = @CreateIP, [ModDateTime] = GETDATE()
	where [ProjectID] = @ProjectID;

	select 'Project Details Updated Successfully' as outputInfo, 1 as rsltType;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_ProjectTask]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-09-05
-- Description:	Update Project Task
-- =============================================
CREATE PROCEDURE [dbo].[SP_UPDATE_ProjectTask]
	-- Add the parameters for the stored procedure here
	@TaskID int,
	@ProjectID int,
	@TaskName nvarchar(100),
	@TaskRate decimal(18,2),
	@TaskRateType int,
	@TaskPriority int,
	@TaskStatus int,
	@Description nvarchar(max),
	@StartDate date,
	@StartTime time(7),
	@EndDate date,
	@EndTime time(7),
	@ServiceType int,
	@AssignTo int,
	@CreateUser int,
	@CreateIP nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Update [dbo].[ProjectTask]
	set [ProjectID] = @ProjectID, 
	[TaskName] = @TaskName, [TaskRate] = @TaskRate, [TaskRateType] = @TaskRateType,
	[TaskPriority] = @TaskPriority, [TaskStatus] = @TaskStatus, [Description] = @Description,
	[StartDate] = @StartDate, [StartTime] = @StartTime,
	[EndDate] = @EndDate, [EndTime] = @EndTime,
	[ServiceType] = @ServiceType, [AssignTo] = @AssignTo, [ApprovalStatus] = 0,
	[ModUser] = @CreateUser, [ModIP] = @CreateIP, [ModDateTime] = GETDATE()
	where [TaskID] = @TaskID;

	select 'Project Task Updated Successfully' as outputInfo, 1 as rsltType, @TaskID as savedID;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_UserLoginChangePassword]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-12-26
-- Description:	Change user login password
-- =============================================
CREATE PROCEDURE [dbo].[SP_UPDATE_UserLoginChangePassword]
	-- Add the parameters for the stored procedure here
	@Username nvarchar(50),
	@NewPassword nvarchar(max),
	@CreateIP nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @IsAlreadyUsedPass int;
	Select @IsAlreadyUsedPass = COUNT(*)
	From [dbo].[User] as u
	Where u.[Username] = @Username and u.[Password] = @NewPassword and u.[IsActive] = 1;

	--When already try update with same old password
	If(@IsAlreadyUsedPass > 0)
	Begin
		select 'Entered new password already used, please choose an new password' as outputInfo, 0 as rsltType;
	End
	Else
	Begin
		--Update user password
		Update [dbo].[User]
		set [Password] = @NewPassword, [IsTempPassword] = 0, [AttemptCount] = 0,
		[ModUser] = null, [ModIP] = @CreateIP, [ModDateTime] = GETDATE()
		where Username = @Username;

		select 'User Password Reset Successfully' as outputInfo, 1 as rsltType;
	End
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_UserMgntChangeUserStatus]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-12-05
-- Description:	change user account status
-- =============================================
CREATE PROCEDURE [dbo].[SP_UPDATE_UserMgntChangeUserStatus]
	-- Add the parameters for the stored procedure here
	@UserID int,
	@Status bit,
	@CreateUser int,
	@CreateIP nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--Update user status
	Update [dbo].[User]
	set [IsActive] = @Status, [AttemptCount] = 0,
	[ModUser] = @UserID, [ModIP] = @CreateIP, [ModDateTime] = GETDATE()
	where UserID = @UserID;

	declare @StatusName nvarchar(100);

	Select @StatusName = CASE WHEN @Status = 1 THEN 'Activated' ELSE 'Deactivated' END 

	select concat('User ', @StatusName, ' Successfully') as outputInfo, 1 as rsltType, @UserID as savedID;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_UserMgntResetPassword]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-12-05
-- Description:	Reset user password
-- =============================================
CREATE PROCEDURE [dbo].[SP_UPDATE_UserMgntResetPassword]
	-- Add the parameters for the stored procedure here
	@UserID int,
	@TempPassword nvarchar(max),
	@CreateUser int,
	@CreateIP nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--reset user password
	Update [dbo].[User]
	set [Password] = @TempPassword, [IsTempPassword] = 1, [AttemptCount] = 0,
	[ModUser] = @UserID, [ModIP] = @CreateIP, [ModDateTime] = GETDATE()
	where UserID = @UserID;

	select 'User Password Resets Successfully' as outputInfo, 1 as rsltType, @UserID as savedID;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_UserProfChangePassword]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-12-04
-- Description:	Change user password
-- =============================================
CREATE PROCEDURE [dbo].[SP_UPDATE_UserProfChangePassword]
	-- Add the parameters for the stored procedure here
	@UserID int,
	@CurrentPassword nvarchar(max),
	@NewPassword nvarchar(max),
	@CreateUser int,
	@CreateIP nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @IsCurrentPassValid int;
	Select @IsCurrentPassValid = COUNT(*)
	From [dbo].[User] as u
	Where u.[UserID] = @UserID and u.[Password] = @CurrentPassword and u.[IsActive] = 1;

	Declare @IsAlreadyUsedPass int;
	Select @IsAlreadyUsedPass = COUNT(*)
	From [dbo].[User] as u
	Where u.[UserID] = @UserID and u.[Password] = @NewPassword and u.[IsActive] = 1;

	--Check Current password is valid
	If(@IsCurrentPassValid = 0)
	Begin
		select 'Entered current password is incorrect' as outputInfo, 0 as rsltType;
	End
	Else
	Begin
		--When already try update with same old password
		If(@IsAlreadyUsedPass > 0)
		Begin
			select 'Entered new password already used, please choose an new password' as outputInfo, 0 as rsltType;
		End
		Else
		Begin
			--Update user password
			Update [dbo].[User]
			set [Password] = @NewPassword,
			[ModUser] = @UserID, [ModIP] = @CreateIP, [ModDateTime] = GETDATE()
			where UserID = @UserID;

			select 'User Password Updated Successfully' as outputInfo, 1 as rsltType;
		End
	End
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_UserProfDetails]    Script Date: 3/22/2024 11:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shalitha Dhananjaya
-- Create date: 2023-12-02
-- Description:	Update user profile details
-- =============================================
CREATE PROCEDURE [dbo].[SP_UPDATE_UserProfDetails]
	-- Add the parameters for the stored procedure here
	@UserID int,
	@UserRoleID int,
	@FirstName nvarchar(100),
	@LastName nvarchar(100),
	@NIC nvarchar(12),
	@MobileNo nvarchar(10),
	@Address1 nvarchar(50),
	@Address2 nvarchar(50),
	@Address3 nvarchar(50),
	@District nvarchar(50),
	@Province nvarchar(50),
	@ContractorServiceList nvarchar(MAX) = '',
	@VendorCategoryList nvarchar(MAX) = '',
	@CreateUser int,
	@CreateIP nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--Update user
	Update [dbo].[User]
	set [FirstName] = @FirstName, [LastName] = @LastName, [NIC] = @NIC, [MobileNo] = @MobileNo,
	[ModUser] = @UserID, [ModIP] = @CreateIP, [ModDateTime] = GETDATE()
	where UserID = @UserID;

	--Update User Address Details
	Update [dbo].[UserAddressDetail]
	set [Address1] = @Address1, [Address2] = @Address2, [Address3] = @Address3, [District] = @District, [Province] = @Province,
	[ModUser] = @UserID, [ModIP] = @CreateIP, [ModDateTime] = GETDATE()
	where UserID = @UserID and IsActive = 1 ;

	--When User is a Contractor
	If(@UserRoleID = 3)
	Begin
			
		DECLARE @ContractorServiceTable TABLE (ServiceTypeID int);
		Insert into @ContractorServiceTable 
		Select CAST([value] AS int) 
		From STRING_SPLIT(@ContractorServiceList, ','); 

		--delete previous info
		delete from [dbo].[ContractorService]
		where UserID = @UserID and IsActive = 1

		Insert into [dbo].[ContractorService] ([UserID],[ServiceTypeID],[IsActive],
		[CreateUser],[CreateIP],[CreateDateTime])
		Select @UserID, c.ServiceTypeID,1,
		@UserID,@CreateIP,GETDATE()
		From @ContractorServiceTable as c

	End
	--When User is a Vendor
	Else If(@UserRoleID = 4)
	Begin

		DECLARE @VendorCategoryTable TABLE (VendorCategoryTypeID int);
		Insert into @VendorCategoryTable 
		Select CAST([value] AS int) 
		From STRING_SPLIT(@VendorCategoryList, ','); 

		--delete previous info
		delete from [dbo].[VendorCategory]
		where UserID = @UserID and IsActive = 1

		Insert into [dbo].[VendorCategory] ([UserID],[VendorCategoryTypeID],[IsActive],
		[CreateUser],[CreateIP],[CreateDateTime])
		Select @UserID, v.VendorCategoryTypeID,1,
		@UserID,@CreateIP,GETDATE()
		From @VendorCategoryTable as v

	End

	select 'User Profile Details Updated Successfully' as outputInfo, 1 as rsltType;

END
GO
USE [master]
GO
ALTER DATABASE [MITProj_CMMS] SET  READ_WRITE 
GO
