using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using CMMS_Model.Authentication;
using Swashbuckle.AspNetCore.Filters;
using System.Text;
using CMMS_Model.Authentication.Contracts;
using CMMS_ApplicationService.UserAccount;
using CMMS_ApplicationService.ProjectMgnt;
using CMMS_ApplicationService.ItemInventory;
using CMMS_ApplicationService.EStore;
using CMMS_ApplicationService.OrderMgnt;
using CMMS_ApplicationService.AdvMgnt;
using CMMS_ApplicationService.UserProf;
using CMMS_ApplicationService.UserMgnt;
using CMMS_ApplicationService.Report;
using CMMS_ApplicationService.Email;
using CMMS_ApplicationService.Dashboard;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
ConfigurationManager configuration = builder.Configuration;
//Used for JWT
builder.Services.AddAuthentication("JWTAuth")
    .AddJwtBearer("JWTAuth", options =>
    {
        var keyBytes = Encoding.UTF8.GetBytes(Constants.Secret);
        var key = new SymmetricSecurityKey(keyBytes);

        options.TokenValidationParameters = new TokenValidationParameters()
        {
            ValidIssuer = Constants.Issuer,
            ValidAudience = Constants.Audience,
            IssuerSigningKey = key
        };
    });
//Add Cors Service
builder.Services.AddCors();
builder.Services.AddControllers();
//to get client IP Address
builder.Services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
//token generate service
builder.Services.AddScoped<IJWTTokenGenerator, JWTTokenGenerator>();
//DB Services
builder.Services.AddScoped<IUserAuthApplicationService, UserAuthApplicationService>();
builder.Services.AddScoped<IDashboardApplicationService, DashboardApplicationService>();
builder.Services.AddScoped<IProjectMgntApplicationService, ProjectMgntApplicationService>();
builder.Services.AddScoped<ITaskMgntApplicationService, TaskMgntApplicationService>();
builder.Services.AddScoped<ITaskApprovalApplicationService, TaskApprovalApplicationService>();
builder.Services.AddScoped<IItemInventoryApplicationService, ItemInventoryApplicationService>();
builder.Services.AddScoped<IEStoreItemApplicationService, EStoreItemApplicationService>();
builder.Services.AddScoped<IEStoreOrderApplicationService, EStoreOrderApplicationService>();
builder.Services.AddScoped<IOrderMgntApplicationService, OrderMgntApplicationService>();
builder.Services.AddScoped<IAdvMgntApplicationService, AdvMgntApplicationService>();
builder.Services.AddScoped<IUserProfileApplicationService, UserProfileApplicationService>();
builder.Services.AddScoped<IUserMgntApplicationService, UserMgntApplicationService>();
builder.Services.AddScoped<IPermissionApplicationService, PermissionApplicationService>();
builder.Services.AddScoped<IUserRoleApplicationService, UserRoleApplicationService>();
builder.Services.AddScoped<IContractorReportApplicationService, ContractorReportApplicationService>();
builder.Services.AddScoped<IVendorReportApplicationService, VendorReportApplicationService>();
//email application services
builder.Services.AddScoped<IEmailMgntApplicationService, EmailMgntApplicationService>();
builder.Services.AddScoped<IUserMgntEmailApplicationService, UserMgntEmailApplicationService>();
builder.Services.AddScoped<IOrderEmailApplicationService, OrderEmailApplicationService>();
builder.Services.AddScoped<IProjectMgntEmailApplicationService, ProjectMgntEmailApplicationService>();

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "CMMS", Version = "v1" });

    //add for JWT
    c.AddSecurityDefinition("oauth2", new OpenApiSecurityScheme
    {
        Description = "Authorization header",
        In = ParameterLocation.Header,
        Name = "Authorization",
        Type = SecuritySchemeType.ApiKey
    });
    c.OperationFilter<SecurityRequirementsOperationFilter>();

});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

//Use Cors Service
app.UseCors(x => x
.AllowAnyOrigin()
.AllowAnyMethod()
.AllowAnyHeader()
);

app.UseHttpsRedirection();

//Used for JWT 
app.UseAuthentication();

app.UseAuthorization();

app.MapControllers();

app.Run();