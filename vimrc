"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:netrw_list_hide= '^\..*'
set mouse=a
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
set formatoptions=cq textwidth=72 foldignore= wildignore+=*.py[co]
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
noremap `  :LustyFilesystemExplorer <CR>
map <silent> <leader><cr> :noh<cr>
" source $MYVIMRC reloads the saved $MYVIMRC
:nmap <Leader>s :source ~/.vimrc
" opens $MYVIMRC for editing, or use :tabedit $MYVIMRC
:nmap <Leader>v :e ~/.vimrc
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Patogen configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call pathogen#infect() 
call pathogen#helptags()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color and highlighting stuff
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"colorscheme ir_black
colorscheme wombat
highlight cursorcolumn term=none cterm=none ctermbg=0233 guibg=#090909
highlight cursorline term=NONE cterm=NONE ctermbg=0233 guibg=#090909
highlight Folded term=none cterm=none ctermbg=0233 guibg=#090909
hi Search term=reverse cterm=none ctermfg=Black ctermbg=Cyan gui=NONE guifg=Black guibg=Cyan
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
