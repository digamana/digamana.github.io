---
layout: post
title: c-sharp task and async await
date: 2023-05-05 12:18 +0800
---

## 開始

<p>紀錄一下非同步用法</p>


假設有隻個判斷式如下
<script  type='text/javascript' src=''>

    public bool check()
    {
      bool result = bExistA1() && bExistA2() && bExistA3();
      return result;
    }
    public bool bExistA1()
    {
      return true;
    }
    public bool bExistA2()
    {
      return true;
    }
    public bool bExistA2()
    {
      return true;
    }


可以改成如下
<script  type='text/javascript' src=''>

    Task<bool> t1 = bExistA1();
    Task<bool> t2 = bExistA2();
    Task.WaitAll(t1, t2);
    bool[] results = new bool[] { t1.Result, t2.Result);

    public async Task<bool> bExistA1()
    {
        /*
        await ...
        */
        return true;
    }
    public async Task<bool> bExistA2()
    {
        /*
        await ...
        */
        return true;
    }
    public async Task<bool> bExistA3()
    {
        /*
        await ...
        */
        return true;
    }
