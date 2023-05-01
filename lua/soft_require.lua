return function(module_name, callback)
  local success, plugin = pcall(require, module_name)

  if success then
    callback(plugin)
  end
end
