return {
  "my-custom-plugin",
  dir = vim.fn.stdpath("config"),
  config = function()
    -- 起動時に通知を出す
    vim.notify("自作プラグインが正常にロードされました！", vim.log.levels.INFO)

    -- キーマップの設定
    vim.keymap.set("n", "<leader>hw", function()
      print("Hello, World! 自作プラグインが動いたよ！")
    end, { desc = "My first plugin command" })
  end,
}
