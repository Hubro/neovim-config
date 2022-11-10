-- Helper to setup plugins
--
-- This will try to require the plugin, then call plugin.setup(options). If the
-- plugin fails to import, that's ignored silently rather than making a splash.
-- This makes it less painful to set up new nvim instances where plugins aren't
-- installed yet.
_G.soft_setup = function(plugin_name, options)
  local success, plugin = pcall(require, plugin_name)

  if success then
    plugin.setup(options)
  end
end

_G.soft_require = function(module_name, callback)
  local success, plugin = pcall(require, module_name)

  if success then
    callback(plugin)
  end
end
