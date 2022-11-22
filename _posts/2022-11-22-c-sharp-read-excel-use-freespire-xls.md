---
layout: post
title: C-Sharp Read Excel use freespire.xls
date: 2022-11-22 23:55 +0800
---

# 安裝套件FreeSpire.XLS
!!!注意!!!
由於FreeSpire.XLS是免費版，所以限制僅能讀取前200個Cell的內容  
以範例程式碼來說  
excel.sheet[1  , 3].Value 到 excel.sheet[200, 3].Value 會有資料  
excel.sheet[201, 3].Value 以後的資料為「""」  
![Desktop View](/assets/img/2022-11-22-c-sharp-read-excel-use-microsoft-office-interop-excel/1.png){: width="800" height="600" }  
<script  type='text/javascript' src=''>

    NuGet\Install-Package FreeSpire.XLS -Version 12.7.0




Hello World
<script  type='text/javascript' src=''>

    using Spire.Xls;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;
    namespace ReadExcel
    {
        internal class Program
        {
            static void Main(string[] args)
            {
              //初始化時，設定要讀取的Excel路徑跟工作表名稱
              Excel excel = new Excel(@"File Path", "SheetName");

              //設定要讀取的儲存格
              var Cell_Value=excel.sheet[3, 3].Value;

              //使用SetSheet("SheetName")可以變更讀取的工作表
              //SetSheet("SheetName")
              Console.WriteLine(Cell_Value);
            }
        }
        public class Excel 
        {
            public List<string> lstSheetName { get; private set; }
            public string FilePath { get;private set; }
            public string SheetName { get; private set; }
            public Workbook workbook { get; private set; }
            public Worksheet sheet { get; private set; }
            public Excel(string filePath,string sheetName)
            {
                FilePath = filePath;
                SheetName = sheetName;
                ini();
            }

            public Worksheet SetSheet(string sheetName)
            {
                int iIndex = lstSheetName.IndexOf(sheetName);
                sheet = workbook.Worksheets[iIndex];
                return sheet;
            }
            public void ini()
            {
                workbook = new Workbook(); 
                workbook.LoadFromFile(FilePath);
                lstSheetName = workbook.Worksheets.Select(c => c.Name).ToList();
                int iIndex = lstSheetName.IndexOf(this.SheetName);
                 sheet = workbook.Worksheets[iIndex];
            }
        }
    }
