# 📝 博客发布指南

配置好 GitHub Actions 后，以后发布博客的完整流程。

## 🚀 快速发布（3步走）

### 步骤1：创建新文章
```bash
hexo new post "文章标题"
```
或手动在 `source/_posts/` 目录创建 `.md` 文件

### 步骤2：编辑文章
使用VS Code或你喜欢的编辑器编辑文章内容

### 步骤3：提交并推送（自动触发部署）
```bash
git add source/_posts/新文章.md
git commit -m "feat: 添加新文章：文章标题"
git push origin main
```

**完成！** GitHub Actions 会自动构建并部署，3-6分钟后文章就会上线。

---

## 📋 常见场景

### 场景1：发布新文章
```bash
# 1. 创建文章
hexo new post "我的新文章"

# 2. 编辑 source/_posts/2026-XX-XX-我的新文章.md

# 3. 提交推送
git add source/_posts/
git commit -m "feat: 添加新文章：我的新文章"
git push origin main
```

### 场景2：修改现有文章
```bash
# 1. 编辑文章文件
# 编辑 source/_posts/已有文章.md

# 2. 提交推送
git add source/_posts/已有文章.md
git commit -m "fix: 更新文章内容"
git push origin main
```

### 场景3：修改博客配置
```bash
# 1. 编辑配置文件
# 编辑 _config.yml 或 _config.butterfly.yml

# 2. 提交推送
git add _config*.yml
git commit -m "config: 更新博客配置"
git push origin main
```

### 场景4：批量提交所有更改
```bash
git add .
git commit -m "chore: 更新博客内容"
git push origin main
```

---

## 💡 提交信息规范

使用清晰的提交信息，方便以后查找：

- `feat: 添加新文章：文章标题` - 新功能（新文章）
- `fix: 修正文章错误` - 修复问题
- `docs: 更新README` - 文档更新
- `style: 调整博客样式` - 样式修改
- `config: 更新博客配置` - 配置修改
- `chore: 清理无用文件` - 维护性更改

---

## ⏱️ 时间线

- **写文章**：根据内容，10分钟到数小时
- **git推送**：5-10秒
- **GitHub Actions构建**：2-5分钟
- **部署完成**：自动完成

**总计**：推送后 **3-6分钟** 内，新文章就会在线可见！

---

## 🔍 验证部署状态

### 查看 GitHub Actions
访问：https://github.com/zhuyikai2002/myblog-backup/actions

- ✅ 绿色 = 成功
- ❌ 红色 = 失败（点击查看日志）

### 查看网站
- **GitHub Pages**: https://zhuyikai2002.github.io/myblog-backup/
- **VPS网站**: https://qzkj.ltd/blog/

---

## 📁 重要目录说明

- `source/_posts/` - 存放所有文章（.md文件）
- `source/css/` - 自定义CSS样式
- `_config.yml` - Hexo主配置文件
- `_config.butterfly.yml` - Butterfly主题配置文件
- `public/` - 构建后的静态网站（自动生成，不要手动编辑）

---

## 🎯 快速命令参考

```bash
# 查看状态
git status

# 查看提交历史
git log --oneline -10

# 暂存所有更改
git add .

# 提交更改
git commit -m "提交说明"

# 推送到GitHub（触发自动部署）
git push origin main

# 创建新文章
hexo new post "文章标题"

# 本地预览（开发时使用）
hexo server
```

---

## 💡 提示

1. **不要手动修改 `public/` 目录**：这是自动生成的
2. **每次推送都会触发部署**：确保代码正确再推送
3. **查看Actions日志**：如果部署失败，查看日志找出问题
4. **使用有意义的提交信息**：方便以后查找和回溯

---

**享受自动化部署的便利！** 🎉
