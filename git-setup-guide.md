# Git 版本控制配置指引

## 第一步：安装 Git

### 方式一：官网下载（推荐）

1. 访问 Git 官网下载页面：https://git-scm.com/download/win
2. 点击 **64-bit Git for Windows Setup** 下载安装包
3. 运行下载的 `.exe` 安装程序
4. 安装过程中使用默认选项一路下一步即可
5. 安装完成后重启终端（或重新打开 PowerShell/CMD）

### 方式二：国内镜像加速

如果官网下载速度慢，可以使用国内镜像：
- 淘宝镜像：https://registry.npmmirror.com/-/binary/git-for-windows/
- 选择最新版本的 `Git-*-64-bit.exe` 下载

### 验证安装

```powershell
git --version
# 应输出类似: git version 2.47.3.windows.1
```

---

## 第二步：配置 Git 用户信息

安装完成后，在终端执行以下命令（替换为你的信息）：

```powershell
# 设置用户名（会显示在提交记录中）
git config --global user.name "你的名字"

# 设置邮箱（会显示在提交记录中）
git config --global user.email "your.email@example.com"

# 设置默认分支名为 main
git config --global init.defaultBranch main

# 设置换行符处理（Windows 上推荐）
git config --global core.autocrlf true

# 设置默认编辑器（可选，VS Code 用户推荐）
git config --global core.editor "code --wait"
```

### 验证配置

```powershell
git config --list
# 检查 user.name 和 user.email 是否已正确设置
```

---

## 第三步：初始化项目仓库

### 进入项目目录

```powershell
cd d:\TRAE\TRAE\farm-game-studio
```

### 初始化仓库并创建初始提交

```powershell
# 初始化 Git 仓库
git init

# 添加所有文件到暂存区
git add .

# 创建初始提交
git commit -m "Initial commit: PRD v2.0.1, TDD, AGENT.md

- PRD: 产品需求文档 v2.0.1
- TDD: 技术设计文档 v2.0.1
- AGENT.md: 游戏工作室架构
- .gitignore: Godot 4.x 忽略规则
- .gitattributes: 跨平台换行配置"

# 重命名主分支为 main
git branch -M main
```

### 验证提交

```powershell
# 查看提交历史
git log --oneline

# 查看仓库状态
git status
```

---

## 第四步：常用 Git 命令速查

### 日常工作流

```powershell
# 查看仓库状态
git status

# 添加修改的文件
git add <filename>       # 添加单个文件
git add .                # 添加所有修改

# 提交更改
git commit -m "描述信息"

# 查看提交历史
git log --oneline --graph

# 撤销修改（未 add）
git checkout -- <filename>

# 撤销 add 操作
git reset HEAD <filename>
```

### 分支管理

```powershell
# 查看所有分支
git branch

# 创建新分支
git checkout -b feature/farm-system

# 切换分支
git checkout main

# 合并分支到主分支
git checkout main
git merge feature/farm-system

# 删除分支
git branch -d feature/farm-system
```

### 与远程仓库协作（GitHub/Gitee）

```powershell
# 添加远程仓库
git remote add origin https://github.com/你的用户名/farm-game-studio.git

# 推送到远程
git push -u origin main

# 拉取远程更新
git pull origin main
```

---

## 第五步：分支命名规范

根据 AGENT.md 中的工作室架构，推荐以下分支命名：

### 功能开发分支
```
feature/farm-system          # 农场系统
feature/npc-social           # NPC 社交
feature/combat-mine          # 战斗矿洞
feature/building-event       # 建造与事件
feature/advanced-systems     # 进阶系统（风水/自动化）
feature/core-systems         # 核心系统（时间/天气/存档）
feature/pet-system           # 宠物系统
feature/achievement-system   # 成就系统
feature/art-assets           # 美术资源
```

### 修复分支
```
fix/bug-description          # 修复具体 Bug
hotfix/urgent-fix           # 紧急修复
```

### 版本发布分支
```
release/v2.0.1              # v2.0.1 版本发布
release/v2.1.0              # v2.1 版本发布
```

---

## 常见问题

### Q: 如何在 VS Code 中使用 Git？
A: VS Code 内置了 Git 支持：
1. 打开项目文件夹
2. 点击左侧「源代码管理」图标（分支形状）
3. 在「更改」区域查看修改
4. 输入提交信息后点击「提交」

### Q: 如何关联 GitHub/Gitee 远程仓库？
A:
1. 在 GitHub/Gitee 创建新仓库（不要勾选 README/.gitignore）
2. 复制仓库地址
3. 执行：
```powershell
git remote add origin <仓库地址>
git push -u origin main
```

### Q: .gitignore 中的规则不会生效怎么办？
A: 如果文件已经被 Git 跟踪，需要先移除：
```powershell
git rm -r --cached .godot/
git commit -m "Remove .godot from tracking"
```

### Q: 如何查看某个文件的修改历史？
A:
```powershell
git log --follow docs/PRD-产品需求文档.md
git diff HEAD~1 docs/PRD-产品需求文档.md
```

---

## 快速检查清单

- [ ] Git 已安装（`git --version` 可正常输出）
- [ ] 用户信息已配置（`git config --list` 可查看）
- [ ] 仓库已初始化（`git init` 已执行）
- [ ] 初始提交已创建（`git log` 可查看提交）
- [ ] .gitignore 已生效（`.godot/` 等目录被忽略）
- [ ] 远程仓库已关联（可选，用于云端备份）
