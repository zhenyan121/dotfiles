#!/bin/sh

set -e

# 缓存目录
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/wallpaper_overview"
mkdir -p "$CACHE_DIR"

# 检查参数
if [ -z "$1" ]; then
    echo "用法: $0 <壁纸文件路径>"
    exit 1
fi

WALLPAPER="$1"

# 1. 生成颜色文件（每次都执行）
matugen image "$WALLPAPER" --source-color-index 0

# 2. 基于原壁纸路径生成唯一的缓存文件名（md5 哈希）
HASH=$(echo -n "$WALLPAPER" | md5sum | cut -d' ' -f1)
CACHE_FILE="$CACHE_DIR/${HASH}.png"

# 3. 检查缓存是否存在
if [ -f "$CACHE_FILE" ]; then
    echo "使用已有缓存图片: $CACHE_FILE"
    # 更新文件的修改时间，表示“最近使用过”
    touch "$CACHE_FILE"
else
    echo "未找到缓存，正在生成模糊暗色壁纸..."
    magick "$WALLPAPER" -blur 0x8 -fill black -colorize 30% "$CACHE_FILE"
fi

# 4. 设置 overview 壁纸，关闭动画
awww img "$CACHE_FILE" -n overview --transition-type none

# 5. 缓存清理：只保留最新的 10 张（按修改时间，最近使用的会被保留）
cd "$CACHE_DIR" || exit 1
# 列出所有 .png 文件，按修改时间排序（最新的在前）
# 保留前 10 个，删除第 11 个及之后的
ls -t *.png 2>/dev/null | tail -n +11 | while read -r oldfile; do
    rm -f "$oldfile"
    echo "已删除旧缓存: $oldfile"
done

echo "完成。当前缓存目录有 $(ls -1 *.png 2>/dev/null | wc -l) 张图片（最多保留 10 张）"
