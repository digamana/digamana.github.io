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


## BackgroundWorker執行時更新UI控件的靜態擴展

<p>由於有時候需要將Value傳回給UI的執行續,所以需要 </p>
使用方式
<script  type='text/javascript' src=''>

    public class main
    {
        ComboBox cb = new ComboBox();
 
        void main()
        {
            //方法1:使用lambda
            cb.InvokeIfRequired(() =>
            {
                cb.Text = "hello";
            });
 
            //方法2:使用Action
            cb.InvokeIfRequired(helloAction);
        }
 
        void helloAction()
        {
            cb.Text = "hello";
        }
    }

Sol:
<script  type='text/javascript' src=''>

    public static class Extensions
    {
        //非同步委派更新UI
        public static void InvokeRequired(this Control control, MethodInvoker action)
        {
            if (control.InvokeRequired)
            {
                control.Invoke(action);
            }
            else
            {
                action();
            }
        }
    }
