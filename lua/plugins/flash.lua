return {
  "folke/flash.nvim",
  -- ファイルを開いたタイミング、または少し遅らせて読み込む（快適な起動速度を維持）
  event = { "BufReadPre", "VeryLazy" },
  ---@type Flash.Config
  opts = {
    -- 視認性（カラー）を大幅に向上させるための設定
    highlight = {
      -- 検索時、マッチした箇所以外の背景を暗く（減光）して、ターゲットを浮き上がらせる
      backdrop = true,
      -- 全てのマッチ箇所をハイライトする
      matches = true,
      -- 他のプラグインのハイライトに負けないように優先度を最大級に設定
      priority = 9999,
    },
    label = {
      -- 大文字のラベルも許可して、より少ないタイピングでジャンプできるようにする
      uppercase = true,
      -- ラベルの配置（"overlay" は文字の上に被せるので一番見やすいです）
      style = "overlay",
      -- レインボーカラーを有効化して、隣り合うラベルを違う色にして見やすくする
      rainbow = {
        enabled = true,
        shade = 4, -- 1〜9 で明度を調整
      },
    },
  },
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash (Jump)",
    },
    {
      "S",
      mode = { "n", "x", "o" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
  },
}
