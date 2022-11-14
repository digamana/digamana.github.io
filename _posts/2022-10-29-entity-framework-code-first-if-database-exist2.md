---
layout: post
title: 'Entity Framework Code First if DataBase Exist-2'
date: 2022-10-29 15:17 +0800
categories: [Visual studio And MSSQL,Use C# And NuGet Command  To Change MSSQL Setting]
---
## 1.確認實體模型準備好了之後  
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist/11.png){: width="600" height="500" }

## 2.執行安裝EntityFramework
指令：
<script  type='text/javascript' src=''>

     NuGet\Install-Package EntityFramework -Version 6.4.4


如附圖
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist2/1.png){: width="600" height="500" }


## 2.執行資料遷移enable-migrations
指令：
<script  type='text/javascript' src=''>

     enable-migrations


如附圖  
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist2/2.png){: width="600" height="500" }

## 3.建立初始資料
指令：
<script  type='text/javascript' src=''>

     add-migration InitialModel -IgnoreChanges -Force


如附圖
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist2/3.png){: width="600" height="500" }

## 4.在更新操作紀錄到資料庫中，以便追蹤更改記錄
指令：
<script  type='text/javascript' src=''>

     Update-Database


如附圖   
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist2/4.png){: width="600" height="500" }

## 在VS建立新的資料表的方式 :建立一個新的Class
  備註：在使用Code First的情況下
<script  type='text/javascript' src=''>

     using System;
     using System.Collections.Generic;
     using System.Linq;
     using System.Text;
     using System.Threading.Tasks;
     
      namespace CodeFirst
      {
          public class NewDataSheet
          {
              public int Id { get; set; }
              public string Name { get; set; }
          }
      }


如附圖  
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist2/5.png){: width="600" height="500" }

## 1.在Model1.cs中添加virtual DbSet   
如附圖  
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist2/6.png){: width="600" height="500" }

## 2.執行add-migration NewDataSheetTable -Force  
備註:NewDataSheetTable 是自己任意定義的名稱  
 -Force表示強制覆蓋當前的migration記錄
<script  type='text/javascript' src=''>

     add-migration NewDataSheetTable -Force
  


如附圖  
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist2/7.png){: width="600" height="500" }  

此時該資料表尚未於資料表中產生實體，且尚無任何內容  
若需要添加內容或更改主鍵或Not Null設定（更改nullable或identity的Bool 設定值  
 !!!如果數值為Int且不須自動累加數值，identity的Bool記得要改為false  
需再Migration資料夾中的NewDataSheetTable遷移記錄 進行更改  
若需要添加內容，可於Up下方輸入SQL指令，變成
<script  type='text/javascript' src=''>

      namespace CodeFirst.Migrations
      {
          using System;
          using System.Data.Entity.Migrations;
    
          public partial class NewDataSheetTable : DbMigration
          {
              public override void Up()
              {
                  CreateTable(
                      "dbo.NewDataSheets",
                      c => new
                          {
                              Id = c.Int(nullable: false, identity: false),
                              Name = c.String(),
                          })
                      .PrimaryKey(t => t.Id);
                  Sql("Insert Into NewDataSheets values(1,'Test')");
                  Sql("Insert Into NewDataSheets values(2,'Demo')");
              }
        
              public override void Down()
              {
                  DropTable("dbo.NewDataSheets");
              }
          }
      }

## 更新實體資料庫
確認完要更改的項目之後
執行Update-Database：同步更新實體資料庫
<script  type='text/javascript' src=''>

      Update-Database

如附圖  
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist2/8.png){: width="600" height="500" }  


## SQL Server可以看到剛剛新增的資料表
已經透過指令更新到SQL Server了  
如附圖  
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist2/9.png){: width="600" height="500" }  



