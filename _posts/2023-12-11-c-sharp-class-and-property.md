---
layout: post
title: C# Class and Property
date: 2023-12-11 21:45 +0800
---

## 前言

<p>有固定格式用特定符號隔開的字串,要拆解後放進Class的方式如下</p>

## 開始

要映射的Class
<script  type='text/javascript' src=''>

    public class Shool
    {
        public string Teacher_Id { get; set; }
        public string Teacher_Name { get; set; }
        public string Student_ID { get; set; }
        public string Student_Name { get; set; }
    }



自動映射的靜態Method
<script  type='text/javascript' src=''>

    public static object stringToBject<T>(string sourceString)
    {
        string[] source = sourceString.Split(';');
        var target = Activator.CreateInstance(typeof(T).GetTypeInfo());
        var props = target.GetType().GetProperties();

        for (int i = 0; i < source.Length; i++)
        {
            switch (props[i].PropertyType.FullName.Split('.')[1])
            {
                case "String":
                    target.GetType().GetProperty(props[i].Name).SetValue(target, source[i]);
                    break;
            }
        }
        return target;
    }


實際執行
![Desktop View](/assets/img/2023-12-11-c-sharp-class-and-property/1.png){: width="800" height="600" }
<script  type='text/javascript' src=''>

    static void Main(string[] args)
    {
        string format = "T_ID;T_NAME;S_ID;S_NAME";
        Shool test = (Shool)stringToBject<Shool>(format);
    }


## 靜態擴展

如下Code
<script  type='text/javascript' src=''>

    public static class Extensions
    {
        public static T ToClass<T>(this string sourceString) where T : class
        {
            string[] source = sourceString.Split(';');
            var target = Activator.CreateInstance(typeof(T).GetTypeInfo());
            var props = target.GetType().GetProperties();
            for (int i = 0; i < source.Length; i++)
            {
                switch (props[i].PropertyType.FullName.Split('.')[1])
                {
                    case "String":
                        target.GetType().GetProperty(props[i].Name).SetValue(target, source[i]);
                        break;
                }
            }
            T result = (T)target;
            return result;
        }
    }



以下是使用方式
<script  type='text/javascript' src=''>

    string format = "T_ID;T_NAME;S_ID;S_NAME"; 
    Shool test = format.ToClass<Shool>(); 

