---
layout: post
title: C# Software automation Use PowerShell Command
date: 2022-11-14 11:10 +0800
---
# 本次範例執行的指令
![Desktop View](/assets/img/2022-11-14-c-sharp-software-automation-use-bat-execute-powershell-command/1.gif){: width="600" height="500" }
<script  type='text/javascript' src=''>
 
    Get-Service | Export-CSV c:\temp\service.csv

# 使用NotePad++將指令另存成ps1檔  
![Desktop View](/assets/img/2022-11-14-c-sharp-software-automation-use-bat-execute-powershell-command/1.PNG){: width="600" height="250" }



# 以C#執行ps1
## 建立.Net Core專案  
安裝套件 Cake.Powershell
<script  type='text/javascript' src=''>

    NuGet\Install-Package Cake.Powershell -Version 2.0.0
C# Source Code
<script  type='text/javascript' src=''>

    using System.IO;
    using System.Management.Automation;
    static void Main(string[] args)
    {
        PowerShell ps = PowerShell.Create();
        ps.AddScript(File.ReadAllText(@"C:\Users\User\Downloads\DEMO\PowerShell.ps1")).Invoke();
        ps.Invoke();

    }

備註 Cake.Powershell需再NET Core的環境下運行  
若有必要請在.Net Framework運行Process.Start()啟動 .Net Core專案的Exe檔  
## 建立.Net Framework專案  

附圖為.Net Core的檔案位置
![Desktop View](/assets/img/2022-11-14-c-sharp-software-automation-use-bat-execute-powershell-command/8.PNG){: width="600" height="500" }

在.Net Framework的專案執行
<script  type='text/javascript' src=''>

    using System.Diagnostics;

    namespace ConsoleApp1
    {
        internal class Program
        {
            static void Main(string[] args)
            {
                string path = @"C:\Users\User\Downloads\DEMO\ConsoleApp3\ConsoleApp3\bin\Debug\net6.0\ConsoleApp3.exe";
                Process.Start(path);
            }
        }
    }


# 失敗時，須調整的設定  
如果出現類似附圖情況  
![Desktop View](/assets/img/2022-11-14-c-sharp-software-automation-use-bat-execute-powershell-command/2.PNG){: width="600" height="500" }

先透過PowerShell確認當前原則狀態  
![Desktop View](/assets/img/2022-11-14-c-sharp-software-automation-use-bat-execute-powershell-command/3.PNG){: width="600" height="500" }
<script  type='text/javascript' src=''>
 
    Get-ExecutionPolicy


微軟的官方文件[about_Execution_Policies](https://learn.microsoft.com/zh-tw/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.3)
有提到我當前的「PowerShell 執行原則」Restricted不允許執行腳本，所以我必須變更原則設定
  
![Desktop View](/assets/img/2022-11-14-c-sharp-software-automation-use-bat-execute-powershell-command/4.PNG){: width="600" height="500" }

以變更成RemoteSigned為例
<script  type='text/javascript' src=''>
 
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

需使用最高權限執行PowerShell才能成功變更設定  
![Desktop View](/assets/img/2022-11-14-c-sharp-software-automation-use-bat-execute-powershell-command/6.PNG){: width="600" height="500" }


否則會出現  
![Desktop View](/assets/img/2022-11-14-c-sharp-software-automation-use-bat-execute-powershell-command/5.PNG){: width="600" height="500" }





# 補充 : 使用Bat檔執行ps1的指令  
備註:
可能會發生，在改過「原則狀態」後，於.Net Framework環境透過Process.Start()啟動會失敗，  
但是Bat手動執行會成功，原因不曉得，  
但因為遇到此狀況所以我才改用.Net Core 來解決問題  
<script  type='text/javascript' src=''>
 
    powershell -noexit "& ""C:\Users\User\Downloads\DEMO\PowerShell.ps1"""

