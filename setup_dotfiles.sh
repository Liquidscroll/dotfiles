#!/bin/bash

DOTFILES_DIR=$(pwd)
BASHRC_FILE=.bashrc
VIMRC_FILE=.vimrc
VIM_DIR=.vim


create_symlink()
{
    local target=$1
    local link_name=$2

    if [ -L "$link_name" ]; then
        echo "Removing existing symbolic link: $link_name"
        rm "$link_name"
    elif [ -e "$link_name" ]; then
        echo "Backing up existing file/dir: $link_name to $link_name.bak"
        mv "$link_name" "$link_name.bak"
    fi

    echo "Creating symbolic link: $link_name -> $target"
    ln -s "$target" "$link_name"
}

create_symlink "$DOTFILES_DIR/$BASHRC_FILE" "$HOME/$BASHRC_FILE"

if [ ! -d "$HOME/$VIM_DIR" ]; then
	echo "Creating .vim directory"
	mkdir -p "$HOME/$VIM_DIR"
fi

create_symlink "$DOTFILE_DIR/$VIMRC_FILE" "$HOME/$VIM_DIR/vimrc"

echo "Dotfiles Linked Successfully."
