
"  Date:         Sunday, 2015.03.08
"  Revision:     1.0
"  Author:       stefano basile
"  File:         .vimrc
"
"
"  wget  https://github.com/basilest/back-up/raw/master/.vimrc
"
"
"
"
set t_Co=256

"<VIM_PLUG> <----------------- INSTALLED VIM-PLUG instead of Vundle
if empty(glob('~/.vim/autoload/plug.vim'))
      silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/.vim/plugged')        " call plug#end() will end at the end of this file

"      ----------------  HERE COMMON COMMANDs TO USE VIM-PLUG:
"
"      :PlugInstall          Install plugins
"
"      :PlugUpdate           Updates plugins
"
"      :PlugClean            Remove unused plugins
"
"      :PlugUpgrade          Upgrade vim-plug itslef
"
"/<VIM_PLUG>


" <VUNDLE> I added .vimrc modification to use vundle
set nocompatible
"filetype off
"          OLD VUNDLE CONFIG: set rtp+=~/.vim/bundle/Vundle.vim/
"          OLD VUNDLE CONFIG: call vundle#begin()

" First point on GitHub to Vundle itself (so it can be autoapdated
" from vi)
"           OLD VUNDLE CONFIG:    Plugin 'gmarik/Vundle.vim'
"
"  To ident code with |
"<INDENT LINE>
"      Plugin 'Yggdroot/indentLine'
"      let g:indentLine_color_term = 239
"      let g:indentLine_color_gui = '#09AA08'
"      let g:indentLine_char = '│'
"      let g:indentLine_fileTypeExclude = ['text', 'sh']
"      :set list lcs=tab:\|\
"</INDENT LINE>
"
"<NERDTREE>
"           OLD VUNDLE CONFIG:    Plugin 'scrooloose/nerdtree.git'
Plug 'scrooloose/nerdtree'
"</NERDTREE>

"<AIRLINE>
"           OLD VUNDLE CONFIG:    Plugin 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline'
set laststatus=2     "to appear even with 1 single file
set ttimeoutlen=50   "removes delay on ESC
let g:airline#extensions#tabline#enabled = 1

"</AIRLINE>

"<FZF>
" use fzf installed via homebrew
set rtp+=/usr/local/opt/fzf
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-h': 'split',
  \ 'ctrl-v': 'vsplit' }
"        :Files
"        :Rg
"</FZF>


"<LIGHTLINE>
"         Plugin 'itchyny/lightline.vim'
"         set laststatus=2
"         let g:lightline = {
"               \ 'colorscheme': 'wombat',
"               \}
"if !has('gui_running')
"      set t_Co=256
"endif

"</LIGHTLINE>

"<FUGITIVE>
Plug 'tpope/vim-fugitive'
"                        :Gedit (and :Gsplit, :Gvsplit, :Gtabedit)
"                        :Gstatus     ( type '-' to add / reset )
"                        :Gdiff
"                        :Gcommit %   ( to cimmit current file )
"                        :Gblame      ( type 'o' to split-open /
"                                       ctrl o to come back (if pressed enter an opened commit in the same window).
"                                       shift o to open in new tab
"                        :Glog        ( previous versions of the file )
"                        :Gmove
"                        :Ggrep
"</FUGITIVE>

" <CTRL-T>
" it requires vim compiled with +ruby:   vim --version | grep -i ruby
"  make distclean &&  ./configure --enable-rubyinterp=yes && make
"           OLD VUNDLE CONFIG:    Plugin 'wincent/command-t'
"Plug 'wincent/command-t'
" command-t commands:
"                        <leader>t  (i.e. in my case ",t") to open the panel
"                        Ctrl-s to open selected as H-split
"                        Ctrl-v to open selected as V-split
"                        Ctrl-t to open selected in new tab
" <CR> to select the file
" </CTRL-T>
" <CTRLP>     u n m a i n t a i n e d
"          Plugin 'ctrlp.vim'
"          set wildignore+=*/tmp/*,*.so,*.swp,*.zip
"          let g:ctrlp_max_height=70
"          "let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
"          let g:ctrlp_custom_ignore = {
"            \ 'dir':  '\v[\/]\.(git|hg|svn)$',
"            \ 'file': '\v\.(exe|so|dll)$',
"            \ }
"          "  \ 'link': '',
"</CTRLP>
" <AUTOCOMPETION PLUGIN>
" Shougo/deoplete.nvim   is the new version of the old famous neocomplete
"           OLD VUNDLE CONFIG:    Plugin 'Shougo/deoplete.nvim'
Plug 'Shougo/deoplete.nvim'
" </AUTOCOMPETION PLUGIN>


