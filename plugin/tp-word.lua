vim.keymap.set("n", "<Plug>(TpWord)", function()
  require("tp-word").tp()
end, { desc = "Go to word" })


vim.api.nvim_create_user_command("TpWord", function()
  require("tp-word").tp()
end, { desc = "Jump to a word" })
