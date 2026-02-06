#语法检查和高亮
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#开启tab上下左右选择补全
zstyle ':completion:*' menu select
autoload -Uz compinit
compinit

# 设置历史记录文件的路径
HISTFILE=~/.zsh_history

# 设置在会话（内存）中和历史文件中保存的条数，建议设置得大一些
HISTSIZE=1000
SAVEHIST=1000

# 忽略重复的命令，连续输入多次的相同命令只记一次
setopt HIST_IGNORE_DUPS

# 忽略以空格开头的命令（用于临时执行一些你不想保存的敏感命令）
setopt HIST_IGNORE_SPACE

# 在多个终端之间实时共享历史记录 
# 这是实现多终端同步最关键的选项
setopt SHARE_HISTORY

# 让新的历史记录追加到文件，而不是覆盖
setopt APPEND_HISTORY
# 在历史记录中记录命令的执行开始时间和持续时间
setopt EXTENDED_HISTORY

# 如果 TERM 变量不是 "linux"，说明不在 TTY 中
if [[ "$TERM" != "linux" ]]; then

    alias ls='eza --icons'
    # End of lines added by compinstall
    eval "$(starship init zsh)"
fi

# 针对 TTY 环境自动切换为英文，避免中文乱码
if [[ "$TERM" == "linux" ]]; then
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    export LANGUAGE=en_US:en
    alias ls='eza'
fi
eval "$(zoxide init zsh)"
alias cat='bat'
alias cd='z'  # 或保留 cd，同时用 z 快速跳转
