local M = {}

vim.api.nvim_set_hl(0, "TpWordLabel", { fg = "#7aa2f7", underline = true, bold = true })

function M.tp()
  require("tp-word.core").tp()
end

return M
