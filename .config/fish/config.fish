fundle plugin 'tuvistavie/fish-ssh-agent'
fundle plugin 'rafaelrinaldi/pure'
fundle plugin 'fisherman/z'

function draw_line --on-event fish_postexec
  set_color brblack; stty size | perl -ale 'print "─"x$F[1]'
end

set -gx VISUAL code-oss
set -gx QT_AUTO_SCREEN_SCALE_FACTOR 1
alias pbpaste "xclip -selection clipboard -o"
alias pbcopy "xclip -selection clipboard -i"
alias netcopy "nc -q 0 tcp.st 7777 | grep URL | cut -d ' ' -f 2 | pbcopy"
alias icat="kitty +kitten icat"

alias google-chrome "google-chrome-stable"
alias chrome "google-chrome"

alias reload-fish "exec fish"
alias fix-bluetooth-audio "pacmd set-card-profile (pacmd list-sinks | sed -n 's/card: \([0-9]*\) <bluez.*/\1/p' | xargs) a2dp_sink"

set -gx PATH ~/go/bin ~/src/devops/skyweaver ~/.npm-global/bin ~/.local/bin ~/bin $PATH

fundle init

# cat ~/.cache/wal/sequences