" <TAGS PLUGIN>
Plug 'majutsushi/tagbar'
nmap <F8> :TagbarToggle<CR>
" <TAGS PLUGIN>

"<UNITE>
"Plugin 'unite.vim'
"--------  Unite config is in the nnoremap section below

"                 call unite#filters#matcher_default#use(['matcher_fuzzy'])
"                 call unite#filters#sorter_default#use(['sorter_rank'])
"                 call unite#custom#source('file,file/new,buffer,file_rec,line', 'matchers', 'matcher_fuzzy')
"                 nnoremap <C-k> :<C-u>Unite -buffer-name=search -start-insert line<cr>

"</UNITE>
"<INCSEARCH>
"Plugin 'haya14busa/incsearch.vim'
""--------  To have the incremental searching in vim
"map /  <Plug>(incsearch-forward)
"map ?  <Plug>(incsearch-backward)
"map g/ <Plug>(incsearch-stay)

"</INCSEARCH>

"<PYTHON-MODE>   plugin for Python
" Python-Mode ---------------------- {{{
"<ch>Plugin 'klen/python-mode'
 " Keys:
 " K             Show python docs
 " <Ctrl-Space>  Rope autocomplete
 " <Ctrl-c>g     Rope goto definition
 " <Ctrl-c>d     Rope show documentation
 " <Ctrl-c>f     Rope find occurrences
 " <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
 " <Leader>r     run
 " [[            Jump on previous class or function (normal, visual, operator modes)
 " ]]            Jump on next class or function (normal, visual, operator modes)
 " [M            Jump on previous class or method (normal, visual, operator modes)
 " ]M            Jump on next class or method (normal, visual, operator modes)
"              let g:pymode_rope = 1
"             "let g:pymode_rope_complete_on_dot = 0 when working with YouCompleteMe plugin
"             "let g:pymode_rope_completion = 0  to cancel the pymode completion totally.
"              let g:pymode_rope_complete_on_dot = 0
"
"              " Documentation
"              let g:pymode_doc = 1
"              let g:pymode_doc_key = 'K'
"
"              "Linting
"              let g:pymode_lint = 1
"              let g:pymode_lint_checker = "pyflakes,pep8"
"              " Auto check on save
"              let g:pymode_lint_write = 1
"
"              " Support virtualenv
"              let g:pymode_virtualenv = 1
"
"              " Enable breakpoints plugin
"              let g:pymode_breakpoint = 1
"              let g:pymode_breakpoint_bind = '<leader>b'
"
"              " syntax highlighting
"              let g:pymode_syntax = 1
"              let g:pymode_syntax_all = 1
"              let g:pymode_syntax_indent_errors = g:pymode_syntax_all
"              let g:pymode_syntax_space_errors = g:pymode_syntax_all
"
"              " Don't autofold code
"              let g:pymode_folding = 0
"
"             "</PYTHON-MODE>
" }}}
"<VIMPROC+VIMSHELL >
"Plugin 'Shougo/vimproc.vim'
"Plugin 'Shougo/vimshell.vim'
"</VIMPROC+VIMSHELL>
"
" A plugin can be installed referencing with its name
" Plugin 'Buffergator'
"
"
"      ----------------  HERE COMMON COMMANDs TO USE VUNDLE:
"
"      :PluginInstall        to install a new plugin written above
"      :bdelete              to close the splitted window inside vi
"
"      :PluginUpdate         to update installed plugin
"      :PluginInstall!                idem
"
"      :Plugins              to search for plugins on vim site
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
" <COLOR SCEHEME>
" use Wombat - Dark gray
" put related .vim in ~/.vim/colors and type :colo wombat
"<ch>:color wombat
" </COLOR SCEHEME>
"
" <SETTINGS FOR C/C++>
"         Plugin 'Valloric/YouCompleteMe'
"         "<ch>let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
"         augroup project
"               autocmd!
"               autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
"         augroup END
"</SETTINGS FOR C/C++>
"
"
" <SETTINGS FOR GO>
"          OLD VUNDLE CONFIG     Plugin 'fatih/vim-go'
Plug 'fatih/vim-go'
"               :GoFmt                               " it work by default on save
"               let g:go_fmt_autosave = 0            " disable fmt on save
"               let g:go_fmt_command = "goimports"   " format with goimports instead of gofmt
"               :GoImports                           " add the import section
"               :GoImport [name][path]               " add. Ex mgo "gopkg.in/mgo.v2"
"               :GoDoc pkg name                      " Ex. GoDoc gopkg.in/mgo.v2
"               :GoBuild
"               :GoTest
"
"---------------------------------<GO PLUGIN>
" //_________________________________  F O R M A T T I N G
"
" // . :GoFmt              not necessary as it works by default on every save
"
" //_________________________________  C O M P I L I N G
"
" // . :GoRun %         run the opened file
" // . :GoBuild
"
" //_________________________________  E R R O R S   M O V I N G
"
" // :cnext and :cprevious    to jump to next previous compiling errors   (for info in quickfix panel)
" // :lnext                   to jump around from other (not quickfix) panels
"
" // let g:go_list_type = "quickfix"         to have all messages from any panel, always in quickfix panel
" //                                         (so I can always use only :next :cprevious)
"
" //_________________________________  T E S T
"
" //   :GoTest                   runs the test (this command is launched from inside both the  *_test.go file or from any other source .go of the same dir)
" //   :GoTestFunc               tests only the function under cursor (ex. TestBar)
"
" //   :GoTestCompile            checks compilation only for a Test file (maybe large file, so I don't want to wait for the test execution)
"
" //   :GoCoverage               reports coverage (showing lines green and red)
" //   :GoCoverageClear          resets lines colours
" //   :GoCoverageToggle         instead if calling in sequnce many times :GoCoverage / :GoCoverageClear
"
" //   :GoCoverageBrowse         beautifully opens directly the page in the browser
"
" //   let g:go_test_timeout = '15s'       set a timeout an waiting for Test ending (default is 10 sec)
"
" //_________________________________  I M P O R T
"
" //   :GoImport strings         to add that import 'string' in the proper section
" //   :GoImport s... <tab>      <tab> autocompletes (looping through the matching values)
" //   :GoImports                call 'goimports' new version of gofmt
"
" //_________________________________  F U N C T I O N   S E L E C T I O N
"
" //   if           select the body of the function --> dif delete, yif yank, vif visual, ...
" //   af           like <if> + also the function name line + any // comments line near the function
" //                let g:go_textobj_include_function_doc = 0 <---- if I want to exclude the behaviour for the comments near the function

