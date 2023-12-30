---
layout: post
title: C# string[] Filter Sql
date: 2023-12-11 22:36 +0800
---
## 前言

<p>演示其中一種如何在C# string[]中,確認內部資料是否有存在於DB的方式</p>

## 開始
假設SQL資料組如下
![Desktop View](/assets/img/2023-12-11-c-sharp-string-filter-sql/1.png){: width="800" height="600" }
<script  type='text/javascript' src=''>

    SELECT [FirstName]
      FROM [School].[dbo].[Customers]



現在C#要確認這組資料裡面,有哪些字串沒有在資料表裡面
<script  type='text/javascript' src=''>

  string[] str = new string[] { "Tag", "Class", "Joh2n", "Jane" };


最終目標是要讓Query長這樣搜尋
![Desktop View](/assets/img/2023-12-11-c-sharp-string-filter-sql/2.png){: width="800" height="600" }

在C#中組出子查詢字串的方式(圈起來的部分)
<script  type='text/javascript' src=''>

    string[] str = new string[] { "Tag", "Class", "Joh2n", "Jane" };
    var str2 = str.Select(c => $@"SELECT '{c}' as aa");
    var strResult = string.Join(" union ", str2);
    //strResult會印出字串
    //SELECT 'Tag'  as aa   union 
    //SELECT 'Class' as aa  union
    //SELECT 'Joh2n' as aa	union
    //SELECT 'Jane' as aa

