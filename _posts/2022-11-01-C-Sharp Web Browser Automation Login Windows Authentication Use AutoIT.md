---
layout: post
title: C# Web Browser Automation Login Windows Authentication Use AutoIT
date: 2022-11-01 23:28 +0800
categories: [Automation,Web]
tags: [C#]
---
開啟新的Visual Studio專案，會使用以下套件  
![Desktop View](/assets/img/2022-11-01-C-Sharp Web Browser Automation Login/1.png){: width="600" height="500" }  
其一：Selenium.WebDriver
<script>

     NuGet\Install-Package Selenium.WebDriver -Version 4.5.1

其二：Selenium.WebDriver.ChromeDriver ( 版本需依據本地Chrome的版本微調)
<script>

     NuGet\Install-Package Selenium.WebDriver.ChromeDriver -Version 106.0.5249.6100


新增AutoIT  
![Desktop View](/assets/img/2022-11-01-C-Sharp Web Browser Automation Login Windows Authentication Use AutoIT/2.png){: width="600" height="500" }
開啟AutoIT  
![Desktop View](/assets/img/2022-11-01-C-Sharp Web Browser Automation Login Windows Authentication Use AutoIT/3.png){: width="600" height="500" }  
AutoIT使用以下Code匯出exe
<script>

      #include <Constants.au3>

      ;RequireAdmin ; unsure if it's needed
      ;$iSleep = 2000
      Opt("WinSearchChildren", 1)
      $sUsername = "Account"
      $sPassword = "Password"
      Sleep(1000)
      For $i = 1 To 20 Step 1
          Sleep(3000)
          $sTitle = WinGetTitle("Sign in")
          If $sTitle = "strTitle" or WinWaitActive("[CLASS:Chrome_WidgetWin_1]")  or WinWaitActive("Sign in") Then
              Send($sUsername)
              Send("{TAB}")
              Send($sPassword,1);$SEND_RAW (1)
              Send("{TAB}")
              Send("{ENTER}")
              Exit 0
          Else
              ContinueLoop
          EndIf
      Next
      Exit 1


匯出exe的方式是在Tool底下選擇Go or Compile
![Desktop View](/assets/img/2022-11-01-C-Sharp Web Browser Automation Login Windows Authentication Use AutoIT/4.png){: width="600" height="500" }
匯出後可以在同目錄底下看到檔案
![Desktop View](/assets/img/2022-11-01-C-Sharp Web Browser Automation Login Windows Authentication Use AutoIT/5.png){: width="600" height="500" }

AutoIT的Code參數來源  
![Desktop View](/assets/img/2022-11-01-C-Sharp Web Browser Automation Login Windows Authentication Use AutoIT/1.png){: width="600" height="500" }  


開啟新專案
<script>

      using OpenQA.Selenium;
      using OpenQA.Selenium.Chrome;
      using System.Threading;

      namespace WebBrowser_AutoLogin
      {
          internal class Program
          {
              static void Main(string[] args) 
              {
                  IWebDriver driver = new ChromeDriver();
                 
                  string str = "URL_Path"; //輸入會跳出Winodows驗證的網址
                  driver.Navigate().GoToUrl(str);
           
                  IWebElement inputAccount = driver.FindElement(By.Name("userLoginId"));
                  Thread.Sleep(2000);
                  Process.Start("輸入匯出的exe的Path");//使用上面匯出的Exe來處理密碼輸入問題
                  //登入

                  IWebElement submitButton = driver.FindElement(By.XPath("//*[@class='btn login-button btn-submit btn-small']"));//自行變更需要進行的操作
                  submitButton.Click();
              }
          }
      }
