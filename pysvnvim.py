import sys, os, vim,re,  time
import fileinput
try :
    import pysvn
except Exception as e:
    vim.command('echoerr "%s"' % str(e))
else:
    vim.command( 'command! -nargs=* OnSvnCommit :py on_svn_commit(<args>)<cr>')
    vim.command( 'command! -nargs=* SvnCommit :py svn_commit(<args>)<cr>')
    vim.command( 'command! GetOsc :py get_oscs()<cr>')
    vim.command( 'command! GetAllOscs :py get_all_oscs()<cr>')
    vim.command( 'command! SvnLogFile :py svn_diff_versions()<cr>')
    vim.command( 'command! SvnLogFileLine :py svn_diff_versions_line()<cr>')

def on_svn_diff_multi():
    try:
        filename = vim.current.buffer[0]
        revisions = []
        client = pysvn.Client()
        selection_found = False
        for line in vim.current.buffer:
            if line[0] == '*':
                selection_found = True
                rev, message = line.split()[:2]
                revisions.append(pysvn.Revision(pysvn.opt_revision_kind.number, rev[1:-1]))
        if not selection_found:
            rev, message = vim.current.line.split()[:2]
            revisions.append(pysvn.Revision(pysvn.opt_revision_kind.number, rev[:-1]))

        if len(revisions) ==1:
            _svn_diff(client, filename, revisions[0])
        elif len(revisions)>1:
            _svn_diff(client, filename, revisions[0], revisions[1])
    except Exception as e:
        vim.command('echoerr "%s"' % str(e))

def svn_diff_versions_line():
    try:
        line  = vim.current.line
        line_no = vim.current.window.cursor[0]
        path = os.path.dirname(vim.current.buffer.name)
        filename = vim.current.buffer.name
        client = pysvn.Client()
        logs = client.log(filename)
        for b in vim.buffers:
            if b.name == 'svn_log':
                vim.command('bd! svn_log')
        vim.command('badd svn_log')
        vim.command('sb svn_log')
        vim.command('set buftype=acwrite')
        vim.command('set bufhidden=hide')
        vim.command('setlocal noswapfile')
        vim.command('autocmd! BufWinLeave svn_log :bd! svn_log')
        for log in logs:
            annotate = client.annotate(filename, revision_start=log['revision'], revision_end=log['revision'])
            annotations = filter(lambda x: x if x['number'] == line_no else None, annotate)
            for a in annotations:
                message = log.message.replace('\n',' ')
                revision = log.revision.number
                author = log.author
                vim.current.buffer.append('%s: %s: %s'%(revision,author, message) )
        vim.command( 'map <buffer> <leader>d :py on_svn_diff_multi()<cr>')
    except Exception as e:
        vim.command('echoerr "%s"' % str(e))

def svn_diff_versions():
    try:
        line  = vim.current.line
        line_no = vim.current.window.cursor[0]
        path = os.path.dirname(vim.current.buffer.name)
        client = pysvn.Client()
        currfile = vim.current.buffer.name
        logs = client.log(currfile)
        for b in vim.buffers:
            if b.name == 'svn_log':
                vim.command('bd! svn_log')
        vim.command('badd svn_log')
        vim.command('sb svn_log')
        vim.command('set buftype=acwrite')
        vim.command('set bufhidden=hide')
        vim.command('setlocal noswapfile')
        vim.command('autocmd! BufWinLeave svn_log :bd! svn_log')
        vim.current.buffer[0]=currfile
        for log in logs:
            message = log.message.replace('\n',' ')
            revision = log.revision.number
            author = log.author
            vim.current.buffer.append('%s: %s: %s'%(revision,author, message) )
        vim.command( 'map <buffer> <leader>d :py on_svn_diff_multi()<cr>')

    except Exception as e:
        vim.command('echoerr "%s"' % str(e))

