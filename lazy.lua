return {
  "chrstncrrnd/go-to-word.nvim",
  keys = {
    { "<leader>gb", function() require("go-to-word").go() end, desc = "Go to word" },
  },
}
