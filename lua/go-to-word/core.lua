local M = {}

local ns = vim.api.nvim_create_namespace("go-to-word")

local prefix_location = {}

local function read_key()
  local ok, key = pcall(vim.fn.getcharstr)
  if not ok then
    return nil
  end
  -- if we type esc or anythign it just ends
  if key:match("[a-z]") == nil then
    return nil
  end
  return key
end

local function read_prefix()
  local first = read_key()
  if not first then return nil end
  local second = read_key()
  if not second then return nil end
  return first .. second
end

local function get_prefix(word_number)
  local base = 97 -- a - 1
  local zeroth = word_number % 26
  local first = math.floor(word_number / 26) % 26
  return string.char(base + first) .. string.char(base + zeroth)
end

local function prefix_word(row, col, word_number)
  -- it is going to be unusual to have over 26*26 words, but just in case we can exit if we do
  if word_number >= 26 * 26 then return end
  local prefix = get_prefix(word_number)
  prefix_location[prefix] = { row, col }
  vim.api.nvim_buf_set_extmark(0, ns, row, 0, {
    virt_text = { { prefix, "GoToWordLabel" } },
    virt_text_win_col = col,
  })
end

local function highlight_prefixes()
  local top = vim.fn.line("w0")
  local bottom = vim.fn.line("w$")
  local lines = vim.api.nvim_buf_get_lines(0, top - 1, bottom, false)
  local word_number = 0
  for i, line in pairs(lines) do
    if #line == 0 then
      goto continue
    end

    -- we are ignoring the actual word here
    for s, _, e in line:gmatch("()([%w_]+)()") do
      if e - s >= 2 then
        prefix_word(top + i - 2, s - 1, word_number)
        word_number = word_number + 1
      end
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

  local selected_prefix = read_prefix()
  clear_prefixes()

  if not selected_prefix then return end
  local loc = prefix_location[selected_prefix]
  if loc then
    vim.api.nvim_win_set_cursor(0, { loc[1] + 1, loc[2] })
  end
  -- reset it
  prefix_location = {}
end

return M
