vim.diagnostic.config({
  float = {
    suffix = function(diagnostic)
      return string.format(
        " [%s] (%s)",
        diagnostic.code,
        diagnostic.source
      ), ""
    end
  }
})
