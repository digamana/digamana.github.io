---
layout: post
title: GitHub Actions and Workflows
date: 2022-12-17 15:06 +0800
---


## 建立一個簡單的Github Action

### 建立Github專案
<p>備註:開源專案是免費使用,私有專案是付費使用</p>
![Desktop View](/assets/img/2022-12-17-github-actions-and-workflows/1.png){: width="600" height="500" }
### 本地讀取專案
![Desktop View](/assets/img/2022-12-17-github-actions-and-workflows/2.png){: width="600" height="500" }
### 建立yml檔案
<p>Step1."手動"建立github資料夾</p>
<p>Step2."手動"建立workflows資料夾</p>
<p>Step3."手動"建立yml檔</p>
![Desktop View](/assets/img/2022-12-17-github-actions-and-workflows/3.png){: width="600" height="500" }


### 編輯yml內容
<p>yml檔中,若中輸入簡單的指令,Push到Github時,就能在Action看到指令的運作了</p>
![Desktop View](/assets/img/2022-12-17-github-actions-and-workflows/4.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    name: command
    on: [push]
    jobs:
        run-shell-command:
            runs-on: ubuntu-18.04
            steps:
                - name: echo a string
                  run: echo "HI"

<p>也可以使用cron來排程執行action</p>
<p>下面cron的寫法代表5分鐘執行一次,而cron的寫法參考如下網址</p>
[https://crontab.guru/examples.html](https://crontab.guru/examples.html)
<script  type='text/javascript' src=''>

    name: command
    on:
        schedule:
        - cron: "0/5 * * * *" 
    jobs:
        run-shell-command:
            runs-on: ubuntu-18.04
            steps:
                - name: echo a string
                  run: echo "HI"


## C#專案Push到Github時,自動進行單元測試

### 建立DEMO專案
![Desktop View](/assets/img/2022-12-17-github-actions-and-workflows/5.png){: width="600" height="500" }
### 建立測試專案
![Desktop View](/assets/img/2022-12-17-github-actions-and-workflows/6.png){: width="600" height="500" }
![Desktop View](/assets/img/2022-12-17-github-actions-and-workflows/7.png){: width="600" height="500" }
![Desktop View](/assets/img/2022-12-17-github-actions-and-workflows/8.png){: width="600" height="500" }
![Desktop View](/assets/img/2022-12-17-github-actions-and-workflows/9.png){: width="600" height="500" }
### 輸入單元測試內容
![Desktop View](/assets/img/2022-12-17-github-actions-and-workflows/10.png){: width="600" height="500" }
### 本地運行單元測試
![Desktop View](/assets/img/2022-12-17-github-actions-and-workflows/11.png){: width="600" height="500" }
### 編輯測試專案的csproj檔
<p>這一個步驟,是為了讓單元測試的結果,以Report的方式顯示</p>
<p>將其PropertyGroup屬性中,追加VSTestLogger與VSTestResultsDirectory屬性,如下</p>
![Desktop View](/assets/img/2022-12-17-github-actions-and-workflows/13.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    <VSTestLogger>trx%3bLogFileName=$(MSBuildProjectName).trx</VSTestLogger>
    <VSTestResultsDirectory>$(MSBuildThisFileDirectory)/TestResults/$(TargetFramework)</VSTestResultsDirectory>


### 手動配置yml
![Desktop View](/assets/img/2022-12-17-github-actions-and-workflows/12.png){: width="600" height="500" }
### 編輯yml

yml內容如下
<script  type='text/javascript' src=''>

    name: CI
    on: [push]
    jobs:
      build_and_test:

        env:
          BUILD_CONFIG: 'Debug'
          SOLUTION: 'GithubActionDemo/GithubActionDemo.sln'

        runs-on: ubuntu-latest

        steps:
        - uses: actions/checkout@v2

        - name: Setup .NET
          uses: actions/setup-dotnet@v1
          with:
            dotnet-version: 6.x


        - name: Restore dependencies
          run: dotnet restore $SOLUTION

        - name: Build
          run: dotnet build $SOLUTION --configuration $BUILD_CONFIG
      
        - name: Test
          run: dotnet test $SOLUTION  --configuration $BUILD_CONFIG --logger "trx;LogFileName=test-results.trx" || true
        - name: Test Report
          uses: dorny/test-reporter@v1
          if: always()
          with:
            name: DotNET Tests
            path: "**/test-results.trx"                            
            reporter: dotnet-trx
            fail-on-error: true

### Push到Github
<p>將專案Push到Github後,然後進入Action</p>
![Desktop View](/assets/img/2022-12-17-github-actions-and-workflows/14.png){: width="600" height="500" }
<p>選擇最新的Commit</p>
![Desktop View](/assets/img/2022-12-17-github-actions-and-workflows/15.png){: width="600" height="500" }
<p>Bulid and Test是測試部署</p>
<p>選擇DotNet Test</p>
![Desktop View](/assets/img/2022-12-17-github-actions-and-workflows/16.png){: width="600" height="500" }
<p>DotNet Test中,可以看到單元測試的結果</p>
![Desktop View](/assets/img/2022-12-17-github-actions-and-workflows/17.png){: width="600" height="500" }
### 重要參考
[https://rakesh-suryawanshi.medium.com/unit-testing-report-with-github-actions-7216f340044e](https://rakesh-suryawanshi.medium.com/unit-testing-report-with-github-actions-7216f340044e)
[https://stackoverflow.com/questions/60126813/github-actions-report-dotnet-test-result-as-annotations](https://stackoverflow.com/questions/60126813/github-actions-report-dotnet-test-result-as-annotations_)
[https://stackoverflow.com/questions/61464151/how-it-is-possible-to-avoid-a-push-in-github-when-the-workflow-tests-fails](https://stackoverflow.com/questions/61464151/how-it-is-possible-to-avoid-a-push-in-github-when-the-workflow-tests-fails)
