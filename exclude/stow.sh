#!/usr/bin/bash

stow -d "$HOME/Projects/dotfiles/" -t "$HOME" -v . --ignore="exclude/*|.venv/*" --adopt
