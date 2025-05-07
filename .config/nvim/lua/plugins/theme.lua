return {
    "vague2k/vague.nvim",
    config = function()
        require("vague").setup({ transparent = true })
        vim.cmd("colorscheme vague")
        vim.cmd(":hi statusline guibg=NONE")
    end
}




-- tokyonight
--[[ 
return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function ()
    vim.cmd.colorscheme "tokyonight"
  end
}
]]




