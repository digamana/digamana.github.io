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


## 快速建立Job,並設定VS專案路徑
![Desktop View](/assets/img/2023-05-05-jenkins-cicd/6.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-05-05-jenkins-cicd/7.png){: width="600" height="500" }


## CI 持續整合

### 安裝插件 Warnings Next Generation

## 備註

Server重啟指令-非強制重啟
<script  type='text/javascript' src=''>

    (jenkins_url)/safeRestart


Server重啟指令-強制重啟
<script  type='text/javascript' src=''>

    (jenkins_url)/restart
