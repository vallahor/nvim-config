return {
  "L3MON4D3/LuaSnip",
  event = "VeryLazy",
  config = function()
    local ls = require("luasnip")
    local s = ls.snippet
    local i = ls.insert_node
    local fmt = require("luasnip.extras.fmt").fmt

    ls.add_snippets("go", {
      s("iferr", fmt(
        [[
          if err != nil {{
            {}
          }}
        ]], { i(1) }
        )),
    })

    ls.add_snippets("odin", {
      s("iferr", fmt(
        [[
          if err != nil {{
            {}
          }}
        ]], { i(1) }
        )),
    })
  end,
}
