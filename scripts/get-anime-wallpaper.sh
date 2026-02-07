#!/bin/bash

# ================= 基础配置 =================
API_URL="https://t.alcy.cc/pc/"
#API_URL="https://www.dmoe.cc/random.php"
SAVE_DIR="$HOME/Pictures/Wallpapers/api-random-download"

# 创建保存目录
mkdir -p "$SAVE_DIR"

# 设置 User-Agent
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

# ================= 参数解析 =================
COUNT=${1:-1}  # 默认 1 次

# 检查参数是否为正整数
if ! [[ "$COUNT" =~ ^[1-9][0-9]*$ ]]; then
    echo "❌ 用法: $0 [次数]"
    echo "   示例: $0     → 执行1次"
    echo "         $0 5   → 执行5次"
    exit 1
fi

# 检查 timg 是否安装
if ! command -v timg &> /dev/null; then
    echo "⚠️  未找到 'timg' 命令，请先安装它来预览图片。"
    echo "👉 Ubuntu/Debian: sudo apt install timg"
    echo "👉 Arch: yay -S timg"
    echo "👉 其他系统: https://github.com/hzeller/timg"
    exit 1
fi

# ================= 主循环 =================
for ((i=1; i<=COUNT; i++)); do
    echo
    echo "🔁 第 $i 次 —— 下载新壁纸中..."

    TMP_FILE="/tmp/wallpaper_preview_$(date +%s)_$i.jpg"

    # 下载到临时文件
    curl -L -A "$USER_AGENT" --connect-timeout 10 -m 120 -o "$TMP_FILE" "$API_URL" 2>/dev/null

    # 检查下载是否成功
    if [ $? -ne 0 ] || [ ! -f "$TMP_FILE" ] || [ $(wc -c < "$TMP_FILE") -lt 20480 ]; then
        echo "❌ 第 $i 次下载失败或图片无效，跳过。"
        rm -f "$TMP_FILE" 2>/dev/null
        continue
    fi

    # 在终端预览图片
    echo "🖼️  正在终端预览第 $i 张图片... (按任意键继续)"
    timg -g 80x40 "$TMP_FILE"

    # 询问用户是否保存
    read -p "💾 是否保存这张壁纸？[Y/n]: " choice
    case "$choice" in
        n|N|no|NO)
            echo "🗑️  已取消保存，临时文件已删除。"
            rm -f "$TMP_FILE"
            ;;
        *)
            # 生成正式文件名并移动
            FINAL_NAME="wall_$(date +%Y%m%d_%H%M%S)_$i.jpg"
            FINAL_PATH="$SAVE_DIR/$FINAL_NAME"
            mv "$TMP_FILE" "$FINAL_PATH"
            echo "✅ 已保存: $FINAL_PATH"
            ;;
    esac

    # 如果不是最后一次，加个分隔线
    if [ $i -lt $COUNT ]; then
        echo "──────────────────────────────────────"
    fi
done

echo
echo "🎉 完成！共尝试 $COUNT 次。"

