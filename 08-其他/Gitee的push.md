---
data: 2026-06-04
aliases:
  - The ways of push gitee
tags:
  - giteepush
---

````markdown
#  Git 项目推送到 Gitee 完整指南

> [!info] 适用场景
> 在 Windows 系统下，通过 `Open Git Bash Here` 将本地项目（包含文档、数据、图片等）推送到 Gitee 远程仓库。

---

## 一、 核心推送步骤与指令

### 1. 打开命令行并初始化
在本地项目文件夹空白处，**右键点击**选择 `Open Git Bash Here`，然后执行：
```bash
git init
````

### 2. 配置忽略文件 (强烈推荐)

在项目根目录创建`.gitignore` 文件，排除不需要的缓存或依赖文件。

```text
# 忽略操作系统临时文件
.DS_Store
Thumbs.db
desktop.ini

# 忽略常见的编辑器[[]]配置文件夹
.vscode/
.idea/

# 忽略日志文件
*.log
```

### 3. 添加文件到暂存区

使用 `.` 自动选中当前目录下的所有文件：

```bash
git add .
```

### 4. 提交到本地仓库

给这次打包写一个“备忘录”并保存到本地：

```bash
git commit -m "添加项目文档、数据及图片资源"
```

### 5. 在 Gitee 新建远程仓库

1. 登录 Gitee 网页版，点击右上角的 **“+”** 号，选择 **“新建仓库”**。
2. 填写仓库名称（建议与本地项目名一致，如 `ai-chem-lab`）。
3. **️ 关键设置**：**千万不要勾选**“使用Readme文件初始化仓库”、“添加.gitignore”和“添加开源许可证”等任何初始化选项！必须保持仓库完全为空，否则后续推送会报冲突错误。
4. 点击“创建”后，复制该仓库的 **HTTPS 地址**（例如：`https://gitee.com/你的用户名/仓库名.git`）。

### 6. 关联 Gitee 远程仓库

回到 Git Bash，将本地仓库与刚创建的 Gitee 空仓库连接：

```bash
git remote add origin <你复制的Gitee仓库HTTPS地址>
```

### 7. 推送到 Gitee 服务器

首次推送需要加上 `-u` 参数建立本地和远程分支的关联（假设主分支为 `main`）：

```bash
git push -u origin main
```

---

## 二、 ️ 常见报错与解决方案

### 1. WSL 路径权限报错 (dubious ownership)

> [!danger] 报错信息  
> `fatal: detected dubious ownership in repository at '//wsl$/...'`

**原因**：在 Windows 下通过 `//wsl$/` 网络路径访问 WSL 文件，Git 发现当前 Windows 用户与 WSL 文件夹所有者不一致，触发安全保护。  
**解决**：将当前项目路径加入 Git 全局安全白名单（直接复制报错提示中的命令执行即可）：

```bash
git config --global --add safe.directory '%(prefix)///wsl$/Ubuntu-22.04/home/josan/venv/ai-chem-lab'
```

### 2. 分支不匹配报错 (src refspec does not match any)

> [!danger] 报错信息  
> `error: src refspec main does not match any`

**原因**：通常是因为之前的 `git add` 或 `git commit` 因权限问题未真正生效，导致本地根本没有生成 `main` 分支。  
**解决**：重新执行添加和提交命令，确保本地分支成功创建：

```bash
git add .
git commit -m "添加项目文档、数据及图片资源"
```

### 3. Gitee 推送权限报错 (403 Forbidden)

> [!danger] 报错信息  
> 推送时提示 `403 Forbidden` 或密码验证失败。

**原因**：Gitee 目前强制要求使用 **私人令牌 (Personal Access Token)** 代替账号密码进行 HTTPS 推送。  
**解决**：

1. 登录 Gitee 网页版 -> 点击右上角头像 -> **设置** -> 左侧菜单 **私人令牌**。
2. 点击 **生成新令牌**，勾选 `projects` 等必要权限，生成并**复制令牌**（只显示一次）。
3. 在 Git Bash 执行 `git push -u origin main`。
4. 提示输入 `Username` 时：输入 Gitee 账号（如 `mdje`）。
5. 提示输入 `Password` 时：**粘贴刚才复制的私人令牌**（输入时屏幕不会显示字符，直接回车即可）。

---

## 三、 常用辅助命令备忘

|指令|作用说明|
|:--|:--|
|`git remote -v`|查看当前关联的远程仓库地址|
|`git remote remove origin`|移除已存在的远程仓库别名（用于重新关联）|
|`git branch`|查看当前所在的本地分支名称|
|`git pull origin main --allow-unrelated-histories`|如果 Gitee 仓库不小心勾选了初始化 README，需先执行此命令合并后再 push|

---

## 四、 后续日常更新流程

首次成功推送并建立关联后，以后每次修改代码只需执行以下三步：

```bash
git add .
git commit -m "本次更新的说明"
git push
```

