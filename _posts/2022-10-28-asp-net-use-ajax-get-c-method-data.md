---
layout: post
title: ASP.NET Use Ajax Get C# Method Data
date: 2022-10-28 11:08 +0800
categories: [C#]
tags: [C#,ASP.Net Framework,AJAX]
published: true 
---
利用AJAX跟C#串接的方式

## 1.在Model 建立一個新的Class 這邊取名為Employee.cs
Source Code：
<script  type='text/javascript' src=''>
  
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;

    namespace WebAjax_Example.Models
    {
        public class Employee
        {
            public int Id { get; set; }
            public string Name { get; set; }
        }
    }



## 2.在HomeController.cs 底下新增一個回傳JsonResult的Method
讓我可以把陣列資料回傳到前端
Source Code：
<script  type='text/javascript' src=''>

    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    using System.Web.Mvc;
    using WebAjax_Example.Models;
    namespace WebAjax_Example.Controllers
    {
        public class HomeController : Controller
        {
            public ActionResult Index()
            {
                return View();
            }
            #region Sample
            [HttpGet]
            public JsonResult GetDataDemo(string strKW)
            {
                List<Employee> listEmployee = new List<Employee>();
                listEmployee.Add(new Employee() {Id=1,Name="AAa1" });
                listEmployee.Add(new Employee() { Id =2, Name = "BBB1" });
                listEmployee.Add(new Employee() { Id =3, Name = "CCC" });
                listEmployee.Add(new Employee() { Id =4, Name = "DD" });
                listEmployee.Add(new Employee() { Id =5, Name = "EEE" });
                return Json(listEmployee, JsonRequestBehavior.AllowGet);
            }
            #endregion
        }
    }


## 3.Index.cshtml 追加Script
data裡面輸入要GetDataDemo的參考
所以可以看到兩者間有一樣的參數名稱  
如下所示，這邊Type使用的是Get  
<script  type='text/javascript' src=''>

    @{
        ViewBag.Title = "Index";
    }
    <h2>@ViewBag.Title.</h2>
    <h3>@ViewBag.Message</h3>

    <p>Use this area to provide additional information.</p>

    @section scripts{
        <script  type='text/javascript' src=''>
        $(document).ready(function () {
            AjaxDEMO()
        });
            function AjaxDEMO() {
 
                $.ajax({
                    async: true,
                    global: false,
                    url: '@Url.Action("GetDataDemo", "Home")',
                    method: 'Get',
                    data: { strKW: 'A' },
                    dataType: 'json',
                    contentType: "application/json; charset=utf-8",
                    success: function (data) {
                        $.each(data, function (i) {
                            console.log(`${data[i].Id}  ${data[i].Name}` );
                        });
                    },
                    beforeSend: function () { },
                    complete: function () {
                    },
                    error: function (xhr) {
                        alert('error');
                    }
                });
            }
        </script>
    }
  
## 4.開啟網頁時，可以看到我們在第２點輸入的資訊
  
![Desktop View](/assets/img/2022-10-28-asp-net-use-ajax-get-c-method-data/1.png){: width="600" height="500" }


--------------------------------------------------------------------------------------------------------------------------
## Controller的Method還傳Class時，JavaScript的撰寫方式
如果遇到Method必須回傳Class的情況
  
假設我們Controller的回傳JsonResult的Method如下  
<script  type='text/javascript' src=''>

    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    using System.Web.Mvc;
    using WebAjax_Example.Models;

    namespace WebAjax_Example.Controllers
    {
        public class AboutController : Controller
        {
            // GET: About
            public ActionResult Index()
            {
                return View();
            }
            #region Sample
            [HttpPost]
            public JsonResult GetDataDemo(Employee DemoEmployee)
            {
                List<Employee> listEmployee = new List<Employee>();
                listEmployee.Add(new Employee() { Id = 1, Name = "AAa1" });
                listEmployee.Add(new Employee() { Id = 2, Name = "BBB1" });
                listEmployee.Add(new Employee() { Id = 3, Name = "CCC" });
                listEmployee.Add(new Employee() { Id = 4, Name = "DD" });
                listEmployee.Add(new Employee() { Id = 5, Name = "EEE" });
                return Json(listEmployee, JsonRequestBehavior.AllowGet);
            }
            #endregion
        }
    }

  Script則這樣打，需要留意，這邊Type使用的是Post
 （用Get印象中會失敗）
<script  type='text/javascript' src=''>

      @{
          ViewBag.Title = "index";
      }
      <h2>@ViewBag.Title.</h2>
      <h3>@ViewBag.Message</h3>

      <p>Use this area to provide additional information.</p>

      @section scripts{
          <script  type='text/javascript' src=''>
          $(document).ready(function () {
              AjaxDEMO()
          });
              function AjaxDEMO() {
                  var _DemoEmployee =
                  {
                      Id: 4,
                      Name: "dddss",
                  }
                  $.ajax({
                      type: 'Post',
                      async: true,
                      global: false,
                      url: '@Url.Action("GetDataDemo", "About")',
                      data: '{DemoEmployee: ' + JSON.stringify(_DemoEmployee) + '}',
                      contentType: "application/json; charset=utf-8",
                      dataType: 'json',
                      success: function (data) {
                          $.each(data, function (i) {
                              console.log(`${data[i].Id}  ${data[i].Name}` );
                          });
                      },
                      beforeSend: function () { },
                      complete: function () {
                      },
                      error: function (xhr) {
                          alert(xhr);
                      }
                  });
              }
          </script>
      }
  
   最後可以下中斷點 看到我們在Vive表鍾用JavaScript傳遞到Controller的資料  
![Desktop View](/assets/img/2022-10-28-asp-net-use-ajax-get-c-method-data/2.png){: width="600" height="500" }

## 範例GIT: [Click](https://github.com/digamana/Ajax_GetData_Example.git)
