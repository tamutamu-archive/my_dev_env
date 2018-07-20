export FZF_DEFAULT_OPTS="--reverse --inline-info"


### git checkout
__fbr__() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //") > /dev/null
}
bind '"\eb": " \C-e\C-u`__fbr__`\e\C-e\er\C-m"'
#bind '"\eb": " \C-e\C-u\C-y\ey\C-u`__fbr__`\e\C-e\er\e^"'



### git log
__fshow__() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}
bind '"\e\C-n": " \C-e\C-u__fshow__\C-m"'
