return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    -- Use the top-level module instead of .configs
    local ts = require("nvim-treesitter")

    -- 1. Configure features like highlighting and indenting
    ts.setup({
      highlight = { enable = true },
      indent = { enable = true },
    })

    -- 2. Define your desired parsers using the new install API
    ts.install({
      "c", "cpp", "lua", "vim", "vimdoc", "elixir", "javascript", "html", "python", "typescript", "go"
    })
  end
}
