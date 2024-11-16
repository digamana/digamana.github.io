---
layout: post
title: 建立私人Nuget Server
date: 2024-11-16 23:02 +0800
---

## 前置條件

1.下載Nuget.exe
![Desktop View](/assets/img/2024-11-16-build-nuget-server/10.png){: width="400" height="300" }

2.把Nuget隨便丟到一個目錄底下 
![Desktop View](/assets/img/2024-11-16-build-nuget-server/11.png){: width="400" height="300" }

3.設定環境變數
以上圖來說 是丟到 C:/temp底下
所以將C:/temp設成環境變數

4.確認nuget這個指令能正常運作
```
nuget
```
如
![Desktop View](/assets/img/2024-11-16-build-nuget-server/12.png){: width="400" height="300" }
## 1.建立Nuget Server專案
![Desktop View](/assets/img/2024-11-16-build-nuget-server/1.png){: width="400" height="300" }
![Desktop View](/assets/img/2024-11-16-build-nuget-server/2.png){: width="400" height="300" }
![Desktop View](/assets/img/2024-11-16-build-nuget-server/3.png){: width="400" height="300" }
![Desktop View](/assets/img/2024-11-16-build-nuget-server/4.png){: width="400" height="300" }
![Desktop View](/assets/img/2024-11-16-build-nuget-server/5.png){: width="400" height="300" }
![Desktop View](/assets/img/2024-11-16-build-nuget-server/6.png){: width="400" height="300" }
![Desktop View](/assets/img/2024-11-16-build-nuget-server/7.png){: width="400" height="300" }
![Desktop View](/assets/img/2024-11-16-build-nuget-server/8.png){: width="400" height="300" }
## 2.建立建立範例DLL
![Desktop View](/assets/img/2024-11-16-build-nuget-server/9.png){: width="400" height="300" }


## 3.處理Dll與Nuget Server


1.手動建立副檔名為nuspec的文件
以範例DLL專案來說 該DLL專案叫做TestNugetLib
就建立一個TestNugetLib.nuspec
文件內容如下
```
<?xml version="1.0"?>
<package>
  <metadata>
    <id>TestNugetLib</id>
    <version>1.0.1</version>
    <authors>YourName</authors>
    <description>My custom library</description>
  </metadata>
  <files>
    <file src="bin/Debug/TestNugetLib.dll" target="lib/net48/" />
  </files>
</package>
```

建好後，開啟cmd或PowerShell，並導向到Dll專案的目錄底下 (與csproj同個目錄)
使用這個指令來產生 版號 + 附檔名為nupkg 的檔案
```
nuget pack TestNugetLib.nuspec -version 1.0.0
```
![Desktop View](/assets/img/2024-11-16-build-nuget-server/13.png){: width="400" height="300" }


使用PowerShell 打以下指令 建立檔名為sha512的檔案
```
$hash.Hash | Out-File -Encoding ASCII -NoNewline "TestNugetLib.1.0.0.nupkg.sha512"
$hash = Get-FileHash -Path "TestNugetLib.1.0.0.nupkg" -Algorithm SHA512
```
![Desktop View](/assets/img/2024-11-16-build-nuget-server/14.png){: width="400" height="300" }


到Nuget Server 發佈的網址上面
![Desktop View](/assets/img/2024-11-16-build-nuget-server/15.png){: width="400" height="300" }

在Packages這個資料夾裡面 建立要發佈的Nuget的名稱
![Desktop View](/assets/img/2024-11-16-build-nuget-server/16.png){: width="400" height="300" }

建立版號資料夾
![Desktop View](/assets/img/2024-11-17-build-nuget-server/17.png){: width="400" height="300" }

將剛剛提到的檔案丟到版號資料夾裡裡面
![Desktop View](/assets/img/2024-11-17-build-nuget-server/18.png){: width="400" height="300" }


## 3.一般User在

開啟工具->選項
![Desktop View](/assets/img/2024-11-17-build-nuget-server/19.png){: width="400" height="300" }


找到nuget設定相關的地方，自己在套件來源那邊新增
網址設定為Nuget Server的網址
![Desktop View](/assets/img/2024-11-17-build-nuget-server/20.png){: width="400" height="300" }

手動切換Nuget的來源
![Desktop View](/assets/img/2024-11-17-build-nuget-server/21.png){: width="400" height="300" }

這裡就能看到剛剛所設定的dll資料
![Desktop View](/assets/img/2024-11-17-build-nuget-server/22.png){: width="400" height="300" }

