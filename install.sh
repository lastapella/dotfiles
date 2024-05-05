#!/usr/bin/env zsh

stow --target=$HOME --ignore='windows' --ignore='\.git.*' --ignore='readme\.md' --ignore='.*\.bak' .
