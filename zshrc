# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

plugins=(
  git
  #autojump
  zsh-autosuggestions
  zsh-syntax-highlighting
  #zsh-vi-mode
  yarn
  #web-search
  #jsontools
  #osx
  sudo
  docker
)

source $ZSH/oh-my-zsh.sh

# (Vim-like) bindings
bindkey '^k' up-history
bindkey '^j' down-history
bindkey '^n' expand-or-complete
bindkey '^p' reverse-menu-complete
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word

# Powerlevel 9k Theme Customization

# Elements options of left prompt (remove the @username context)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(host dir rbenv vcs)

# Elements options of right prompt
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)

# Add a second prompt line for the command
POWERLEVEL9K_PROMPT_ON_NEWLINE=false

# Add a space in the first prompt
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%f"

# Change the git status to red when something isn't committed and pushed
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='red'

# Add a new line after the global prompt
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
