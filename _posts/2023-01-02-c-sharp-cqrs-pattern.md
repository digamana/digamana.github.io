---
layout: post
title: C# 使用CQRS架構設計( dotnet 6.0 )
date: 2023-01-02 17:30 +0800
---

## 前言
<p>根據參考網站照著步驟DEMO的CQRS架構</p>
<p>以CQRS Pattern來達成資料庫"讀寫"模組分離的架構</p>
<p>架構圖大致上是長這樣</p>
![Desktop View](/assets/img/2023-01-02-c-sharp-cqrs-pattern/1.png){: width="600" height="500" }
<p>如果搭配MicroService 和Dapper的話，可以設計成這樣</p>
搭配Dapper讀取資料庫時,如果使用動態型別,可像下面這樣設計
<script  type='text/javascript' src=''>

    public interface IEmployeeQueriesRepository
    {
      Task<IEnumerable<dynamic>> GetEmployeeAsync1();
    }
    public class EmployeeQueriesRepository : IEmployeeQueriesRepository
    {
      public async Task<IEnumerable<dynamic>> GetEmployeeAsync1()
      {
          using (var connection = new SqlConnection(@"SqlConnection"))
          {
              string strQUERY = @"
              Select 
              Id           as N'Id',
              FirstName    as N'FirstName',
              LastName     as N'LastName',
              DateOfBirth  as N'DateOfBirth',
              Street       as N'Street',
              City         as N'City',
              ZipCode      as N'ZipCode'
              from dbo.EmployeeSheet
              ";
              connection.Open();
              return await connection.QueryAsync<dynamic>(strQUERY);
          }
      }
    }


搭配Dapper讀取資料庫時,如果有明確型別,可像下面這樣設計 
<script  type='text/javascript' src=''>

    public interface IEmployeeQueriesRepository
    {
      Task<IEnumerable<Employee>> GetEmployeeAsync1();
    }
    public class EmployeeQueriesRepository : IEmployeeQueriesRepository
    {
      public async Task<IEnumerable<Employee>> GetEmployeeAsync1()
      {
          using (var connection = new SqlConnection(@"SqlConnection"))
          {
              string strQUERY = @"
              Select 
              Id           as N'Id',
              FirstName    as N'FirstName',
              LastName     as N'LastName',
              DateOfBirth  as N'DateOfBirth',
              Street       as N'Street',
              City         as N'City',
              ZipCode      as N'ZipCode'
              from dbo.EmployeeSheet
              ";
              connection.Open();
              return await connection.QueryAsync<Employee>(strQUERY);
          }
      }
    }

## GitHub
[https://github.com/digamana/CQRS-PatternRepo.git](https://github.com/digamana/CQRS-PatternRepo.git)
## 參考
[https://learn.microsoft.com/zh-tw/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/cqrs-microservice-reads](https://learn.microsoft.com/zh-tw/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/cqrs-microservice-reads)  
[https://www.partech.nl/nl/publicaties/2021/05/using-the-cqrs-pattern-in-c-sharp](https://www.partech.nl/nl/publicaties/2021/05/using-the-cqrs-pattern-in-c-sharp)  
