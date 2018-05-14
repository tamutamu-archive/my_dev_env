# use: type_tl "hoge"
function type_tl() {
  stty -echo && xdotool type --clearmodifiers "$1" && stty echo
}

