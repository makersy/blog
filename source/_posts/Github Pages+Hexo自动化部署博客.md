---
title: Github Pages + Hexo + Github Actions自动化部署博客
date: 2023-02-22 00:31:25
tags:
- 折腾

categories:
- 折腾

---

# 背景

传统的 GitHub Pages + Hexo 搭建的博客，GitHub只保存了最终生成的部分，如静态网页等。这样做有2个缺点：

- 每次写完博客都要自行在本地执行编译部署上传，步骤繁琐。虽说熟能生巧，但老是做重复工作也会降低写博客的热情
- Hexo 相关的配置以及 markdown 文件都存在本地，换机之后所有配置文件都要跟着转移（我就是换机之后忘了转移配置文件，导致样式全丢了）


**目标**

- 成功使用 GitHub Pages + Hexo + Github Actions 搭建个人博客
- 只需提交博客 markdown 文件至 GitHub 即可触发自动化编译部署
- 可以在任何环境下写博客并发表，不依赖电脑上的 Node + Hexo 环境，甚至可以全在浏览器端完成


# 前提

本篇默认是 Mac 环境。

Git、Homebrew（mac包管理软件）默认已安装。 

拥有一个GitHub账号，且能正常推拉代码。

# 步骤

## 安装node和hexo

安装node

```bash
brew install node
```

安装hexo

```bash
npm install -g hexo-cli
```

## 初始化Hexo

选择一个**空文件夹**用于存hexo文件以及md文件，假设是 `~/blog` 。

```bash
cd ~/blog
 
hexo init
```

初始化完毕。

## 切换next主题

首先在当前目录下执行：

```bash
git clone https://github.com/theme-next/hexo-theme-next themes/next

npm install hexo-theme-next
```
其次，修改项目根目录下的 `_config.yml` 文件，找到`theme`字段，更改为`next`即可。

注意把 `themes/next/.git` 文件夹删除，否则 next 会被 git 视为 submodule，无法被添加到暂存区。

## 本地编译&启动

此时博客的架子初始化完成了，可以在当前目录下执行以下命令来实现本地编译&启动，查看效果。

```bash
hexo g
hexo s
```

终端会输出：

```
INFO  Validating config
INFO  Start processing
INFO  Hexo is running at http://localhost:4000 . Press Ctrl+C to stop.
```

访问 http://localhost:4000 即可查看效果。

## 创建Github仓库

