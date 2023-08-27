---
layout: post
title: Git Restore Commit Record
date: 2023-07-25 23:05 +0800
---

# 前言

<p>稍微記錄一下如何救回不小心使用重設(hard) 刪除的git</p>
![Desktop View](/assets/img/2023-07-25-git-restore-commit-record/0.png){: width="600" height="500" }

# Step1.列出所有Log

![Desktop View](/assets/img/2023-07-25-git-restore-commit-record/3.png){: width="600" height="500" }
列出所有Log指令
<script  type='text/javascript' src=''>

    git reflog


# Step2.還原

![Desktop View](/assets/img/2023-07-25-git-restore-commit-record/4.png){: width="600" height="500" }
列出所有Log指令
<script  type='text/javascript' src=''>

    git reset --hard xxxxx


# 備註

要單純切回某個commit做修正,要先用checkout , 再new branch
<script  type='text/javascript' src=''>

    git checkout e761896


或直接使用下面這個指令,等同於checkout + new branch
<script  type='text/javascript' src=''>

  git branch Your_Branch_Name e761896
