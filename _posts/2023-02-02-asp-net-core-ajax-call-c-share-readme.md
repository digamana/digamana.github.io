---
layout: post
title: ASP.NET Core 使用 ajax 呼叫 C# Method的注意須知
date: 2023-02-02 18:29 +0800
---

##
## 問題點
<p>我從ASP.NET Framework轉到ASP.NET CORE時,使用datatables時</p>
<p>語法都一樣,但是在ASP.NET Framework可以成功,在ASP.NET CORE</p>
![Desktop View](/assets/img/2023-02-02-asp-net-core-ajax-call-c-share-readme/1.png){: width="600" height="500" }

<p>後續測試時發現,把要使用Json傳遞的參數名稱,改成全小寫,或是只有開頭大小,能順利取得資料</p>
<p>從這點推測出,可能的問題點與與命名方式有關</p>
![Desktop View](/assets/img/2023-02-02-asp-net-core-ajax-call-c-share-readme/2.png){: width="600" height="500" }
### 解決方式
<p>結論是加入下列資料</p>
<p>安裝Microsoft.AspNetCore.Mvc.NewtonsoftJson</p>
![Desktop View](/assets/img/2023-02-02-asp-net-core-ajax-call-c-share-readme/3.png){: width="600" height="500" }
 <script  type='text/javascript' src=''>

    NuGet\Install-Package Microsoft.AspNetCore.Mvc.NewtonsoftJson -Version 7.0.2


<p>改變命名設定</p>
![Desktop View](/assets/img/2023-02-02-asp-net-core-ajax-call-c-share-readme/4.png){: width="600" height="500" }
 <script  type='text/javascript' src=''>

    builder.Services.AddControllers()
            .AddJsonOptions(options => options.JsonSerializerOptions.PropertyNamingPolicy = null);
    builder.Services.AddMvc()
            .AddJsonOptions(options => options.JsonSerializerOptions.PropertyNamingPolicy = null);
    builder.Services.AddRazorPages()
            .AddJsonOptions(options => options.JsonSerializerOptions.PropertyNamingPolicy = null);




### 解決方式參考至此
[https://aska22.medium.com/howto-net-core-3-1-%E5%8F%96%E6%B6%88%E5%8F%83%E6%95%B8%E5%B0%8F%E9%A7%9D%E5%B3%B0%E8%BD%89%E6%8F%9B%E8%A8%AD%E5%AE%9A-552994751632](https://aska22.medium.com/howto-net-core-3-1-%E5%8F%96%E6%B6%88%E5%8F%83%E6%95%B8%E5%B0%8F%E9%A7%9D%E5%B3%B0%E8%BD%89%E6%8F%9B%E8%A8%AD%E5%AE%9A-552994751632)
