# Nvim Hidesig
  
<a href="https://nvim-treesitter.zulipchat.com/">
  <img alt="Zulip Chat" src="https://img.shields.io/badge/zulip-join_chat-brightgreen.svg" />
</a>


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
    delay = 200,    -- update delay on CursorMoved and InsertLeave
  }
}
```
# Screenshots

![BeforeVsAfter](https://user-images.githubusercontent.com/10522258/158731893-6394007e-c1ec-4724-8b60-3f0dc20affe6.png)

# TODO
- [x] Dim sorbet sig on buffer changed
- [x] Cache color calculation and highlight groups

# Credits

Thank you for inspiring me and set examples so I can understand nvim treesitter lua api.

- [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
- [p00f/nvim-ts-rainbow](https://github.dev/p00f/nvim-ts-rainbow)
- [NarutoXY/dim.lua](https://github.com/NarutoXY/dim.lua)
- [nvim-treesitter/nvim-treesitter-refactor](https://github.com/nvim-treesitter/nvim-treesitter-refactor)
- @theHamsta
