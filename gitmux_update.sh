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

function get_branch {
   echo $(git symbolic-ref --short HEAD)
}


## MAIN FUNCTION
function main {
    is_git_repo
    if [ $? -eq 0 ]; then   # Git repo
        tmux setenv GITMUX_REPO 1 
        tmux setenv GITMUX_BRANCH $(get_branch)
    else                    # No git repo
        tmux setenv GITMUX_REPO 0
        tmux setenv -u GITMUX_BRANCH
    fi
}

main
