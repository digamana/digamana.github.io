---
layout: post
title: Entity Framework Code First if DataBase Exist3
date: 2022-10-29 17:15 +0800
categories: [Visual studio And MSSQL,Use C# And NuGet Command  To Change MSSQL Setting]
---
## 前言  
使用Fluent Api修改資料表型態、名稱等方式  
好處:較能達成程式碼的耦合分離  
以變更現有資料表NewDataSheets的設定為例
欄位設定如附圖  
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist3/0.png){: width="600" height="500" }


## 1.建議新增統一放置Config的資料夾，並在其中加入新的cs檔   
例如NewDataSheetConfig.cs  
<script  type='text/javascript' src=''>

      namespace CodeFirst.Config
      {
          using System.Data.Entity.ModelConfiguration;
          public class NewDataSheetConfig : EntityTypeConfiguration<NewDataSheet>
          {
              public NewDataSheetConfig()
              {
                  //這裡用來設定這張資料表要變成怎樣的設定
                  //指令下面示範
              }
          }
      }

如附圖  
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist3/1.png){: width="600" height="500" }

## 2.變更Model1.cs底下的OnModelCreating的寫法  
更改前  
<script  type='text/javascript' src=''>
      using System.Data.Entity;

      namespace CodeFirst
      {
          public partial class Model1 : DbContext
          {
              public Model1()
                  : base("name=Model1")
              {
              }

              public virtual DbSet<Member> Members { get; set; }
              public virtual DbSet<NewDataSheet> NewDataSheet { get; set; }
              protected override void OnModelCreating(DbModelBuilder modelBuilder)
              {
                  modelBuilder.Entity<Member>()
                      .Property(e => e.UserName)
                      .IsUnicode(false);

                  modelBuilder.Entity<Member>()
                      .Property(e => e.UserEmail)
                      .IsUnicode(false);
              }
          }
      }


更改後
<script  type='text/javascript' src=''>
      using System.Data.Entity;

      namespace CodeFirst
      {
          public partial class Model1 : DbContext
          {
              public Model1()
                  : base("name=Model1")
              {
              }

              public virtual DbSet<Member> Members { get; set; }
              public virtual DbSet<NewDataSheet> NewDataSheet { get; set; }
              protected override void OnModelCreating(DbModelBuilder modelBuilder)
              {
                  modelBuilder.Entity<Member>()
                      .Property(e => e.UserName)
                      .IsUnicode(false);

                  modelBuilder.Entity<Member>()
                      .Property(e => e.UserEmail)
                      .IsUnicode(false);

                  modelBuilder.Configurations.Add(new Config.NewDataSheetConfig());
              }
          }
      }



## 3.設定所需變更的資料  
例如我希望Name的資料型態長度是20
<script  type='text/javascript' src=''>

      namespace CodeFirst.Config
      {
          using System.Data.Entity.ModelConfiguration;
          public class NewDataSheetConfig : EntityTypeConfiguration<NewDataSheet>
          {
              public NewDataSheetConfig()
              {
                  Property(t => t.Name).HasMaxLength(20);
              }
          }
      }

## 4.執行Add-Migration
指令：
<script  type='text/javascript' src=''>

     Add-Migration SetMaxLength


如附圖  
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist3/2.png){: width="600" height="500" }

## 5.執行更新Update-Database
指令：
<script  type='text/javascript' src=''>

     Update-Database

如附圖  
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist3/3.png){: width="600" height="500" }

到SQL Server中 可以看到以完成欄位長度的修正
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist3/4.png){: width="600" height="500" }



## 6.還原Migration版本的方式  
!!!但是不建議如次操作，因為修改後若要Update，會遺失中間的Migration留存紀錄  
 <script  type='text/javascript' src=''>

     Update-Database -TargetMigration: OddDataSheetReNameNameTo_Name

OddDataSheetReNameNameTo_Name為Migrations資料夾底下的檔名  
如圖所示
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist3/5.png){: width="600" height="500" }


## 以下是Fluent Api可以參考的指令
![Desktop View](/assets/img/2022-10-29-entity-framework-code-first-if-database-exist3/1.png){: width="600" height="500" }
變更TableName↓
<script  type='text/javascript' src=''>

     ToTable("NewDataSheet","Hellow")

配置主鍵↓
<script  type='text/javascript' src=''>

     HasKey(t=>t.Name);

配置複合鍵↓
<script  type='text/javascript' src=''>

     HasKey(t=>new{t.id , t.Name});


變更藍位名稱↓
<script  type='text/javascript' src=''>

     Property(t => t.Name).HasColumnName("sName");


變更欄位型態↓
<script  type='text/javascript' src=''>

     Property(t => t.Name).HasColumnType("varchar");


不使用Visual Studio中生成的資料表設定，而是直接使用已存在於資料庫的欄位設定
<script  type='text/javascript' src=''>

     Property(t => t.Name).HasDatabaseGenerated(DatabaseGeneratedOption.None)


　
Not Null設定
<script  type='text/javascript' src=''>

     Property(t=>t.Name).IsRequired();


變更字串長度↓
<script  type='text/javascript' src=''>

     .Property(t=>t.Name).HasMaxLength(255);


