---
layout: post
title: C# Read/Write Excel
date: 2022-11-27 22:11 +0800
---
## 前言
拿到了一份有作業上使用VBA Button Click的Excel，在其Click的商業邏輯之下，  
手動Click 1次要跑完至少要花費30秒  
所以想使用C#建立簡單的Winform模仿其商業邏輯來降低「需要多次Click情況」時的耗費時間  
以下我將測試期間使用過的Excel套件都封裝成一樣的Class，並記錄其特點  
以便我日後若有讀寫Excel的其他需求可以在這邊直接參考或Copy  


## Excel套件整理
### Microsoft.Office.Interop.Excel

![Desktop View](/assets/img/2022-11-27-c-sharp-read-excel/1.png){: width="800" height="600" }  
<script  type='text/javascript' src=''>

    NuGet\Install-Package Microsoft.Office.Interop.Excel -Version 15.0.4795.1001



特點
1.每次執行 xlApp.Workbooks.Open("FilePath") 都會真的開起檔案(非背景運行)  
2.需要額外使用Dispose來釋放記憶體  
3.運作效率明顯較其他套件來的慢  
4.帶有VBA的xls使用SavaAs Method結果失敗  
<script  type='text/javascript' src=''>

    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;
    using Excel = Microsoft.Office.Interop.Excel;
    namespace ReadExcel
    {
        internal class Program
        {
            static void Main(string[] args)
            {
                Excel.Application xlApp = new Excel.Application();
                Excel.Workbook xlWorkbook = xlApp.Workbooks.Open(@"xls File Path");
                Excel._Worksheet xlWorksheet = xlWorkbook.Sheets[1];
                Excel.Range xlRange = xlWorksheet.UsedRange;
                int rowCount = xlRange.Rows.Count;
                int colCount = xlRange.Columns.Count;

                //iterate over the rows and columns and print to the console as it appears in the file
                //excel is not zero based!!
                for (int i = 1; i <= rowCount; i++)
                {
                    for (int j = 1; j <= colCount; j++)
                    {
                        //new line
                        if (j == 1)
                            Console.Write("\r\n");

                        //write the value to the console
                        if (xlRange.Cells[i, j] != null && xlRange.Cells[i, j].Value2 != null)
                        {
                            var test = xlRange.Cells[i, j].Value2.ToString();
                            Console.Write(xlRange.Cells[i, j].Value2.ToString() + "\t");
                        }
                        
                    }
                }

                Excel excel = new Excel(@"C:\temp\VIS3_DEMO.xls", "ProdVIS4");
                int i = 3;
                int j = 3;
                if (excel.xlRange.Cells[i, j] != null && excel.xlRange.Cells[i, j].Value2 != null)
                {
                    var test = excel.xlRange.Cells[i, j].Value2.ToString();
                    Console.Write(excel.xlRange.Cells[i, j].Value2.ToString() + "\t");
                }

            }
        }
        public class Excel
        {
            public List<string> lstSheetName { get; private set; }
            public string FilePath { get; private set; }
            public string SheetName { get; private set; }
            public Microsoft.Office.Interop.Excel.Application xlApp { private set; get; }
            public Microsoft.Office.Interop.Excel.Workbook workbook { get; private set; }
            public Microsoft.Office.Interop.Excel.Sheets sheet { get; private set; }
            public Microsoft.Office.Interop.Excel.Range xlRange { private set; get; }
            public Microsoft.Office.Interop.Excel.Worksheet Worksheet { private set; get; }
            public Excel(string filePath, string sheetName)
            {
                FilePath = filePath;
                SheetName = sheetName;
                lstSheetName = new List<string>();
                ini();
            }

            public Microsoft.Office.Interop.Excel.Sheets SetSheet(string sheetName)
            {
                SheetName = sheetName;
                int iIndex = lstSheetName.IndexOf(sheetName);
                sheet = workbook.Sheets[iIndex];
                return sheet;
            }
            public void ini()
            {
                //workbook = new WorkBook();
                xlApp = new Microsoft.Office.Interop.Excel.Application();
                xlApp.Visible = false;
                workbook = xlApp.Workbooks.Open(FilePath);
                xlApp.Visible = false;

                foreach (Microsoft.Office.Interop.Excel.Worksheet wSheet in workbook.Worksheets)
                {
                    lstSheetName.Add(wSheet.Name);
                }
                int iIndex = lstSheetName.IndexOf(this.SheetName);
                Worksheet = (Microsoft.Office.Interop.Excel.Worksheet)workbook.Worksheets[iIndex];
                xlRange = Worksheet.UsedRange;
            }
            public void Dispose()
            {
                if (workbook != null) workbook.Close(false, System.Reflection.Missing.Value, System.Reflection.Missing.Value);
                if (xlApp != null) xlApp.Quit();
                GC.Collect();
                GC.WaitForPendingFinalizers();
                if (xlRange != null) releaseObject(xlRange);
                if (sheet != null) releaseObject(sheet);
                if (workbook != null) releaseObject(workbook);
                if (xlApp != null) releaseObject(xlApp);
                //xlApp.Quit();
            }
            private void releaseObject(object obj)
            {
                try
                {
                    System.Runtime.InteropServices.Marshal.ReleaseComObject(obj);
                    obj = null;
                }
                catch (Exception ex)
                {
                    obj = null;
                    MessageBox.Show("Unable to release the Object " + ex.ToString());
                }
                finally
                {
                    GC.Collect();
                }
            }
        }
    }


