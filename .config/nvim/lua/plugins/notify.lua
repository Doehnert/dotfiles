return {
  "rcarriga/nvim-notify",
  config = function()
    vim.notify = require("notify") -- override the default `vim.notify`

    require("notify").setup({
      stages = "fade",       -- animation style
      timeout = 3000,        -- how long the popup stays (in ms)
      background_colour = "#000000", -- or use "Normal" for UI-consistent
      render = "default",    -- or minimal, simple, compact
      max_width = 80,
    })
  end,
}
