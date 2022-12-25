---
layout: post
title: web api test
date: 2022-12-06 23:10 +0800
---

## 前言
待補
## 概要
WebService 分為 SOAP跟REST兩種
測試WebService需要有WSDL，沒有WSDL會連有哪些function及其有哪些參數可以輸入都無從得知
備註WSDL是XML檔,用來描述Web Service

## 測試工具 SoapUI

<p>SoapUI官方網址</p>
[https://www.soapui.org/downloads/latest-release/](https://www.soapui.org/downloads/latest-release/)


## Web Service - SOAP
### 開啟SoapUI
![Desktop View](/assets/img/2022-12-06-web-api-test/1.png){: width="800" height="600" }  

###  導入SOAP的WSDL到SoapUI

![Desktop View](/assets/img/2022-12-06-web-api-test/2.png){: width="800" height="600" }

###  測試輸出
<p>Step1.左邊資料夾展開後,雙擊Request</p>
<p>Step2.「?」 的部分是Method的參數，測試時任意輸入</p>
<p>Step3.輸入完之後按「▶」，進行輸出</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/3.png){: width="800" height="600" }
### free Web Service
[free Web Service](https://www.796t.com/content/1547817483.html)

### 建立自動測試
<p>Step1.左邊右鍵,雙擊new TestSuit</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/4.png){: width="800" height="600" }
<p>Step2.這邊我將我的new TestSuit命名為Emp，接著右鍵新增測試</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/5.png){: width="800" height="600" }
<p>Step3.新增測試步驟</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/6.png){: width="800" height="600" }
<p>Step4.設定</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/7.png){: width="800" height="600" }
<p>Step5.在Context內，輸入要用來驗證的Value，</p>
<p>除此之外還可以驗證是不是有效的SOAP、有沒有回應HTTP Request CODE</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/8.png){: width="800" height="600" }
<p>Step6.可以針對已經打好的Test Case進行總測試</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/9.png){: width="800" height="600" }
<p>Step7.設定Value為變數的方式，建立Property</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/10.png){: width="800" height="600" }
<p>Step7.設定Property</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/11.png){: width="800" height="600" }


### 使用Groovy Script撰寫自動測試

<p>目標是使用Groovy編寫自動化腳本，藉此取代如下圖的手動輸入輸出</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/12.png){: width="800" height="600" }

<p>Groovy Script的建立方式</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/13.png){: width="800" height="600" }
<p>在TestStep中，建立SOAP Request，用來進行單獨測試</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/14.png){: width="800" height="600" }
<p>有了單獨測試的項目後，就可以使用Groovy Script來撰寫腳本了</p>
<p>備註:要記得儲存,不然Add Step時不會顯示Groovy Scrip</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/15.png){: width="800" height="600" }
<p>輸出結果</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/17.png){: width="800" height="600" }
<script  type='text/javascript' src=''>

    import com.eviware.soapui.support.XmlHolder
    import com.eviware.soapui.impl.wsdl.testcase.WsdlTestRunContext

    def getReq = testRunner.testCase.testSuite.testCases["AutoTrans"].testSteps["SOAP Request"].getPropertyValue("Request")
    def getEmpxml = new XmlHolder(getReq)

    //取得區域變數
    def id2= testRunner.testCase.testSuite.testCases['AutoTrans'].getPropertyValue("id2")
    def id1= testRunner.testCase.testSuite.testCases['AutoTrans'].getPropertyValue("id1")

    //設定xml要設定的Values
    getEmpxml.setNodeValue("//web:getEnCnTwoWayTranslator/web:Word",id2)
    //取得更新後的xml
    def newAddXml = getEmpxml.getXml()

    //更新xml輸入端的畫面
    testRunner.testCase.testSuite.testCases["AutoTrans"].testSteps["SOAP Request"].setPropertyValue("Request",newAddXml)
    log.info newAddXml

    //更新xml輸出端的畫面
    def addTestStep = testRunner.testCase.testSuite.testCases["AutoTrans"].testSteps["SOAP Request"]
    def contextAddEmployee = new WsdlTestRunContext(addTestStep)
    addTestStep.run(testRunner,contextAddEmployee)

    //讀取結果,以便進行驗證
    def getRes = testRunner.testCase.testSuite.testCases["AutoTrans"].testSteps["SOAP Request"].getPropertyValue("Response")
    def getEmpRes = new XmlHolder(getRes)
    def getResponse1 = getEmpRes.getNodeValue("//*:getEnCnTwoWayTranslatorResult/*:string[1]")
    def getResponse2= getEmpRes.getNodeValue("//*:getEnCnTwoWayTranslatorResult/*:string[2]")
    log.info getResponse1
    log.info getResponse2

