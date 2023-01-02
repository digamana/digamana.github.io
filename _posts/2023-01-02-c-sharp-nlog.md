---
layout: post
title: C# 使用Nlog撰寫Logger日誌
date: 2023-01-02 14:41 +0800
---
## 前言
<p>因為有時候</p>

## 安裝套件
<p>NLog</p>
 ![Desktop View](/assets/img/2023-01-02-c-sharp-nlog/1.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    NuGet\Install-Package NLog -Version 5.1.1

<p>NLog.Config</p>
 ![Desktop View](/assets/img/2023-01-02-c-sharp-nlog/2.png){: width="600" height="500" }
 <script  type='text/javascript' src=''>

    NuGet\Install-Package NLog.Config -Version 4.7.15

<p>NLog.Schema</p>
 ![Desktop View](/assets/img/2023-01-02-c-sharp-nlog/3.png){: width="600" height="500" }
 <script  type='text/javascript' src=''>

    NuGet\Install-Package NLog.Schema -Version 4.7.15


## 編輯NLog.config
<p>載完NLog套件時,會出現NLog.config</p>
<p>編輯其內容,可以根據設定Log的嚴重程度,決定儲存Log的方式</p>
 ![Desktop View](/assets/img/2023-01-02-c-sharp-nlog/4.png){: width="600" height="500" }
 <script  type='text/javascript' src=''>

    <?xml version="1.0" encoding="utf-8" ?>
    <nlog xmlns="http://www.nlog-project.org/schemas/NLog.xsd"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" autoReload="true">

	    <!--[變數] 文字樣板 -->
	    <variable name="Layout" value="${longdate} | ${level:uppercase=true} | ${logger} | ${message} ${newline}"/>
	    <variable name="LayoutFatal" value="${longdate} | ${level:uppercase=true} | ${logger} | ${message} | ${exception:format=tostring} ${newline}"/>

	    <!--[變數] 檔案位置 -->
	    <variable name="LogFileSaveFolderPath" value="${basedir}/Logs/${shortdate}/"/>
	    <variable name="LogFilePath" value="${LogFileSaveFolderPath}/${logger}.log"/>
	    <variable name="LogFileFatalPath" value="${LogFileSaveFolderPath}/FatalFile.log"/>

	    <!--[設定] 寫入目標-->
	    <targets>
		    <target name="File" xsi:type="File" fileName="${LogFilePath}" layout="${Layout}"
				    encoding="utf-8" maxArchiveFiles="30" archiveNumbering="Sequence"
				    archiveAboveSize="1048576" archiveFileName="${LogFileSaveFolderPath}/${logger}.log{#######}" />
		    <target name="FileFatal" xsi:type="File" fileName="${LogFileFatalPath}" layout="${LayoutFatal}"
				    encoding="utf-8" maxArchiveFiles="30" archiveNumbering="Sequence"
				    archiveAboveSize="1048576" archiveFileName="${LogFileSaveFolderPath}/FatalFile.log{#######}" />
		    <target name="EventLog" xsi:type="EventLog" source="NLogLogger" log="Application"
				    layout="${date}| ${level} | ${message}"/>
	    </targets>

	    <!--[設定] 紀錄規則-->
	    <rules>
		    <logger name="*" levels="Trace,Debug" writeTo="File" />
		    <logger name="*" levels="Info" writeTo="File" />
		    <logger name="*" levels="Warn" writeTo="File" />
		    <logger name="*" levels="Error,Fatal" writeTo="FileFatal" />
		    <logger name="*" levels="Fatal" writeTo="EventLog" />
	    </rules>

    </nlog>

## 執行紀錄Log的程式
<p>紀錄Log的指令像這樣</p>
 ![Desktop View](/assets/img/2023-01-02-c-sharp-nlog/5.png){: width="600" height="500" }
 <script  type='text/javascript' src=''>

    using NLog;
    namespace ConsoleApp6
    {

        internal class Program
        {
            private static Logger logger = LogManager.GetCurrentClassLogger();
            static void Main(string[] args)
            {
                logger.Trace("我是追蹤:Trace");
                logger.Debug("我是偵錯:Debug");
                logger.Info("我是資訊:Info");
                logger.Warn("我是警告:Warn");
                logger.Error("我是錯誤:error");
                logger.Fatal("我是致命錯誤:Fatal");
            }
        }
    }

## Log紀錄位置
<p>根據NLog.config的描述,產生的Log文件「位置」</p>
 ![Desktop View](/assets/img/2023-01-02-c-sharp-nlog/6.png){: width="600" height="500" }
<p>根據NLog.config的描述,產生的Log文件「內容」</p>
 ![Desktop View](/assets/img/2023-01-02-c-sharp-nlog/7.png){: width="600" height="500" }

<p>根據NLog.config的描述,產生的「事件檢視器」的紀錄</p>
<p>備註寫入Log時,須注意有無權限,例如「事件檢視器」就一定要用最高權限</p>
 ![Desktop View](/assets/img/2023-01-02-c-sharp-nlog/8.png){: width="600" height="500" }
 

## 參考
[https://kevintsengtw.blogspot.com/2011/10/nlog-advanced-net-logging-1.html](https://kevintsengtw.blogspot.com/2011/10/nlog-advanced-net-logging-1.html)  
[https://learningcoding.coderbridge.io/2020/02/13/NLog/](https://learningcoding.coderbridge.io/2020/02/13/NLog/)  
[https://dotblogs.com.tw/stanley14/2017/02/15/nlog](https://dotblogs.com.tw/stanley14/2017/02/15/nlog)  
