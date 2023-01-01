---
layout: post
title: C# 使用Microservice架構設計( dotnet 6.0 )
date: 2023-01-01 22:27 +0800
---
## 前言
<p>架構圖 待補</p>

## 建立ASP.NET Core Web API (1/2)
### 新增專案,其名為CompanyManagement
<p>建立方式如下</p>
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/1.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/2.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/3.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/4.png){: width="600" height="500" }


### 新增CompanyModel.cs
<p>建立方式如下</p>
 ![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/9.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    namespace CompanyManagement
    {
        public class CompanyModel
        {
            public int CompanyID { get; set; }
            public string CompanyName { get; set; }
            public string CompanyClass { get; set; }
            public DateTime DateofJoining { get; set; }
        }
    }


### 新增CompanyServiceController.cs
<p>建立方式如下</p>
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/10.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/11.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/12.png){: width="600" height="500" }

### 設定 API Controller

API Controller的function如下
<script  type='text/javascript' src=''>

    using Microsoft.AspNetCore.Mvc;
    namespace CompanyManagement.Controllers
    {
        [Route("api/[controller]")]
        [ApiController]
        public class CompanyServiceController : ControllerBase
        {
            // GET: api/<StudentAdmissionController>
            [HttpGet]
            public IEnumerable<CompanyModel> Get()
            {
                CompanyModel admissionobj1 = new CompanyModel();
                CompanyModel admissionobj2 = new CompanyModel();
                admissionobj1.CompanyID = 1;
                admissionobj1.CompanyName = "HI";
                admissionobj1.CompanyClass = "X";
                admissionobj1.DateofJoining = DateTime.Now;
                admissionobj2.CompanyID = 2;
                admissionobj2.CompanyName = "Jay";
                admissionobj2.CompanyClass = "V";
                admissionobj2.DateofJoining = DateTime.Now;
                List<CompanyModel> listofobj = new List<CompanyModel>
                {
                    admissionobj1,
                    admissionobj2
                };
                return listofobj;
            }
        }
    }



### 執行API顯示結果
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/18.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/16.png){: width="600" height="500" }

## 建立ASP.NET Core Web API (2/2)
### 新增專案，其名為EmpDetail
<p>新增專案</p>
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/5.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/6.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/7.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/8.png){: width="600" height="500" }
###　新增EmpDetail.cs
 ![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/13.png){: width="600" height="500" }
 <script  type='text/javascript' src=''>

     namespace EmpDetail
    {
        public class EmpModel
        {
            public int EmpID { get; set; }
            public string EmpName { get; set; }
            public double AttendencePercentage { get; set; }
        }
    }

### 新增EmpServiceController.cs
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/14.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/11.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/15.png){: width="600" height="500" }
### 設定 API Controller 
API Controller的function如下
 <script  type='text/javascript' src=''>

    using Microsoft.AspNetCore.Mvc;
    namespace EmpDetail.Controllers
    {
        [Route("api/[controller]")]
        [ApiController]
        public class EmpServiceController : ControllerBase
        {

            [HttpGet]
            public IEnumerable<EmpModel> Get()
            {
                EmpModel attendanceObj1 = new EmpModel();
                EmpModel attendanceObj2 = new EmpModel();
                attendanceObj1.EmpID = 1;
                attendanceObj1.EmpName = "Adam";
                attendanceObj1.AttendencePercentage = 83.02;
                attendanceObj2.EmpID = 2;
                attendanceObj2.EmpName = "Brad";
                attendanceObj2.AttendencePercentage = 71.02;
                List<EmpModel> listObj = new List<EmpModel>
                {
                    attendanceObj1,
                    attendanceObj2
                };
                return listObj;
            }
        }
    }


### 執行API顯示結果 
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/19.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/17.png){: width="600" height="500" }
### 設定「同時啟動多個專案」
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/20.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/21.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/22.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/23.png){: width="600" height="500" }

## 建立專案「APIGeteway」
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/24.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/1.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/25.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/3.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/26.png){: width="600" height="500" }
### 在APIGeteway專案中,安裝Ocelot 
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/27.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    NuGet\Install-Package Ocelot -Version 18.0.0

### 新增Ocelot.json 
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/28.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/29.png){: width="600" height="500" }
### 設定Ocelot.json 
Ocelot.json的內容如下
<script  type='text/javascript' src=''>

    {
      "Routes": [
        {
          "DownstreamPathTemplate": "/api/CompanyService",
          "DownstreamScheme": "https",
          "DownstreamHostAndPorts": [
            {
              "Host": "localhost",
              "Port": 7185
            }
          ],
          "UpstreamPathTemplate": "/apigateway/CompanyAPI",
          "UpstreamHttpMethod": [ "GET", "PUT", "POST" ]
        },
        {
          "DownstreamPathTemplate": "/api/EmpService",
          "DownstreamScheme": "https",
          "DownstreamHostAndPorts": [
            {
              "Host": "localhost",
              "Port": 7252
            }
          ],
          "UpstreamPathTemplate": "/apigateway/EmpAPI",
          "UpstreamHttpMethod": [ "GET", "PUT", "POST" ]
        }
      ]
    }

### 設定啟動時,根據JSON載入設定 
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/31.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    using Ocelot.DependencyInjection;
    using Ocelot.Middleware;
    var builder = WebApplication.CreateBuilder(args);
    // Add services to the container.
    builder.Services.AddCors(options => {
        options.AddPolicy("CORSPolicy", builder => builder.AllowAnyMethod().AllowAnyHeader().AllowCredentials().SetIsOriginAllowed((hosts) => true));
    });
    builder.Services.AddControllers();
    // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
    builder.Services.AddEndpointsApiExplorer();
    builder.Services.AddSwaggerGen();
    builder.Configuration.AddJsonFile("Ocelot.json", optional: false, reloadOnChange: true);
    builder.Services.AddOcelot(builder.Configuration);
    var app = builder.Build();
    // Configure the HTTP request pipeline.
    if (app.Environment.IsDevelopment())
    {
        app.UseSwagger();
        app.UseSwaggerUI();
    }
    app.UseCors("CORSPolicy");
    app.UseHttpsRedirection();
    app.UseAuthorization();
    app.MapControllers();
    await app.UseOcelot();
    app.Run();

### 設定多專案同時啟動 
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/30.png){: width="600" height="500" }

### Ocelot.json設定對照 
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/32.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/33.png){: width="600" height="500" }

## Microservice架構DEMO成功的顯示結果

<p>執行專案</p>
<p>可以從APIGeteway的網址調用到其他專案的API</p>
![Desktop View](/assets/img/2023-01-01-c-sharp-microservice-gateway-design-use-dotnet-6-0/34.png){: width="600" height="500" }
