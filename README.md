# tp-word.nvim

Teleport to any word, a neovim plugin to emulate Helix's `gw` functionality.



## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
return {
  "chrstncrrnd/tp-word.nvim",
  keys = {
    { "<leader>ww", "<Plug>(TpWord)", remap = true, desc = "Teleport to word" },
  },
}
```



## Usage
By triggering the plugin's keybind, every word is given a 2 letter prefix overlay, type the prefix of any word,
and the cursor gets teleported to that word.

The default keybind is `<leader>ww` however can be changed via the installation config.