### IronXL
![Desktop View](/assets/img/2022-11-27-c-sharp-read-excel/2.png){: width="800" height="600" }  
<script  type='text/javascript' src=''>

    NuGet\Install-Package IronXL.Excel -Version 2022.11.10251


特點  
1.我不太確定License中提及的版本及使用Nuget直接載來的版本差在哪  
2.可以良好的讀寫透過Excel公式所產生的Value  
3.讀取「帶有VBA的xls」時，使用SavaAs Method結果失敗  
4.測試中出現過我無法成功Debug的Error  
<script  type='text/javascript' src=''>

    using IronXL;
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
              var result=excel.sheet["A3"].StringValue;
              Console.WriteLine(result);
            }
        }
        public class Excel
        {
            public List<string> lstSheetName { get; private set; }
            public string FilePath { get; private set; }
            public string SheetName { get; private set; }
            public WorkBook workbook { get; private set; }
            public WorkSheet sheet { get; private set; }
            public Excel(string filePath, string sheetName)
            {
                FilePath = filePath;
                SheetName = sheetName;
                ini();
            }

            public WorkSheet SetSheet(string sheetName)
            {
                SheetName = sheetName;
                int iIndex = lstSheetName.IndexOf(sheetName);
                sheet = workbook.WorkSheets[iIndex];
                return sheet;
            }
            public void ini()
            {
                workbook = WorkBook.Load(FilePath);
                lstSheetName = workbook.WorkSheets.Select(c => c.Name).ToList();
                int iIndex = lstSheetName.IndexOf(this.SheetName);
                sheet = workbook.WorkSheets[iIndex];
            }
        }
    }

### FreeSpire.XLS
![Desktop View](/assets/img/2022-11-27-c-sharp-read-excel/3.png){: width="800" height="600" }  
<script  type='text/javascript' src=''>

    NuGet\Install-Package FreeSpire.XLS -Version 12.7.0

特點  
1.由於FreeSpire.XLS是免費版，所以限制僅能讀取前200個Cell的內容  
由於FreeSpire.XLS是免費版，所以限制僅能讀取前200個Cell的內容    
以範例程式碼來說   
excel.sheet[1  , 3].Value 到 excel.sheet[200, 3].Value 會有資料  
excel.sheet[201, 3].Value 以後的資料為「""」  
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


### ExcelLibrary.SpreadSheet
![Desktop View](/assets/img/2022-11-27-c-sharp-read-excel/4.png){: width="800" height="600" }  
<script  type='text/javascript' src=''>

    NuGet\Install-Package ExcelLibrary -Version 1.2011.7.31




