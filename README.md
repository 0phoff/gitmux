GITMUX <WIP - Dont use>
======
This tmux plugin sets some tmux environment variables with information about the current git repository.  
It is based of [tmux-gitbar](https://github.com/aurelien-rainone/tmux-gitbar), but gives the user more freedom to create his own statusbar with the variables.

## Installation
Install this plugin with [tpm](https://github.com/tmux-plugins/tpm).
  > set -g @plugin '0phoff/gitmux'

## Usage
In your tmux config, you can use the following variables
  - GITMUX_REPO     : This value is non-zero if the current pane is in a git repository
  - GITMUX_BRANCH   : This variable contains the name of the current branch
