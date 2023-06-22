local status_hop, hop = pcall(require, "hop")
if not status_hop then
	return
end

-- you can configure Hop the way you like here; see :h hop-config
hop.setup({
	keys = "etovxqpdygfblzhckisuran",
})
