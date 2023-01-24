---
layout: post
title: Jekyll Blog Local Server 安裝步驟
date: 2023-01-24 00:54 +0800
---

## 懶人包
<p>把下面所有有用到的安裝檔和Chirpy專案,都丟到同個壓縮檔了 </p>
[https://drive.google.com/drive/folders/1PH_WtigNRmPxKDC-x2vqz4Ua85W6YnRm?usp=share_link](https://drive.google.com/drive/folders/1PH_WtigNRmPxKDC-x2vqz4Ua85W6YnRm?usp=share_link)

## Ruby+Devkit
<p>下載Ruby+Devkit 3.1.3-1 (x64) </p>
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/1.png){: width="600" height="500" }
[https://rubyinstaller.org/downloads/](https://rubyinstaller.org/downloads/)

<p>安裝完以後,要勾選Run ridk install </p>
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/7.png){: width="600" height="500" }
<p>選擇3,按Enter執行安裝 </p>
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/8.png){: width="600" height="500" }

## 安裝RubyGems
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/2.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/3.png){: width="600" height="500" }
<p>安裝完Ruby+Devkit ,就能執行setup.rb了</p>
[https://rubygems.org/pages/download](https://rubygems.org/pages/download)
## 安裝Jekyll
<p>使用cmd安裝Jekyll</p>
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/4.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/5.png){: width="600" height="500" }
 <script  type='text/javascript' src=''>

    gem install jekyll


## 安裝Chirpy
<p>因為我使用的是Chirpy的主題,所以要到專案的跟目錄底下執行這個指令</p>
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/6.png){: width="600" height="500" }
 <script  type='text/javascript' src=''>

    bundle


## 安裝Git Gui
<p>為了附上Git的環境變數,所以安裝完後要重開機</p>
[https://git-scm.com/download/gui/windows](https://git-scm.com/download/gui/windows)

## 啟動Server
<p>到專案的目錄底下</p>
使用
 <script  type='text/javascript' src=''>

    bundle exec jekyll server --livereload --open-url http://localhost:4000/ 




## 新增文章的指令
如下
 <script  type='text/javascript' src=''>

    bundle exec jekyll post "名稱"
