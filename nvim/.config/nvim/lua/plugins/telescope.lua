local ignore = {
	"node_modules",
	".git",
	".venv",
	"lazy-lock.json",
	"package-lock.json",
	"yarn.lock",
	"dist",
	"target",
	"build",
	".gradle",
}

return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.3",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-frecency.nvim",
		},
		opts = {
			pickers = {
				live_grep = {
					theme = "ivy",
					file_ignore_patterns = ignore,
					additional_args = function(_)
						return { "--hidden" }
					end,
				},
				find_files = {
					file_ignore_patterns = ignore,
					find_command = { "fd", "-tf", "--hidden" },
				},
			},
		},
	},
	{
		"nvim-telescope/telescope-frecency.nvim",
		config = function()
			require("telescope").load_extension("frecency")
		end,
	},
}