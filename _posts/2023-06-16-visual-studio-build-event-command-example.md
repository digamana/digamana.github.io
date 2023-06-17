---
layout: post
title: Visual Studio 建置事件
date: 2023-06-16 20:42 +0800
---

# 前言

# Hello World
如下
<script  type='text/javascript' src=''>

    Write-Host "Hello World"

# 簡單PowerShell指令
![Desktop View](/assets/img/2023-06-16-visual-studio-build-event-command-example/1.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-06-16-visual-studio-build-event-command-example/VS建置事件範例GIF.gif){: width="600" height="500" }
<script  type='text/javascript' src=''>

    powershell.exe –command "Get-Service | Export-CSV c:\temp\service.csv"


# 複雜PowerShell指令
<p>只要有使用到function跟variable的動作都算複雜的操作指令</p>
<p>在這種情況下只能把複雜的操作寫進ps1檔,接著再使用執行指定ps1檔這種簡單指令做觸發</p>
如下
<script  type='text/javascript' src=''>

    powershell.exe -Command "if (Test-Path "C:\Users\user\Downloads\My.ps1") {powershell.exe -ExecutionPolicy Bypass -File "C:\Users\user\Downloads\My.ps1"} else { Write-Host "檔案不存在"}"


<p>有時會碰到需要使用最高權限執行PowerShell的情況</p>
<p>這種情況需要使用最高權限開啟VS,才能成功重建,所以會再PoweShell指令中,加入判斷當前啟動權限,判斷完後再執行動作</p>
My.ps1的內容如下
<script  type='text/javascript' src=''>

    function CheckRunAsAdmin {
        $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)

        return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    }

    $isAdmin = CheckRunAsAdmin
    Write-Host $isAdmin # False代表一般權限 True代表最高權限
    if($isAdmin) 
    {
    #To do SomeThing
    }
