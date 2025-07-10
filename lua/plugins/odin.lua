return {
  "Tetralux/odin.vim",
  config = function()
    vim.cmd([[
      " from https://github.com/Tetralux/odin.vim/pull/11
      setlocal indentexpr=GetOdinIndent(v:lnum)

      function! GetOdinIndent(lnum)
        let prev = prevnonblank(a:lnum-1)

        if prev == 0
          return 0
        endif

        let prevline = getline(prev)
        let line = getline(a:lnum)

        let ind = indent(prev)

        if prevline =~ '[({]\s*$'
          let ind += shiftwidth()
        endif

        if prevline =~ ':=$'
          let ind += shiftwidth()
        endif

        " Indent if previous line is a case statement
        if prevline =~ '^\s*case.*:\s*$'
          let ind += shiftwidth()
        endif

        if line =~ '^\s*[)}]'
          let ind -= shiftwidth()
        endif

        " Un-indent if current line is a case statement
        if line =~ '^\s*case.*:\s*$'
            let ind -= shiftwidth()
        endif

        return ind
      endfunction
    ]])
  end,
}
