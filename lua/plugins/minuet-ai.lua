return {
  "milanglacier/minuet-ai.nvim",
  enabled = false,
  opts = {
    virtualtext = {
      auto_trigger_ft = {},
      keymap = {
        -- accept whole completion
        accept = '<C-e>',
        -- accept one line
        accept_line = '<A-j>',
        -- accept n lines (prompts for number)
        -- e.g. "A-z 2 CR" will accept 2 lines
        -- accept_n_lines = '<A-z>',
        -- Cycle to prev completion item, or manually invoke completion
        prev = '<A-p>',
        -- Cycle to next completion item, or manually invoke completion
        next = '<A-n>',
        dismiss = '<A-e>',
      },
    },
    provider = "openai_fim_compatible",
    n_completions = 3,
    context_window = 1024,
    request_timeout = 60,
    provider_options = {
      openai_fim_compatible = {
        name = "ollama",
        api_key = "TERM",
        end_point = "http://aura:12189/v1/completions",
        stream = true,
        -- model = "deepseek-coder-v2:16b",
        model = "qwen2.5-coder:7b",
        -- template = {
        --     prompt = "See [Prompt Section for default value]",
        --     suffix = "See [Prompt Section for default value]",
        -- },
        optional = {
          max_tokens = 256,
          stop = { "\n\n" },
        },
      }
    }
  },
}
