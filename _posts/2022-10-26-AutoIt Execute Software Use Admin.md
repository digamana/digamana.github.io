---
layout: post
title: 2022-10-26-AutoIt Execute Software Use Admin
date: 2022-10-26 15:38 +0800
categories: [Windows ,AutoIT]
tags: [AutoIT]

---
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
