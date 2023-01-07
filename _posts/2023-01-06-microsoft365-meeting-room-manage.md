---
layout: post
title: Microsoft 365 的 Teams/Outlook的 新增方法的會議室 與 授權管理會議室Booking狀態的權限
date: 2023-01-06 20:22 +0800
---

## 實際情況描述
<p>需要新增Teams/Outlook可選擇的會議室</p>
![Desktop View](/assets/img/2023-01-06-microsoft365-meeting-room-manage/7.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-06-microsoft365-meeting-room-manage/8.png){: width="600" height="500" }
## 新增Teams/Outlook會議室

### 事前準備
<p>需先在Microsoft 365 Apps admin center，創建好會議室信箱</p>
 新增會議室信箱的位置詳見,[授權管理會議室的booking狀態的權限](#授權管理會議室的booking狀態的權限)

<p>本機最高權限執行PowerShell</p>
![Desktop View](/assets/img/2023-01-06-microsoft365-meeting-room-manage/1.png){: width="600" height="500" }
<p>建立原則策略,並同意執行原則</p>
![Desktop View](/assets/img/2023-01-06-microsoft365-meeting-room-manage/2.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    Set-ExecutionPolicy RemoteSigned

<p>設定SecurityProtocolType</p>
![Desktop View](/assets/img/2023-01-06-microsoft365-meeting-room-manage/3.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

<p>安裝ExchangeOnlineManagement模組</p>
![Desktop View](/assets/img/2023-01-06-microsoft365-meeting-room-manage/4.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    Install-Module -Name ExchangeOnlineManagement

<p>導入ExchangeOnlineManagement模組</p>
![Desktop View](/assets/img/2023-01-06-microsoft365-meeting-room-manage/5.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    Import-Module ExchangeOnlineManagement



### 正式開始

<p>從PowerShell登入Microsoft</p>
<p>UserPrincipalName後面請打O365的管理者帳號</p>
<p>假設管理者帳號是 ABC@yahoo.com.tw</p>
<p>就輸入 Connect-ExchangeOnline -UserPrincipalName   ABC@yahoo.com.tw</p>
![Desktop View](/assets/img/2023-01-06-microsoft365-meeting-room-manage/9.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    Connect-ExchangeOnline -UserPrincipalName  MyMail@Domain.com

<p>使用get-DistributionGroup確認要加入的會議室目錄中文名稱</p>
![Desktop View](/assets/img/2023-01-06-microsoft365-meeting-room-manage/6.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    get-DistributionGroup 
 
<p>使用指令加入會議室,這個指令成功後,就能在Teams和Outlook上看到會議室了</p>
<p>舉例:中文名稱為「ABC會議室」,會議室信箱為「QWR@yahoo.com.tw」</p>
<p>指令就是 Add-DistributionGroupMember -Identity "ABC會議室" - QWR@yahoo.com.tw</p>
指令如下
<script  type='text/javascript' src=''>

    Add-DistributionGroupMember -Identity "中文名稱" - 會議室信箱

<p>結束,以上步驟完成就能在Teams/Outlook看到新增的會議室了</p>

## 授權「管理會議室的Booking狀態」的權限
<p>登入Microsoft 365 Apps admin center</p>
[https://config.office.com/](https://config.office.com/)  
![Desktop View](/assets/img/2023-01-06-microsoft365-meeting-room-manage/006.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-06-microsoft365-meeting-room-manage/007.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-06-microsoft365-meeting-room-manage/001.png){: width="600" height="500" }
<p>選擇Exchange</p>
![Desktop View](/assets/img/2023-01-06-microsoft365-meeting-room-manage/002.png){: width="600" height="500" }
<p>點擊「資源」 ->  選擇「會議室帳號」 -> 點選「管理代理人」</p>
![Desktop View](/assets/img/2023-01-06-microsoft365-meeting-room-manage/003.png){: width="600" height="500" }
<p>在「Step1」新增要給予授權的代理人,並在「Step2」設定給予的權限大小</p>
![Desktop View](/assets/img/2023-01-06-microsoft365-meeting-room-manage/004.png){: width="600" height="500" }
