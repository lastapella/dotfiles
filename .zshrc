eval "$(starship init zsh)"
 #Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nvim'
 else
   export EDITOR='nvim'
 fi
export EDITOR='nvim' 

# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-history-substring-search"
# plug "zsh-users/zsh-completions"
plug "marlonrichert/zsh-autocomplete"
# plug "zap-zsh/supercharge"
# plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"
plug "felixr/docker-zsh-completion"

bindkey -e
# Keybinding for autocomplete
bindkey '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
bindkey -M menuselect  '^[[D' .backward-char  '^[OD' .backward-char
bindkey -M menuselect  '^[[C'  .forward-char  '^[OC'  .forward-char

# Keybinding for history
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

source ~/.zsh.d/completions/docker.zsh
source ~/.zsh.d/completions/az
source ~/.zsh.d/completions/git.zsh
source ~/.zsh.d/completions/directories.zsh
source $HOME/.aliases

export PATH="$PATH:/usr/local/go/bin:$HOME/.zsh.d/bin/script:$HOME/bin"

# Load and initialise completion system
autoload -Uz compinit && compinit
# _ZO_ECHO=1
eval "$(zoxide init zsh  --cmd cd)"
# zoxide add $(find ${TMS_DIRS[@]} -mindepth 1 -maxdepth 1 -type d -not -name hooks -not -name info -not -name refs -not -name objects -not -name worktrees -not -name logs)
# zoxide add $TMS_ADDITIONAL_DIRS
if [ "$TMUX" = "" ]; then tmux; fi
