export TERM="xterm-256color"      # sbasile: added as warned by zsh itslef at login
setopt HIST_FIND_NO_DUPS          # sbasile: imported the BASH equivalent (export HISTCONTROL=ignoredups)

# sbasile: the following 2 bindkey are used to have ^R seraching reverse in history
bindkey -v
bindkey '^R' history-incremental-search-backward

export HISTSIZE=100000
export SAVEHIST=$HISTSIZE
# sbasile: Appends every command to the history file once it is executed
setopt inc_append_history
# sbasile: Reloads the history whenever you use it
setopt share_history

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="robbyrussell"    sbasile: commented
#ZSH_THEME="agnoster"         sbasile: tried this one, and it seems to work
ZSH_THEME="powerlevel9k/powerlevel9k"


#------------------ [START] configuration for  powerlevel9k/powerlevel9k
#source ~/.fonts/*.sh
#POWERLEVEL9K_MODE='awesome-fontconfig'
#POWERLEVEL9K_MODE='awesome-patched'
POWERLEVEL9K_MODE='nerdfont-complete'

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(status history ip context dir vcs)
#POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_DISABLE_RPROMPT=true

POWERLEVEL9K_PROMPT_ON_NEWLINE=true      # prompt on 2nd line
#POWERLEVEL9K_RPROMPT_ON_NEWLINE=true     # command result (on right) also on 2nd line
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true     # separates prompts lines with 1 empty line

POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_unique"

#POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='blue'
#POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='black'
#POWERLEVEL9K_IP_FOREGROUND='236'
#POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND='069'
#POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND='237'
#POWERLEVEL9K_DIR_HOME_BACKGROUND='008'
#POWERLEVEL9K_DIR_HOME_FOREGROUND='231'
#POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='008'
#POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='231'
#POWERLEVEL9K_VCS_CLEAN_BACKGROUND='189'
#POWERLEVEL9K_VCS_CLEAN_FOREGROUND='022'
##POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='157'
#POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='189'
#POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='166'
#POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='189'
#POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='141'

#DEFAULT_BACKGROUND='black'
DEFAULT_BACKGROUND='234'
DEFAULT_FOREGROUND='226'
POWERLEVEL9K_IP_BACKGROUND=$DEFAULT_BACKGROUND
POWERLEVEL9K_IP_FOREGROUND=$DEFAULT_FOREGROUND
POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND=$DEFAULT_BACKGROUND
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND=$DEFAULT_FOREGROUND
POWERLEVEL9K_DIR_HOME_BACKGROUND=$DEFAULT_BACKGROUND
POWERLEVEL9K_DIR_HOME_FOREGROUND=$DEFAULT_FOREGROUND
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND=$DEFAULT_BACKGROUND
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND=$DEFAULT_FOREGROUND
POWERLEVEL9K_VCS_CLEAN_BACKGROUND=$DEFAULT_BACKGROUND
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='157'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=$DEFAULT_BACKGROUND
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='214'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=$DEFAULT_BACKGROUND
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='141'

# --->  for code ({000..255}) print -P -- "$code: %F{$code}This is how your text would look like%f"  <-- paste in terminal to see all the colors
#------------------ [END] configuration for  powerlevel9k/powerlevel9k
#_______________ Using fd with fzf
#export FZF_DEFAULT_COMMAND='fd --type file --color=always'
#export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
#export FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"


#<FZF>
# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/usr/local/opt/fzf/shell/key-bindings.zsh"
#</FZF>

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=100   # default 20

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#---------- [START] my aliases / exports / functions
unalias -m '*'                    # first remove all other aliases
source ${HOME}/_shell.aliases.sh  # then load my ones
source ${HOME}/_shell.exports.sh
source ${HOME}/_shell.functions.sh

#---------- [END] my aliases / exports / functions
bindkey -v     # vi mode for command line


