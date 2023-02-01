---
layout: post
title: Asp.Net Core Use Code First if Database Exist
date: 2023-01-25 22:38 +0800
---
<p>在Asp.Net Core因為再新增項目中沒有了ADO.NET,所以只能透過指令建立連線</p>
## 事前作業-建立ASP.NET CORE專案
## 安裝EntityFrameworkCore套件
### Microsoft.EntityFrameworkCore.Design
 [https://www.nuget.org/packages/Microsoft.EntityFrameworkCore.Design/7.0.2?_src=template](https://www.nuget.org/packages/Microsoft.EntityFrameworkCore.Design/7.0.2?_src=template)
![Desktop View](/assets/img/2023-01-25-asp-net-core-use-code-first-if-database-exist/1.png){: width="600" height="500" }
 <script  type='text/javascript' src=''>

    NuGet\Install-Package Microsoft.EntityFrameworkCore.Design -Version 7.0.2


### Microsoft.EntityFrameworkCore.SqlServer
[https://www.nuget.org/packages/Microsoft.EntityFrameworkCore.SqlServer/7.0.2?_src=template](https://www.nuget.org/packages/Microsoft.EntityFrameworkCore.SqlServer/7.0.2?_src=template)
![Desktop View](/assets/img/2023-01-25-asp-net-core-use-code-first-if-database-exist/2.png){: width="600" height="500" }
 <script  type='text/javascript' src=''>

    NuGet\Install-Package Microsoft.EntityFrameworkCore.SqlServer -Version 7.0.2


### Microsoft.EntityFrameworkCore.Tools 
[https://www.nuget.org/packages/Microsoft.EntityFrameworkCore.Tools/7.0.2?_src=template](https://www.nuget.org/packages/Microsoft.EntityFrameworkCore.Tools/7.0.2?_src=template)
![Desktop View](/assets/img/2023-01-25-asp-net-core-use-code-first-if-database-exist/3.png){: width="600" height="500" }
 <script  type='text/javascript' src=''>

    NuGet\Install-Package Microsoft.EntityFrameworkCore.Tools -Version 7.0.2

 

## 使用指令建立
最簡單的指令如下  
![Desktop View](/assets/img/2023-01-25-asp-net-core-use-code-first-if-database-exist/4.png){: width="600" height="500" }
 <script  type='text/javascript' src=''>

    Scaffold-DbContext "Server=DESKTOP-LF7SA0P\SQLEXPRESS;Database=School;Trusted_Connection=True;TrustServerCertificate=true;MultipleActiveResultSets=true;User ID=sa;Password=aaa12345" Microsoft.EntityFrameworkCore.SqlServer -OutputDir Models -Force


### 指令說明
![Desktop View](/assets/img/2023-01-25-asp-net-core-use-code-first-if-database-exist/5.png){: width="600" height="500" }

<p></p>
<p></p>
<p></p>
