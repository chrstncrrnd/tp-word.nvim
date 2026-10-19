local M = {}

vim.api.nvim_set_hl(0, "GoToWordLabel", { fg = "#7aa2f7", underline = true, bold = true })

function M.go()
  require("go-to-word.core").go()
end

return M
