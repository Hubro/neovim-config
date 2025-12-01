local M = {}

M.entity_ids = function(callback)
  local api_url = vim.env.HASS_SERVER or vim.env.HOME_ASSISTANT_URL
  local token = vim.env.HASS_TOKEN or vim.env.HOME_ASSISTANT_TOKEN

  if not api_url then
    vim.notify("HOME_ASSISTANT_URL is not set", vim.log.levels.ERROR)
    return
  end

  if not token then
    vim.notify("HOME_ASSISTANT_TOKEN is not set", vim.log.levels.ERROR)
    return
  end

  local cmd = { "curl", "-v", "-H", "Authorization: Bearer " .. token, api_url .. "/api/states" }

  vim.system(cmd, {}, function(result)
    if result.code ~= 0 then
      vim.notify(
        "Command failed\n\n" .. vim.inspect(result),
        vim.log.levels.ERROR
      )
      return
    end

    local entities = vim.json.decode(result.stdout)
    local entity_ids = vim.tbl_map(function(entity) return entity.entity_id end, entities)

    table.sort(entity_ids)

    vim.schedule_wrap(callback)(entity_ids)
  end)
end

return M