def get_all_oscs():
    try:
        line  = vim.current.line
        line_no = vim.current.window.cursor[0]
        path = os.path.dirname(vim.current.buffer.name)
        filename = vim.current.buffer.name
        client = pysvn.Client()
        logs = client.log(filename)
        for b in vim.buffers:
            if b.name == 'svn_log':
                vim.command('bd! svn_log')
        vim.command('badd svn_log')
        vim.command('sb svn_log')
        vim.command('set buftype=acwrite')
        vim.command('set bufhidden=hide')
        vim.command('setlocal noswapfile')
        vim.command('autocmd! BufWinLeave svn_log :bd! svn_log')
        for log in logs:
            annotate = client.annotate(filename, revision_start=log['revision'], revision_end=log['revision'])
            annotations = filter(lambda x: x if x['number'] == line_no else None, annotate)
            for a in annotations:
                if a['number']  == line_no:
                    oscs = re.findall('OSC:*(\d+).*', log['message'])
                    for osc in oscs:
                        vim.current.buffer.append("http://osc.iress.com.au/view.php?id=%s Rev:%s by %s on %s" % \
                                (osc, log['revision'].number, log['author'],time.ctime(log['date'])))

    except Exception as e:
        vim.command('echoerr "%s"' % str(e))

def get_oscs():
    try:
        line  = vim.current.line
        line_no = vim.current.window.cursor[0]
        path = os.path.dirname(vim.current.buffer.name)
        client = pysvn.Client()
        annotate = client.annotate(vim.current.buffer.name)
        if len( annotate)==0:
            vim.command('echoerr "%s"' % 'annonate failed')

        annotations = filter(lambda x: x if x['number'] == line_no else None, annotate)
        if len( annotations)==0:
            vim.command('echoerr "%s"' % 'annonate failed')
        for a in annotations:
            revision = a['revision']
            try :
                logs = client.log(vim.current.buffer.name, revision,revision)
            except Exception as e:
                vim.command('echoerr "%s"' % str(e))
            else :
                if not logs:
                    vim.command('echoerr "%s"' % 'No logs')
                for log in logs:
                    oscs = re.findall('OSC:*(\d+).*', log['message'])
                    for osc in oscs:
                        print "http://osc.iress.com.au/view.php?id=%s Rev:%s by %s on %s" % \
                                (osc, log['revision'].number, log['author'],time.ctime(log['date']))
    except Exception as e:
        vim.command('echoerr "%s"' % str(e))

def _pre_commit_check(files):
    valid = True
    finput = fileinput.FileInput(files)
    for line in finput:
        if 'sj_debug' in line:
            vim.command('echoerr "Invalid line:%s: filename:%s: lineno:%s "' % \
                    (line,finput.filename(), finput.filelineno()))
            valid = False
            break
    finput.close()
    return valid

def on_svn_commit(version=''):
    try:
        print "Commiting"
        buffer = vim.current.buffer
        commit_msg = ""
        for line in buffer:
            if not line.startswith('#'):
                commit_msg += line
            else :
                break
        commit_msg = commit_msg.strip()
        if not commit_msg or commit_msg == "OSC:":
            print "Empty commit message, quiting ..."
            return

        force = True if int(vim.eval('v:cmdbang'))==1 else False
        if not commit_msg.startswith("OSC:") and not force:
            print "Commit message does not specify OSC, use w! to force commit."
            return

        commit_files = []
        commit_files_added = []
        branches = []
        for line in buffer:
            if line.startswith('#M') or line.startswith('#D') or line.startswith('#A'):
                commit_files.append(line[3:])
            elif line.startswith('#UA'):
                commit_files.append(line[4:])
                commit_files_added.append(line[4:])
            if line.startswith('#BRANCHES'):
                branches = line[len('#BRANCHES'):].split(',')

        if not _pre_commit_check(commit_files):
            print "File check failed"
            return

        if not  len(commit_files):
            print "No files to commit ..."
            return

        client = pysvn.Client()
        for p in commit_files:
            revision2 = client.update(p)
        client.add(commit_files_added, recurse=False)
        revision = client.checkin(commit_files, commit_msg, recurse=False)
        print "Commited version %s" % str(revision)
        if branches:
            svn_merge_branches(commit_msg,revision, commit_files, branches)
        vim.command('bdelete!')
    except Exception as e:
        vim.command('echoerr "%s"' % str(e))

