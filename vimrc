let g:netrw_list_hide= '^\..*'
set mouse=a

map <C-q> :conf bd <CR><CR>
map <silent><A-Left> :bn!<CR>
map <silent>[D :bp!<CR>

noremap <silent> <F3> :BufExplorer <CR>
noremap <silent> <S-F4> :Vex <CR><CR>
noremap <silent> <F4> :Explore! <CR><CR>
noremap <silent> <F6> :QFix <CR>
noremap `  :LustyFilesystemExplorer <CR>
noremap <silent> cf :cs find c <C-R><C-W> <CR>
noremap <silent> cd :cs find g <C-R><C-W> <CR>
set cscopequickfix=s-,c-,d-,i-,t-,e-
set hidden

call pathogen#infect() 
call pathogen#helptags()


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
" Wrap at 72 chars for comments.
set formatoptions=cq textwidth=72 foldignore= wildignore+=*.py[co]

filetype indent on
filetype plugin on
filetype plugin indent on
filetype on
syntax on

colorscheme ir_black
highlight cursorcolumn term=none cterm=none ctermbg=0233 guibg=#090909
highlight cursorline term=NONE cterm=NONE ctermbg=0233 guibg=#090909
highlight Folded term=none cterm=none ctermbg=0233 guibg=#090909
cabbr vdf vert diffsplit
" More syntax highlighting.
let python_highlight_all = 1

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

:command! CleanBlanks :%s/\ \+$//gc 

" `gf` jumps to the filename under the cursor.  Point at an import statement
" and jump to it!
python << EOF
import sys, os, vim
sys.path.insert(0, 'src/py/')
sys.path.insert(0, 'lib/py/')
for p in sys.path:
    if os.path.isdir(p):
        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
EOF

" Use F7/Shift-F7 to add/remove a breakpoint (ipdb.set_trace)
" Totally cool.
python << EOF
import vim
def SetBreakpoint():
    import re
    nLine = int( vim.eval( 'line(".")'))
    import_line= "from debug import debug as sj_debug"
    strLine = vim.current.line
    strWhite = re.search( '^(\s*)', strLine).group(1)
    vim.current.buffer.append(
       "%(space)ssj_debug() %(mark)s Breakpoint %(mark)s" %
         {'space':strWhite, 'mark': '#' * 30}, nLine - 1)
    for strLine in vim.current.buffer:
        if strLine == import_line:
            break
    else:
        vim.current.buffer.append( import_line, 0)
        vim.command( 'normal j1')

def RemoveBreakpoints():
    import re
    nCurrentLine = int( vim.eval( 'line(".")'))
    nLines = []
    nLine = 1
    for strLine in vim.current.buffer:
        if strLine == "from debug import debug as sj_debug" or strLine.lstrip().startswith("sj_debug()") or strLine.lstrip().startswith("sj_trace()"):
            nLines.append( nLine)
        nLine += 1
    nLines.reverse()
    for nLine in nLines:
        vim.command( "normal %dG" % nLine)
        vim.command( "normal dd")
        if nLine < nCurrentLine:
            nCurrentLine -= 1
    vim.command( "normal %dG" % nCurrentLine)

vim.command( 'map <f7> :py SetBreakpoint()<cr>')
vim.command( "map <f8> :py RemoveBreakpoints()<cr>")
EOF
