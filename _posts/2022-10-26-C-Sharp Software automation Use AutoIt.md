---
layout: post
title: C# Software automation Use AutoIt
date: 2022-10-26 15:40 +0800
categories: [Automation,DeskTop App]
tags: [C#]
published: true

---
## 事前準備：1.下載軟體
首先，需要到AutoIT官網下載軟體  
[AutoIT官網](https://www.autoitscript.com/site/]https://www.autoitscript.com/site/)
因為需要使用AutoIt Window Info 
![Desktop View](/assets/img/2022-10-26-C-Sharp Software automation Use AutoIt/4.png){: width="600" height="500" }

## 事前準備：2.最高權限啟動
再來，編譯時或啟動軟體時都需使用Administrator權限

Visual Studio Administrator Mode
![Desktop View](/assets/img/2022-10-26-C-Sharp Software automation Use AutoIt/1.png){: width="600" height="500" }

 
## 安裝套件AutoItX.Dotnet
使用的套件
<script  type='text/javascript' src=''>

    NuGet\Install-Package AutoItX.Dotnet -Version 3.3.14.5

![Desktop View](/assets/img/2022-10-26-C-Sharp Software automation Use AutoIt/2.png){: width="600" height="500" }

以安裝RAR軟體為例  
檔案位置  
![Desktop View](/assets/img/2022-10-26-C-Sharp Software automation Use AutoIt/3.png){: width="200" height="200" }

## 範例影片
<iframe width="560" height="315" src="https://www.youtube.com/embed/lzoobVkN2jc" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>



## 主要指令
1.開啟檔案位置
<script  type='text/javascript' src=''>

    AutoItX.Run("Software Path", string.Empty);


1.等待畫面出現
<script  type='text/javascript' src=''>

    AutoItX.WinWaitActive("Software Title");


1.Click畫面中的Button
<script  type='text/javascript' src=''>

    AutoItX.ControlClick("Software Title", "", "Control Advanced Mode");


