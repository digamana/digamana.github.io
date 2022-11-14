---
layout: post
title: AutoIT Decrypt And Encryption
date: 2022-11-03 00:10 +0800
categories: [Other ,AutoIT]
---

AutoIT的加密 與 解密

加密
<script  type='text/javascript' src=''>

      #include <Crypt.au3>           ;  
      #include <MsgBoxConstants.au3> ; 

      $sSourceData = "Yyds2241" ; 待加密資料
      $sKey = "iamisakey"         ; 加密用的 key
      $algorithm = $CALG_RC4      ; 
      $bEecrypted = _Crypt_EncryptData($sSourceData, $sKey, $algorithm);開始加密

      MsgBox($MB_SYSTEMMODAL, 'Binary Eecrypted', $bEecrypted);

      ClipPut( $bEecrypted) ;使用複製指令取得加密後的字串


解密
<script  type='text/javascript' src=''>

    #include <Crypt.au3>           ;  
    #include <MsgBoxConstants.au3> ; 
    $sKey = "iamisakey"         ; 加密關鍵字
    $algorithm = $CALG_RC4      ;  

 

    Func Decrypt($bEecrypted )
    ;MsgBox($MB_SYSTEMMODAL, '開始解密', $bEecrypted)
    $bDecrypted = _Crypt_DecryptData($bEecrypted, $sKey, $algorithm);開始解密
    Return  BinaryToString($bDecrypted);獲得解密後的資料
    EndFunc   ;==>Test_Numparams


## 可以搭配的技術
- [軟體自動化]({{ site.baseurl }}{% link _posts/2022-10-26-AutoIt Execute Software Use Admin.md %})
