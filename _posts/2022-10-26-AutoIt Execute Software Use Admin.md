---
layout: post
title: AutoIt Execute Software Use Admin
date: 2022-10-26 15:38 +0800
categories: [Windows ,AutoIT]
tags: [AutoIT]

---
## 使用最高權限開啟指定檔案
詳見以下Source Code
<script  type='text/javascript' src=''>

      #include <MsgBoxConstants.au3>
      #include <WinAPIFiles.au3>

      Example()

      Func Example()
          ; Create a constant variable in Local scope of the filepath that will be read/written to.
          Local Const $sFilePath = _WinAPI_GetTempFileName(@TempDir)

          Local $iFileExists = ("用來確認是否安裝完畢的檔案位置")
          Local $SetupFilePath ="安裝檔路徑"

          ; Display a message of whether the file exists or not.
          If  FileExists($iFileExists) Then
              MsgBox($MB_SYSTEMMODAL, "", "Teams已安裝")
         Else
		      If FileExists($SetupFilePath) Then
		         MsgBox($MB_SYSTEMMODAL, "", "安裝檔位置：存在");

			      If IsAdmin() Then
			         MsgBox($MB_SYSTEMMODAL, "", "如果是最高權限");
			         Run($SetupFilePath )
			      Else
			         MsgBox($MB_SYSTEMMODAL, "", "不是最高權限的安裝");
			         RunAs ("帳號","網域", "密碼",0,$SetupFilePath)
			      EndIf

		      Else
		         MsgBox($MB_SYSTEMMODAL, "", "安裝檔位置：不存在");
	           EndIf

          EndIf

      EndFunc   ;==>Example



## 可以搭配的技術
- [AutoIT加密與解密]({{ site.baseurl }}{% link _posts/2022-11-03-autoit-decrypt-and-encryption.md %})
- [C# 軟體自動化，使用套件AutoItX]({{ site.baseurl }}{% link _posts/2022-10-26-C-Sharp Software automation Use AutoIt.md %})
