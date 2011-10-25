import sys, os, vim,re, pysvn
# `gf` jumps to the filename under the cursor.  Point at an import statement
# and jump to it!
sys.path.insert(0, 'src/py/')
sys.path.insert(0, 'lib/py/')
for p in sys.path:
    if os.path.isdir(p):
        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))

# Use F7/Shift-F7 to add/remove a breakpoint (ipdb.set_trace)
# Totally cool.
def SetBreakpoint():
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
    nCurrentLine = int( vim.eval( 'line(".")'))
    nLines = []
    nLine = 1
    for strLine in vim.current.buffer:
        if strLine == "from debug import debug as sj_debug" or \
            strLine.lstrip().startswith("sj_debug()") or \
            strLine.lstrip().startswith("sj_trace()"):
            nLines.append( nLine)
        nLine += 1
    nLines.reverse()
    for nLine in nLines:
        vim.command( "normal %dG" % nLine)
        vim.command( "normal dd")
        if nLine < nCurrentLine:
            nCurrentLine -= 1
    vim.command( "normal %dG" % nCurrentLine)

def fix_commas():
    line  = vim.current.line
    line = re.sub('\ *\,\ *',',',line)
    line = re.sub(',',', ', line)
    line = re.sub('\ *\=\ *','=',line)
    line = re.sub('(?!=[=,>,<,!])=(?!=[=,<,>,!])',' = ', line)
    line = re.sub('==',' == ', line)
    vim.current.line= line

def fix_blanks():
    start = end =0
    for index,line in enumerate(vim.current.buffer):
        if re.match("^\s*$", line):
            start = index
        else :
            start = None
        #vim.current.buffer[index] = re.sub("^\s+$","",line)
        if len(dellines) >2:
            for i,v in enumerate(dellines):
                del vim.current.buffer[v]
            dellines = []

def get_osc():
    line  = vim.current.line
    line_no = vim.current.window.cursor[0]
    client = pysvn.Client()
    annotate = client.annotate(vim.current.buffer.name)
    rev = filter(lambda x: x if x['number'] == line_no else None, annotate)[0]['revision']
    path = os.path.dirname(vim.current.buffer.name)
    log = client.log(path, rev,rev)[0]
    oscs = re.findall('OSC:(\d+)', log['message'])
    for osc in oscs:
        print "http://osc.iress.com.au/view.php?id=%s" % osc

vim.command( 'command! GetOsc :py get_osc()<cr>')
vim.command( 'command! FixCommas :py fix_commas()<cr>')
vim.command( 'command! FixBlanks :py fix_blanks()<cr>')
vim.command( 'map <leader>f :py fix_commas()<cr>')
vim.command( 'map <f7> :py SetBreakpoint()<cr>')
vim.command( "map <f8> :py RemoveBreakpoints()<cr>")

