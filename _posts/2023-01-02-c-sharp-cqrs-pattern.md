---
layout: post
title: C# 使用CQRS架構設計( dotnet 6.0 )
date: 2023-01-02 17:30 +0800
---

## 前言
<p>根據參考網站照著步驟DEMO的CQRS架構</p>
<p>以CQRS Pattern來達成資料庫讀寫模組分離的架構 (我這邊文章中實作資料庫讀寫的指令)</p>
<p>架構圖大致上是長這樣</p>
![Desktop View](/assets/img/2023-01-02-c-sharp-cqrs-pattern/1.png){: width="600" height="500" }

## GitHub
[https://github.com/digamana/CQRS-PatternRepo.git](https://github.com/digamana/CQRS-PatternRepo.git)
## 參考
[https://learn.microsoft.com/zh-tw/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/cqrs-microservice-reads](https://learn.microsoft.com/zh-tw/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/cqrs-microservice-reads)  
[https://www.partech.nl/nl/publicaties/2021/05/using-the-cqrs-pattern-in-c-sharp](https://www.partech.nl/nl/publicaties/2021/05/using-the-cqrs-pattern-in-c-sharp)  
