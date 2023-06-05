---
layout: post
title: C# 擴展方法 (Extend method)
date: 2023-06-05 22:04 +0800
---

## 前言
<p>
稍微紀錄一下擴展方法的使用方式,因為感覺在某些場合,比起直接調用Method,不如使用Extend method的易讀性更來的高
</p>

## 範例
Source Code：
<script  type='text/javascript' src=''>

    public static class StringUtilities
    {
        /// <summary>
        /// 以Email含有1個"@"作為判斷依據
        /// </summary>
        public static bool IsEmail(this string s)  
        {
          return  s.Contains("@") && s.Split('@').Length==2;
        }
    }


主程式調用方式如下
<script  type='text/javascript' src=''>

    public class Program
    {
        static void Main(string[] args)
        {
            string Email = "s12345@yahoo.com.tw";
            Console.WriteLine(Email.IsEmail());
        }
    }


備註: 擴展方式一定要使用 static class
