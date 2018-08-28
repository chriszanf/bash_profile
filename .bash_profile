#  ---------------------------------------------------------------------------
#  Description:  This file holds all my BASH configurations and aliases
#
#  Forked from Nathaniel Landau https://natelandau.com/my-mac-osx-bash_profile
#
#  Sections:
#  1.   Environment Configuration
#  2.	  Terminal Improvements
#  3. 	Folder and File management
#  4.	  Searching
#  5.	  Process Management
#. 6. 	Networking
#  ---------------------------------------------------------------------------


#   -------------------------------
#   1.  ENVIRONMENT CONFIGURATION
#   -------------------------------

#	Export TERM
export TERM=xterm-color

#   Change Prompt
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "

#   Set Default Editor (change 'Nano' to the editor of your choice)
export EDITOR=/usr/bin/nano

#   Set default blocksize for ls, df, du
export BLOCKSIZE=1k

#   Add color to terminal
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

#   Source ~/.bashrc
source ~/.bashrc

#   Set Paths
export PATH="$PATH:/usr/local/bin"
export PATH="/usr/local/git/bin:/sw/bin:/usr/local:/usr/local/sbin:/usr/local/mysql/bin:$PATH"

#   -----------------------------
#   2.  TERMINAL IMPROVEMENTS
#   -----------------------------

alias cp='cp -iv'                                                                         # Preferred 'cp' implementation
alias mv='mv -iv'                                                                         # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                                                                   # Preferred 'mkdir' implementation
alias ll='ls -FGlAhp'                                                                     # Preferred 'ls' implementation
alias less='less -FSRXc'                                                                  # Preferred 'less' implementation
alias f='open -a Finder ./'                                                               # Opens current directory in MacOS Finder
alias ~="cd ~"                                                                            # ~:            Go Home
alias c='clear'                                                                           # c:            Clear terminal display
alias which='type -all'                                                                   # which:        Find executables
alias path='echo -e ${PATH//:/\\n}'                                                       # path:         Echo all executable Paths
alias show_options='shopt'                                                                # Show_options: display bash options settings
alias fix_stty='stty sane'                                                                # fix_stty:     Restore terminal settings when screwed up
alias cic='set completion-ignore-case On'                                                 # cic:          Make tab-completion case-insensitive
alias pyjss='jss_helper -v'																  # JSS Python alias
alias appVer='mdls -name kMDItemVersion' 												  # appVer:			Followed by path/to/app gives app version
alias macModel=$(system_profiler SPHardwareDataType | grep "Model Identifier" | awk '{ print $3; }')
alias activeFont=$(system_profiler SPFontsDataType | grep -i "Full Name" | awk '{$1=$2=""; print $0}')
alias cls=$(clear)
alias claer='clear'
alias clr='clear' 																		  # cls: claer: clr: 3 ways of clearing the CLi

# The following are additonal apps added after reading: https://remysharp.com/2018/08/23/cli-improved
# Brew command:
# brew install bat prettyping fzf glances diff-so-fancy fd nnn tldr ack ag jq

alias cat='bat'
alias ping='prettyping --nolegend'
alias top='glances'
alias du="ncdu --color dark -rr -x --exclude .git --exclude node_modules"
alias help='tldr'
alias preview="fzf --preview 'bat --color \"always\" {}'"
# add support for ctrl+o to open selected file in VS Code
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort'"

#   lr:  Full Recursive Directory Listing
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

# Directory Navigation
alias cd..='cd ../'                                                                       # Go back 1 directory level (for fast typers)
alias ..='cd ../'                                                                         # Go back 1 directory level
alias ...='cd ../../'                                                                     # Go back 2 directory levels
alias .3='cd ../../../'                                                                   # Go back 3 directory levels
alias .4='cd ../../../../'                                                                # Go back 4 directory levels
alias .5='cd ../../../../../'                                                             # Go back 5 directory levels
alias .6='cd ../../../../../../'                                                          # Go back 6 directory levels


#   -----------------------------
#      TERMINAL FUNCTIONS
#   -----------------------------

mcd() { mkdir -p "$1" && cd "$1"; }                                                       # mcd:          Makes new Dir and jumps inside
trash() { command mv "$@" ~/.Trash; }                                                     # trash:        Moves a file to the MacOS trash
ql() { qlmanage -p "$*" >&/dev/null; }                                                    # ql:           Opens any file in MacOS Quicklook Preview
appV() { mdls -name kMDItemVersion "$*"; }                                                # appV: 		  Gets the version of any app in path provided
cd() { builtin cd "$@"
  ll
}
																						  # Always list directory contents upon 'cd'
#   mans: Example: mans mplayer codec
mans() {
  man $1 | grep -iC2 --color=always $2 | less
}

#	Check SHA1 with value in clipboard
shachk() {
  [[ $(pbpaste) == $(shasum "$@" | awk '{print $1}') ]] &&
    echo $1 == $(pbpaste) $'\e[1;32mMATCHES\e[0m' && return
  echo $1 != $(pbpaste) $'\e[1;31mFAILED\e[0m'
}
#   showa: to remind yourself of an alias (given some part of it)
showa() { /usr/bin/grep --color=always -i -a1 $@ ~/Library/init/bash/aliases.bash | grep -v '^\s*$' | less -FSRXc; }


