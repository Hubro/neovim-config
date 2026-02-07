return {
  cmd = { "robotframework_ls" },
  filetypes = { "robot" },
  root_markers = { ".git" },
  settings = {
    robot = {
      pythonpath = (
        vim.env.PYTHONPATH and vim.split(vim.env.PYTHONPATH, ":") or { "" }
      ),
    },
  },
}
