local ts_filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" }

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_ts_wrap", { clear = true }),
  pattern = ts_filetypes,
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
  end,
})
