---
layout: post
title: C# Connect SAP RFC
date: 2022-10-26 15:45 +0800
categories: [Side project]
tags: [C#,SAP RFC]
---
## 章節
- [開始](#開始)
## 建立SAP RFC的範例影片  
為了示範C#與SAP串接，首先我們需要先建立用來串接的SAP測試資料  
<iframe width="560" height="315" src="https://www.youtube.com/embed/l67hAfa72TM" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
建立完後接著開始做C#串接  

## 使用C#串接 SAP RFC所需的套件
![Desktop View](/assets/img/2022-10-26-C-Sharp Connect SAP RFC/1.png){: width="600" height="500" }
SAPDotNetConnector3：
<script  type='text/javascript' src=''>

    NuGet\Install-Package SAPDotNetConnector3 -Version 0.3.0


sapnco3.x64：
<script  type='text/javascript' src=''>

    NuGet\Install-Package sapnco3.x64 -Version 3.0.2


# 開始
## C# 串接 SAP RFC的方式
核心Source Code :  
<script  type='text/javascript' src=''>

           RfcConfigParameters argsP = new RfcConfigParameters();
            argsP.Add(RfcConfigParameters.Name, "Your_Name");
            argsP.Add(RfcConfigParameters.AppServerHost, "Your_Sap_IP");
            argsP.Add(RfcConfigParameters.SystemNumber, "Your_SystemNumber");
            argsP.Add(RfcConfigParameters.SystemID, "Your_SystemID");
            argsP.Add(RfcConfigParameters.User, "User_Account");
            argsP.Add(RfcConfigParameters.Password, "User_Password");
            argsP.Add(RfcConfigParameters.Client, "Your_Client");
            argsP.Add(RfcConfigParameters.Language, "Your_Language");  



##  Source Code參數來源
Source Code Setting  
![Desktop View](/assets/img/2022-10-26-C-Sharp Connect SAP RFC/2.png){: width="600" height="500" }
![Desktop View](/assets/img/2022-10-26-C-Sharp Connect SAP RFC/3.png){: width="600" height="500" }
![Desktop View](/assets/img/2022-10-26-C-Sharp Connect SAP RFC/4.png){: width="600" height="500" }   


## 獲得Return結構的方式

<p>使用GetStructure</p>
![Desktop View](/assets/img/2022-10-26-C-Sharp Connect SAP RFC/8.png){: width="600" height="500" }

<p>以下是使用SAP內建的"獲取匯率"的RFC 演示 輸入/輸出</p>
![Desktop View](/assets/img/2022-10-26-C-Sharp Connect SAP RFC/5.png){: width="600" height="500" }
<p>根據輸出內容,去結構中確認對應的宣告字串</p>
![Desktop View](/assets/img/2022-10-26-C-Sharp Connect SAP RFC/6.png){: width="600" height="500" }
<p>在C#中使用GetStructure獲取需要Return的字串</p>
<p>在使用GetString,來取得其內容</p>
![Desktop View](/assets/img/2022-10-26-C-Sharp Connect SAP RFC/7.png){: width="600" height="500" }

## 建立專案使用C#串接 SAP RFC的影片
串接方式可詳見以下影片  
<iframe width="560" height="315" src="https://www.youtube.com/embed/Y8qZMO56sYk" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
## 相關連結
- [GitHub Source Code](https://github.com/digamana/C-Sharp-Connect-SAP-RFC )
