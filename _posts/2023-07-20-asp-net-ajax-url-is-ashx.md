---
layout: post
title: ASP.NET Ajax URL is ashx
date: 2023-07-20 23:04 +0800
---

# 前言

# 開始

## AJAX的URL設定
![Desktop View](/assets/img/2023-07-20-asp-net-ajax-url-is-ashx/1.png){: width="600" height="500" }
## AJAX的參數傳遞設定
![Desktop View](/assets/img/2023-07-20-asp-net-ajax-url-is-ashx/2.png){: width="600" height="500" }
## AJAX的接收回傳設定
<p>這邊重點是在經過JSON.parse(data)的解碼後,就能在中斷點上看到JSON了</p>
![Desktop View](/assets/img/2023-07-20-asp-net-ajax-url-is-ashx/3.png){: width="600" height="500" }
## 後端使用強型別撰寫
![Desktop View](/assets/img/2023-07-20-asp-net-ajax-url-is-ashx/4.png){: width="600" height="500" }
# 示範
範例C# Code
<script  type='text/javascript' src=''>

     public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            ProcessAjax(context);
        }
        private void ProcessAjax(HttpContext context)
        {
            var methodName = context.Request.Form["Rounter"];
            //輸出method
            var parameters = context.Request.Form["parameters"];
            //輸出jreq
            var value = SentTest();
            var jsonResult = JsonConvert.SerializeObject(value[1]);
            var output = jsonResult.ToString();

            context.Response.ContentType = "text/plain";
            context.Response.Write(output);
        }
        private object[] SentTest()
        {
            JObject jResult = new JObject();
            JObject ExtraResult = new JObject();// ResponseContent 裡的JSON
            ExtraResult["Demo"] = "Happy";
            ExtraResult["Work"] = "Cat";
            jResult.Add("ErrCode", "0");
            jResult.Add("Description", "");
            jResult.Add("Extra", ExtraResult);
            return new object[] { 0, jResult.ToString() };
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }



範例JavaScript Code
<script  type='text/javascript' src=''>

      function Demo() {
            var jreq = {
                FirstArgu: 'ssss',
                SecArgu: 'ddd',
            }
            jreq = JSON.stringify(jreq);
            jreq = encodeURIComponent(jreq);
            let resultData = null;
            $.ajax({
                type: "POST",
                url: '../Controllers/Handler1.ashx?',
                data: "Rounter=method&parameters=" + jreq,
                async: false,
                timeout: 3000, //超時時間：3秒
                error: function (e) {
                    alert("time out " + e.status);
                },
                success: function (data) {
                    resultData = JSON.parse(data);
                    if (resultData["description"] == "") {
                        resultData = resultData.ResponseContent;
                    }
                    else {
                        alert(resultData["description"]);
                        resultData = null;
                    }
                }
            });
            return resultData;
        }
