---
layout: post
title: App.Config Set Key And Value
date: 2023-04-17 23:33 +0800
---
## appSettings

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

    string AppSetting = ConfigurationManager.AppSettings["SetKey"];


## connectionString
<p>ConnectString設定與讀取的方式如下,基本上與上方的appSettings差不多</p>
App.Config
<script  type='text/javascript' src=''>

    <configuration>
      <connectionStrings>
	      <add name="MSSQL" connectionString=" " providerName="System.Data.SqlClient"/>
      </connectionStrings>
    </configuration>

Program.cs
<script  type='text/javascript' src=''>

     string strConnectString = ConfigurationManager.ConnectionStrings["MSSQL"].ConnectionString;
