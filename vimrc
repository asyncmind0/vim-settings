"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:netrw_list_hide= '^\..*'
set term=rxvt
set mouse=a
set ttymouse=xterm2
set cscopequickfix=s-,c-,d-,i-,t-,e-
set hidden
set softtabstop=4
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set autoindent
set smartindent
set grepprg=grep\ -nH\ $*
set cursorline
set cursorcolumn
set fdm=syntax
set confirm
set backspace=2
set t_Co=256 
set colorcolumn=80
set statusline=
set laststatus=2
set showcmd
set hidden
set hlsearch
set equalalways
set nowrap
" Wrap at 72 chars for comments.
set formatoptions=cq textwidth=0 foldignore= wildignore+=*.py[co]
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filetype settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype indent on
filetype plugin on
filetype plugin indent on
filetype on
syntax on
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => bufExplorer plugin
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
noremap <silent> <F3> :BufExplorer <CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <silent> <S-F4> :Vex <CR><CR>
noremap <silent> <F4> :Explore! <CR><CR>
noremap <silent> <F6> :QFix <CR>
noremap <silent> <S-F6> :QFix <CR>
noremap `  :LustyFilesystemExplorer <CR>
map <silent> <leader><cr> :noh<cr>
" source $MYVIMRC reloads the saved $MYVIMRC
:nmap <Leader>s :source ~/.vimrc
" opens $MYVIMRC for editing, or use :tabedit $MYVIMRC
:nmap <Leader>v :e ~/.vimrc
" Convert slashes to backslashes for Windows.
if has('win32')
  nmap ,cs :let @*=substitute(expand("%"), "/", "\\", "g")<CR>
  nmap ,cl :let @*=substitute(expand("%:p"), "/", "\\", "g")<CR>

  " This will copy the path in 8.3 short format, for DOS and Windows 9x
  nmap ,c8 :let @*=substitute(expand("%:p:8"), "/", "\\", "g")<CR>
else
  nmap ,cs :let @*=expand("%")<CR>
  nmap ,cl :let @*=expand("%:p")<CR>
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" command mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <silent> cf :cs find c <C-R><C-W> <CR>
noremap <silent> cd :cs find g <C-R><C-W> <CR>
map <C-q> :conf bd <CR><CR>
map <silent><A-Left> :bn!<CR>
map <silent>[D :bp!<CR>
map <leader>. :cn <CR>
:command! CleanBlanks :%s/\ \+$//gc 
:command! Suw :w !sudo tee %

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Patogen configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call pathogen#infect() 
call pathogen#helptags()
" To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled = ["watchdog"]

" for some reason the csscolor plugin is very slow when run on the terminal
" but not in GVim, so disable it if no GUI is running
if !has('gui_running')
    call add(g:pathogen_disabled, 'csscolor')
endif

" Gundo requires at least vim 7.3
if v:version < '703' || !has('python')
    call add(g:pathogen_disabled, 'gundo')
endif

if v:version < '702'
    call add(g:pathogen_disabled, 'autocomplpop')
    call add(g:pathogen_disabled, 'fuzzyfinder')
    call add(g:pathogen_disabled, 'l9')
endif

call pathogen#infect()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color and highlighting stuff
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set t_AB=<Esc>[48;5;%dm
"set t_AF=<Esc>[38;5;%dm
colorscheme tango2
"colorscheme ir_black
"colorscheme wombat
highlight cursorcolumn term=none cterm=none ctermbg=0233 guibg=#090909
highlight cursorline term=NONE cterm=NONE ctermbg=0233 guibg=#090909
highlight Folded term=none cterm=none ctermbg=0233 guibg=#090909
hi Search term=reverse cterm=none ctermfg=Black ctermbg=Cyan gui=NONE guifg=Black guibg=Cyan
hi ColorColumn ctermbg=232 guibg=lightgrey
cabbr vdf vert diffsplit
" More syntax highlighting.
let python_highlight_all = 1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Cscope settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cs add ~/.vim/cscope.out
cs add ./cscope.out
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Quick Fix Stuff
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" toggles the quickfix window.
let g:jah_Quickfix_Win_Height=10
command! -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
    if exists("g:qfix_win") && a:forced == 0
        cclose
        lcl
    else
        execute "copen " . g:jah_Quickfix_Win_Height
    endif
endfunction
" used to track the quickfix window
augroup QFixToggle
    autocmd!
    autocmd BufWinEnter quickfix let g:qfix_win = bufnr("$")
    autocmd BufWinLeave * if exists("g:qfix_win") && expand("<abuf>") == g:qfix_win | unlet! g:qfix_win | endif
augroup END
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Python Stuff
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
pyfile ~/.vim/pyvim.py
pyfile ~/.vim/pysvnvim.py
let g:PyLintOnWrite = 0
let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax

au BufRead,BufNewFile *.scss set filetype=scss
au BufRead,BufNewFile *.scss set filetype=scss
let g:Tail_Center_Win = 1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  window splits
"  http://stackoverflow.com/questions/2586984/how-can-i-swap-positions-of-two-open-files-in-splits-in-vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! MarkWindowSwap()
    let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
    "Mark destination
    let curNum = winnr()
    let curBuf = bufnr( "%" )
    exe g:markedWinNum . "wincmd w"
    "Switch to source and shuffle dest->source
    let markedBuf = bufnr( "%" )
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' curBuf
    "Switch to dest and shuffle source->dest
    exe curNum . "wincmd w"
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' markedBuf 
endfunction

function! DoWindowSwapTwo()
    "Mark destination
    let curNum = winnr()
    let curBuf = bufnr( "%" )
    exe 2 . "wincmd w"
    "Switch to source and shuffle dest->source
    let markedBuf = bufnr( "%" )
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' curBuf
    "Switch to dest and shuffle source->dest
    exe curNum . "wincmd w"
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' markedBuf 
endfunction
nmap <silent> <leader>mw :call MarkWindowSwap()<CR>
nmap <silent> <leader>pw :call DoWindowSwap()<CR>
nmap <silent> <leader>sw :call DoWindowSwapTwo()<CR>
set guifont=Inconsolata-dz\ for\ Powerline
let g:Powerline_symbols = 'fancy'
