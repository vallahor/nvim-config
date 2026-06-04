-- vim.pack.add({ "https://github.com/habamax/vim-godot" })

-- vim_godot.{bat|sh}: {file} {line} {col}
-- batch file to run as the external editor
-- @echo off
-- setlocal
-- set FILE=%1
-- set LINE=%2
-- set COL=%3
-- set "FILE=%FILE:\=/%"

-- set SERVER=127.0.0.1:6004

-- netstat -ano | findstr :6004 >nul
-- if %ERRORLEVEL% NEQ 0 (
--     start C:\apps\neovide\neovide.exe --no-vsync -- +":e %FILE%" +":call cursor(%LINE%,%COL%)"
-- ) else (
--     nvim --server %SERVER% --remote-send "<esc>:e %FILE%<cr>:call cursor(%LINE%,%COL%)<cr>"
-- )
-- endlocal

if true then
  return
end
-- paths to check for project.godot file
local fn = vim.fn
local nvim_create_autocmd = vim.api.nvim_create_autocmd

nvim_create_autocmd("FileType", {
  pattern = { "gdscript", "gdresource", "gdshader" },
  callback = function()
    vim.api.nvim_set_option_value("expandtab", false, { scope = "local" })
    vim.api.nvim_set_option_value("tabstop", 4, { scope = "local" })
    vim.api.nvim_set_option_value("shiftwidth", 4, { scope = "local" })
    -- vim.api.nvim_set_option_value("indentexpr", "", { scope = "local" })
  end,
})

local v = vim.v
local godot_project_path = ""

local paths_to_check = { "/", "/../" }
local cwd = fn.getcwd()
local fs_stat = vim.uv.fs_stat

-- iterate over paths and check
for i = 1, #paths_to_check do
  local value = paths_to_check[i]
  if fs_stat(cwd .. value .. "project.godot") then
    godot_project_path = cwd .. value
    break
  end
end

if godot_project_path ~= "" then
  local is_server_running = fs_stat(godot_project_path .. "/server.pipe")

  local addr = godot_project_path .. "/server.pipe"
  if fn.has("win32") == 1 then
    addr = "127.0.0.1:6004"
  end

  local started_godot_server = false
  if fn.filereadable(cwd .. "/project.godot") == 1 and not is_server_running then
    if v.servername ~= addr then
      local ok = pcall(function()
        fn.serverstart(addr)
      end)

      if ok then
        started_godot_server = true
      end
    end
  end

  nvim_create_autocmd("VimLeavePre", {
    callback = function()
      if started_godot_server then
        pcall(function()
          fn.serverstop(addr)
        end)
      end
    end,
  })
end
