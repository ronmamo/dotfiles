# bash
alias ll='ls -al'
alias l='ls -al'
export VISUAL=nano

PROMPT_COMMAND='pwd2=$(sed "s:\([^/]\)[^/]*/:\1/:g" <<<$PWD)'
export PS1='ॐ  $pwd2 \$ '

# asdf
[ ! -e ~/.asdf ] && echo "install asdf - https://github.com/asdf-vm/asdf" || {
	[ -e ~/.tool-versions ] || echo "install asdf plugins and versions"
	. ~/.asdf/asdf.sh
	. ~/.asdf/completions/asdf.bash
}

# fzf
[ ! -e ~/.fzf ] && echo "install fzf - https://github.com/junegunn/fzf" || {
	. ~/.fzf.bash
	export FZF_COMPLETION_TRIGGER='**' # i.e. cd **<TAB>
}

# bash history
export HISTSIZE=100000
export HISTFILESIZE=100000
shopt -s histappend
export PROMPT_COMMAND="${PROMPT_COMMAND};history -a;history -n;"

# hub (git)
! type hub 2&>1 /dev/null && echo "install hub - https://github.com/github/hub" || {
	alias git=hub
}

# brew shell completion - https://docs.brew.sh/Shell-Completion
if type brew &>/dev/null; then
  for COMPLETION in $(brew --prefix)/etc/bash_completion.d/*
  do
    [[ -f $COMPLETION ]] && source "$COMPLETION"
  done
  if [[ -f $(brew --prefix)/etc/profile.d/bash_completion.sh ]];
  then
    source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
  fi
fi

# docker
alias dc='docker-compose'

dotfiles_sync() {
	local DOTFILES=".bash_profile .tool-versions"
	local GITREPO=https://github.com/ronmamo/dotfiles
	local WORKDIR=~/.dotfiles
	rm -rf $WORKDIR || true
	git clone $GITREPO $WORKDIR
	cd $WORKDIR
	for FILE in $DOTFILES; do cp -f ~/$FILE .; done
	git add .; git commit -am "dotfiles_sync $(date +%m-%d-%y)"; git push 
	cd -
	rm -rf $WORKDIR
}
