-- Convenience function for require on modules that might not be available
--
-- If the module exists, the callback is executed with the module as the only
-- argument.
--
return function(module_name, callback)
  local success, plugin = pcall(require, module_name)

  if success then
    callback(plugin)
  end
end
