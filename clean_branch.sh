#!/bin/bash
echo "⚠️  警告：这将永久删除云端历史，不可恢复！"
read -p "输入'YES'确认继续: " confirm
[ "$confirm" != "YES" ] && echo "已取消" && exit 0

# 1. 创建全新孤儿分支
git checkout --orphan new_temp

# 2. 添加并提交所有文件（新历史起点）
git add -A
git commit -m "初始提交 - 全新开始"

# 3. 强制删除云端旧分支（如果存在）
git push origin --delete new 2>/dev/null

# 4. 重命名并强制推送
git branch -m new
git push -f origin new

echo "✅ 完成！'new'分支已重置为无历史状态"
echo "⚠️  其他开发者需要：git fetch && git reset --hard origin/new"