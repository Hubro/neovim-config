-- Function for restoring the view after running a function
--
-- Useful for auto-formatting and other code-modifying functions.
--
return function(func)
  local view = vim.fn.winsaveview()

  func()

  if view then
    vim.fn.winrestview(view)
  end
end
