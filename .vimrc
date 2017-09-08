set nocompatible "run in vim mode
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'delimitMate.vim'
Plugin 'c.vim'
Plugin 'fatih/vim-go'
Plugin 'Valloric/YouCompleteMe'

call vundle#end()
filetype plugin indent on

set expandtab       "expand tabs into spaces
set autoindent      "auto-indent new lines
set smartindent     "return ending brackets to proper locations
set softtabstop=2   "indentation level of soft-tabs
set tabstop=2       "indentation leves of normal tabs
set shiftwidth=2    "how many columns to re-indent with << and >>
set showmatch       "show matching brackets
set ruler           "show cursor position at all times
set nohls           "don't highlight the previous search term
set number          "turn on line numbering
set wrap            "turn on visual word wrapping
set linebreak       "only break lines on 'breakat' characters
set laststatus=2
set mouse=a
syntax on           "turn on syntax highlighting

if has("autocmd")
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
\| exe "normal g'\"" | endif
endif

augroup filetypedetect
  au! BufRead,BufNewFile *nc setfiletype nc "http://www.vim.org/scripts/script.php?script_id=1847
  "html.ep now handled by https://github.com/yko/mojo.vim
  autocmd BufNewFile,BufReadPost *.ino,*.pde set filetype=cpp
augroup END

"strip trailing whitespace from certain files
autocmd BufWritePre *.conf :%s/\s\+$//e
autocmd BufWritePre *.py :%s/\s\+$//e
autocmd BufWritePre *.css :%s/\s\+$//e
autocmd BufWritePre *.html :%s/\s\+$//e

:set bs=2 "fix backspace on some consoles

set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
