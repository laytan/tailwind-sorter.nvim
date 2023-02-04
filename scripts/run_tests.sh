#!/usr/bin/env bash

if [[ ! -d ~/.local/share/nvim/site/pack/ci/opt ]]
then
  mkdir -p ~/.local/share/nvim/site/pack/ci/opt
fi

if [[ ! -d ~/.local/share/nvim/site/pack/ci/opt/plenary.nvim ]]
then
  git clone https://github.com/nvim-lua/plenary.nvim ~/.local/share/nvim/site/pack/ci/opt/plenary.nvim
fi

if [[ ! -d ~/.local/share/nvim/site/pack/ci/opt/nvim-treesitter ]]
then
  git clone https://github.com/nvim-treesitter/nvim-treesitter ~/.local/share/nvim/site/pack/ci/opt/nvim-treesitter
fi

# Credit to nvim-treesitter/nvim-treesitter for the rest of this script.

HERE="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
cd $HERE/..

run() {
    nvim --headless --noplugin -u tests/minimal_init.lua \
        -c "PlenaryBustedDirectory $1 { minimal_init = './tests/minimal_init.lua' }"
}

if [[ $2 = '--summary' ]]; then
    ## really simple results summary by filtering plenary busted output
    run tests/$1  2> /dev/null | grep -E '^\S*(Testing|Success|Failed|Errors)\s*:'
else
    run tests/$1
fi
