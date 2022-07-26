local ok, go = pcall(require, "go")
if not ok then
	return
end

go.setup({
	goimport = "goimports", -- if set to 'gopls' will use golsp format
	gofmt = "gofmt", -- if set to gopls will use golsp format
})
