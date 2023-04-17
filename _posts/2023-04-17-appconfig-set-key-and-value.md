---
layout: post
title: App.Config Set Key And Value
date: 2023-04-17 23:33 +0800
---

<p>在App.Config的檔案裡面,可以在configuration裡面加入appSettings,然後在appSettings裡面新增所需的Key And Value的Config</p>

App.Config
<script  type='text/javascript' src=''>

    <configuration>
        <appSettings>
          <add key="SetKey" value="I am Value" />
        </appSettings>
    </configuration>


<p>在C#裡面可以這樣調用上方App.Config的appSettings的資料</p>
Program.cs
<script  type='text/javascript' src=''>

    ConfigurationManager.AppSettings["SetKey"];
