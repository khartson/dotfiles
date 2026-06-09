# ==========================================
# History Configurations
# ==========================================
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
setopt APPEND_HISTORY
setopt SHARE_HISTORY

# ==========================================
# Keybindings & Completions
# ==========================================
# Enable Vi-mode keybindings
bindkey -v

autoload -Uz compinit 
compinit 

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive completion

# ==========================================
# Path Adjustments
# ==========================================
# Safely prepend baseline local binary paths if they exist
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# ==========================================
# Prompt Initialization
# ==========================================
# Initialize the Starship cross-shell prompt environment
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi