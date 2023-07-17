---
layout: post
title: JavaScript Class Exmaple
date: 2023-07-17 23:02 +0800
---

<p>附圖為C#與JavaScript使用Class的等效語法</p>
![Desktop View](/assets/img/2023-07-17-javascript-class-exmaple/1.png){: width="600" height="500" }
範例
<script  type='text/javascript' src=''>

    class RequestDemo {
        constructor(TableName, ActionName) {
            this.tableName = TableName;
            this.ActionName = ActionName;
        }
        static Creat(TableName, ActionName) {
            return new RequestDemo(TableName, ActionName);
        }
        Run() {
            console.log(this.tableName, this.ActionName);
        }
    }
