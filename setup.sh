#!/bin/bash

[ $UID -ne 0 ] && {
	sudo apt update
	sudo apt install -y vim wget git build-essential cmake python3-dev
} || {
	apt update
	apt install -y vim git wget build-essential cmake python3-dev 
}

# clone the Vundle repo
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# configure the vimrc file to use Vundle
cat > /tmp/vimrc << EOF
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'Valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
set ts=4
set noexpandtab
set number
set encoding=utf8
set listchars=tab:⇥\ ,trail:⦁
colorscheme jellybeans
let g:airline_theme='jellybeans'
let g:airline_powerline_fonts = 1 
EOF

# if a vimrc file already existed, append it to the new one
[ -f ~/.vimrc ] && cat ~/.vimrc >> ~/tmp/vimrc

# and make the new vimrc file the active one
mv /tmp/vimrc ~/.vimrc

# Download the jellybeans VIM theme
mkdir -p ~/.vim/colors && cd ~/.vim/colors
wget https://raw.githubusercontent.com/nanotech/jellybeans.vim/master/colors/jellybeans.vim

# Update the plugins via Vundle, this will clone the repositories
vim -c PluginUpdate -c quit -c quit

# now build the YouCompleteMe C/C++ server
cd ~/.vim/bundle/YouCompleteMe
python3 install.py --clang-completer

# enable the powerline fonts
git clone https://github.com/powerline/fonts.git /tmp/powerline-fonts
cd /tmp/powerline-fonts
./install.sh
rm -rf /tmp/powerline-fonts

echo ""
echo "###############################################################################"
echo "# Now please configure your terminal emulator to use a Powerline enabled font #"
echo "###############################################################################"
