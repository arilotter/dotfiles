#{{{ Make sure you get tmuxed
#	if [[ ! $TERM =~ screen ]]; then
#		exec tmux
#	fi
#}}}


#{{{ Antigen stuff
	source ~/src/antigen/antigen.zsh

	antigen use oh-my-zsh #woo

	antigen bundle zsh-users/zsh-syntax-highlighting
	antigen bundle git
	antigen bundle pip
	antigen bundle command-not-found
	antigen bundle sharat87/autoenv
	antigen bundle virtualenv
	antigen theme ari
	antigen apply

#}}}

#{{{ Useful settings stuff
	# i think this fixes shit
	export TERM=rxvt-unicode
	
	# set dat PATH
	export PATH="/home/ari/bin:/home/ari/games:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"

	# en_CA sucks
	export LANG=en_US.UTF-8

	# 10 second wait if you do something that will delete everything.  I wish I'd had this before...
	setopt RM_STAR_WAIT

	# hella master race
	export EDITOR="nano"

	# i think this is useful ??
	setopt IGNORE_EOF
#}}}

#{{{ Completion stuff
	# Faster! (?)
	zstyle ':completion::complete:*' use-cache 1


	# case insensitive completion
	zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

	zstyle ':completion:*' verbose yes
	zstyle ':completion:*:descriptions' format '%B%d%b'
	zstyle ':completion:*:messages' format '%d'
	zstyle ':completion:*:warnings' format 'No matches for: %d'
	zstyle ':completion:*' group-name ''
	#zstyle ':completion:*' completer _oldlist _expand  _complete
	zstyle ':completion:*' completer _expand  _complete _approximate _ignored

	# generate descriptions with magic.
	zstyle ':completion:*' auto-description 'specify: %d'

	# Don't prompt for a huge list, page it!
	zstyle ':completion:*:default' list-prompt '%S%M matches%s'

	# Don't prompt for a huge list, menu it!
	zstyle ':completion:*:default' menu 'select=0'

	# Have the newer files last so I see them first
	zstyle ':completion:*' file-sort modification reverse

	# color code completion!!!!  Wohoo!
	zstyle ':completion:*' list-colors "=(#b) #([0-9]#)*=36=31"

	unsetopt LIST_AMBIGUOUS
	setopt  COMPLETE_IN_WORD

	# Separate man page sections.  Neat.
	zstyle ':completion:*:manuals' separate-sections true

	# Egomaniac!
	zstyle ':completion:*' list-separator 'fREW'

	# complete with a menu for xwindow ids
	zstyle ':completion:*:windows' menu on=0
	zstyle ':completion:*:expand:*' tag-order all-expansions

	# more errors allowed for large words and fewer for small words
	zstyle ':completion:*:approximate:*' max-errors 'reply=(  $((  ($#PREFIX+$#SUFFIX)/3  ))  )'

	# Errors format
	zstyle ':completion:*:corrections' format '%B%d (errors %e)%b'

	# Don't complete stuff already on the line
	zstyle ':completion::*:(rm|vi):*' ignore-line true

	# Don't complete directory we are already in (../here)
	zstyle ':completion:*' ignore-parents parent pwd

	zstyle ':completion::approximate*:*' prefix-needed false
#}}}


#{{{ Key bindings
	# Who doesn't want home and end to work?
	bindkey '\e[1~' beginning-of-line
	bindkey '\e[4~' end-of-line

	# Ensure that arrow keys work as they should
	bindkey '\e[A' up-line-or-history
	bindkey '\e[B' down-line-or-history

	bindkey '\eOA' up-line-or-history
	bindkey '\eOB' down-line-or-history

	bindkey '\e[C' forward-char
	bindkey '\e[D' backward-char

	bindkey '\eOC' forward-char
	bindkey '\eOD' backward-char

	# Rebind the insert key. 
	bindkey '\e[2~' overwrite-mode

	# Rebind the delete key. hella useful
	bindkey '\e[3~' delete-char

	# it's like, space AND completion.  Gnarlbot.
	bindkey -M viins ' ' magic-space
	
	# alt-s to insert sudo at the start of the line. HELLA USEFUL.
	insert_sudo () { zle beginning-of-line; zle -U "sudo " }
	zle -N insert-sudo insert_sudo
	bindkey "^[s" insert-sudo
