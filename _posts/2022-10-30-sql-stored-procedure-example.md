---
layout: post
title: SQL Stored Procedure Example
date: 2022-10-30 17:37 +0800
categories: [Other ,SQL]
tags: [SQL]
---
建立Store Procedure
<script  type='text/javascript' src=''>
        USE [DemoDB]
        GO

        /****** Object:  StoredProcedure [dbo].[spMember]    Script Date: 2022/10/31 下午 04:10:54 ******/
        SET ANSI_NULLS ON
        GO

        SET QUOTED_IDENTIFIER ON
        GO

        -- =============================================
        -- Author:		<Author,,Name>
        -- Create date: <Create Date,,>
        -- Description:	<Description,,>
        -- =============================================
        CREATE PROCEDURE [dbo].[spMember]
	        -- Add the parameters for the stored procedure here
                @UserID int,
                @UserName varchar(50),
                @UserEmail varchar(50)
        AS
        BEGIN
	        -- SET NOCOUNT ON added to prevent extra result sets from
	        -- interfering with SELECT statements.
	        SET NOCOUNT ON;

            -- Insert statements for procedure here
	        SELECT  * from Member where UserName = @UserName
          or UserEmail = @UserEmail
        END
        GO

如果輸入" " 或Null 回傳全部資料的方式  
不特別處理的話會Search " "或Null  
通常使用操作上如果不輸入數值,通常會希望將資料全部帶出來
Select的部分改成如下
<script  type='text/javascript' src=''>
 
    FROM [dbo].[Member]
    where
    (@UserName IS NULL OR @UserName = [UserName] or LEN(LTRIM(@UserName)) = 0 )   and
    (@UserEmail IS NULL OR @UserEmail = [UserEmail] or LEN(LTRIM(@UserEmail)) = 0 )  

