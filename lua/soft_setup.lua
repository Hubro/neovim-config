return function(plugin_name, options)
  local success, plugin = pcall(require, plugin_name)

  if success then
    plugin.setup(options)
  end
end
