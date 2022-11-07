---
layout: post
title: SQL Trigger Example
date: 2022-10-30 17:36 +0800
categories: [Other ,SQL]
tags: [SQL]
---
透過Trigger紀錄資料異動的紀錄

1.首先會有一個主資料表
<script>

      USE [DemoDB]
      GO
      /****** Object:  Table [dbo].[Member]    Script Date: 2022/10/30 下午 11:23:35 ******/
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
      INSERT [dbo].[Member] ([UserID], [UserName], [UserEmail]) VALUES (1, N'haha', N'A@ya.com')
      GO
      INSERT [dbo].[Member] ([UserID], [UserName], [UserEmail]) VALUES (2, N'sdsa', N'B@yahoo.com')
      GO
      INSERT [dbo].[Member] ([UserID], [UserName], [UserEmail]) VALUES (3, N'CDE', N'C@yahoo.com')
      GO
      INSERT [dbo].[Member] ([UserID], [UserName], [UserEmail]) VALUES (4, N'de', N'D@yahoo.com')
      GO
      INSERT [dbo].[Member] ([UserID], [UserName], [UserEmail]) VALUES (5, N'E', N'E@yahoo.com')
      GO
      INSERT [dbo].[Member] ([UserID], [UserName], [UserEmail]) VALUES (6, N'dcdc', N'F@yahoo.com')
      GO
      SET IDENTITY_INSERT [dbo].[Member] OFF
      GO

![Desktop View](/assets/img/2022-10-30-sql-trigger-example/1.png){: width="400" height="400" }

2.建立用來記錄異動資料的資料表
<script>

        USE [DemoDB]
      GO

      /****** Object:  Table [dbo].[Member_Backup]    Script Date: 2022/10/30 下午 11:18:40 ******/
      SET ANSI_NULLS ON
      GO

      SET QUOTED_IDENTIFIER ON
      GO

      CREATE TABLE [dbo].[Member_Backup](
	      [UserID] [int] NULL,
	      [UserName] [varchar](10) NULL,
	      [UserEmail] [varchar](50) NULL
      ) ON [PRIMARY]
      GO

![Desktop View](/assets/img/2022-10-30-sql-trigger-example/2.png){: width="400" height="400" }

3.在主資料表底下建立Trigger  
![Desktop View](/assets/img/2022-10-30-sql-trigger-example/3.png){: width="200" height="200" }



方法1：透過變數先將被變更的第一項內容記錄下來
<script>

      USE [DemoDB]
      GO

      /****** Object:  Trigger [dbo].[triMember]    Script Date: 2022/10/30 下午 11:31:54 ******/
      SET ANSI_NULLS ON
      GO

      SET QUOTED_IDENTIFIER ON
      GO

      -- =============================================
      -- Author:		<Author,,Name>
      -- Create date: <Create Date,,>
      -- Description:	<Description,,>
      -- =============================================
      CREATE TRIGGER [dbo].[triMember]
         ON  [dbo].[Member]
         AFTER UPDATE
      AS 
      BEGIN
	      -- 宣告變數，用來記錄被改變的資料內容
	      SET NOCOUNT ON;
	      DECLARE @UserID int;
	      DECLARE @UserName varchar(50)
	      DECLARE @UserEmail varchar(50)
          -- 透過Select來獲得第一項被改變的欄位內容
	        select @UserID=UserID,@UserName =UserName ,@UserEmail=UserEmail from deleted

	        PRINT @UserID
	        PRINT @UserName
	        PRINT @UserEmail
	  
	        -- 將被改變的內容插到新的一列中
	       INSERT INTO Member_Backup(UserName,UserEmail) values ( @UserName,@UserEmail)
      END
      GO

      ALTER TABLE [dbo].[Member] ENABLE TRIGGER [triMember]
      GO


方法２：Insert時 Select來找到被改變的那一列  
[參考至此](https://www.sqlshack.com/understanding-change-tracking-in-sql-server-using-triggers/)
<script>

        USE [DemoDB]
        GO

        /****** Object:  Trigger [dbo].[triMember]    Script Date: 2022/10/30 下午 11:39:46 ******/
        SET ANSI_NULLS ON
        GO

        SET QUOTED_IDENTIFIER ON
        GO

        -- =============================================
        -- Author:		<Author,,Name>
        -- Create date: <Create Date,,>
        -- Description:	<Description,,>
        -- =============================================
        CREATE TRIGGER [dbo].[triMember]
           ON  [dbo].[Member]
           AFTER UPDATE
        AS 
        BEGIN
 
	         INSERT INTO Member_Backup(UserName,UserEmail)  
	             SELECT i.UserName,i.UserEmail
		        FROM inserted AS i
		        UNION
		        SELECT d.UserName,d.UserEmail
		        FROM deleted AS d;
        END
        GO

        ALTER TABLE [dbo].[Member] ENABLE TRIGGER [triMember]
        GO




