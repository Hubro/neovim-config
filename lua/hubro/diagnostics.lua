local M = {}

local tag_policy = {
  {
    name = "unnecessary",
    highlight = "DiagnosticUnnecessary",
    suppress = true,
  },
  {
    name = "deprecated",
    highlight = "DiagnosticDeprecated",
  },
}

local original_underline_handler
local pending_highlights = {}

local function pending_key(namespace, bufnr)
  return string.format("%d:%d", namespace, bufnr)
end

local function clear_pending_highlights(namespace, bufnr)
  local key = pending_key(namespace, bufnr)
  local autocmd = pending_highlights[key]

  if autocmd then
    vim.api.nvim_del_autocmd(autocmd)
    pending_highlights[key] = nil
  end
end

local function highlight_namespace(namespace)
  return vim.api.nvim_create_namespace("hubro.diagnostic.tags." .. namespace)
end

local function highlight_priority(severity, opts)
  local priority = vim.hl.priorities.diagnostics
  opts = opts or {}

  if not opts.severity_sort then
    return priority
  end

  if type(opts.severity_sort) == "table" and opts.severity_sort.reverse then
    return priority + severity - vim.diagnostic.severity.ERROR
  end

  return priority + vim.diagnostic.severity.HINT - severity
end

local function render_tag_highlights(namespace, bufnr, diagnostics, opts)
  local highlight_ns = highlight_namespace(namespace)

  for _, diagnostic in ipairs(diagnostics) do
    local line = vim.api.nvim_buf_get_lines(
      bufnr,
      diagnostic.lnum,
      diagnostic.lnum + 1,
      true
    )[1]
    local start_col = math.min(diagnostic.col, math.max(#line - 1, 0))

    for _, policy in ipairs(tag_policy) do
      if diagnostic._tags[policy.name] then
        vim.hl.range(
          bufnr,
          highlight_ns,
          policy.highlight,
          { diagnostic.lnum, start_col },
          { diagnostic.end_lnum, diagnostic.end_col },
          { priority = highlight_priority(diagnostic.severity, opts) }
        )
      end
    end
  end
end

local function show_tag_highlights(namespace, bufnr, diagnostics, opts)
  clear_pending_highlights(namespace, bufnr)

  if vim.api.nvim_buf_is_loaded(bufnr) then
    render_tag_highlights(namespace, bufnr, diagnostics, opts)
    return
  end

  local key = pending_key(namespace, bufnr)
  pending_highlights[key] = vim.api.nvim_create_autocmd("BufRead", {
    buffer = bufnr,
    once = true,
    callback = function()
      pending_highlights[key] = nil
      render_tag_highlights(namespace, bufnr, diagnostics, opts)
    end,
  })
end

local function diagnostic_position(diagnostic)
  if diagnostic._extmark_id and diagnostic.namespace then
    local namespace = vim.diagnostic.get_namespace(diagnostic.namespace)
    local location_ns = namespace.user_data.location_ns

    if location_ns then
      local extmark = vim.api.nvim_buf_get_extmark_by_id(
        diagnostic.bufnr,
        location_ns,
        diagnostic._extmark_id,
        { details = true }
      )

      if extmark[3] and extmark[3].invalid then
        return
      end

      if #extmark > 0 then
        return extmark[1], extmark[2]
      end
    end
  end

  return diagnostic.lnum, diagnostic.col
end

function M.is_suppressed(diagnostic)
  if not diagnostic._tags then
    return false
  end

  for _, policy in ipairs(tag_policy) do
    if policy.suppress and diagnostic._tags[policy.name] then
      return true
    end
  end

  return false
end

function M.setup()
  if original_underline_handler then
    return
  end

  original_underline_handler = vim.diagnostic.handlers.underline
  vim.diagnostic.handlers.underline = {
    show = function(namespace, bufnr, diagnostics, opts)
      local underlined = {}
      local suppressed = {}

      for _, diagnostic in ipairs(diagnostics) do
        if M.is_suppressed(diagnostic) then
          suppressed[#suppressed + 1] = diagnostic
        else
          underlined[#underlined + 1] = diagnostic
        end
      end

      original_underline_handler.show(namespace, bufnr, underlined, opts)
      show_tag_highlights(namespace, bufnr, suppressed, opts)
    end,
    hide = function(namespace, bufnr)
      original_underline_handler.hide(namespace, bufnr)
      clear_pending_highlights(namespace, bufnr)

      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_clear_namespace(
          bufnr,
          highlight_namespace(namespace),
          0,
          -1
        )
      end
    end,
  }
end

function M.jump(forward)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_lnum = cursor[1] - 1
  local cursor_col = cursor[2]
  local positions = {}

  for _, diagnostic in ipairs(vim.diagnostic.get(0)) do
    if not M.is_suppressed(diagnostic) then
      local lnum, col = diagnostic_position(diagnostic)

      if lnum then
        positions[#positions + 1] = {
          diagnostic = diagnostic,
          lnum = lnum,
          col = col,
        }
      end
    end
  end

  table.sort(positions, function(a, b)
    if a.lnum == b.lnum then
      return a.col < b.col
    end

    return a.lnum < b.lnum
  end)

  local target

  if forward then
    for _, position in ipairs(positions) do
      if position.lnum > cursor_lnum
          or position.lnum == cursor_lnum and position.col > cursor_col then
        target = position.diagnostic
        break
      end
    end

    target = target or positions[1] and positions[1].diagnostic
  else
    for index = #positions, 1, -1 do
      local position = positions[index]

      if position.lnum < cursor_lnum
          or position.lnum == cursor_lnum and position.col < cursor_col then
        target = position.diagnostic
        break
      end
    end

    target = target or positions[#positions] and positions[#positions].diagnostic
  end

  if not target then
    vim.api.nvim_echo(
      { { "No more valid diagnostics to move to", "WarningMsg" } },
      true,
      {}
    )
    return
  end

  vim.diagnostic.jump({
    diagnostic = target,
    on_jump = function()
      vim.diagnostic.open_float({
        scope = "cursor",
        focus = false,
        format = function(diagnostic)
          if not M.is_suppressed(diagnostic) then
            return diagnostic.message
          end
        end,
      })
    end,
  })
end

return M
