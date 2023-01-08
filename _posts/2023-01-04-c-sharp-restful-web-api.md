---
layout: post
title: (尚未整理) C# RestFul Web Api
date: 2023-01-04 23:36 +0800
published: false 
---
## 前言
<p>這邊紀錄一下我學到的RestFul Web Api的基本技巧與知識</p>

## 建立專案

## 建立新的Controller
### 設定ApiController
### 設定Route
### 設定Post/Get
</p>備註:整理時注意<p>
先用下面這種方式DEMO資料表的資料內容,然後寫 httpGet/httpPost/httpDelete/httpPatch使用上的範例寫法
<script  type='text/javascript' src=''>

    public static class CompanyStore
    {
        public static List<Company> CompanyList = new List<Company>
        {
            new Company{id=1,Name="TW",Description="100" },
            new Company{id=2,Name="US",Description="100" }
        };
    }
<p>接著在演示 DTO and AutoMapper ->所有串接改成異步方法  -> 實際串接資料庫 -> 建立API Request </p>

設定Post的方式
<script  type='text/javascript' src=''>

    [HttpPost]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public ActionResult<Company> CreatCompany([FromBody] Company company)
    { 
        if(company == null) { return BadRequest(); }
        if (company.id > 0) return StatusCode(StatusCodes.Status500InternalServerError);
        return Ok(company);
    }