特點  
1.沒有內建Excel Insert的Method  
2.帶有VBA的xls使用SavaAs Method 成功  
3.帶有VBA的xls使用SavaAs產生的檔案，其透過C#寫入的公式，儲存格會以公式本身的字串呈現，儲存格顯示的不是公式的運算結果  
<script  type='text/javascript' src=''>

    using ExcelLibrary.SpreadSheet;
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Text;
    using System.Threading;
    using System.Threading.Tasks;

    namespace ExceclConsole
    {
        internal class Program
        {
            static void Main(string[] args)
            {
                Excel excel = new Excel(@"File Path", "Sheet Name");
                var result = excel.sheet.Cells[3, 3].Value;
                Console.WriteLine(result);

            }
        }
        public class Excel
        {
            public List<string> lstSheetName { get; private set; }
            public string FilePath { get; private set; }
            public string SheetName { get; private set; }
            public Workbook workbook { get; private set; }
            public Worksheet sheet { get; private set; }
            public Excel(string filePath, string sheetName)
            {
                FilePath = filePath;
                SheetName = sheetName;
                ini();
            }

            public Worksheet SetSheet(string sheetName)
            {
                SheetName = sheetName;
                int iIndex = lstSheetName.IndexOf(sheetName);
                sheet = workbook.Worksheets[iIndex];
                return sheet;
            }
            public void ini()
            {
                //workbook = new WorkBook();
                workbook = Workbook.Load(FilePath);
                lstSheetName = workbook.Worksheets.Select(c => c.Name).ToList();
                int iIndex = lstSheetName.IndexOf(this.SheetName);
                sheet = workbook.Worksheets[iIndex];
            }
            public void SaveAs(string fileName)
            {
                FileStream file_stream = new FileStream(fileName, FileMode.Create);
                workbook.SaveToStream(file_stream);
                file_stream.Close();
            }
        }
    }

### Epplus
![Desktop View](/assets/img/2022-11-27-c-sharp-read-excel/5.png){: width="800" height="600" }  
<script  type='text/javascript' src=''>

    NuGet\Install-Package EPPlus -Version 4.5.3.3


特點  
1.不支援xls  
2.「EPPlus 4.5.3.3」之前的版本可以免費使用,後面的版本要錢  
備註  
1.由於我需要讀取「帶有VBA的xls」所以我參考了[這個](https://igouist.github.io/post/2020/04/epplus/)  
先透過Microsoft.Office.Interop.Excel轉檔成Xlsx，在進行讀寫  
2.為了解決轉檔時，另存新檔會跑出詢問畫面的問題
我參考了[這裡](https://social.msdn.microsoft.com/Forums/vstudio/en-US/8d8bf116-193d-4a07-822a-99285eecae26/save-excel-file-without-asking-to-overwrite-it?forum=csharpgeneral)
<script  type='text/javascript' src=''>

    using OfficeOpenXml;
    using System.IO;

    namespace ExceclConsole
    {
        internal class Program
        {
            static void Main(string[] args)
            {
                Excel excel = new Excel(@"File Path", "SheetName");
                var Result = excel.sheet.Cells[3, 3].Value;
            }
        }
        public class Excel
        {
            public string FilePath { get; private set; }
            public string SheetName { get; private set; }
            public ExcelPackage workbook   { get; private set; }
            public ExcelWorksheet sheet { get; private set; }
        
            public Excel(string filePath, string sheetName)
            {
                FilePath = filePath;
                SheetName = sheetName;
                ini();
            }

            public ExcelWorksheet SetSheet(string sheetName)
            {
                sheet = workbook.Workbook.Worksheets[sheetName]; // 可以使用頁籤名稱
                return sheet;
            }
            public void ini()
            {
                workbook = new ExcelPackage(new FileInfo(FilePath));
                sheet =workbook.Workbook.Worksheets[SheetName];
            }
            public void Dispose() 
            {
                workbook.Dispose();
                sheet.Dispose();
            }
        }
    }

 

## 其他套件
### SpreadsheetLight
特點  
1.非Open Source 所以Google資料偏少  
2.由於我光是讀取「帶有VBA的xls」就失敗了，然後就沒有然後了  


## GitHub  
[https://github.com/digamana/ExceclRepo.git](https://github.com/digamana/ExceclRepo.git)