" </SETTINGS FOR GO>
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
function! My_DocPerl(word, pathname)
    let user = system ("tr -d '\n' <<< \"${USER}\"")
    let time = system ("date +\"%s\" | tr -d '\n'")
    let tmp_file = "/tmp/" . user . time
    "nb. no nedd to remove spaces in clean_path as cWORD does not return any
    "let clean_path = system ("echo ".a:word."|sed 's/^[^-a-zA-Z0-9:_/]*\([-a-zA-Z0-9:_/]*\).*/\1/;'|tr -d '\n'")
    let clean_path = substitute(a:word, "^qw(", "", "")   "nb. no nedd to remove spaces as cWORD does not return any
    let clean_path = substitute(clean_path, "^[^0-9a-zA-Z_/]*", "", "")  "remove dirty char at the beginning and....
    let clean_path = substitute(clean_path,  "[^0-9a-zA-Z_]*$", "", "")  " ...at the end
    "echom clean_path
    let cmd = "perl ~/bin/docpl.pl " . clean_path . " " . a:pathname . " > ". tmp_file
    "echom cmd
    let a = system (cmd)
    :exe "split ".tmp_file
endfunction
function! My_Jump_to_file(word, pathname)
    let clean_path = substitute(a:word, "^qw(", "", "")   "nb. no nedd to remove spaces as cWORD does not return any
    let clean_path = substitute(clean_path, "^[^0-9a-zA-Z_/]*", "", "")  "remove dirty char at the beginning and....
    let clean_path = substitute(clean_path,  "[^0-9a-zA-Z_]*$", "", "")  " ...at the end
    let cmd = "perl -I ~/bin -MpathConversion -e 'pathConversion::get_absolute_path(\"" . clean_path . "\",\"" . a:pathname . "\",1)'"
    "echom cmd
    let file_path = system (cmd)
    "echom file_path
    :exe "split " . file_path
endfunction
function! My_filter_files()
    :exe ":g!/ *|[-+0-9 ]*$/d"
    :exe ":%s/ *|[-+0-9 ]*$//"
    :exe ":%!sort -u"
