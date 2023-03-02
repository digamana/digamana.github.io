---
layout: post
title: C# WinForom UI 事件更新元件處理
date: 2023-02-16 14:21 +0800
---

## 前言
<p>使用Winfrom或WPF 製作桌面小程式的時候會用到</p>

## 問題描述
<p>按下Button時,畫面會卡住,畫面無法達到「按下按鈕 ->按鈕鎖定 ->執行商業邏輯 ->執行完畢 ->按鈕鎖定」這樣的基本效果</p>
 

## 解法
<p>使用BackgroundWorker可以解決上述的問題點 </p>
Sol:
<script  type='text/javascript' src=''>

    public partial class MainWindow : Window
    {
        private BackgroundWorker worker = new BackgroundWorker();
        public MainWindow()
        {
            InitializeComponent();
            this.worker.DoWork += new DoWorkEventHandler(worker_DoWork);
            this.worker.RunWorkerCompleted += new RunWorkerCompletedEventHandler(worker_RunWorkerCompleted);
        }
        private void Button_Click(object sender, RoutedEventArgs e)
        {
            if (this.Button.IsEnabled == true) this.Button.IsEnabled = false;
            worker.RunWorkerAsync();
        }
        void worker_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            if (this.Button.IsEnabled == false) this.Button.IsEnabled = true;
        }
        void worker_DoWork(object sender, DoWorkEventArgs e)
        {
            doSomeThing();
        }
        private void doSomeThing()
        {
            Task Task1 = Task.Run(() => {
            /*
             * 商業邏輯放這邊
             */
            });
            Task.WaitAll(Task1);
        }
    }
