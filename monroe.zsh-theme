ZSH_THEME_GIT_PROMPT_PREFIX="{"
ZSH_THEME_GIT_PROMPT_SUFFIX="}"
ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red]"
ZSH_THEME_GIT_PROMPT_CLEAN="$fg[green]"

MONROE_RUBY_SHOW=true
MONROE_NVM_SHOW=true
MONROE_SHOW_UNPUSHED=true
MONROE_SHOW_UNMERGED=true
MONROE_SHOW_UNTRACKED=true

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

function monroe_git_untracked_files() {
  if [[ $MONROE_SHOW_UNTRACKED == false ]] then
    return
  fi

  local untracked=`git status --porcelain 2>/dev/null| grep "^??" | wc -l`
  if [ "$untracked" != "0" ]; then
    prompt_segment none red "↭$untracked"
  fi
}

function monroe_git_unpushed_files {
  if [[ $MONROE_SHOW_UNPUSHED == false ]] then
    return
  fi

  # check if we're in a git repo
  [[ "$(command git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]] || return

  if [ $(current_branch)=$(command git name-rev --name-only HEAD 2>/dev/null ) ]; then
    local unpushed=$(git log origin/$(current_branch)..$(current_branch) --oneline &>/dev/null | wc -l)
    local re='^[0-9]+$'
    if [ $unpushed =~ $re ]; then
      if [ $unpushed != "0" ]; then
        prompt_segment none cyan "⇡$unpushed"
      fi
    fi
  fi
}

function monroe_git_unmerged_files {
  if [[ $MONROE_SHOW_UNMERGED == false ]] then
    return
  fi

  # check if we're in a git repo
  [[ "$(command git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]] || return

  local unmerged=`expr $(git branch --no-color --no-merged master &>/dev/null | wc -l)`

  if [ "$unmerged" != "0" ]; then
    prompt_segment none cyan "♆$unmerged"
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
  prompt_segment none red ♦$ruby_prompt
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
  monroe_git_untracked_files
  monroe_git_unpushed_files
  monroe_git_unmerged_files
}


PROMPT='
  $(build_prompt)
  %{$reset_color%}  ⇝ '

