---
layout: post
title: ASP.NET Core 部署檔案到IIS卻出現"檔案正由另一個程序使用"的解決方式
date: 2024-03-29 23:53 +0800
---

## 前言

<p>為了解決部署到IIS時,直接將檔案複製貼上,會出現"檔案正由另一個程序使用"的問題</p>
<p>通常是需要經過 關閉站台 => 複製貼上 => 開啟站台 的流程</p>
<p>但這樣實在太麻煩了</p>
![Desktop View](/assets/img/2024-03-29-asp-net-core-deploy-file-to-iis-but-file-in-using/1.png){: width="400" height="300" }


## 解決方式

<p>部署前建立app_offline.htm ,將其放到IIS目錄底下, 在進行檔案複製 </p>
<p>完成後再將app_offline.htm刪除</p>
<p>app_offline.htm內容可有可無, 有HTML資料可告知當前正常佈版中</p>
