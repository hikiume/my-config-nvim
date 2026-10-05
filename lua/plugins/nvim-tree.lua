return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,

    keys = {
      { "<C-e>", "<cmd>NvimTreeFindFileToggle<CR>", mode = "n", desc = "tree: toggle at current file" },
    },

    config = function()
      -- netrwの無効化は setup より前に書くのが推奨
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        filters = {
          dotfiles = false,
          custom = {},
        },
        git = {
          ignore = false,
        },
        update_focused_file = {
          enable = true, -- バッファ切り替え時にツリーが自動追従
        },
      })
    end,
  },
}