#}}}


#{{{ History Stuff
	# Where it gets saved
	HISTFILE=~/.history

	# Remember about a years worth of history (AWESOME)
	SAVEHIST=10000
	HISTSIZE=10000

	# Don't overwrite, append!
	setopt APPEND_HISTORY

	# Write after each command
	# setopt INC_APPEND_HISTORY

	# Killer: share history between multiple shells
	setopt SHARE_HISTORY

	# If I type cd and then cd again, only save the last one
	setopt HIST_IGNORE_DUPS

	# Even if there are commands inbetween commands that are the same, still only save the last one
	setopt HIST_IGNORE_ALL_DUPS

	# Pretty    Obvious.  Right?
	setopt HIST_REDUCE_BLANKS

	# If a line starts with a space, don't save it.
	setopt HIST_IGNORE_SPACE
	setopt HIST_NO_STORE

	# When using a hist thing, make a newline show the change before executing it.
	setopt HIST_VERIFY

	# Save the time and how long a command ran
	setopt EXTENDED_HISTORY

	setopt HIST_SAVE_NO_DUPS
	setopt HIST_EXPIRE_DUPS_FIRST
	setopt HIST_FIND_NO_DUPS
#}}}

#{{{ function stuff
	function chpwd() {
	    emulate -L zsh
	    ls
	}

	function getip() {
		echo $(ip route get 8.8.8.8 | awk '/8.8.8.8/ {print $NF}')
	}

	# print a fractal (hella useless)
	function fractal {
	   local lines columns colour a b p q i pnew
	   ((columns=COLUMNS-1, lines=LINES-1, colour=0))
	   for ((b=-1.5; b<=1.5; b+=3.0/lines)) do
		   for ((a=-2.0; a<=1; a+=3.0/columns)) do
			   for ((p=0.0, q=0.0, i=0; p*p+q*q < 4 && i < 32; i++)) do
				   ((pnew=p*p-q*q+a, q=2*p*q+b, p=pnew))
			   done
			   ((colour=(i/4)%8))
				echo -n "\\e[4${colour}m "
			done
			echo
		done
	}

	# URL encode something and print it.
	function urlencode() {
		perl -lpe 's/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg'
	}

	# Search google for the given keywords.
	function google {
		w3m "http://www.google.com/search?q=`echo "${(j: :)@}" | urlencode`"
	}
	# quick n easy git commit
	function commit {
		git commit -am "$(curl -s "http://whatthecommit.com/index.txt")"
	}

#}}}
#{{{ aliases


	#My Aliases
	alias mktar="tar -cvf"
	alias mkbz2="tar -cvjf"
	alias mkgz="tar -cvzf"
	alias untar="tar -xvf"
	alias unbz2="tar -xvjf"
	alias ungz="tar -xvzf"
	alias apt-getupgrade="sudo apt-get update && sudo apt-get upgrade"
	alias apt-getdist="sudo apt-get update && sudo apt-get dist-upgrade"
	alias shh="echo It\'s ssh, not ssh, you idiot."

	alias sparky="ssh pi@192.168.1.139"

        alias copy="xclip -selection c"
        alias paste="xclip -selection c -o"
	alias reload_zsh="source ~/.zshrc"
	alias mixer="alsamixer"
#}}}


#{{{ Welcome yourself ;P
	toilet "Welcome, $(whoami)." -w 120 -f future
	ls
#}}}

######################################
# REMOVE THIS BEFORE YOU CLOSE SHELL #
######################################
#exit
