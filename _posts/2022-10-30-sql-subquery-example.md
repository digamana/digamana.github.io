---
layout: post
title: SQL Subquery Example
date: 2022-10-30 17:31 +0800
categories: [Other ,SQL]
tags: [SQL]
---
## 使用With As 來達到子查詢的方式  
### 範例資料表如圖所示  
![Desktop View](/assets/img/2022-10-30-sql-subquery-example/1.png){: width="600" height="500" }  

### 第一次搜尋，試著尋找與字母CD有關的資料，Main為自定義變數
Source Code：
<script  type='text/javascript' src=''>

      with Main as
      (
      SELECT TOP (1000) [UserID]
            ,[UserName]
            ,[UserEmail]
        FROM [DemoDB].[dbo].[Member]
        where UserName like '%CD%'
      ) select * FROM Main



![Desktop View](/assets/img/2022-10-30-sql-subquery-example/2.png){: width="600" height="500" }

### 第二次搜尋，從上回搜尋的結果資料當中，繼續搜尋與字母A有關的資料
Source Code：
<script  type='text/javascript' src=''>

      with Main as
      (
      SELECT TOP (1000) [UserID]
            ,[UserName]
            ,[UserEmail]
        FROM [DemoDB].[dbo].[Member]
        where UserName like '%CD%'
      ) select * FROM Main
      where UserName like '%A%'


![Desktop View](/assets/img/2022-10-30-sql-subquery-example/3.png){: width="600" height="500" }


## 使用Left join 來達到子查詢的方式  
Source Code：
<script  type='text/javascript' src=''>

    select   
	    [Member].[UserName]
	    [Main].[UserEmail]
    FROM [DemoDB].[dbo].[Member]
    Left join (
           SELECT TOP (1000) [UserID]
            ,[UserName]
            ,[UserEmail]
		    FROM [DemoDB].[dbo].[Member]
		    where UserName like '%CD%'
        ) AS Main on [Member].[UserName] = Main.[UserName]


## 建立Table指令
備註:這跟這篇文章無關,只是我想簡單放個指令而已
因為這樣我之後就能先在Excel擬好欄位名稱,就直接先快速建表,型態再到介面手動調整,這樣感覺比較有效率
<script  type='text/javascript' src=''>

    CREATE TABLE [dbo].[TableName](
	  ColName [varchar](50)  NULL,
  ) 

