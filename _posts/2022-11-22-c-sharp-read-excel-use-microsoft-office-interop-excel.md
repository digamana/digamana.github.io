---
layout: post
title: C-Sharp Read Excel use Microsoft.Office.Interop.Excel
date: 2022-11-22 23:26 +0800
---

# 安裝套件Microsoft.Office.Interop.Excel  
![Desktop View](/assets/img/2022-11-22-c-sharp-read-excel-use-microsoft-office-interop-excel/1.png){: width="800" height="600" }  
<script  type='text/javascript' src=''>

    NuGet\Install-Package Microsoft.Office.Interop.Excel -Version 15.0.4795.1001



Hello World
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

            }
        }
    }
