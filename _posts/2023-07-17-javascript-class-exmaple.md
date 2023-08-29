---
layout: post
title: JavaScript Class Exmaple
date: 2023-07-17 23:02 +0800
---
# JavaScript 靜態工廠
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


# JavaScript 驗證與提示分離簡易架構

範例
<script  type='text/javascript' src=''>

      class RequireSave {
          constructor() { }
          /**建立輸入驗證 */
          static Creat()
          {
              return new RequireSave();
          }
          static Test() {
              const temp = RequireSave.Creat().Valid();
              if (temp['IsSuccess'] === false) alert(temp['Describe']);
          }
          /**一口氣驗證所有必填項目,是否都有填寫 */
          Valid() {
              let IsSuccess = true;
              let Describe = '';
              let Methods = [];
              Methods.push(this.MyDomItem);

              for (const method of Methods) {
                  const result = method();
                  if (result.IsSuccess === false) {
                      IsSuccess = false;
                      Describe += `${result.Describe} \n`;
                  }
              }
              return { 'IsSuccess': IsSuccess, 'Describe': Describe }
          }
          /*Vaild DOM ITEM*/
          MyDomItem() {
              let jqr = { 'IsSuccess': true, 'Describe': '' };
              const temp = $('#MyDomItem').val()
              if (temp === '') {
                  jqr = { 'IsSuccess': false, 'Describe': '警告' };
              }
              return jqr;
          }
      }
