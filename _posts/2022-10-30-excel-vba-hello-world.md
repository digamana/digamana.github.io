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



## Class Of List

以C#來說, Class Of List如果長這樣
<script  type='text/javascript' src=''>

    using System.Collections;
    using System.Collections.Generic;

    namespace ConsoleApp4
    {
        class Program
        {
            static void Main(string[] args)
            {
                List<CResult> Emp = new List<CResult>();
                Emp.Add(new CResult()
                {
                    Customer = "aaa",
                    Mo = "ccc"
                });
                Emp.Add(new CResult()
                {
                    Customer = "aaa1",
                    Mo = "ccc1"
                });
            }
        }
        public class CResult
        { 
            public string Rows { get;  set; }
            public string Customer { get;  set; }
            public string Mo { get;  set; }
            public ArrayList MoList { get;  set; }
        }
    }


Excel VBA的實現方式如下  

Class Name:CResult內容:
<script  type='text/javascript' src=''>

    Private pRows As String
    Private pCustomer As String
    Private pMo As String
    Private pMoList As ArrayList
 
    ' Rows property
    ''''''''''''''''''''''
    Public Property Get Rows() As String
        Rows = pRows
    End Property
    Public Property Let Rows(Value As String)
        pRows = Value
    End Property

    ''''''''''''''''''''''
    ' Customer property
    ''''''''''''''''''''''
    Public Property Get Customer() As String
        Customer = pCustomer
    End Property
    Public Property Let Customer(Value As String)
        pCustomer = Value
    End Property

    ''''''''''''''''''''''
    ' Mo property
    ''''''''''''''''''''''
    Public Property Get Mo() As String
        Mo = pMo
    End Property
    Public Property Let Mo(Value As String)
        pMo = Value
    End Property

    ''''''''''''''''''''''
    ' MoList property
    ''''''''''''''''''''''
    Public Property Get MoList() As ArrayList
        Set MoList = pMoList
    End Property
    Public Property Let MoList(Value As ArrayList)
        Set pMoList = Value
    End Property


Main Sheet Event
<script  type='text/javascript' src=''>

    Dim Employees As Collection
    Dim Emp As CResult
    Set Employees = New Collection
    
        Set Emp = New CResult
            Emp.Customer = "aaa"
            Emp.Mo = "ccc"
    Employees.Add Emp
    
        Set Emp = New CResult
            Emp.Customer = "aaa1"
            Emp.Mo = "ccc2"
    Employees.Add Emp