### Goovy Script語法備註

輸出字串的方式
<script  type='text/javascript' src=''>

    log.info "tsrt"


Get區域變數並輸出的方式
![Desktop View](/assets/img/2022-12-06-web-api-test/16.png){: width="800" height="600" }
<script  type='text/javascript' src=''>

    log.info  testRunner.testCase.testSuite.testCases['AutoTrans'].getPropertyValue("id")

設定區域變數
<script  type='text/javascript' src=''>

    testRunner.testCase.testSuite.testCases['AutoTrans'].setPropertyValue("id","abcdefg")

## 可練習使用REST的參考網站
<p>http測試平台httpbin</p>
[http://httpbin.org/](http://httpbin.org/)
<p>Trello - 專案管理網頁</p>
<p>官網</p>
[https://trello.com/](https://trello.com/)
<p>官方API說明</p>
[https://developer.atlassian.com/cloud/trello/rest/api-group-actions/](https://developer.atlassian.com/cloud/trello/rest/api-group-actions/)
<p>官方Api金鑰取得</p>
[https://trello.com/app-key](https://trello.com/app-key)


## Web Service - REST

<p>使用Trello官方的API網址，在SOAP UI建立測試Procject的方式</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/18.png){: width="800" height="600" }

<p>設定Api Key 與 Token的方式</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/19.png){: width="800" height="600" }

<p>>測試使用WebApi 實際操作建立Trello看板的方式</p>
<p>>仔細看文件上,有提到name、key、token這些參數名稱</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/20.png){: width="800" height="600" }
![Desktop View](/assets/img/2022-12-06-web-api-test/21.png){: width="800" height="600" }


<p>>使用Script Assertion驗證Values</p>

### 驗證XML格式
<p>轉換JSON格式的網站</p>
[https://jsoneditoronline.org/](https://jsoneditoronline.org/)
<p>使用SOAP UI官方提供的資料練習驗證</p>
[https://www.soapui.org/resources/tutorials/rest-sample-project/](https://www.soapui.org/resources/tutorials/rest-sample-project/)
![Desktop View](/assets/img/2022-12-06-web-api-test/31.png){: width="800" height="600" }

<p>以非商業用途申請flickr的API KEY</p>
[https://www.flickr.com/services/apps/create/apply](https://www.flickr.com/services/apps/create/apply)
<p>這邊我導入在官網下載的flick的XML</p>
<p>並在導入後,輸入從flick官網上獲得的API KEY</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/32.png){: width="800" height="600" }

<p>使用JsonPath Match驗證JSON資料的方式</p>
<p>這邊我要驗證的是perpage=100</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/33.png){: width="800" height="600" }
<p>建立驗證的方式</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/34.png){: width="800" height="600" }


<p>建立</p>



## Mock Service
<p>使用Mock Service製作假資料，以便用來在真正的Service開發完成前，可以使用假資料測試資料驗證</p>

### 加入Mock Service
<p>一樣要先使用SOAP的WSDL或REST的URL導入專案，然後再導入的專案底下，點擊右鍵</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/35.png){: width="800" height="600" }
<p>建完之後,可以看到用來輸出假資料的視窗</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/36.png){: width="800" height="600" }

### Mock Service Response模式
<p>如果在Mock Service有加入很多Response要來進行測試</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/37.png){: width="800" height="600" }
<p>需要在Dispatch設定要回傳Response模式</p>
<p>其中,若使用Script,可以用Groovy語法來寫動態回傳Response的腳本</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/38.png){: width="800" height="600" }


## WebService 安全測試

### 建立安全測試

<p>Steo1</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/39.png){: width="800" height="600" }
<p>Steo2</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/40.png){: width="800" height="600" }



## SOAP UI Connect MSSQL

### 安裝JDBC驅動

<p>SOAP UI官網</p>
[https://www.soapui.org/docs/jdbc/reference/jdbc-drivers/](https://www.soapui.org/docs/jdbc/reference/jdbc-drivers/)
![Desktop View](/assets/img/2022-12-06-web-api-test/41.png){: width="800" height="600" }

<p>下載微軟官網的這個驅動(for Mssql)</p>
[https://www.microsoft.com/zh-tw/download/confirmation.aspx?id=11774](https://www.microsoft.com/zh-tw/download/confirmation.aspx?id=11774)

<p>把sqljdbc42.jar與sqljdbc_auth.dll丟到「C:\Program Files\SmartBear\SoapUI-5.7.0\bin\ext」底下</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/42.png){: width="800" height="600" }

<p>[重要]丟完後，重啟SOAP UI </p>

### 建立連線
<p>在testCase中,新增JDBC Request</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/43.png){: width="800" height="600" }

