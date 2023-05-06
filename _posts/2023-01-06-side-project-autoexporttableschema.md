---
layout: post
title: Sql Table Schema 產生器
date: 2023-01-06 23:59 +0800
---

## 前言
<p>因為工作上會需要打Table Schema </p>
<p>碰到有很多資料庫且裡面很多資料表的情況,一想到還要一個一個進去裡面看型態欄位就覺得很麻煩</p>
<p>因為在這之前,也已經有在blog其他篇文章中,留下C# Dapper Connect SQL的操作方式、以及使用Excel迅速建檔的方式</p>
<p>所以想到可以乾脆的趁這時利用這兩個素材解決我需求</p>

## 關鍵Query

關鍵的Query如下，整隻程式都是基於這個Query產生的資料去做延伸的
 <script  type='text/javascript' src=''>

     with main as
    (
    SELECT
    c.name 'Column Name',
    t.Name 'Column Type',
    c.max_length 'Max Length',
    case
    when c.is_nullable = 0 then 'Not Null'
    when c.is_nullable = 1 then 'Is Null'
    End as 'IsNull',
    ISNULL(i.is_primary_key, 0) 'IsPrimaryKey',
    c.object_id 'object_id'
    FROM
    sys.columns c
    INNER JOIN
    sys.types t ON c.user_type_id = t.user_type_id
    LEFT OUTER JOIN
    sys.index_columns ic ON ic.object_id = c.object_id AND ic.column_id = c.column_id
    LEFT OUTER JOIN
    sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
    )
    SELECT
    s.name AS SchemaName,
    t.name AS TableName,
    main.[Column Name] as N'ColumnName',
    main.[Column Type] as N'ColumnType',
    main.[Max Length] as N'MaxLength',
    main.[IsNull],
    main.[IsPrimaryKey],
    sys.extended_properties.value as N'ColumnDescription'
    FROM sys.tables t
    INNER JOIN sys.schemas s
    ON t.schema_id = s.schema_id
    left join main on main.object_id = OBJECT_ID(t.name　)
    left join sys.extended_properties on sys.extended_properties.major_id = main.object_id and sys.extended_properties.minor_id = columnproperty(main.object_id, main.[Column Name], 'ColumnId') and sys.extended_properties.name = 'MS_Description'

## 操作介紹



### 執行畫面
![Desktop View](/assets/img/2023-01-06-side-project-autoexporttableschema/1.png){: width="600" height="500" }
### 基本輸入
<p>選擇「基本輸入」</p>
![Desktop View](/assets/img/2023-01-06-side-project-autoexporttableschema/2.png){: width="600" height="500" }
<p>「基本輸入」所對應的資料</p>
![Desktop View](/assets/img/2023-01-06-side-project-autoexporttableschema/3.png){: width="600" height="500" }
<p>匯出</p>
![Desktop View](/assets/img/2023-01-06-side-project-autoexporttableschema/4.png){: width="600" height="500" }
<p>最終結果</p>
![Desktop View](/assets/img/2023-01-06-side-project-autoexporttableschema/5.png){: width="600" height="500" }

### 輸入ConnectString
![Desktop View](/assets/img/2023-01-06-side-project-autoexporttableschema/7.png){: width="600" height="500" }
<p>匯出結果同上</p>
### 匯入範本
<p>先下載範本</p>
![Desktop View](/assets/img/2023-01-06-side-project-autoexporttableschema/8.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-06-side-project-autoexporttableschema/11.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-06-side-project-autoexporttableschema/9.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-06-side-project-autoexporttableschema/10.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-06-side-project-autoexporttableschema/12.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-06-side-project-autoexporttableschema/13.png){: width="600" height="500" }
<p>匯出結果同上</p>
## 操作影片

<iframe width="560" height="315" src="https://www.youtube.com/embed/COedXyWRpZc" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## 執行檔下載點(Google Drive)
<p>備註:執行檔自行斟酌下載,又或者從GitHub Code Review之後再自行使用</p>
[https://drive.google.com/drive/folders/1QwKbm9ftEL8F12Y-m0e5Y9uatimTam_p?usp=share_link](https://drive.google.com/drive/folders/1QwKbm9ftEL8F12Y-m0e5Y9uatimTam_p?usp=share_link)
## GitHub
[https://github.com/digamana/AutoExportTableSchemaRepo.git](https://github.com/digamana/AutoExportTableSchemaRepo.git)
