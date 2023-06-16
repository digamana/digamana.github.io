---
layout: post
title: Visual Studio 建置事件
date: 2023-06-16 20:42 +0800
---

# 前言

# Hello World

# 簡單PowerShell指令
![Desktop View](/assets/img/2023-06-16-visual-studio-build-event-command-example/1.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-06-16-visual-studio-build-event-command-example/VS建置事件範例GIF.gif){: width="600" height="500" }
<script  type='text/javascript' src=''>

    powershell.exe –command "Get-Service | Export-CSV c:\temp\service.csv"


# 複雜PowerShell指令
<p>只要有使用到function跟variable的動作都算複雜的操作指令</p>
<p>在這種情況下只能把複雜的操作寫進ps1檔,接著再使用執行指定ps1檔這種簡單指令做觸發</p>
