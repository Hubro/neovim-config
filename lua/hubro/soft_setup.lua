-- Convenience function for calling setup on plugins that might not be installed
--
-- If the module exists, then module.setup(...) is called with the input
-- options table.
--
return function(plugin_name, options)
  local success, plugin = pcall(require, plugin_name)

  if success then
    plugin.setup(options)
  end
end
