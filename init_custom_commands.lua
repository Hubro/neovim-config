vim.cmd([[
  command CloseHiddenBuffers :call CloseHiddenBuffers()

  " Close all hidden buffers!
  "
  " Yanked from https://stackoverflow.com/a/30101152/388916
  function! CloseHiddenBuffers()
    let tpbl=[]
    let closed = 0
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
      if getbufvar(buf, '&mod') == 0
        silent execute 'bwipeout' buf
        let closed += 1
      endif
    endfor
    echo "Closed ".closed." hidden buffers"
  endfunction
]])
