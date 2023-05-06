---
layout: post
title: C# 寄信範例程式
date: 2023-04-21 17:45 +0800
---

發信範例Method如下
<script  type='text/javascript' src=''>

    public static void sendMailLog()
    {
	  WebMail.SmtpServer = ""; //例如微軟的smtp 就打 smtp.office365.com
	  WebMail.SmtpPort = 0;    //  smtp.office365.com底下可打587 port
	  WebMail.SmtpUseDefaultCredentials = true;
	  WebMail.EnableSsl = true;  
	  WebMail.Password = "Your Mail Pwd"; //寄件人信箱密碼
	  WebMail.From = "Your Mail Acc";     //寄件人信箱帳號
	  WebMail.UserName = "Your Mail Acc"; //寄件人信箱帳號
	  WebMail.Send(
        to: "", //打收件人信箱 格式為「信箱1,信箱2,信箱3,信箱4」組成的string,  可參考string.Join(",", List<Mail>);
			  subject: "測是", //標題
			  filesToAttach: new string[] { filePath }, //附檔路徑
			  body: "" //信件內容,(可用html格式撰寫)
         );
    }
