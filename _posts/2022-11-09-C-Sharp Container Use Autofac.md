---
layout: post
title: C# DI Container Use Autofac
date: 2022-11-09 11:25 +0800
---
使用以下套件  
![Desktop View](/assets/img/2022-11-09-C-Sharp Container Use Autofac/1.png){: width="400" height="400" }
<script  type='text/javascript' src=''>

    NuGet\Install-Package Autofac -Version 6.3.0

Code Example
<script  type='text/javascript' src=''>



使用下來，覺得在使用MVC的時候效果最明顯  
![Desktop View](/assets/img/2022-11-09-C-Sharp Container Use Autofac/2.png){: width="400" height="400" }  

Autofac
<script  type='text/javascript' src=''>

    NuGet\Install-Package Autofac -Version 6.3.0


Autofac.Mvc5
<script  type='text/javascript' src=''>


    NuGet\Install-Package Autofac.Mvc5 -Version 6.1.0


建立要使用DI的Class與Interface
<script  type='text/javascript' src=''>

      public interface ILogger
      {
          void Log(string msg);
      }
      public class Logger : ILogger
      {
        
          public void Log(string msg)
          {
              Console.WriteLine("LOG:" + msg);
          }
      }


建立用來實現DI的Class，例如AutofacConfig.cs  
![Desktop View](/assets/img/2022-11-09-C-Sharp Container Use Autofac/3.png){: width="800" height="600 }
<script  type='text/javascript' src=''>


    using Autofac;
    using Autofac.Integration.Mvc;
    using System.Collections.Generic;
    using System.Linq;
    using System.Reflection;
    using System.Web;
    using System.Web.Mvc;

    namespace AutofacMVC.App_Start
    {
        public  class AutofacConfig
        {
            public static void Run()
            {
                ContainerBuilder builder = new ContainerBuilder();
                builder.RegisterControllers(Assembly.GetExecutingAssembly());
                builder.RegisterType<Logger>().As<ILogger>();
                IContainer container = builder.Build();
                DependencyResolver.SetResolver(new AutofacDependencyResolver(container));
            }
        }

    }

在Global.asax 添加Method  
![Desktop View](/assets/img/2022-11-09-C-Sharp Container Use Autofac/4.png){: width="800" height="600" }

最後在Controoler正在使用DI注入例如
<script  type='text/javascript' src=''>

    using AutofacMVC.App_Start;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    using System.Web.Mvc;

    namespace AutofacMVC.Controllers
    {
        public class HomeController : Controller
        {
            protected ILogger Logger;  
            public HomeController(ILogger logger)
            {
                Logger= logger;
             
            }
            public ActionResult Index()
            {
                return View();
            }
        }
    }
