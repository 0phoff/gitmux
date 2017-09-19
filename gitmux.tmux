#!/bin/bash
#--------------------------------------------------------------------------------------------------------
# GITMUX
#--------------------------------------------------------------------------------------------------------
#
# GITMUX : Tmux plugin to get information about git repository
# By 0phoff
# MIT license
#
#--------------------------------------------------------------------------------------------------------
#
# Usage:  - set -g @plugin '0phoff/gitmux'
#
#--------------------------------------------------------------------------------------------------------

# Current directory
if-shell 'test -z ${GITMUX_DIR}' \
    'GITMUX_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"'

# Install gitmux_update as a prompt command
if-shell 'echo $PROMPT_COMMAND | grep -qv gitmux_update' \
  'PROMPT_COMMAND="$PROMPT_COMMAND; $GITMUX_DIR/gitmux_update.sh"'