def on_svn_diff():
    try:
        oper,cur_file = vim.current.line.split()
        if oper == '#U':return
        if not os.path.isfile(cur_file):
            print "Invalid file path"
            return
        client = pysvn.Client()
        info = client.info(cur_file)
        revision = info['revision']
        _svn_diff(client, cur_file,revision)
    except Exception as e:
        vim.command('echoerr "%s"' % str(e))

def _svn_diff_new(client,filename,revision, revision2=None):
    try:
        up_data = client.diff('/tmp/',filename, revision1=revision)
        tmp_filename = os.path.join('/tmp',os.path.basename(filename)+str(revision.number))
        with file(tmp_filename, 'w') as tmp_file:
            tmp_file.write(up_data)
        vim.command('tabnew %s' % filename)
        vim.command('vert diffpatch %s'%tmp_filename)
        vim.command( 'map :q :py _close_diff_tab("%s") <cr>'%tmp_filename)
    except Exception as e:
        vim.command('echoerr "%s"' % str(e))

def _svn_diff(client,filename,revision, revision2=None):
    try:
        up_data = client.cat(filename, revision=revision)
        tmp_filename = os.path.join('/tmp',os.path.basename(filename)+str(revision.number))
        with file(tmp_filename, 'w') as tmp_file:
            tmp_file.write(up_data)
        if revision2:
            up_data = client.cat(filename, revision=revision2)
            tmp_filename2 = os.path.join('/tmp',os.path.basename(filename)+str(revision2.number))
            with file(tmp_filename2, 'w') as tmp_file:
                tmp_file.write(up_data)
            filename = tmp_filename2
        _open_diff_tab(filename, tmp_filename)

    except Exception as e:
        vim.command('echoerr "%s"' % str(e))

def _close_diff_tab(tmp_filename):
    vim.command( ':tabclose')
    vim.command('bd! %s' % tmp_filename)
    vim.command( 'unmap :q')

def _open_diff_tab(filename, tmp_filename):
    try:
        vim.command('tabnew %s' % filename)
        vim.command('vert diffsplit %s'%tmp_filename)
        vim.command( 'map :q :py _close_diff_tab("%s") <cr>'%tmp_filename)
    except Exception as e:
        vim.command('echoerr "%s"' % str(e))

def on_svn_revert():
    try:
        for line in vim.current.buffer:
            if line.startswith('#R'):
                oper,cur_file = line.split()
                if not os.path.isfile(cur_file):
                    print "Invalid file path"
                    continue
                client = pysvn.Client()
                client.revert(cur_file)
        vim.command('bd! svn_commit')
        svn_commit()
    except Exception as e:
        vim.command('echoerr "%s"' % str(e))

def svn_commit(version=''):
    try:
        path = os.getcwd()
        if version:
            path = re.sub('xplan\d*','xplan%s' % version ,path)
        os.chdir(path)
        vim.command('wa')
        for b in vim.buffers:
            if b.name == 'svn_commit':
                vim.command('bd! svn_commit')
        vim.command('badd svn_commit')
        vim.command('sb svn_commit')
        vim.command('set buftype=acwrite')
        vim.command('set bufhidden=hide')
        vim.command('setlocal noswapfile')
        vim.command('autocmd! BufWriteCmd svn_commit :OnSvnCommit %s'%version)
        vim.command('autocmd! BufWinLeave svn_commit :bd! svn_commit')
        vim.current.buffer[0]='OSC:'
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
        vim.command( 'map <buffer> <leader>r :py on_svn_revert()<cr>')
    except Exception as e:
        vim.command('echoerr "%s"' % str(e))


def svn_merge_branches(message, revision, files, branches):
    try:
        for branch in branches:
            branch = branch.strip()
            branchpaths = []
            local_path = os.path.join('/home/steven/iress/xplan'+branch)
            os.chdir(local_path)
            client = pysvn.Client()
            for file in files:
                path = re.sub('xplan\d*', 'xplan%s' % branch, file)
                revision2 = client.update(path)[0]
                client.merge(file, revision,path,revision2,  local_path)
                branchpaths.append(path)
                vim.command('echo "%s"' % str(branchpaths))
            revision3 = client.checkin(branchpaths, message, recurse=False)
            print "Commited version %s on branch %s" % (str(revision3), branch)
    except Exception as e:
        vim.command('echoerr "%s"' % str(e))



