---
layout: post
title: Use Jenkins Run CI/CD
date: 2023-05-05 13:53 +0800
---

## 安裝jenkins
<p>1.下載jenkins</p>
[https://www.jenkins.io/](https://www.jenkins.io/)

<p>2.下載Java環境 (環境需求)</p>
[https://www.oracle.com/java/technologies/downloads/#jdk17-windows](https://www.oracle.com/java/technologies/downloads/#jdk17-windows)

## MSBuild 建置

## 安裝jenkins的MSBuild插件
![Desktop View](/assets/img/2023-05-05-jenkins-cicd/1.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-05-05-jenkins-cicd/2.png){: width="600" height="500" }



### 設定MSBuild路徑
![Desktop View](/assets/img/2023-05-05-jenkins-cicd/3.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-05-05-jenkins-cicd/4.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-05-05-jenkins-cicd/5.png){: width="600" height="500" }

### 取得本機MSBuild.exe路徑
VS 2022 MSBuild路徑
<script  type='text/javascript' src=''>

    C:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin


## [本地專案] 重建

### 建立Job,並設定VS專案路徑
![Desktop View](/assets/img/2023-05-05-jenkins-cicd/6.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-05-05-jenkins-cicd/7.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-05-05-jenkins-cicd/8.png){: width="600" height="500" }

## [本地專案] 單元測試

### 簡單Report
Jenkins安裝NUnit plugin
![Desktop View](/assets/img/2023-05-05-jenkins-cicd/9.png){: width="600" height="500" }
<p>下載NUnit Console </p>
[https://nunit.org/download/](https://nunit.org/download/)
<p>確認有安裝成功</p>
![Desktop View](/assets/img/2023-05-05-jenkins-cicd/10.png){: width="600" height="500" }
<p>Jenkins建立Job</p>
<p>選擇建立「執行 Windows 批次指令」</p>
![Desktop View](/assets/img/2023-05-05-jenkins-cicd/11.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    "C:\Program Files (x86)\NUnit.org\nunit-console\nunit3-console.exe" "C:\Users\User\source\repos\ConsoleApp1\UnitTestProject1\bin\Debug\UnitTestProject1.dll" -result =TestResult.xml;format=nunit2 



<p>執行後,可以看到單元測試的報表</p>
![Desktop View](/assets/img/2023-05-05-jenkins-cicd/12.png){: width="600" height="500" }

### 更多Report
Jenkins安裝NUnit plugin
![Desktop View](/assets/img/2023-05-05-jenkins-cicd/9.png){: width="600" height="500" }
Jenkins安裝HTML Publisher plugin
![Desktop View](/assets/img/2023-05-05-jenkins-cicd/13.png){: width="600" height="500" }
Jenkins安裝Cobertura Plugin
![Desktop View](/assets/img/2023-05-05-jenkins-cicd/14.png){: width="600" height="500" }

下載 NUnit Console :[https://nunit.org/download/](https://nunit.org/download/)  
下載 OpenCover :[https://github.com/OpenCover/opencover/releases](https://github.com/OpenCover/opencover/releases)  
下載 ReportGenerator :[https://github.com/danielpalme/ReportGenerator/releases](https://github.com/danielpalme/ReportGenerator/releases)  
下載 OpenCoverToCoberturaConverter :[https://www.nuget.org/packages/OpenCoverToCoberturaConverter](https://www.nuget.org/packages/OpenCoverToCoberturaConverter)
備註 :上述都直接載ZIP解壓縮以便能快速找到exe位置為主  
![Desktop View](/assets/img/2023-05-05-jenkins-cicd/15.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    "C:\Users\User\Downloads\JenkinsTool\opencover\OpenCover.Console.exe" -register:user -target:"C:\Program Files (x86)\NUnit.org\nunit-console\nunit3-console.exe" -targetargs:"C:\Users\User\source\repos\ConsoleApp1\UnitTestProject1\bin\Debug\UnitTestProject1.dll" -filter:"+[*]*" -output:Coverage.xml
    "C:\Users\User\Downloads\JenkinsTool\D\net47\ReportGenerator.exe" -reports:Coverage.xml -targetDir:CodeCoverageHTML
    "C:\Users\User\Downloads\JenkinsTool\opencovertocoberturaconverter\tools\OpenCoverToCoberturaConverter.exe" -input:Coverage.xml -output:Cobertura.xml -sources:C:\Users\User\source\repos\ConsoleApp1



## CI 持續整合

### 安裝插件 Warnings Next Generation

## 備註

Server重啟指令-非強制重啟
<script  type='text/javascript' src=''>

    (jenkins_url)/safeRestart


Server重啟指令-強制重啟
<script  type='text/javascript' src=''>

    (jenkins_url)/restart
