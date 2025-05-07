return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>fs", builtin.find_files, {})
		vim.keymap.set("n", "<leader>fp", ":Telescope git_files<cr>")
		vim.keymap.set("n", "<leader>fz", ":Telescope live_grep<cr>")
		vim.keymap.set("n", "<leader>fo", ":Telescope oldfiles<cr>")
		vim.keymap.set("n", "<leader>fb", ":Telescope buffers<cr>")
		vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<cr>")
	end,
}
