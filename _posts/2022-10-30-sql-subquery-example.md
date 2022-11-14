---
layout: post
title: SQL Subquery Example
date: 2022-10-30 17:31 +0800
categories: [Other ,SQL]
tags: [SQL]
---
## 使用With As 來達到子查詢的方式  
範例資料表如圖所示  
![Desktop View](/assets/img/2022-10-30-sql-subquery-example/1.png){: width="600" height="500" }  

## 第一次搜尋，試著尋找與字母CD有關的資料，Main為自定義變數
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

## 第二次搜尋，從上回搜尋的結果資料當中，繼續搜尋與字母A有關的資料
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
