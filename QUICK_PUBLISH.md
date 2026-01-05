# 🚀 博客发布 - 超简单指南

## 3步发布法（最常用）

```bash
cd /home/rik/myblog

# 1. 添加所有更改
git add .

# 2. 提交更改
git commit -m "feat: 更新博客内容"

# 3. 推送发布（自动触发部署）
git push origin main
```

**完成！** GitHub Actions会自动构建并部署，3-5分钟后文章就上线了。

---

## 常用场景

### 发布新文章
```bash
hexo new post "文章标题"        # 创建文章模板
# 编辑 source/_posts/新文章.md
git add source/_posts/
git commit -m "feat: 添加新文章：文章标题"
git push origin main
```

### 修改现有文章
```bash
# 编辑 source/_posts/已有文章.md
git add source/_posts/
git commit -m "fix: 更新文章内容"
git push origin main
```

### 修改配置
```bash
# 编辑 _config.yml 或 _config.butterfly.yml
git add _config*.yml
git commit -m "config: 更新配置"
git push origin main
```

---

## 提交信息建议

- `feat: 添加新文章：标题`
- `fix: 修正文章错误`
- `config: 更新博客配置`
- `style: 调整样式`
- `chore: 更新博客内容`

---

## 查看部署状态

访问：https://github.com/zhuyikai2002/myblog-backup/actions

- ✅ 绿色 = 成功
- ❌ 红色 = 失败（查看日志）

---

## 访问地址

- VPS: https://qzkj.ltd/blog/
- GitHub Pages: https://zhuyikai2002.github.io/myblog-backup/

---

**记住：3步搞定，不要手动执行 hexo generate 和 rsync！**
