# GoBaek.nvim

GoBaek.nvim is a Neovim plugin to create and manage Baekjoon problem directories and Go templates.

## Installation

### Using Lazy.nvim
```lua
{
  "maximizemaxwell/gobaek.nvim",
  config = function()
    require("gobaek").setup()
  end,
}
