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


# 泛用格式
## 後端回傳泛用格式
範例
<script  type='text/javascript' src=''>


    public class Response
    {
        /// <summary>
        /// 要回傳給前端進行驗證的陣列
        /// </summary>
        public IEnumerable<dynamic> Model { get; private set; }
        /// <summary>
        /// 回傳驗證是否成功
        /// </summary>
        public bool IsSuccess { get; private set; }

        /// <summary>
        /// 回傳驗證失敗時,要給前端看的資料
        /// </summary>
        public string Describe { get; private set; }

        /// <summary>
        /// 為了方便控管 禁止直接使用 new Response()建立物件
        /// </summary>
        /// <param name="_IsSuccess"></param>
        /// <param name="_Describe"></param>
        private Response(bool _IsSuccess, string _Describe = null)
        {
            IsSuccess = _IsSuccess;
            Describe = _Describe; // 驗證失敗時 請一定要描述失敗內容
        }
        /// <summary>
        /// 不直接使用 new Response 是因為會不好掌握哪邊有寫回傳 以及為了方便檢閱驗證結果
        /// </summary>
        /// <param name="_IsSuccess"></param>
        /// <param name="_Describe"></param>
        /// <returns></returns>
        public string ErrCode { get; private set; }

        /// <summary>
        /// 建立回傳物件
        /// <para> _IsSuccess : 是否成功 </para>
        /// <para> _Describe  : 事件描述 </para>
        /// </summary>
        /// <param name="_IsSuccess">是否成功</param>
        /// <param name="_Describe">事件描述</param>
        /// <returns></returns>
        public static Response Creat(bool _IsSuccess, string _Describe = null)
        {
            return new Response(_IsSuccess, _Describe);
        }
        /// <summary>
        /// 只有"最後"要將資料傳回前端時,才會用到這段 , 以下為Method內容
        /// <para>string JS = JsonConvert.SerializeObject(this);</para>
        /// <para>object[] objArray = new object[] { 0, JS };</para>
        /// <para>return objArray;</para>
        /// </summary>
        /// <returns></returns>
        public object[] Run()
        {
            string JS = JsonConvert.SerializeObject(this);
            object[] objArray = new object[] { 0, JS };
            return objArray;
        }
        /// <summary>
        /// 設定要回傳給前端進行驗證的List
        /// </summary>
        /// <param name="_Model"></param>
        /// <returns></returns>
        public Response SetModel(IEnumerable<dynamic> _Model)
        {
            Model = _Model;
            return this;
        }
        /// <summary>
        /// 設定錯誤代碼
        /// </summary>
        /// <param name="_ErrCode"></param>
        /// <returns></returns>
        public Response SetErrCode(string _ErrCode)
        {
            ErrCode = _ErrCode;
            return this;
        }
    }

## 搭配上面,泛用接收格式

範例
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
                resultData['IsSuccess'] = false;
                resultData['Describe'] = e.status;
            },
            success: function (data) {
                resultData = JSON.parse(data);
            }
        });
        return resultData;
        }
