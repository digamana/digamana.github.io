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
