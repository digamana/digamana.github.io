---
layout: post
title: Jekyll Blog Local Server 安裝步驟
date: 2023-01-24 00:54 +0800
---

## for Windows Server
### 懶人包
<p>把下面所有有用到的安裝檔和Chirpy專案,都丟到同個壓縮檔了 </p>
[https://drive.google.com/drive/folders/1PH_WtigNRmPxKDC-x2vqz4Ua85W6YnRm?usp=share_link](https://drive.google.com/drive/folders/1PH_WtigNRmPxKDC-x2vqz4Ua85W6YnRm?usp=share_link)

### Ruby+Devkit
<p>下載Ruby+Devkit 3.1.3-1 (x64) </p>
[https://rubyinstaller.org/downloads/](https://rubyinstaller.org/downloads/)
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/1.png){: width="600" height="500" }


<p>安裝完以後,要勾選Run ridk install </p>
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/7.png){: width="600" height="500" }
<p>選擇3,按Enter執行安裝 </p>
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/8.png){: width="600" height="500" }

### 安裝RubyGems
[https://rubygems.org/pages/download](https://rubygems.org/pages/download)
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/2.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/3.png){: width="600" height="500" }
<p>安裝完Ruby+Devkit ,就能執行setup.rb了</p>

### 安裝Jekyll
<p>使用cmd安裝Jekyll</p>
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/4.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/5.png){: width="600" height="500" }
 <script  type='text/javascript' src=''>

    gem install jekyll


### 安裝Chirpy
<p>因為我使用的是Chirpy的主題,所以要到專案的跟目錄底下執行這個指令</p>
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/6.png){: width="600" height="500" }
 <script  type='text/javascript' src=''>

    bundle


### 安裝Git Gui
<p>因為是為了附上Git的環境變數,所以安裝完後要重開機</p>
[https://git-scm.com/download/gui/windows](https://git-scm.com/download/gui/windows)

### 啟動Server
<p>到專案的目錄底下</p>
使用
 <script  type='text/javascript' src=''>

    bundle exec jekyll server --livereload --open-url http://localhost:4000/ 




### 新增文章的指令
如下
 <script  type='text/javascript' src=''>

    bundle exec jekyll post "名稱"


## for Windows Docker
### 建立DockerFile
<p>建立檔名DockerFile (無附檔名) </p>
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/9.png){: width="600" height="500" }
**DockerFile**
 <script  type='text/javascript' src=''>

    # 使用官方的Ruby映像作為基底
    FROM ruby:3.1.3

    # 安裝Devkit
    RUN apt-get update && \
        apt-get install -y --no-install-recommends \
        build-essential \
        && rm -rf /var/lib/apt/lists/*

    # 安裝Git
    RUN apt-get update && \
        apt-get install -y --no-install-recommends \
        git \
        && rm -rf /var/lib/apt/lists/*

    # 安裝RubyGems (使用指定版本)
    RUN gem update --system 3.4.5

    # 安裝Jekyll
    RUN gem install jekyll

    # 設定環境變數以避免RubyGems的警告
    ENV BUNDLE_SILENCE_ROOT_WARNING=1

    # 在工作目錄中複製Gemfile和Gemfile.lock
    WORKDIR /app
    COPY Gemfile* /app/

    # 在工作目錄中複製整個Git存儲庫
    #COPY .git /app/.git

    # 使用bundle安裝依賴
    RUN gem install bundler && bundle install

    # 開放Jekyll預設的伺服器埠
    EXPOSE 4000

    # 將整個Blog目錄映射進容器
    VOLUME /app

    # CMD 指令，啟動Jekyll伺服器
    CMD ["jekyll", "serve", "--incremental", "--livereload", "--force_polling", "--host", "0.0.0.0"]




<p>放到與Blog同個路徑底下 </p>
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/10.png){: width="600" height="500" }


### 方案1.建立Compose.yml
<p>放到與Blog同個路徑底下 </p>
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/14.png){: width="600" height="500" }
Compose.yml
<script type='text/javascript' src=''>

    version: '3.3'
    services:
      jekyll:
        volumes:
            - './:/srv/jekyll'
        ports:
            - '4000:4000'
            - '35729:35729'
        image: jekyll/jekyll
        command: jekyll serve --incremental --livereload --force_polling




<p>最高權限開啟PowerShell 並切到Blog路徑 ,開始進行compose.yml的安裝</p>
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/15.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    docker-compose up -d






<p>上述指令做完後,可以在Docker GUI中 看到建立好的容器</p>
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/16.png){: width="600" height="500" }
<p>點進容器後,就能看到在容器內運作的Server了</p>
<p>若在Winodows安裝Server, 原本那些資料會顯示在Winodows所要一直開起的CMD中, 現在則是資料改成顯示在Docker中</p>
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/17.png){: width="600" height="500" }




<p>由於後續我將上面所用到的東西上傳至自己的Docker Hub中</p>
<p>所以之後可以考慮將Compose.yml的內容更改指定的Image</p>
<p>在進行以下指令 ,記得cmd要切到Compose.ym的目錄底下</p>
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/18.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    docker-compose up -d



可複製
<script  type='text/javascript' src=''>

    pqc91077/jekyll-github-pages-theme-chirpy:latest


### 方案2.直接進行DockerFile安裝
<p>!!!重要!!!  此步驟會卡在最後livereload指令無法生效. 也就是無法更新Blog文章後 無法馬上看到網頁更新</p>
<p>最高權限開啟PowerShell 並切到Blog路徑 ,開始進行DockerFile安裝</p>
<p>這邊Blog路徑是E:\Coding\作品練習\blog </p>
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/11.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    docker build -t blog-server-container .



<p>安裝完後,可以在Docker GUI中 看到Images的名稱</p>
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/12.png){: width="600" height="500" }


<p>啟動Docker 並將Blog在Winodows的路徑與容器共用</p>
![Desktop View](/assets/img/2023-01-24-jekyll-blog-local-server/13.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    docker run -d -p 4000:4000 -v E:/Coding/作品練習/blog:/app blog-server-container



