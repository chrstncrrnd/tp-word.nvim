local M = {}

local ns = vim.api.nvim_create_namespace("go-to-word")


local function get_prefix(word_number)
  local base = 97 -- a - 1
  local zeroth = word_number % 26
  local first = ((word_number - zeroth) / 26) % 26
  return string.char(base + first) .. string.char(base + zeroth)
end

local function prefix_word(row, col, word_number)
  -- vim.api.nvim_buf_set_extmark(0, ns, top + i - 2, 0, {
  --   virt_text = { { "ab", "error" } },
  --   virt_text_win_col = 0,
  --   end_col = 10,
  -- })
  vim.api.nvim_buf_set_extmark(0, ns, row, 0, {
    virt_text = { { get_prefix(word_number), "error" } },
    virt_text_win_col = col,
  })
end

local function highlight_prefixes()
  local top = vim.fn.line("w0")
  local bottom = vim.fn.line("w$")
  local lines = vim.api.nvim_buf_get_lines(0, top - 1, bottom, false)
  local word_number = 1
  for i, line in pairs(lines) do
    if #line == 0 then
      goto continue
    end
    local skip_to_next_word = false
    for j = 1, #line do
      local char = line:sub(j, j)
      -- we have a whitespace character
      if char == " " then
        skip_to_next_word = false
        goto continue_str
      end

      if not skip_to_next_word then
        prefix_word(top + i - 2, j - 1, word_number)
        word_number = word_number + 1
      end
      skip_to_next_word = true
      ::continue_str::
    end

    ::continue::
  end
end

local function clear_prefixes()
  vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
end

function M.go()
  -- local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  -- local top = vim.fn.line("w0")
  -- local bot = vim.fn.line("w$")
  -- local lines = vim.api.nvim_buf_get_lines(0, top - 1, bot, false)
  highlight_prefixes()
  vim.cmd.redraw() -- try without this
  local ok, key = pcall(vim.fn.getcharstr)

  clear_prefixes()

  if ok then
    print("Key pressed: ", key)
  end
end

return M
