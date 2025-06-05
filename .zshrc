# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="$PATH:$HOME/go/bin:$HOME/.bin"
export TERM="screen-256color"
export ZSH="$HOME/.oh-my-zsh"
export LD_SDK

export FEATURE_FLAG_MODE=ENABLED
export LD_SDK_KEY="sdk-2f7e2884-a74b-4505-a5f5-50b94f31fab3"

DISABLE_AUTO_TITLE="true"

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor root line)
ZSH_HIGHLIGHT_PATTERNS=(
	'rm -rf *' 'fg=white,bold,bg=red'
)

ZSH_AUTOSUGGEST_STRATEGY=(history)

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
	aws
	brew
	colorize
	git
	git-extras
	fzf
	node
	npm
	macos
	tmux
	z
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

export EDITOR=nvim
if type nvim > /dev/null 2>&1; then 
	alias vim='nvim'
fi

bindkey -v 
export KEYTIMEOUT=20
bindkey -M viins '^u' vi-cmd-mode
bindkey '^ ' autosuggest-accept

zstyle ':completion:*' menu select
zmodload zsh/complist

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# TODO: RangerCD setup
rangercd() {
	temp="$(mktemp)"
	ranger --choosedir="$temp" "$@"
	if [ -f "$temp" ]; then 
		dir="$(cat $temp)"
		rm -rf "$temp"
		[ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
	fi
}
bindkey -s '^o' 'rangercd\n'

alias lc=listclasses
alias tw=timewrap

export WORK_HOME="$HOME/Desktop/Code/Work"
export TOOLS_HOME="$WORK_HOME/tools"

export PATH="$PATH:$TOOLS_HOME/bin"

alias wk="cd $WORK_HOME"
alias be="cd $WORK_HOME/backend"
alias fe="cd $WORK_HOME/frontend"
alias api="cd $WORK_HOME/apis"

bindkey -s '^[6' 'aws_vpn toggle\n'
bindkey -s '^[7' 'osc_token fetch\n'
bindkey -s '^[8' 'source osc_cust_env\n'
bindkey -s '^[9' 'source osc_env\n'
bindkey -s '^[0' 'source clear_osc_env\n'

export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
autoload edit-command-line; zle -N edit-command-line 
bindkey '^e' edit-command-line

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


export RBENV_ROOT="$HOME/.rbenv"
[[ -d $RBENV_ROOT/bin ]] && export PATH="$RBENV_ROOT/bin:$PATH"
eval "$(rbenv init -)"

export JABBA_ROOT="$HOME/.jabba"
[ -s "$JABBA_ROOT/jabba.sh" ] && source "$JABBA_ROOT/jabba.sh"

eval "$(fzf --zsh)"

# pnpm
export PNPM_HOME="/Users/joshuahamill/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export CONFLUENT_HOME="/Users/joshuahamill/confluent-7.9.0"
export PATH="$PATH:$CONFLUENT_HOME/bin"

[ -s "$WORK_HOME/deployer/deployer_completion" ] && \. "$WORK_HOME/deployer/deployer_completion"

eval "$(gs shell completion zsh)"
eval "$(k3d completion zsh)"
eval "$(zoxide init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