</p>輸入連線資料<p>
![Desktop View](/assets/img/2022-12-06-web-api-test/44.png){: width="800" height="600" }
Driver
<script  type='text/javascript' src=''>

    com.microsoft.sqlserver.jdbc.SQLServerDriver

Connection String
<script  type='text/javascript' src=''>

    jdbc:sqlserver://HostName   ; username=    ;   password=


Sql Server Browser要打開,否則測試連線會Error
![Desktop View](/assets/img/2022-12-06-web-api-test/45.png){: width="800" height="600" }
TCP/IP監聽也要打開,否則測試連線會Error
![Desktop View](/assets/img/2022-12-06-web-api-test/46.png){: width="800" height="600" }

以上都處理好,就能連線成功
![Desktop View](/assets/img/2022-12-06-web-api-test/47.png){: width="800" height="600" }


### Query輸出
打上SQL語法,輸出會呈現XML架構
![Desktop View](/assets/img/2022-12-06-web-api-test/48.png){: width="800" height="600" }

Query 可以使用SOAP UI的區域變數
![Desktop View](/assets/img/2022-12-06-web-api-test/49.png){: width="800" height="600" }
### 測試連線,因連線失敗而參考的網址


[https://community.smartbear.com/t5/SoapUI-Open-Source-Questions/I-am-facing-problem-while-connecting-MSSQL-connection-in-Soapui/m-p/164597#M26986](https://community.smartbear.com/t5/SoapUI-Open-Source-Questions/I-am-facing-problem-while-connecting-MSSQL-connection-in-Soapui/m-p/164597#M26986)  
[https://stackoverflow.com/questions/36822071/how-to-create-a-mssql-server-connection-in-soapui](https://stackoverflow.com/questions/36822071/how-to-create-a-mssql-server-connection-in-soapui)  
[https://community.smartbear.com/t5/SoapUI-Open-Source-Questions/Solved-JDBC-Cannot-connect-to-a-MS-SQL-database/td-p/132235](https://community.smartbear.com/t5/SoapUI-Open-Source-Questions/Solved-JDBC-Cannot-connect-to-a-MS-SQL-database/td-p/132235)  
[]()

## 正式環境/測試環境 分離的方式
<p>在正式的WebService開發完成之前,可以使用Mock建立假的測試資料</p>
<p>這邊紀錄切換Mock與正式WebService可以參考的方式</p>
<p>首先,導入WebService後,新增Mock,會變成如下圖的結構</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/51.png){: width="800" height="600" }

<p>建立變數</p>
<p>env:                   放用來切換是dev還是prod的字串</p>
<p>EnCnTwoWayTranslator : 這邊放Request的URL</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/52.png){: width="800" height="600" }

<p>把Request的URL替換成區域變數</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/53.png){: width="800" height="600" }

<p>新增一個TestSuite</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/54.png){: width="800" height="600" }

<p>將Mock和正式的Request加到Test Step中</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/55.png){: width="800" height="600" }
<p>備註1: 要注意Mock的輸出方式</p>

<p>備註2: 要注意Mock 要記得打開</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/56.png){: width="800" height="600" }

<p>建立兩個檔案,副檔名為properties</p>
<p>其內容為 dev的request與正式的request</p>
<p>格式如圖所示,就是與SOAP的Values要一樣</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/57.png){: width="800" height="600" }

<p>打開TestSuite開始打Groovy腳本(Setup Script)</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/58.png){: width="800" height="600" }

<script  type='text/javascript' src=''>

    String env = context.expand('${#Project#env}')
    String filePath = "C:\temp"+env+".properties"

    Properties props = new Properties()
    File configFile = new File(filePath)
    configFile.withInputStream{
	    line->
	    props.load(line)
    }
    testSuite.project.setPropertyValue('getEnCnTwoWayTranslator',props['getEnCnTwoWayTranslator'])


## 壓力測試
<p>可以留意的參數</p>
<p>Thread: 可以把執行序視為用戶數量看待</p>
<p>avg: 平均的響應時間</p>
<p>tps: 每秒輸出多少</p>
<p>可以透過以上3個參數在Excel匯出曲線圖，以便得出最佳使用人數限制</p>
![Desktop View](/assets/img/2022-12-06-web-api-test/50.png){: width="800" height="600" }

