let g:netrw_list_hide= '^\..*'
"let g:ProjTags = [ "/home/steven/Coventry/M95CS/project/genetic/src/ctags" ] 
let g:tex_flavor='latex'
let g:Tex_Folding=0 


map <M-Esc>[62~ <MouseDown>
map! <M-Esc>[62~ <MouseDown>
map <M-Esc>[63~ <MouseUp>
map! <M-Esc>[63~ <MouseUp>
map <M-Esc>[64~ <S-MouseDown>
map! <M-Esc>[64~ <S-MouseDown>
map <M-Esc>[65~ <S-MouseUp>
map! <M-Esc>[65~ <S-MouseUp>
map <C-q> :conf bd 
map <silent><C-Left> <ESC>:bn<CR>
map <silent><C-Right> <ESC>:bp<CR>
noremap <silent> <F4> :NERDTreeToggle <CR>
let NERDTreeWinPos="left"
noremap <silent> <F3> :BufExplorer <CR>
"noremap <silent> <C-@> :Project <CR>
inoremap <Nul> <C-x><C-o>
nmap <silent> <S-F1> \pW
noremap <silent> <F6> :QFix <CR>
noremap <silent> ,c :Ack "//\ *TODO" <CR>
noremap <silent> [1;5C <esc> :bn <CR>
noremap <silent> [1;5D <esc> :bp <CR>
"nmap <silent> <F2> <Plug>ToggleProject
nnoremap <silent> <F2> :TlistToggle<CR>
noremap `  :LustyFilesystemExplorer <CR>
noremap <silent> cf :cs find c <C-R><C-W> <CR>
noremap <silent> cd :cs find g <C-R><C-W> <CR>
set cscopequickfix=s-,c-,d-,i-,t-,e-
set hidden

"set term=ansi
set hlsearch
set nowrap
set clipboard+=unnamed 
set mouse=a
set wrap
set lbr
set complete=.,w,b,u,t,i
autocmd FileType text setlocal textwidth=78
set nocompatible
set ve=block
set nu
"set  co=100
set nowrap
set go-=T
set go-=m
set guifont=DejaVu\ Sans\ Mono\ 12
"set guifont=Nimbus\ Sans\ L\ 10
set softtabstop=4
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set autoindent
set smartindent
set grepprg=grep\ -nH\ $*
set iskeyword+=:
set nonumber
"set tags=$OCRICKET/TAGS,$HOME/www/padikuin/src,$HOME/www/stevenjoseph/src,$HOME/www/virt/lib/python2.6/site-packages/tornado/
"set cursorline
"set cursorcolumn
set t_Co=256 
set incsearch " jumps to search word as you type (annoying but excellent)
set wildignore=*.o,*.obj,*.bak,*.exe
"syn on
set fdm=syntax
set confirm
set backspace=2

 
filetype indent on
filetype plugin on
filetype on
"color koehler
"color blackboard


"set tags+=$HOME/.vim/tags/python.ctags
autocmd FileType python set omnifunc=pythoncomplete#Complete
inoremap <C-space> <C-x><C-o>
syn match pythonError "^\s*def\s\+\w\+(.*)\s*$" display
syn match pythonError "^\s*class\s\+\w\+(.*)\s*$" display
syn match pythonError "^\s*for\s.*[^:]$" display
syn match pythonError "^\s*except\s*$" display
syn match pythonError "^\s*finally\s*$" display
syn match pythonError "^\s*try\s*$" display
syn match pythonError "^\s*else\s*$" display
syn match pythonError "^\s*else\s*[^:].*" display
syn match pythonError "^\s*if\s.*[^\:]$" display
syn match pythonError "^\s*except\s.*[^\:]$" display
syn match pythonError "[;]$" display
syn keyword pythonError         do
	    
autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

"python << EOL
"import vim
"def EvaluateCurrentRange():
"   eval(compile('\n'.join(vim.current.range),'','exec'),globals())
"EOL
"map <C-h> :py EvaluateCurrentRange()

autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class  
autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
""Python support end
""
"autocmd WinEnter * setlocal cursorline
"autocmd WinLeave * setlocal nocursorline

augroup taskjuggler
" taskjuggler files
au! BufNewFile,BufRead *.tj{p,i} set ft=tjp
augroup END
au BufRead,BufNewFile *.viki set ft=viki
""jcommenter
autocmd FileType java let b:jcommenter_class_author='Kalle Björklid (bjorklid@st.jyu.fi)'
  autocmd FileType java let b:jcommenter_file_author='Kalle Björklid (bjorklid@st.jyu.fi)'
  autocmd FileType java source ~/.vim/plugin/jcommenter.vim
  autocmd FileType java map <M-c> :call JCommentWriter()<CR> 
"jcommenter end

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

filetype plugin indent on
syntax on
"colorscheme tango
colorscheme ir_black
highlight cursorcolumn term=none cterm=none ctermbg=0233 guibg=#090909
highlight cursorline term=NONE cterm=NONE ctermbg=0233 guibg=#090909
highlight Folded term=none cterm=none ctermbg=0233 guibg=#090909
cabbr vdf vert diffsplit
"map :vdf :vert diffsplit
"autocmd FileType java source /home/steven/vim/javakit/vim/JavaKit.vim
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
set wmh=0
nmap <C-TAB> <C-W>w
map - <C-W>-
map + <C-W>+

"https://dev.launchpad.net/UltimateVimPythonSetup{
if !exists("autocommands_loaded")
  let autocommands_loaded = 1
  autocmd BufRead,BufNewFile,FileReadPost *.py source ~/.vim/python
endif
" This beauty remembers where you were the last time you edited the file, and returns to the same position.
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
"}

autocmd! FileType python setlocal omnifunc=pysmell#Complete
command! Txml set ft=xml | execute "%!tidy -q -i -xml"
command! Thtml set ft=html | execute "%!tidy -q -i -ashtml"

let g:DirDiffExcludes = ".git,*.class,*.exe,.*.swp"
au BufRead,BufNewFile *.scss set filetype=scss
set ts=4
highlight OverLength ctermbg=darkgrey ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

let loaded_matchparen=1
set colorcolumn=80
function! MoshBookmark()
  redir >> ~/.vims
  echo
  echo strftime("%Y-%b-%d %a %H:%M")
  echo "cd ". $PWD
  echo "vim ". expand("%:p").':'.line('.')
  echo ' word='.expand("<cword>")
  echo ' cline='.getline('.')
  redir END
endfunction
:command! MoshBookmark :call MoshBookmark()
let NERDTreeMapActivateNode="<Right>"
let NERDTreeMapCloseChildren="[DA"
let NERDTreeMapCloseDir="<Left>"
"set nu
set ruler
"set spell spelllang=en_us
" zg to add word to word list
" " zw to reverse
" " zug to remove word from word list
" " z= to get list of possibilities
"set spellfile=~/.vim/spellfile.add
"highlight clear SpellBad
"highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
"highlight clear SpellCap
"highlight SpellCap term=underline cterm=underline
"highlight clear SpellRare
"highlight SpellRare term=underline cterm=underline
"highlight clear SpellLocal
"highlight SpellLocal term=underline cterm=underline
cs add ~/.vim/cscope.out
cs add ./cscope.out
