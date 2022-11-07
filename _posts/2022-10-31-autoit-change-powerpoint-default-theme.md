---
layout: post
title: AutoIT Change PowerPoint Default Theme
date: 2022-10-31 17:13 +0800
categories: [Other ,PowerPoint Theme]
tags: [AutoIT]
---
曾經遇到過要希望能讓全公司的人在使用PPT時,一打開PPT就有公司預設模板的問題
當時是使用AutoIT製作一個exe檔，
將公司的PPT模板放置在網路路徑上
然後透過這個Exe來Copy預設模板，並蓋掉User本機PPT預設模板
備註：須將檔案放置在 C:\Users\AppData\Roaming\Microsoft\Templates　　底下，且檔名需要改成blank.potx
<script>
      #Include <EditConstants.au3>
      #Include <GUIConstantsEx.au3>

      #Include "Copy.au3"

      Opt('MustDeclareVars', 1)
      Opt('TrayAutoPause', 0)

      Global $hForm, $Input1, $Input2, $Button1, $Button2, $Button3, $Button4, $Data, $Msg, $Path, $Progress, $State, $Copy = False, $Pause = False
      Global $Source = 'Source Path', $Destination = 'Target Path'

      If Not _Copy_OpenDll() Then
	      MsgBox(16, '', 'DLL not found.')
	      Exit
      EndIf

      $hForm = GUICreate('PPT模板更新',460, 163)
      GUICtrlCreateLabel('Source:', 14, 23, 58, 14)
      $Input1 = GUICtrlCreateInput($Source, 74, 20, 348, 19, BitOR($ES_AUTOHSCROLL, $ES_LEFT, $ES_MULTILINE))
      GUICtrlSetState(-1, $GUI_DISABLE)
      $Button1 = GUICtrlCreateButton('...', 426, 19, 21, 21)
      GUICtrlCreateLabel('Destination:', 14, 55, 58, 14)
      $Input2 = GUICtrlCreateInput($Destination, 74, 52, 348, 19, BitOR($ES_AUTOHSCROLL, $ES_LEFT, $ES_MULTILINE))
      GUICtrlSetState(-1, $GUI_DISABLE)
      $Button2 = GUICtrlCreateButton('...', 426, 51, 21, 21)
      $Progress = GUICtrlCreateProgress(14, 94, 432, 16)
      $Button3 = GUICtrlCreateButton('更新', 185, 126, 80, 21)
      $Button4 = GUICtrlCreateButton(';', 326, 126, 21, 21)
      GUICtrlSetFont(-1, 10, 400, 0, 'Webdings')
      GUICtrlSetState(-1, $GUI_DISABLE)
      GUISetState()

      While 1
	      If $Copy Then
		      $State = _Copy_GetState()
		      If $State[0] Then
			      $Data = Round($State[1] / $State[2] * 100)
			      If GUICtrlRead($Progress) <> $Data Then
				      GUICtrlSetData($Progress, $Data)
			      EndIf
		      Else
			      Switch $State[5]
				      Case 0
					      GUICtrlSetData($Progress, 100)
					      MsgBox(64, '', '更新成功', 0, $hForm)
				      Case 1235 ; ERROR_REQUEST_ABORTED
					      MsgBox(16, '', 'File copying was aborted.', 0, $hForm)
				      Case Else
					      MsgBox(16, '', '更新失敗' & @CR & @CR & $State[5], 0, $hForm)
			      EndSwitch
			      GUICtrlSetData($Progress, 0)
			      GUICtrlSetState($Button1, $GUI_ENABLE)
			      GUICtrlSetState($Button2, $GUI_ENABLE)
			      GUICtrlSetState($Button4, $GUI_DISABLE)
			      GUICtrlSetData($Button3, '更新')
			      GUICtrlSetData($Button4, ';')
			      $Copy = 0
		      EndIf
	      EndIf
	      $Msg = GUIGetMsg()
	      Switch $Msg
		      Case $GUI_EVENT_CLOSE
			      ExitLoop
		       Case $Button1
			      ;Run('Start "G:\Copy"', "", @SW_Hide));
			      ;$Path = FileOpenDialog('Select Source File', StringRegExpReplace($Source, '\\[^\\]*\Z', ''), 'All Files (*.*)', 3, StringRegExpReplace($Source, '^.*\\', ''), $hForm)
			      If $Path Then
				      GUICtrlSetData($Input1, $Path)
				      $Source = $Path
			      EndIf
		      Case $Button2
			      ;$Path = FileOpenDialog('Select Destination File', StringRegExpReplace($Destination, '\\[^\\]*\Z', ''), 'All Files (*.*)', 2, StringRegExpReplace($Source, '^.*\\', ''), $hForm)
			      If $Path Then
				      GUICtrlSetData($Input2, $Path)
				      $Destination = $Path
			      EndIf
		      Case $Button3
			      If $Copy Then
				      _Copy_Abort()
			      Else
				      If (Not $Source) Or (Not $Destination) Then
					      MsgBox(16, '', 'The source and destination file names must be specified.', 0, $hForm)
					      ContinueLoop
				      ;EndIf
				      ;If FileExists($Destination) Then
				      ;	If MsgBox(51, '', $Destination & ' already exists.' & @CR & @CR & 'Do you want to replace it?', 0, $hForm) <> 6 Then
				      ;		ContinueLoop
				      ;	EndIf
				      EndIf
				      GUICtrlSetState($Button1, $GUI_DISABLE)
				      GUICtrlSetState($Button2, $GUI_DISABLE)
				      GUICtrlSetState($Button4, $GUI_ENABLE)
				      GUICtrlSetData($Button3, '停止')
				      _Copy_CopyFile($Source, $Destination)
				      $Copy = 1
			      EndIf
		      Case $Button4
			      $Pause = Not $Pause
			      If $Pause Then
				      GUICtrlSetData($Button4, '4')
			      Else
				      GUICtrlSetData($Button4, ';')
			      EndIf
			      _Copy_Pause($Pause)
	      EndSwitch
      WEnd
