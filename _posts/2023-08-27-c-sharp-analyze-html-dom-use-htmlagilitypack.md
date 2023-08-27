---
layout: post
title: C#使用HtmlAgilityPack套件取代XPath進行HTML元素分析
date: 2023-08-27 16:11 +0800
---
# 前言

# 安裝HtmlAgilityPack套件
![Desktop View](/assets/img/2023-08-27-c-sharp-analyze-html-dom-use-htmlagilitypack/1.png){: width="800" height="600" }  
<script  type='text/javascript' src=''>

    NuGet\Install-Package HtmlAgilityPack -Version 1.11.52


# 開始使用

## 分析所有HTML字串
<p>假設HTML長這樣</p>
![Desktop View](/assets/img/2023-08-27-c-sharp-analyze-html-dom-use-htmlagilitypack/2.png){: width="800" height="600" }
範例如下
<script  type='text/javascript' src=''>

    public void test()
    {    
        string html = @"
            <html>
	            <head>
		            <title>示例</title>
	            </head>
	            <body>
		            <a href='https://www.example.com'>Example Website</a>
		            <a href='https://www.google.com'>Google</a>
		            <a href='https://www.openai.com'>OpenAI</a>
		            <div id='content'>
			            <h1>Hello, World!</h1>
			            <p>This is a sample HTML document.</p>
		            </div>
	            </body>
            </html>
        ";
 
        // 創建HtmlDocument實例並載入HTML內容
        HtmlDocument doc = new HtmlDocument();
        doc.LoadHtml(html);

        // 使用Descendants方法遍歷所有<a>標籤
        foreach (HtmlNode linkNode in doc.DocumentNode.Descendants("a"))
        {
            // 獲取連結的文字內容和URL屬性
            string linkText = linkNode.InnerText;
            string linkUrl = linkNode.GetAttributeValue("href", "");

            Console.WriteLine("Link Text: " + linkText);
            Console.WriteLine("Link URL: " + linkUrl);
            Console.WriteLine();
        }

    }
