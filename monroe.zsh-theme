ZSH_THEME_GIT_PROMPT_PREFIX="{"
ZSH_THEME_GIT_PROMPT_SUFFIX="}"
ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red]"
ZSH_THEME_GIT_PROMPT_CLEAN="$fg[green]"

MONROE_RUBY_SHOW=true
MONROE_NVM_SHOW=true

# =================

function prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"

  echo -n "%{$bg%}%{$fg%} "
  [[ -n $3 ]] && echo -n $3
}

function monroe_prompt_pc_name() {
  echo -n "$fg[cyan]%m:"
}

function monroe_prompt_dir() {
  local dir=''
  dir="${dir}%4(c:...:)%3c" || dir="${dir}%1~"
  prompt_segment none yellow $dir
}

# Git ----

function monroe_git_dirty() {
  # check if we're in a git repo
  [[ "$(command git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]] || return
  # check if it's dirty
  [[ "$PURE_GIT_UNTRACKED_DIRTY" == 0 ]] && local umode="-uno" || local umode="-unormal"
  command test -n "$(git status --porcelain --ignore-submodules ${umode})"

  if [[ $? == 0 ]]; then
    prompt_segment none red ":("
  else
    prompt_segment none green ":)"
  fi
}

function monroe_git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  prompt_segment none none "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# Ruby ---

function monroe_ruby_version() {
  if [[ $MONROE_RUBY_SHOW == false ]]; then
    return
  fi

  which ruby &> /dev/null || return
  local ruby_prompt
  ruby_prompt=$(echo "$(ruby -e 'print RUBY_VERSION')" )
  ruby_prompt=${ruby_prompt}
  prompt_segment none red "♦ "$ruby_prompt
}

# NVM ---

function monroe_node_version() {
  if [[ $MONROE_NVM_SHOW == false ]] then
    return
  fi

  [[ $(which nvm) != "nvm not found" ]] || return
  local nvm_prompt
  nvm_prompt=$(node -v 2> /dev/null)
  [[ "${nvm_prompt}x" == "x" ]] && return
  nvm_prompt=${nvm_prompt}
  prompt_segment none green "⬡ "$nvm_prompt
}

# Things happen

build_prompt() {
  monroe_prompt_pc_name
  monroe_ruby_version
  monroe_node_version
  monroe_prompt_dir
  monroe_git_prompt_info
  monroe_git_dirty
}


PROMPT='
  $(build_prompt)
  %{$reset_color%}  ⇝ '