<p>待學習FromBody的用途</p>
<p>參考網站</p>
[https://www.cnblogs.com/ypyp123/p/16198778.html](https://www.cnblogs.com/ypyp123/p/16198778.html)
[https://blog.csdn.net/dawfwafaew/article/details/123753114](https://blog.csdn.net/dawfwafaew/article/details/123753114)
[https://blog.csdn.net/weixin_52437470/article/details/113726646](https://blog.csdn.net/weixin_52437470/article/details/113726646)

### Post驗證資料的方式
<p>首先在Model上面進行描述,例如限制一定要輸入就用Request,限制資料長度就用MaxLength</p>
![Desktop View](/assets/img/2023-01-04-c-sharp-restful-web-api/001.png){: width="600" height="500" }
<p>然後再Controller 使用ModelState.IsValid進行驗證</p>
<p>備註Controller有加上ApiController的描述會自動進行驗證,否則得用ModelState.IsValid觸發驗證</p>
![Desktop View](/assets/img/2023-01-04-c-sharp-restful-web-api/002.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    if (!ModelState.IsValid)
    {
        return BadRequest();
    }

<p>待補上:使用Post 底下CreatedAtRoute的使用方法</p>
<p>待補上: [ProducesResponseType(StatusCodes.Status201Created)]的使用方法</p>

### ProducesResponseType的用法

<p>ProducesResponseType打的是這個Request要給使用者看得可能返回的Status Code</p>
![Desktop View](/assets/img/2023-01-04-c-sharp-restful-web-api/004.png){: width="600" height="500" }
### 刪除資料的http
<p>備註1:刪除資料的時候可以用HttpDelete</p>
<p>備註2:因為刪除資料後不想返回任何資訊,可以用IActionResult與NoContent</p>
![Desktop View](/assets/img/2023-01-04-c-sharp-restful-web-api/003.png){: width="600" height="500" }

### 更新資料的http -httpPut
<p>使用httpPut可以紀錄完整的更新資訊</p>
![Desktop View](/assets/img/2023-01-04-c-sharp-restful-web-api/005.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    [HttpPut("{Num:int}", Name = "UpdateCompany")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public IActionResult UpadteCompany(int Num,[FromBody]Company company )
    {
        if(company==null || Num!=company.id) return BadRequest();
        //更新資料庫的商業邏輯
        var tempBU = CompanyStore.CompanyList.FirstOrDefault(c => c.id == Num);
        tempBU.Name= company.Name;
        tempBU.Description= company.Description;
        return NoContent();
    }



### 更新資料的http -Patch
<p>使用httpPatch只更新完整資料表中的其中一個欄位的資料</p>
使用JsonPath
<script  type='text/javascript' src=''>

    NuGet\Install-Package JsonPath.Net -Version 0.3.1

以及Mvc.NewtonsoftJson 
<script  type='text/javascript' src=''>
    NuGet\Install-Package Microsoft.AspNetCore.Mvc.NewtonsoftJson -Version 7.0.1


<p>啟動時追加AddNewtonsoftJson</p>
![Desktop View](/assets/img/2023-01-04-c-sharp-restful-web-api/006.png){: width="600" height="500" }
<p>實際調用Patch的方式</p>
![Desktop View](/assets/img/2023-01-04-c-sharp-restful-web-api/007.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    [HttpPut("{Num:int}", Name = "PatchCompany")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public IActionResult UpadteByJsonPatchCompany(int Num, JsonPatchDocument<Company> PatchCompany)
    {
        if (PatchCompany==null || Num==0) return BadRequest();
        var tempBU = CompanyStore.CompanyList.FirstOrDefault(c => c.id == Num);
        PatchCompany.ApplyTo(tempBU, ModelState);
        if (!ModelState.IsValid) return BadRequest(ModelState);

        return NoContent();
    }



### 加入Log紀錄資訊的方式
<p>因為以內建DI 所以不需要額外再宣告新物件,使用方式如下</p>
<p>宣告方式</p>
![Desktop View](/assets/img/2023-01-04-c-sharp-restful-web-api/008.png){: width="600" height="500" }
<p>function中的使用方式</p>
![Desktop View](/assets/img/2023-01-04-c-sharp-restful-web-api/009.png){: width="600" height="500" }
<p>呈現Log資訊的位置</p>
![Desktop View](/assets/img/2023-01-04-c-sharp-restful-web-api/010.png){: width="600" height="500" }

### 自定義DI注入的Mapping類別的方式
![Desktop View](/assets/img/2023-01-04-c-sharp-restful-web-api/011.png){: width="600" height="500" }

### 實體框架注入ConnectString的方式
<p>.NET Core 與 .Net Framework不同,無法使用ADO.NET 快速建立已存在的資料庫模型,替代方案詳見以下網址參考</p>
[https://stackoverflow.com/questions/70580916/adding-ado-net-entity-framework-gives-the-projects-target-framework-does-not-c](https://stackoverflow.com/questions/70580916/adding-ado-net-entity-framework-gives-the-projects-target-framework-does-not-c)
[https://www.entityframeworktutorial.net/efcore/create-model-for-existing-database-in-ef-core.aspx](https://www.entityframeworktutorial.net/efcore/create-model-for-existing-database-in-ef-core.aspx)

### 自定義API的Request狀態
<p>當使用Get/Post之後,總不可能每次都不告知Request是否正常</p>
<p>首先建立新的Class 用來儲存API Request</p>
<p>Class可以長這樣</p>
![Desktop View](/assets/img/2023-01-04-c-sharp-restful-web-api/012.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    public class ApiRequest
    {
        public HttpStatusCode HttpStatusCode { get; set; }
        public bool IsSuccess { get; set; }
        public IEnumerable<string> ErrMessage { get; set; }
        public object Result { get; set; }
    }


### .Net專案正確的Call API架構

<p>首先需要在.NET網頁專案的JSON中,定義要使用的API的網址</p>
![Desktop View](/assets/img/2023-01-04-c-sharp-restful-web-api/013.png){: width="600" height="500" }
<p>在.NET網頁專案也建立一個用來記錄API狀態Response跟Request的Class</p>
![Desktop View](/assets/img/2023-01-04-c-sharp-restful-web-api/014.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-04-c-sharp-restful-web-api/015.png){: width="600" height="500" }

<p>開始建立Call API的底層架構</p>
<p>先建立Services資料夾,結構長這樣</p>
![Desktop View](/assets/img/2023-01-04-c-sharp-restful-web-api/016.png){: width="600" height="500" }
IBaseService.cs
<script  type='text/javascript' src=''>

    public interface IBaseService
    {
        ApiRequest apiRequest { get; set; }
        Task<T> SendAsync<T> (ApiRequest apiRequest);
    }

BaseService.cs
<script  type='text/javascript' src=''>

    using Newtonsoft.Json;
    using System.Text;
    using WebApplication2.Model;
    using WebApplication2.Services.IServices;

    namespace WebApplication2.Services
    {
        public class BaseService : IBaseService
        {
   
            public ApiRequest apiRequest {get; set ; }
            public IHttpClientFactory httpClient { get; set; }

            public BaseService(IHttpClientFactory httpClient) 
            { 
                this.apiRequest = new ApiRequest();
                this.httpClient = httpClient;
            }

            public async Task<T> SendAsync<T>(ApiRequest apiRequest)
            {
                try
                {
                    var client = httpClient.CreateClient("");
                    HttpRequestMessage message = new HttpRequestMessage();
                    message.Headers.Add("Accept", "application/json");
                    message.RequestUri = new Uri(apiRequest.Url);
                    if (apiRequest.Data != null)
                    {
                        message.Content = new StringContent(JsonConvert.SerializeObject(apiRequest.Data), Encoding.UTF8, "application/json");
                    }
                    switch (apiRequest.ApiType)
                    {
                        case ApiType.Get:
                            message.Method=HttpMethod.Get;
                            break;
                        case ApiType.Post:
                            message.Method = HttpMethod.Post;
                            break;
                        case ApiType.Put:
                            message.Method = HttpMethod.Put;
                            break;
                        case ApiType.Delete:
                            message.Method = HttpMethod.Delete;
                            break;
                    }
                    HttpResponseMessage apiResponse = null;
                    apiResponse =await client.SendAsync(message);   
                    var apiContent = await apiResponse.Content.ReadAsStringAsync();
                    var APIResponse = JsonConvert.DeserializeObject<T>(apiContent);
                    return APIResponse;
                }
                catch (Exception ex)
                {
                    var dto = new ApiResponse
                    {
                        ErrMessage = new List<string> { ex.Message.ToString() },
                        IsSuccess = false
                    };
                    var res= JsonConvert.SerializeObject(dto);
                    var APIResponse= JsonConvert.DeserializeObject<T>(res);
                    return APIResponse;
                }
            }
        }
    }



### Method參數用法
