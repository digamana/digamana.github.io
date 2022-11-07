---
layout: post
title: '[待補][MIS]使用Bat指令繞過Windows AD驗證的方式'
date: 2022-10-26 14:57 +0800
categories: [Windows ,Bat]
tags: [Bat]
published: false 
---
情境：
作為公司的IT若要控管公司眾多電腦的資安風險，會統一在電腦都安裝防毒軟體，  
並設定在執行安裝的時候一定要輸入Windows AD驗證  
此時會碰到的困擾是某些軟體中會存在一定要使用AD權限才能執行操作的功能
下面描述的是為這個情境解套的方式之一  


使用NotePad++開啟，
輸入
runas/user:Domain\Account /savecred "FileExe Path"  
並另存為bat檔  

Domain\Account 是該網域中的AD帳號

![Desktop View](/assets/img/使用Bat繞過Windows AD驗證/Account.png){: width="300" height="250" }