endfunction
function! My_filter_git_diff()
    :exe ":%s/^+++ b\\//+++ b /"
endfunction
function! My_random_tagVal(word)
    let tag_name = a:word
    echom tag_name
    let cmd = "perl ~/bin/randXML.pl -t '" . tag_name ."'"
    let tag_val = system (cmd)
    "echom tag_val
    "add some space so the selection of empty tags still works:
    :exe ":normal wa" . "  "
    :exe ":normal vits" . tag_val
endfunction
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

function My_TrimWhiteSpace()  " Removes trailing spaces
  %s/\s*$//
    ''
endfunction
" }}}
" Vimscript MY file settings MAIN ---------------------- {{{
set nu
if has('mouse')       "to have mouse support (vim --version  or :version to see if +mouse)
    set mouse=a
endif
if has('mouse_sgr')   "to have mouse on extra cols in large window (vim --version  or :version to see if +mouse_sgr)
    set ttymouse=sgr
endif
set ttymouse=xterm2      " to have mouse-resizing-windows even in tmux
"<ch>set relativenumber
set ic
set hlsearch

set tabstop=4    "changes tab to 4 spaces every time I type a NEW tab. To replace even old tabs do --> :retab
set shiftwidth=4 "number of spaces in the indentation
set expandtab
set autoindent
"set relativenumber
set backspace=2
autocmd BufWritePre * call My_TrimWhiteSpace()
"autocmd BufWritePre * %s/\s\+$//
"the following autocmd map the external prog xmllint to the = so that I can format all the file with gg=G
"au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null

"       OLD VUNDLE ENDING CONFIG:  call vundle#end()
"       OLD VUNDLE ENDING CONFIG:  filetype plugin indent on
"       OLD VUNDLE ENDING CONFIG:  filetype on <---- vim-plug does it in plug#end()
call plug#end()

:color default
runtime macros/matchit.vim


"set colorcolumn=80
"highlight ColorColumn ctermbg=darkgray

:let mapleader=","
:nnoremap <leader>ev :split $MYVIMRC<cr>
:nnoremap <leader>sv :source $MYVIMRC<cr>
:nnoremap <leader>lg :split ~/error_log<cr>
:nnoremap <leader>d   :call My_DocPerl(expand("<cWORD>"), expand('%:p'))<cr>
:nnoremap <leader>f   :call My_Jump_to_file(expand("<cWORD>"), expand('%:p'))<cr>
:nnoremap <leader>cg  :call My_filter_files()<cr>
:nnoremap <leader>cb  :call My_filter_git_diff()<cr>
":nnoremap <leader>r   :call My_random_tagVal(expand("<cWORD>"))<cr>
":nnoremap <leader>rn  :call My_random_tagVal("_fixed_INT_")<cr>
":nnoremap <leader>rf  :call My_random_tagVal("_fixed_FLOAT_")<cr>
":nnoremap <leader>rd  :call My_random_tagVal("_fixed_DATE_")<cr>
":nnoremap <leader>rs  :call My_random_tagVal("_fixed_STR__")<cr>
":nnoremap <leader>m  :call My_Menu_Item(2)<cr>
":nnoremap <leader>w  :.s/\([dD][sSeE]:[wW]\)[0-9]\{7,7\}/\10000000/g<cr>
:nnoremap <leader>w  :.s/\([a-zA-Z:]\)\{1,2\}[0-9]\{7,7\}/\10000000/g<cr>

":nnoremap <leader>F :CtrlP ~/git_branches/CONCORDION_WF.M/concordion-webfiling<cr>

"----UNITE CONFIG:  '!' means project dir (the one with a subdir .git or .svn)
":nnoremap <leader>F :Unite file_rec<cr>
":nnoremap <leader>F :Unite file<cr>
":nnoremap <leader>B :Unite buffer<cr>

"To open nerdtree
:nnoremap <leader>n  :NERDTreeToggle<cr>
" }}}

" Vimscript MY file settings AUGROUP TYPE-VIM  ---------------------- {{{
:augroup filetype_vim
:        autocmd!
:        autocmd FileType vim setlocal foldmethod=marker
:augroup END
" }}}

" <SYNTAX> Here setting for syntax stuff
"syntax=on
syntax enable
:syn sync fromstart     "to have syntax highlight never broken in the middle of a file
"
"
" </SYNTAX>
set path=.,~,~/chl-perl
:set tags=tags
