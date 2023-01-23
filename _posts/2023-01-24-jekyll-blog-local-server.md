---
layout: post
title: jekyll blog local server
date: 2023-01-24 00:54 +0800
---

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



## 啟動Server
<p>到專案的目錄底下</p>
使用
 <script  type='text/javascript' src=''>

    bundle exec jekyll server --livereload --open-url http://localhost:4000/ 




## 新增文章的指令
如下
 <script  type='text/javascript' src=''>

    bundle exec jekyll post "名稱"
