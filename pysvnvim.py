import sys, os, vim,re,  time
try :
    import pysvn
except Exception as e:
    pass
    #vim.command("No svn support")
else:
    vim.command( 'command! OnSvnCommit :py on_svn_commit()<cr>')
    vim.command( 'command! SvnCommit :py svn_commit()<cr>')
    vim.command( 'command! GetOsc :py get_oscs()<cr>')

def get_oscs():
    line  = vim.current.line
    line_no = vim.current.window.cursor[0]
    path = os.path.dirname(vim.current.buffer.name)
    client = pysvn.Client()
    annotate = client.annotate(vim.current.buffer.name)
    annotations = filter(lambda x: x if x['number'] == line_no else None, annotate)
    for a in annotations:
        revision = a['revision']
        try :
            logs = client.log(path, revision,revision)
        except:
            pass
        else :
            for log in logs:
                oscs = re.findall('OSC:(\d+)', log['message'])
                for osc in oscs:
                    print "http://osc.iress.com.au/view.php?id=%s Rev:%s by %s on %s" % \
                            (osc, log['revision'].number, log['author'],time.ctime(log['date']))

def on_svn_commit():
    print "Commiting"
    buffer = vim.current.buffer
    commit_msg = ""
    for line in buffer:
        if not line.startswith('#'):
            commit_msg += line
    commit_msg = commit_msg.strip()
    if not commit_msg:
        print "Empty commit message, quiting ..."
        return

    force = True if int(vim.eval('v:cmdbang'))==1 else False
    if not commit_msg.startswith("OSC:") and not force:
        print "Commit message does not specify OSC, use w! to force commit."
        return

    commit_files = []
    commit_files_added = []
    for line in buffer:
        if line.startswith('#M') or line.startswith('#D') or line.startswith('#A'):
            commit_files.append(line[3:])
        elif line.startswith('#UA'):
            commit_files.append(line[4:])
            commit_files_added.append(line[4:])

    if not  len(commit_files):
        print "No files to commit ..."
        return

    try :
        client = pysvn.Client()
        client.add(commit_files_added, recurse=False)
        revision = client.checkin(commit_files, commit_msg, recurse=False)
        print "Commited version %s" % str(revision)
        vim.command('bdelete!')
    except Exception as e:
        print e

def on_svn_diff():
    cur_file = vim.current.line.split()[1]
    if not os.path.isfile(cur_file):
        print "Invalid file path"
        return
    client = pysvn.Client()
    info = client.info(cur_file)
    url = info['url']
    revision = info['revision']
    up_data = client.cat(url, revision=revision)
    tmp_filename = os.path.join('/tmp',os.path.basename(cur_file))
    with file(tmp_filename, 'w') as tmp_file:
        tmp_file.write(up_data)
    vim.command('tabnew %s' % cur_file)
    vim.command('autocmd! BufWinLeave <buffer> :tabclose')
    vim.command('vert diffsplit %s'%tmp_filename)
    vim.command('autocmd! BufWinLeave <buffer> :tabclose')

def svn_commit():
    path = os.getcwd()
    vim.command('wa')
    for b in vim.buffers:
        if b.name == 'svn_commit':
            vim.command('bd! svn_commit')
    vim.command('badd svn_commit')
    vim.command('sb svn_commit')
    vim.command('set buftype=acwrite')
    vim.command('set bufhidden=hide')
    vim.command('setlocal noswapfile')
    vim.command('autocmd! BufWriteCmd svn_commit :OnSvnCommit')
    vim.current.buffer.append('# Enter Commit Message Above ')
    client = pysvn.Client()
    stats = client.status(path, get_all=False, ignore=True)
    modified = []
    unversioned = []
    added = []
    deleted = []
    for stat in stats:
        if stat['text_status'] == pysvn.wc_status_kind.modified:
            modified.append(stat['path'])
        if stat['text_status'] == pysvn.wc_status_kind.deleted:
            deleted.append(stat['path'])
        if stat['text_status'] == pysvn.wc_status_kind.added:
            added.append(stat['path'])
        elif stat['text_status'] == pysvn.wc_status_kind.unversioned:
            unversioned.append(stat['path'])

    for p in modified:
        vim.current.buffer.append('#M ' + str(p))

    for p in added:
        vim.current.buffer.append('#A ' + str(p))

    for p in deleted:
        vim.current.buffer.append('#D ' + str(p))

    for p in unversioned:
        vim.current.buffer.append('#U ' + str(p))
    vim.command( 'map <buffer> <leader>d :py on_svn_diff()<cr>')


