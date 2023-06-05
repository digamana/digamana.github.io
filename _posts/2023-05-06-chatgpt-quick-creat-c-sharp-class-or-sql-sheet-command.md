---
layout: post
title: 使用ChatGPT解決程式C#或Sql命名問題
date: 2023-05-06 16:06 +0800
---

## 前言

有時候在建立C#的Class或Sql的資料表的時候,
雖然知道欄位的用途及用意,
但總是會在命名的時候,想不到要如何轉成適當的名稱
所以想乾脆就直接讓ChatGPT來協助命名  

## C# Class指令
指令如下
<script  type='text/javascript' src=''>

    現在你是一個程式語言翻譯機 , 翻譯規則如下
    現在我的C#有一個Class 底下有很多個 像是
        public string FilePath { get; set; }  ///檔案位置
    的屬性
    我會給你後面的中文註解,請幫依序列出如上面範例一樣 英文與註解 意思相關的屬性
    並根據這些註解給我一個合適的Class Name
    例如適合範例中 適合的Class Name為Demo 而註解則是 測試
    切記註解一定要是繁體中文, 且回覆是 一個Class 封裝多個public string屬性
    只要回答我輸入的數量, 不要額外多做回覆,如以下範例所示
    只打了2個輸入 所以輸出 也只有2個public string屬性
    範例輸入如下
     1.檔案位置
     2.物料文件
    範例輸出格式如下
    ```
    /// <summary>
    /// 測試
    /// </summary>
    public class demo 
    {
	    /// <summary>
	    /// 檔案位置
	    /// </summary>
	    public string FilePath { get; set; }  
	
	    /// <summary>
	    /// 物料文件
	    /// </summary>
	    public string MaterialDocument { get; set; } 
	
    }
    ```

    現在開始根據我已下輸入的中文進行轉換

    採購單
    請購單
    物料文件



<p>範例</p>
![Desktop View](/assets/img/2023-05-06-chatgpt-quick-creat-c-sharp-class-or-sql-sheet-command/1.png){: width="600" height="500" }



## Mssql Creat Table指令
指令如下
<script  type='text/javascript' src=''>

    現在你是一個程式語言翻譯機 , 翻譯規則如下
    現在我的Mssql 需要建立一個Table
    我會給你後面的中文註解,請幫依序列出如上面範例一樣 英文與註解 意思相關的屬性
    並根據這些註解給我一個合適的TableName
    例如適合範例中 適合的Table Name為Demo 而註解則是 測試
    切記註解一定要是繁體中文, 
    且回覆是 一個TableName 封裝多個欄位
    且不要有主鍵、我要每個欄位都允許NuLL、每個資料型態都是NVARCHAR(50)
    只要回答我輸入的數量, 不要額外多做回覆,如以下範例所示
    只打了2個輸入 所以輸出 也只有2個欄位
    範例輸入如下
     1.檔案位置
     2.物料文件
    範例輸出格式如下
    ```
    -- 測試
    CREATE TABLE dbo.Demo
    (
        FileName NVARCHAR(50) Null,       -- 檔案位置
        MaterialDocument  NVARCHAR(50) Null,       -- 物料文件
    );

    EXEC sp_addextendedproperty 'MS_Description', '檔案位置', 'SCHEMA', 'dbo', 'TABLE', 'Demo', 'COLUMN', 'FileName';
    EXEC sp_addextendedproperty 'MS_Description', '物料文件', 'SCHEMA', 'dbo', 'TABLE', 'Demo', 'COLUMN', 'MaterialDocument';
    ```

    現在開始根據我已下輸入的中文進行轉換

    手機
    電腦
    電風扇
    螢幕
    外套


<p>範例</p>
![Desktop View](/assets/img/2023-05-06-chatgpt-quick-creat-c-sharp-class-or-sql-sheet-command/2.png){: width="600" height="500" }
