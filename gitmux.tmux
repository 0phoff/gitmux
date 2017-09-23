#!/bin/bash
#!/usr/bin/bash
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
GITMUX_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Install gitmux_update
tmux set-hook -g window-pane-changed    "run-shell \"$GITMUX_DIR/gitmux_update.sh\""
tmux set-hook -g session-window-changed "run-shell \"$GITMUX_DIR/gitmux_update.sh\""
tmux set-hook -g client-session-changed "run-shell \"$GITMUX_DIR/gitmux_update.sh\""

tmux setenv -g GITMUX_SCRIPT "$GITMUX_DIR/gitmux_update.sh"
tmux source "$GITMUX_DIR/gitmux.conf"
