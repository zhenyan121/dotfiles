#!/usr/bin/env bash

# 配置
API_URL="http://localhost:2023/graphql"
TOKEN=""
CURL_OPTS=(-s -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN")

# 图标 (需要 Nerd Font)
ICON_RUNNING="󰔡"
ICON_STOPPED="󰨙"

# 检查 jq
if ! command -v jq &> /dev/null; then
    echo '{"text": "⚠️", "tooltip": "jq not installed", "class": "error"}'
    exit 1
fi

# 获取当前运行状态
get_status() {
    QUERY_JSON='{"query":"query { general { dae { running } } }"}'
    RESPONSE=$(curl "${CURL_OPTS[@]}" -d "$QUERY_JSON" "$API_URL" 2>/dev/null)
    
    # 提取 running 字段，直接取值，不添加 // empty
    RUNNING=$(echo "$RESPONSE" | jq -r '.data.general.dae.running' 2>/dev/null)
    
    if [ "$RUNNING" = "null" ] || [ -z "$RUNNING" ]; then
        echo "error"
    else
        echo "$RUNNING"
    fi
}

# 切换状态
toggle() {
    CURRENT=$(get_status)
    if [ "$CURRENT" = "error" ]; then
        echo "error"
        return
    fi
    
    # dry: true 停止, false 启动
    if [ "$CURRENT" = "true" ]; then
        DRY_VALUE="true"
    else
        DRY_VALUE="false"
    fi
    
    MUTATION_JSON="{\"query\":\"mutation Run(\$dry: Boolean!) { run(dry: \$dry) }\",\"variables\":{\"dry\":$DRY_VALUE},\"operationName\":\"Run\"}"
    curl "${CURL_OPTS[@]}" -d "$MUTATION_JSON" "$API_URL" > /dev/null 2>&1
}

# 输出 Waybar 格式
output_waybar() {
    STATUS=$(get_status)
    
    if [ "$STATUS" = "error" ]; then
        echo '{"text": "󰤫", "tooltip": "dae API 连接失败", "class": "error"}'
        return
    fi
    
    if [ "$STATUS" = "true" ]; then
        echo "{\"text\": \"$ICON_RUNNING\", \"tooltip\": \"dae 正在运行\", \"class\": \"running\"}"
    else
        echo "{\"text\": \"$ICON_STOPPED\", \"tooltip\": \"dae 已停止\", \"class\": \"stopped\"}"
    fi
}

# 主入口
case "$1" in
    toggle)
        toggle
        output_waybar
        ;;
    status)
        output_waybar
        ;;
    *)
        output_waybar
        ;;
esac
