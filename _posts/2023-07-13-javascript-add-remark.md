---
layout: post
title: JavaScript程式碼新增註解與參考Method的方式
date: 2023-07-13 00:45 +0800
---
# 示範

## 註解
![Desktop View](/assets/img/2023-07-13-javascript-add-remark/1.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    /**
     * 測試1
     * 測試2
     * @param {any} demo1 demo1參數的註解
     * @param {any} demo2 demo2參數的註解
     */
    function functionName(demo1, demo2)
    {
    }


## 參考Method
JS最上層輸入如下,輸入reference path才能有效找到JS Method的引用位置
<script  type='text/javascript' src=''>

    /// <reference path="My_JS_File_Path" />
