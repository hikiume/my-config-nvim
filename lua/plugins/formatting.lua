return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    formatters_by_ft = {
      typescript = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
  },
  config = function(_, opts)
    local conform = require("conform")
    conform.setup(opts)

    -- 手動フォーマット用キーマップ（<leader>fm）
    vim.keymap.set({ "n", "v" }, "<leader>fm", function()
      conform.format({
        lsp_format = "fallback",
        async = false,
        timeout_ms = 500,
      })
    end, { desc = "Format file or range" })
  end,
}
