---
layout: post
title: 'Entity Framework Code First if DataBase Exist-1'
date: 2022-10-29 14:09 +0800
categories: [Visual studio And MSSQL,Use C# And NuGet Command  To Change MSSQL Setting]
---
資料庫已存在時的Code First操作方式

這是要用來DEMO的當作已存在的資料庫

在開始DEMO之前 要先有確定有已存在的資料庫並將其連線新增至專案中  
都完成了才會開始使用Code First指令  
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist/1.png){: width="600" height="500" }
  
[DemoDB]是我用來DEMO的資料庫名稱
<script  type='text/javascript' src=''>

     USE [DemoDB]
    GO
    /****** Object:  Table [dbo].[Member]    Script Date: 2022/10/29 下午 02:29:51 ******/
    SET ANSI_NULLS ON
    GO
    SET QUOTED_IDENTIFIER ON
    GO
    CREATE TABLE [dbo].[Member](
	    [UserID] [int] IDENTITY(1,1) NOT NULL,
	    [UserName] [varchar](10) NULL,
	    [UserEmail] [varchar](50) NULL,
     CONSTRAINT [PK_Member] PRIMARY KEY CLUSTERED 
    (
	    [UserID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
    GO
    SET IDENTITY_INSERT [dbo].[Member] ON 
    GO
    INSERT [dbo].[Member] ([UserID], [UserName], [UserEmail]) VALUES (1, N'A', N'A@ya.com')
    GO
    INSERT [dbo].[Member] ([UserID], [UserName], [UserEmail]) VALUES (2, N'B', N'B@yahoo.com')
    GO
    INSERT [dbo].[Member] ([UserID], [UserName], [UserEmail]) VALUES (3, N'C', N'C@yahoo.com')
    GO
    INSERT [dbo].[Member] ([UserID], [UserName], [UserEmail]) VALUES (4, N'D', N'D@yahoo.com')
    GO
    INSERT [dbo].[Member] ([UserID], [UserName], [UserEmail]) VALUES (5, N'E', N'E@yahoo.com')
    GO
    INSERT [dbo].[Member] ([UserID], [UserName], [UserEmail]) VALUES (6, N'F', N'F@yahoo.com')
    GO
    SET IDENTITY_INSERT [dbo].[Member] OFF
    GO


開起一個用來DEMO用的專案  
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist/2.png){: width="600" height="500" }  
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist/3.png){: width="600" height="500" }  

 
將ADO.NET實體資料模型加入道專案中  
1.新增項目  
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist/6.png){: width="600" height="500" }

2.選擇ADO.NET實體資料模型  
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist/7.png){: width="600" height="500" }

3.因為是要DEMO操作已存在的資料庫 所以選擇來自資料庫的Code First  
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist/8.png){: width="600" height="500" }

4.設定連線資料（根據自己環境新增連線）
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist/9.png){: width="600" height="500" }

5.選擇資料庫物件
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist/10.png){: width="600" height="500" }

6.完成
會新增一個檔案像下圖這樣
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist/11.png){: width="600" height="500" }
