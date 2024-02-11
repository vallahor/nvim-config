return {
  "Tetralux/odin.vim",
  config = function()
    -- vim.api.nvim_create_autocmd("BufWritePre", {
    --   pattern = "*.odin",
    --   command = ":lua vim.lsp.buf.format()",
    -- })
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
          let ind += &sw
        endif

        if prevline =~ ':=$'
          let ind += &sw
        endif

        " Indent if previous line is a case statement
        if prevline =~ '^\s*case.*:\s*$'
          let ind += &sw
        endif

        if line =~ '^\s*[)}]'
          let ind -= &sw
        endif

        " Un-indent if current line is a case statement
        if line =~ '^\s*case.*:\s*$'
            let ind -= &sw
        endif

        return ind
      endfunction
    ]])
  end,
}