需要创建2个仓库：  
1. {username}.github.io  
这个仓库即 Github Pages 仓库，用来存放Hexo编译出的静态网页。  
名称要严格按照此格式，仓库需要设置为 public，添加`gh-pages`分支。
下图是pages相关配置：
    ![Pages配置](http://qn.haoliny.top/mweb/16769941908560.jpg)

2. blog  
这个仓库存放 markdown 文件、Hexo以及next主题的配置

## 部署密钥

### 生成

选择一个放公私钥的目录，一路按回车直到生成成功

```bash
ssh-keygen -f github-deploy-key
```

当前目录下会有 github-deploy-key 和 github-deploy-key.pub 两个文件。

### 配置

#### blog仓库

复制当前目录下 **`github-deploy-key`** 文件内容，在 `blog` 仓库 `Settings -> Secrets and Variables -> Add a new secret` 页面上添加。

1. 在 `Name` 输入框填写 `HEXO_DEPLOY_PRI`。
2. 在 `Value` 输入框填写 `github-deploy-key` 文件内容。

![HEXO_DEPLOY_PRI](http://qn.haoliny.top/mweb/16769946701164.jpg)

#### {username}.github.io 仓库

复制当前目录下 `github-deploy-key.pub` 文件内容，在 `{username}.github.io` 仓库 `Settings -> Deploy keys -> Add deploy key` 页面上添加。

1. 在 `Title` 输入框填写 `HEXO_DEPLOY_PUB`。
2. 在 `Key` 输入框填写 `github-deploy-key.pub` 文件内容。
3. 勾选 `Allow write access` 选项。

![HEXO_DEPLOY_PUB](http://qn.haoliny.top/mweb/16769949752402.jpg)

## 编写Github Actions

### Workflow模板

在 `blog` 仓库根目录下创建 `.github/workflows/deploy.yml` 文件，目录结构如下。

```
blog (repository)
└── .github
    └── workflows
        └── deploy.yml
```

`deploy.yml`文件内容：

```yaml
name: CI

on:
  push:
    branches:
      - master

env:
  GIT_USER: makersy
  GIT_EMAIL: your-email@gmail.com
  DEPLOY_REPO: makersy/makersy.github.io
  DEPLOY_BRANCH: gh-pages

jobs:
  build:
    name: Build on node ${{ matrix.node_version }} and ${{ matrix.os }}
    runs-on: ubuntu-latest
    strategy:
      matrix:
        os: [ubuntu-latest]
        node_version: [12.x]

    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Use Node.js ${{ matrix.node_version }}
        uses: actions/setup-node@v1
        with:
          node-version: ${{ matrix.node_version }}

      - name: Configuration environment
        env:
          HEXO_DEPLOY_PRI: ${{secrets.HEXO_DEPLOY_PRI}}
        run: |
          sudo timedatectl set-timezone "Asia/Shanghai"
          mkdir -p ~/.ssh/
          echo "$HEXO_DEPLOY_PRI" > ~/.ssh/id_rsa
          chmod 600 ~/.ssh/id_rsa
          ssh-keyscan github.com >> ~/.ssh/known_hosts
          git config --global user.name $GIT_USER
          git config --global user.email $GIT_EMAIL

      - name: Install dependencies
        run: |
          npm install
          npm install -g hexo-cli

      - name: Deploy hexo
        run: |
          hexo clean
          hexo g
          hexo d
```

需要自己修改的部分：  

1. env.GIT_USER
2. env.GIT_EMAIL
3. env.DEPLOY_REPO
4. env.DEPLOY_BRANCH  

含义见下方参数说明。

**模版参数说明：**

* name 为此 Action 的名字
* on 触发条件，当满足条件时会触发此任务，这里的 `on.push.branches.$.master` 是指当 master 分支收到 push 后执行任务。
* env 为环境变量对象
    * env.GIT_USER 为 Hexo 编译后使用此 git 用户部署到仓库。
    * env.GIT_EMAIL 为 Hexo 编译后使用此 git 邮箱部署到仓库。
    * env.DEPLOY_REPO 为 Hexo 编译后要部署的仓库，例如：`makersy/makersy.github.io`。
    * env.DEPLOY_BRANCH 为 Hexo 编译后要部署到的分支，例如：`gh-pages`。
* jobs 为此 Action 下的任务列表
    * jobs.{job}.name 任务名称
    * jobs.{job}.runs-on 任务所需容器，可选值：ubuntu-latest、windows-latest、macos-latest。
    * jobs.{job}.strategy 策略下可以写 array 格式，此 job 会遍历此数组执行。
    * jobs.{job}.steps 一个步骤数组，可以把所要干的事分步骤放到这里。
    * jobs.{job}.steps.$.name 步骤名，编译时会会以 LOG 形式输出。
    * jobs.{job}.steps.$.uses 所要调用的 Action，可以到 https://github.com/actions 查看更多。
    * jobs.{job}.steps.$.with 一个对象，调用 Action 传的参数，具体可以查看所使用 Action 的说明。


## 写文章

如何创建一篇文章：

1. 可以在 `blog/source/_posts` 文件夹下直接写md。
2. 也可以进入blog根目录，执行 `hexo new 文章名称`，例如`hexo new "hello world"`，文章会生成到 `source/_posts` 目录下。

具体可以参考[官方文档](https://hexo.io/zh-cn/docs/writing.html)。

采用方式2生成的文章会有如下的格式，Hexo会按此格式方便编译识别标题、时间、类别等，也可以自己复制。

```yaml
---
title: 标题 # 自动创建，如 hello-world
tags: 
- 标签1
- 标签2
- 标签3
categories:
- 分类1
- 分类2
---
```

## 部署至GitHub Pages

要让Hexo项目部署到Github Pages项目，首先需要如下配置：

1. 修改`blog`项目根目录下的 `_config.yml` 文件，找到 Deployment，配置如下：
    ```yaml
    deploy:
      type: git
      repo: git@github.com:makersy/makersy.github.io.git
      branch: gh-pages
    ```
    修改`repo`为自己的地址
2. 安装 `hexo-deployer-git` 部署插件
    ```bash
    npm install hexo-deployer-git --save
    ```

本文主要目标是实现自动化部署，但是也可以实现常规的本地手动部署。

### GitHub Actions自动化部署

1. 在 `blog` 下写一篇文章（参考写文章部分），提交至 GitHub
2. 在 `blog` Github Actions 页面查看触发的action

### 本地手动部署

需要本地已安装Hexo。

到 `blog` 项目根目录，执行：

```bash
hexo clean
hexo g
hexo d
```

即可将项目部署到 `{username}.github.io` 项目


# 扩展

## 用Vercel加速Pages服务

目前没用，先记录着

https://wiki-power.com/%E7%94%A8Vercel%E5%8A%A0%E9%80%9FPages%E6%9C%8D%E5%8A%A1

## Next主题配置

https://www.mdnice.com/writing/382af676baff4ed4ad5511074fb736da

## 首页文章截断

懒人刚需。

这个插件的作用是控制首页文章的**标题**和**阅读全文**之间展示几行正文。

如果要控制正文截断位置，正常来说是通过在md文件中加入

 ```md
 <!-- more -->
 ```

 这样太麻烦，经常忘了写。但是如果没有这个标记，hexo就会默认将全文展示在首页，且官方没有这部分功能的自定义配置。

**安装步骤：**

1. 到blog根目录，执行
    ```bash
    npm install hexo-excerpt --save
    ```

2. 还是在根目录的 `_config.yml` 文件添加：

    ```yaml
    # excerpt
    ## depth 截断行数
    excerpt:
      depth: 4
      excerpt_excludes: []
      more_excludes: []
      hideWholePostExcerpts: true
    ```
    字段具体含义见：https://github.com/chekun/hexo-excerpt

## 自动提交脚本

1. 将这个文件放到blog项目根目录
https://raw.githubusercontent.com/makersy/blog/master/auto-push.sh

2. 添加可执行权限
```bash
chmod a+x ./auto-push.sh
```

3. 执行脚本
```bash
./auto-push.sh
```
完成向Github的提交，以日期作为提交信息。

## 添加分类页和标签页

见 [Hexo添加分类及标签（在Next主题下）](https://tohugo.com/2021/01/26/%E5%B7%A5%E5%85%B7%E9%85%8D%E7%BD%AE/Hexo%E6%B7%BB%E5%8A%A0%E5%88%86%E7%B1%BB%E5%8F%8A%E6%A0%87%E7%AD%BE%EF%BC%88%E5%9C%A8Next%E4%B8%BB%E9%A2%98%E4%B8%8B%EF%BC%89/)

## 添加评论区

见 https://www.jianshu.com/p/02fc71f3633f

# 参考
- [Hexo官方文档](https://hexo.io/zh-cn/docs)

- [https://segmentfault.com/a/1190000038373795](https://segmentfault.com/a/1190000038373795)

- [https://losophy.github.io/post/71afd747.html](https://losophy.github.io/post/71afd747.html)

- https://chekun.me/post/hexo-excerpt/
