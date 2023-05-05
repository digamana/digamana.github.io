---
layout: post
title: c-sharp winform subform creat and dispose
date: 2023-05-05 12:20 +0800
---

## 開始

<p>紀錄一下Winform開啟子視窗後, 釋放資源的寫法</p>

主視窗調用如下
<script  type='text/javascript' src=''>

       frmForm = new frmForm();
       frmForm.ShowDialog();
       frmForm.Dispose();

子視窗如下
<script  type='text/javascript' src=''>

    public partial class frmForm : Form
    {
        public frmForm()
        {
        }
    }
