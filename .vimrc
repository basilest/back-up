"
"  Date:         Sunday, 2015.03.08 
"  Revision:     1.0
"  Author:       stefano basile
"  File:         .vimrc
"
"
"
"
"
"
" <VUNDLE> I added .vimrc modification to use vundle 
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" First point on GitHub to Vundle itself (so it can be autoapdated
" from vi)
Plugin 'gmarik/vundle'
"
"  To ident code with |
"<INDENT LINE>
Plugin 'Yggdroot/indentLine'
"let g:indentLine_color_term = 239
"let g:indentLine_color_gui = '#09AA08'
let g:indentLine_char = '│'
let g:indentLine_fileTypeExclude = ['text', 'sh']
:set list lcs=tab:\|\ 
"</INDENT LINE>
"
"<NERDTREE>
Plugin 'scrooloose/nerdtree.git'
"</NERDTREE>
"
" A plugin can be installed referencing with its name
" Plugin 'Buffergator'
"
filetype plugin indent on
"
"      ----------------  HERE COMMON COMMANDs TO USE VINDLE:
"
"      :PluginInstall        to install a new plugin written above
"      :bdelete              to close the splitted winow inside vi
"
"      :PluginUpdate         to update installed plugin
"      :PluginInstall!                idem
"      
"      :Plugins              to serach for plugins on vim site
"      :PluginSearch!
"
"      :PluginList           to listed my installed plugins
"      :PluginSearch!
"
"      :PluginClean          Remove filesystem dir remained of installed
"                            plugins, if they are not listed here anymore.
"                            So, to rm a plugin remove its line where above
"                            and call :PluginClean
"
" </VUNDLE> 
"
"
" Vimscript MY FUNCTIONS ---------------------- {{{
"---- My_Date_1 --- returns today date using external  bash 'date'
function! My_Date_1()
    let date = system ("date +'%A %F'")
    "let date = get(list, 0, 'default')
    "silent! execute:("!date|sed  -e 's/\([^,]*\),.*/\1/") 
    echom date
    :exe ":normal A" . " " . date 
    "ap
endfunction
"---- My_Date --- returns today date using internal vim 'strtime'
function! My_Date()
    let date = strftime("%A %F")
    :exe ":normal A" . " " . date
endfunction
function! My_Menu_Item(num_item)
    echom a:num_item
    let cmd = "perl -n -e'/^\s*(\d+)[-\s\.]*(.*)/ && ($1==" . a:num_item . ") && print \"$2\"' list.txt"
    echom cmd
    let menu_item = system (cmd)
    echom menu_item

endfunction
" }}}
" Vimscript MY file settings MAIN ---------------------- {{{
set mouse=a
set nu
set autoindent 
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab
set relativenumber
set hlsearch

:let mapleader=","
:nnoremap <leader>ev :split $MYVIMRC<cr>
:nnoremap <leader>sv :source $MYVIMRC<cr>
:nnoremap <leader>a  ea'<esc>hbi'<esc>
":nnoremap <leader>d  :exe ":normal A" . strftime("%A %F")<cr>
:nnoremap <leader>d  :call My_Date()<cr>
:nnoremap <leader>m  :call My_Menu_Item(2)<cr>
" }}}

" Vimscript MY file settings AUGROUP TYPE-VIM  ---------------------- {{{
:augroup filetype_vim
:        autocmd!
:        autocmd FileType vim setlocal foldmethod=marker
:augroup END
" }}}

" <SYNTAX> Here setting for syntax stuff 
" syntax=on
"
"
" </SYNTAX>

