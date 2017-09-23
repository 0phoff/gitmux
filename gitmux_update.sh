#!/bin/bash
#--------------------------------------------------------------------------------------------------------
# GITMUX UPDATE
#--------------------------------------------------------------------------------------------------------
#
# GITMUX UPDATE: Internal file for GITMUX plugin
# By 0phoff
# MIT license
#
#--------------------------------------------------------------------------------------------------------

## HELPER FUNCTIONS
function is_git_repo {
  local is_working_tree=$(git rev-parse --is-inside-work-tree 2> /dev/null)
  if [ "$is_working_tree" == true ]; then
    return 0
  else
    return 1
  fi
}


## MAIN FUNCTION
function main {
    local current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    local dir=$(tmux display -p '#{pane_current_path}')
    cd $dir
    is_git_repo

    if [ $? -eq 0 ]; then   # Git repo
        local git_fields=($("$current_dir/gitstatus.sh" "$dir" 2>/dev/null))

        tmux setenv -g GITMUX_REPO              1 
        tmux setenv -g GITMUX_BRANCH            "${git_fields[0]}"
        tmux setenv -g GITMUX_REMOTE            "${git_fields[1]}"
        tmux setenv -g GITMUX_COMMITS_AHEAD     "${git_fields[2]}"
        tmux setenv -g GITMUX_COMMITS_BEHIND    "${git_fields[3]}"
        tmux setenv -g GITMUX_STAGED            "${git_fields[4]}"
        tmux setenv -g GITMUX_CONFLICTS         "${git_fields[5]}"
        tmux setenv -g GITMUX_CHANGED           "${git_fields[6]}"
        tmux setenv -g GITMUX_UNTRACKED         "${git_fields[7]}"
        tmux setenv -g GITMUX_STASHED           "${git_fields[8]}"
        tmux setenv -g GITMUX_CLEAN             "${git_fields[9]}"
    else                    # No git repo
        tmux setenv -g GITMUX_REPO 0
        tmux setenv -g -u GITMUX_BRANCH
        tmux setenv -g -u GITMUX_REMOTE
        tmux setenv -g -u GITMUX_COMMITS_AHEAD
        tmux setenv -g -u GITMUX_COMMITS_BEHIND
        tmux setenv -g -u GITMUX_STAGED        
        tmux setenv -g -u GITMUX_CONFLICTS     
        tmux setenv -g -u GITMUX_CHANGED       
        tmux setenv -g -u GITMUX_UNTRACKED     
        tmux setenv -g -u GITMUX_STASHED       
        tmux setenv -g -u GITMUX_CLEAN         
    fi

    tmux refresh-client -S
}

main
