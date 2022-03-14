# Nvim Hide Sig

[![Gitter](https://badges.gitter.im/nvim-treesitter/community.svg)](https://gitter.im/nvim-treesitter/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

Dim Sorbet signature definitions so you can focus on the code.

# Quick start

- Install and set up [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter#quickstart) according to their documentation.
- Install this plugin

```lua
  -- Packer
  use "omnisyle/nvim-hidesig"

```
- Add a `hidesig` section in the [call to `require("nvim-treesitter.configs").setup()`](https://github.com/nvim-treesitter/nvim-treesitter#modules):

```lua
require("nvim-treesitter.configs").setup {
  highlight = {
      -- ...
  },
  -- ...
  hidesig = {
    enable = true,
    opacity = 0.75, -- opacity for sig definitions
  }
}
```

# Credits

Thank you for inspiring me and set examples so I can understand nvim treesitter lua api.

- [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
- [p00f/nvim-ts-rainbow](https://github.dev/p00f/nvim-ts-rainbow)
- [NarutoXY/dim.lua)](https://github.com/NarutoXY/dim.lua)
