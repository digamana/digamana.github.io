---
layout: post
title: 變更PPT預設模板
date: 2022-12-01 20:39 +0800
---

## 前言

## 原理
將範本檔命名為blank.potx  
貼到C:\Users\User\AppData\Roaming\Microsoft\Templates 底下  
就能取代原本的空白PPT主題
![Desktop View](/assets/img/2022-12-01-side-project-change-ppt-default-topic/1.png){: width="800" height="600" }
![Desktop View](/assets/img/2022-12-01-side-project-change-ppt-default-topic/2.png){: width="800" height="600" }  
## 範例程式
安裝套件KnownFolders
<script  type='text/javascript' src=''>

    NuGet\Install-Package Syroot.Windows.IO.KnownFolders -Version 1.2.3


將上面的原理,以C#做成小程式來執行
只要blank.potx放在網路空間，然後把執行檔發佈給底下User，執行時就會自動將blank.potx複製到本機的Templates 底下了
<script  type='text/javascript' src=''>

    using System;
    using System.Diagnostics;
    using System.IO;

    namespace pptSetTemplete
    {
        class Program
        {
            public static readonly string RoamingAppData = new Syroot.Windows.IO.KnownFolder(Syroot.Windows.IO.KnownFolderType.RoamingAppData).Path;
            static void Main(string[] args)
            {
                string fileName = "blank.potx";
                string sourcePath = @"「blank.potx」's File Path";
                string targetPath = Path.Combine(RoamingAppData, "Microsoft", "Templates"); ;
                Process.Start(targetPath);
                // Use Path class to manipulate file and directory paths.
                string sourceFile = System.IO.Path.Combine(sourcePath, fileName);
                string destFile = System.IO.Path.Combine(targetPath, fileName);

                Console.WriteLine($"PPT模板存放路徑：{sourceFile}");
                Console.WriteLine($"PPT模板安裝路徑：{destFile}");
                if (File.Exists(sourcePath) == false)
                {
                    Console.WriteLine($"PPT預設模板的安裝失敗：找不到{sourceFile}");
                    Console.ReadKey();
                    return;
                }
                Console.WriteLine("安裝預設中 請稍後 1.2分鐘");
                System.IO.Directory.CreateDirectory(targetPath);
                System.IO.File.Copy(sourceFile, destFile, true);
                if (System.IO.Directory.Exists(sourcePath))
                {
                    string[] files = System.IO.Directory.GetFiles(sourcePath);
                    foreach (string s in files)
                    {
                        fileName = System.IO.Path.GetFileName(s);
                        destFile = System.IO.Path.Combine(targetPath, fileName);
                        System.IO.File.Copy(s, destFile, true);
                    }
                }
                else
                {
                    Console.WriteLine("Source path does not exist!");
                }
                Console.WriteLine("安裝完成 請關閉視窗");
                Console.ReadKey();
            }
        }
    }

## GitHub
