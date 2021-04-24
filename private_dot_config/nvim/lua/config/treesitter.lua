local treesitter_configs = require('nvim-treesitter.configs')

--local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
--parser_config.json = {
--  install_info = {
--    url = "~/Dev/github/tree-sitter/tree-sitter-json",
--    files = {"src/parser.c"},
--    generate_requires_npm = true,
--  },
--}
--parser_config.jsonc = {
--  install_info = {
--    url = "~/Dev/gitlab/WhyNotHugo/tree-sitter-jsonc",
--    files = {"src/parser.c"},
--    generate_requires_npm = true,
--  }
--}

treesitter_configs.setup({
  ensure_installed = {
    'comment',
    'css',
    'go',
    'graphql',
    'html',
    'javascript', 'typescript', 'tsx',
    'json', 'jsonc', 'toml', 'yaml',
    'lua',
    'python',
    'query',
    'regex',
    'ruby',
    'rust',
  },
  autotag = {
    enable = true,
  },
  context_commentstring = {
    enable = true,
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = false,
  },
  playground = {
    enable = true,
  },
})

vim.api.nvim_exec([[
  nmap <Leader>ghg :TSHighlightCapturesUnderCursor<CR>
  nmap <Leader>gtr :TSPlaygroundToggle<CR>
]], false)
