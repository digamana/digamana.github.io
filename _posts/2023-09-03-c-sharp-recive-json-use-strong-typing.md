---
layout: post
title: C# 強型別解析JSON字串範例
date: 2023-09-03 11:17 +0800
---

## 前置步驟

<p>安裝Newtonsoft.Json</p>
![Desktop View](/assets/img/2023-09-03-c-sharp-recive-json-use-strong-typing/0.png){: width="800" height="600" }
<script  type='text/javascript' src=''>

    NuGet\Install-Package Newtonsoft.Json -Version 13.0.3

## 開始

<p>最初API或AJAX調用成功, 在C#下中斷點,應該可以看到類似下圖的樣子</p>
![Desktop View](/assets/img/2023-09-03-c-sharp-recive-json-use-strong-typing/1.png){: width="800" height="600" }

<p>進一步使用分析Json 格式會看到如下</p>
![Desktop View](/assets/img/2023-09-03-c-sharp-recive-json-use-strong-typing/2.png){: width="800" height="600" }

<p>這時候我們就可以開始根據Json 格式製作C#強型別存取Json的Class了</p>
解析的語法如下
<script  type='text/javascript' src=''>

    var settings = new JsonSerializerSettings
      {
          ContractResolver = new DefaultContractResolver
          {
              NamingStrategy = new SnakeCaseNamingStrategy() // 或其他策略，如 CamelCaseNamingStrategy
          }
      };
    JsonResponse mapsResponse = JsonConvert.DeserializeObject<JsonResponse>(response.Content, settings);//settings依情況而定,不一定要打



<p>其中JsonResponse裡面有強型別JSON結構</p>
如下
<script  type='text/javascript' src=''>

    public class JsonResponse
    {
        [JsonProperty("geocoded_waypoints")]
        public List<geocoded_waypoints> geocoded_waypoints { get; set; }
    }
    public class geocoded_waypoints
    {
        [JsonProperty("geocoder_status")]
        public string geocoder_status { get; set; }

        [JsonProperty("place_id")]
        public string place_id { get; set; }

        [JsonProperty("types")]
        public List<string> Types { get; set; }
    }

<p>要注意的是JsonProperty內容字串要與JSON一致</p>
![Desktop View](/assets/img/2023-09-03-c-sharp-recive-json-use-strong-typing/3.png){: width="800" height="600" }
<p>下中斷點會長這樣</p>
![Desktop View](/assets/img/2023-09-03-c-sharp-recive-json-use-strong-typing/4.png){: width="800" height="600" }


## JSON字串-假資料測試

### 方法1 自己打
模擬輸入假的JSON字串,以便進行測試
<script  type='text/javascript' src=''>

        /// <summary>
        /// 使用方式 var test = GetRootObject();
        /// </summary>
        public static RootObject GetRootObject()
        {
            var json = @"{
            ""geocoded_waypoints"": [
                {
                    ""geocoder_status"": ""OK"",
                    ""place_id"": ""ChIJB0guq-amQjQRg-Bq2akhxEU"",
                    ""types"": [
                        ""street_address""
                    ]
                },
                {
                    ""geocoder_status"": ""OK"",
                    ""partial_match"": true,
                    ""place_id"": ""ChIJS1h-WtOrQjQR8juhInQJddw"",
                    ""types"": [
                        ""establishment"",
                        ""point_of_interest"",
                        ""school"",
                        ""secondary_school""
                    ]
                }
            ]
        }";
            var settings = new JsonSerializerSettings
            {
                ContractResolver = new DefaultContractResolver
                {
                    NamingStrategy = new SnakeCaseNamingStrategy() // 或其他策略，如 CamelCaseNamingStrategy
                }
            };
            // 使用Newtonsoft.Json反序列化為物件
            var rootObject = JsonConvert.DeserializeObject<RootObject>(json, settings);
            return rootObject;
        }
        public class RootObject
        {
            public List<GeocodedWaypoint> GeocodedWaypoints { get; set; }
        }
        public class GeocodedWaypoint
        {
            public string GeocoderStatus { get; set; }
            public string PlaceId { get; set; }
            public List<string> Types { get; set; }
        }



![Desktop View](/assets/img/2023-09-03-c-sharp-recive-json-use-strong-typing/6.png){: width="800" height="600" }

### 方法2 給Json請GPT生成

ChatGPT範例指令
<script  type='text/javascript' src=''>

    示範如何在C# 模擬這個JSON輸入
    {
       "geocoded_waypoints" : 
       [
          {
             "geocoder_status" : "OK",
             "place_id" : "ChIJB0guq-amQjQRg-Bq2akhxEU",
             "types" : 
             [
                "street_address"
             ]
          },
          {
             "geocoder_status" : "OK",
             "partial_match" : true,
             "place_id" : "ChIJS1h-WtOrQjQR8juhInQJddw",
             "types" : 
             [
                "establishment",
                "point_of_interest",
                "school",
                "secondary_school"
             ]
          }
       ]
    }




## 備註

<p>如果JSON字串覺得都一樣,但不曉得是為什麼讀不到資料的時候</p>
<p>要考慮可能會有JSON英文大小寫在交握時自動變更的可能性,依情況調整成不同的策略</p>
![Desktop View](/assets/img/2023-09-03-c-sharp-recive-json-use-strong-typing/5.png){: width="800" height="600" }
<script  type='text/javascript' src=''>

    var settings = new JsonSerializerSettings
    {
        ContractResolver = new DefaultContractResolver
        {
            NamingStrategy = new SnakeCaseNamingStrategy() // 或其他策略，如 CamelCaseNamingStrategy
        }
    };

## 輸入API網址的方式

### 安裝套件

RestSharp
![Desktop View](/assets/img/2023-09-03-c-sharp-recive-json-use-strong-typing/7.png){: width="800" height="600" }
<script  type='text/javascript' src=''>

    NuGet\Install-Package RestSharp -Version 110.2.0


使用方式
<script  type='text/javascript' src=''>

    RestClient client = new RestClient("https://www.binance.com/api/v3/ticker/price");
    RestRequest request = new RestRequest();
    var settings = new JsonSerializerSettings
    {
        ContractResolver = new DefaultContractResolver
        {
            NamingStrategy = new SnakeCaseNamingStrategy() // 或其他策略，如 CamelCaseNamingStrategy
        }
    };
    RestResponse response = client.Execute(request);
    if (response.StatusCode == HttpStatusCode.OK)
    {
        var mapsResponse = JsonConvert.DeserializeObject<Price>(response.Content, settings);
 
    }
    
    public class Price
    {
        [JsonProperty("symbol")]
        public string symbol { get; set; }
        [JsonProperty("price")]
        public string price { get; set; }
    }
