---
layout: post
title: Excel VBA Hello World
date: 2022-10-30 06:38 +0800
published: true
categories: [Other ,Excel VBA]
---
這邊DEMO使用Button讀取、寫入Excel儲存格的範例

## 簡單建立EXCEL 並使用VBA的方式
1.範例Eecel  
![Desktop View](/assets/img/2022-10-30-excel-vba-hello-world/1.png){: width="600" height="500" }

2.新增一個Button  
![Desktop View](/assets/img/2022-10-30-excel-vba-hello-world/2.png){: width="600" height="500" }

3.設定巨集名稱  
![Desktop View](/assets/img/2022-10-30-excel-vba-hello-world/3.png){: width="600" height="500" }

4.開始撰寫程式  
![Desktop View](/assets/img/2022-10-30-excel-vba-hello-world/4.png){: width="600" height="500" }

5.簡單的Hello World ：點選button後MessageBox會跳出A1的內容  
![Desktop View](/assets/img/2022-10-30-excel-vba-hello-world/5.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

     Sub 按鈕1_Click()
      MsgBox ThisWorkbook.Sheets("工作表1").Cells(1, 1)
      End Sub

6.成功畫面  
![Desktop View](/assets/img/2022-10-30-excel-vba-hello-world/6.png){: width="600" height="500" }


## Delete File
Source Code：

## Copy File
Source Code：

## Open Other Excel (Workbook)
Source Code：




