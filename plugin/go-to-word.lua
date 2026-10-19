vim.keymap.set({ "n", "v" }, "<Plug>(GoToWord)", function()
  require("go-to-word").go()
end, { desc = "Go to word" })


vim.api.nvim_create_user_command("GoToWord", function()
  require("go-to-word").go()
end, { desc = "Jump to a word" })