#   -------------------------------
#   3.  FILE AND FOLDER MANAGEMENT
#   -------------------------------

zipf() { zip -r "$1".zip "$1"; }       # zipf:         To create a ZIP archive of a folder
alias numFiles='echo $(ls -1 | wc -l)' # numFiles:     Count of non-hidden files in current dir
alias make1mb='mkfile 1m ./1MB.dat'    # make1mb:      Creates a file of 1mb size (all zeros)
alias make5mb='mkfile 5m ./5MB.dat'    # make5mb:      Creates a file of 5mb size (all zeros)
alias make10mb='mkfile 10m ./10MB.dat' # make10mb:     Creates a file of 10mb size (all zeros)

#   cdf:   to frontmost window of MacOS Finder
#   ------------------------------------------------------
cdf() {
  currFolderPath=$(
    /usr/bin/osascript <<EOT
            tell application "Finder"
                try
            set currFolder to (folder of the front window as alias)
                on error
            set currFolder to (path to desktop folder as alias)
                end try
                POSIX path of currFolder
            end tell
EOT
  )
  echo "cd to \"$currFolderPath\""
  cd "$currFolderPath"
}

#   extract:  Extract most know archives with one command
#   ---------------------------------------------------------
extract() {
  if [ -f $1 ]; then
    case $1 in
    *.tar.bz2) tar xjf $1 ;;
    *.tar.gz) tar xzf $1 ;;
    *.bz2) bunzip2 $1 ;;
    *.rar) unrar e $1 ;;
    *.gz) gunzip $1 ;;
    *.tar) tar xf $1 ;;
    *.tbz2) tar xjf $1 ;;
    *.tgz) tar xzf $1 ;;
    *.zip) unzip $1 ;;
    *.Z) uncompress $1 ;;
    *.7z) 7z x $1 ;;
    *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}


#   ---------------------------
#   4.  SEARCHING
#   ---------------------------

alias qfind="find . -name "              # qfind:    Quickly search for file
ff() { /usr/bin/find . -name "$@"; }     # ff:       Find file under the current directory
ffs() { /usr/bin/find . -name "$@"'*'; } # ffs:      Find file whose name starts with a given string
ffe() { /usr/bin/find . -name '*'"$@"; } # ffe:      Find file whose name ends with a given string

#   spotlight: Search for a file using MacOS Spotlight's metadata
#   -----------------------------------------------------------
spotlight() { mdfind "kMDItemDisplayName == '$@'wc"; }


#   ---------------------------
#   5.  PROCESS MANAGEMENT
#   ---------------------------

#   findPid: find out the pid of a specified process
#   -----------------------------------------------------
#       Note that the command name can be specified via a regex
#       E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
#       Without the 'sudo' it will only find processes of the current user
#   -----------------------------------------------------
findPid() { lsof -t -c "$@"; }

#   memHogsTop, memHogsPs:  Find memory hogs
#   -----------------------------------------------------
alias memHogsTop='top -l 1 -o rsize | head -20'
alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

#   cpuHogs:  Find CPU hogs
#   -----------------------------------------------------
alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

#   topForever:  Continual 'top' listing (every 10 seconds)
#   -----------------------------------------------------
alias topForever='top -l 9999999 -s 10 -o cpu'

#   ttop:  Recommended 'top' invocation to minimize resources
#   ------------------------------------------------------------
#       Taken from this macosxhints article
#       http://www.macosxhints.com/article.php?story=20060816123853639
#   ------------------------------------------------------------
alias ttop="top -R -F -s 10 -o rsize"

#   my_ps: List processes owned by my user:
#   ------------------------------------------------------------
my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command; }


#   ---------------------------
#   6.  NETWORKING
#   ---------------------------

# flushDNS:     Flush out the DNS Cache
alias flushDNS='dscacheutil -flushcache && sudo killall -HUP mDNSResponder'
alias myip='dig +short myip.opendns.com @resolver1.opendns.com' # myip:         Public facing IP Address
alias netCons='lsof -i'                                         # netCons:      Show all open TCP/IP sockets
alias lsock='sudo /usr/sbin/lsof -i -P'           # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP' # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP' # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'            # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'            # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'      # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                # showBlocked:  All ipfw rules inc/ blocked IPs

#   ii:  display useful host related informaton
#   -------------------------------------------------------------------
ii() {
  echo -e "\nYou are logged on ${RED}$HOST"
  echo -e "\nAdditionnal information:$NC "
  uname -a
  echo -e "\n${RED}Users logged on:$NC "
  w -h
  echo -e "\n${RED}Current date :$NC "
  date
  echo -e "\n${RED}Machine stats :$NC "
  uptime
  echo -e "\n${RED}Current network location :$NC "
  scselect
  echo -e "\n${RED}Public facing IP Address :$NC "
  myip
  #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
  echo
}
