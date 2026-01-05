return {
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, ".git")

    if root == nil then
      return
    end

    if root:find("/site%-packages/", 1, true) then
      return
    end

    on_dir(root)
  end,
  settings = {
    basedpyright = {
      analysis = {
        -- typeCheckingMode = "strict",-- Sane default for new projects
        typeCheckingMode = "standard", -- Sane default for old projects and standalone files
        diagnosticMode = "workspace",  -- "openFilesOnly" / "off"
        autoImportCompletions = true,
        diagnosticSeverityOverrides = {
          reportUnusedImport = false,
          reportUnusedClass = false,
          reportUnusedFunction = false,
          reportUnusedVariable = false,
        },
      },
    },
  },
  handlers = {
    -- ["textDocument/publishDiagnostics"] = function() end
  }
}
