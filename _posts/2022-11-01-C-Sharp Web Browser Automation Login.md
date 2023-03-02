---
layout: post
title: C# WebBrowser Automation Login
date: 2022-11-01 23:42 +0800
categories: [Automation,Web]
tags: [C#]
---

首先需要安裝套件  
![Desktop View](/assets/img/2022-11-01-C-Sharp Web Browser Automation Login/1.png){: width="600" height="500" }  
其一：Selenium.WebDriver
<script  type='text/javascript' src=''>

     NuGet\Install-Package Selenium.WebDriver -Version 4.5.1

其二：Selenium.WebDriver.ChromeDriver ( 版本需依據本地Chrome的版本微調)
<script  type='text/javascript' src=''>

     NuGet\Install-Package Selenium.WebDriver.ChromeDriver -Version 106.0.5249.6100

 
以登入Netflix為例
使用以下範例
<script  type='text/javascript' src=''>

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
                  //開啟網頁
                  string str = "https://www.netflix.com/tw/Login";
                  driver.Navigate().GoToUrl(str);
           
                  IWebElement inputAccount = driver.FindElement(By.Name("userLoginId"));
                  Thread.Sleep(50);
                  inputAccount.SendKeys("Account"); //輸入帳號
                  Thread.Sleep(50);

                  IWebElement inputPassword = driver.FindElement(By.Name("password"));
                  Thread.Sleep(50);
                  inputPassword.SendKeys("Password"); //輸入密碼
                  Thread.Sleep(50);
                  //登入
                  IWebElement submitButton = driver.FindElement(By.XPath("//*[@class='btn login-button btn-submit btn-small']"));
                  Thread.Sleep(50);
                  submitButton.Click();
              }
          }
      }


參數來源  
![Desktop View](/assets/img/2022-11-01-C-Sharp Web Browser Automation Login/2.png){: width="600" height="500" }   
執行GIF ，依照上面範例中的帳號密碼的輸入的話，理所當然會在Cick Login之後顯示帳號或密碼錯誤
![Desktop View](/assets/img/2022-11-01-C-Sharp Web Browser Automation Login/3.GIF){: width="600" height="500" }  

額外需求補充
如果要點擊某個button,但是html都長一樣的話,像以下範例一樣,使用XPath彙整出陣列,在進行enter  
![Desktop View](/assets/img/2022-11-01-C-Sharp Web Browser Automation Login/3.png){: width="600" height="500" } 
<script  type='text/javascript' src=''>

    IReadOnlyCollection<IWebElement> ConsoleCLI = driver.FindElements(By.XPath("//*[@class='console-controls ng-star-inserted']/button"));
    ConsoleCLI.ToList()[3].SendKeys(Keys.Enter);
