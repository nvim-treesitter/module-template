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
    delay = 200,    -- update delay on CursorMoved and InsertLeave
  }
}
```
# Screenshots

### Before

<img width="585" alt="Screen Shot 2022-03-14 at 10 09 22 AM" src="https://user-images.githubusercontent.com/10522258/158189581-39635c0c-f552-4de0-b230-d8609fae4dfd.png">

### After

<img width="585" alt="Screen Shot 2022-03-14 at 10 28 21 AM" src="https://user-images.githubusercontent.com/10522258/158193121-775435c6-139b-4f90-b5b1-c2519a569017.png">

# TODO
- [ ] Dim sorbet sig on buffer changed
- [x] Cache color calculation and highlight groups

# Credits

Thank you for inspiring me and set examples so I can understand nvim treesitter lua api.

- [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
- [p00f/nvim-ts-rainbow](https://github.dev/p00f/nvim-ts-rainbow)
- [NarutoXY/dim.lua](https://github.com/NarutoXY/dim.lua)
- [nvim-treesitter/nvim-treesitter-refactor](https://github.com/nvim-treesitter/nvim-treesitter-refactor)
- @theHamsta
