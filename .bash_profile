# bash
alias ll='ls -al'
alias l='ls -al'
export VISUAL=nano
export CLICOLOR=1

export PROMPT_COMMAND='pwd2=$(sed "s:\([^/]\)[^/]*/:\1/:g" <<<$PWD)' # prompt short path /Users/ron = /U/r
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
export HISTIGNORE=?:??
shopt -s histappend
export PROMPT_COMMAND="${PROMPT_COMMAND};history -a;history -n;"

# hub (git)
! type hub 2>&1 > /dev/null && echo "install hub - https://github.com/github/hub" || {
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
unset COMPLETION

# ssh hostnames completion based on ~/.ssh/config
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# bash options
for OPT in globstar nocaseglob #cdspell autocd
do	
	shopt -s $OPT 2> /dev/null
done
unset OPT

# other
alias dc='docker-compose'
alias kc='kubectl'

dotfiles_sync() {
	local DOTFILES=".bash_profile .bashrc .tool-versions .hushlogin"
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
