---
layout: post
title: Leetcode C# 常用解題技巧
date: 2023-03-15 11:37 +0800
---

## 前言
<p>因為有時候刷題的時候,會發生我知道大概要用什麼語法or演算法or技巧進行處理</p>
<p>但我卻無法完整打出那段程式碼</p>
<p>所以在這邊紀錄一下針對那些小技巧</p>

## 開始

### HashSet

### 陣列交集
如下
<script  type='text/javascript' src=''>

    string[] words1;
    string[] words2;
    var intersectedList = words1.Intersect(words2);

### 陣列互斥
如下
<script  type='text/javascript' src=''>

    string[] ArrS1=s1.Split(" ");
    string[] ArrS2=s2.Split(" ");
    //Except=>差集
    //Union=>=>並集、聯集
    //Intersect =>交集
    //互斥的寫法
    var exceptResult = ArrS1.Except(ArrS2).Union(ArrS2.Except(ArrS1)).ToArray();

### ToDictionary
<p>假設有個陣列arr = ["d","b","c","b","c","a"] 算出內容物出現幾次的方式</p>
如下
<script  type='text/javascript' src=''>

    string[] arr = new int[] { 10, 11, 44, 9, 8, 19, 45, 20, 24, 11, 3, 7 };
    var map = arr.GroupBy(a => a).ToDictionary(g => g.Key, g => g.Count());
    //備註後面可以接Select(c=>c.Key) 或 Select(c=>c.Value)來轉成陣列 


### 排列組合
備註: 1079. Letter Tile Possibilities
如下
<script  type='text/javascript' src=''>

    public int NumTilePossibilities(string tiles) {
        string strResult="";
        HashSet<string> set=new HashSet<string>();
        permute("",tiles,ref set);
        return set.Count()-1;
    }
    static void permute(string result, string now,ref HashSet<string> set)
    {
        if (now == "")
        {
            //Console.WriteLine(result);
            set.Add(result);
        }
        else
        {
            for (int i = 0; i < now.Length; i++)
            {
                permute(result + now[i], now.Substring(0, i) + now.Substring(i + 1),ref set);
            }
            now=now.Substring(0, now.Length-1);
            permute(result,now,ref set);
            
        }
    }

### 快速排序法
如下
<script  type='text/javascript' src=''>

    int[] arr = new int[] { 10, 11, 44, 9, 8, 19, 45, 20, 24, 11, 3, 7 };
    QuickSortArray(arr, 0, arr.Length - 1);

    public static void QuickSortArray(int[] array, int iL, int iR)
    {
        if (iL >= iR) return;
        int pivot = Partition(array, iL, iR);
        QuickSortArray(array, iL, pivot - 1);
        QuickSortArray(array, pivot + 1, iR);
    }
    public static int Partition(int[] array, int iL, int iR)
    {
        int key = array[iL];//基準值
        while (iL < iR)
        {
            //因為基準值右邊要擺比基準值大的數字,所以要從右往左,先找到小於等於基準值的內容
            while (iL < iR && array[iR] > key) iR--;
            array[iL] = array[iR];
           //因為基準值左邊要擺比基準值寫的數字,所以要從左往右,先找到大於基準值的內容
            while (iL < iR && array[iL] <= key) iL++;
            array[iR] = array[iL];
        }
        //迴圈結束後，左邊都會小於等於基準值，右邊都會大於基準值。
        array[iL] = key;
        return iR;
    }


### 英文字串字母是否相等
假設要判斷2個英文字串,是不是由同樣的字母組成的話,可以用以下的寫法 (包含相同字母出現次數)
如下
<script  type='text/javascript' src=''>

    string str = "Hel";
    var charList = new char[26];
    foreach (char c in str)
    {
        charList[c - 97]++;
    }
    var key = new string(charList);

### 最大公因數
如下
<script  type='text/javascript' src=''>

    int gcd2(int m, int n)
    {
      if (n == 0)return m;
      return gcd2(n,m%n);
    }


### 二微陣列長度
如下
<script  type='text/javascript' src=''>

    int[][] matrix //假設題目裡面的二微陣列長這樣
    //迴圈的寫法
    for(int i=0; i<matrix.Length; i++){
        for(int j=0; j<matrix[i].Length; j++){

        }
    }
