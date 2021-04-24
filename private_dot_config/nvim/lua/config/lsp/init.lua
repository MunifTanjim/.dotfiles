local compe = require('compe')
local lsp_config = require('lspconfig')
local lsp_install = require('lspinstall')
-- local lsp_saga = require('lspsaga')
local null_ls = require("null-ls")
local trouble = require('trouble')

vim.opt.completeopt = { "menuone", "noselect" }

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = {
    noremap = true,
    silent = true,
  }

  buf_set_keymap('n',    'gD',         '<cmd>lua vim.lsp.buf.declaration()<CR>',                                opts)
  buf_set_keymap('n',    'gd',         '<cmd>lua vim.lsp.buf.definition()<CR>',                                 opts)
  buf_set_keymap('n',    'K',          '<cmd>lua vim.lsp.buf.hover()<CR>',                                      opts)
  buf_set_keymap('n',    'gi',         '<cmd>lua vim.lsp.buf.implementation()<CR>',                             opts)
  buf_set_keymap('n',    '<C-k>',      '<cmd>lua vim.lsp.buf.signature_help()<CR>',                             opts)
  -- buf_set_keymap('n', '<Leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',                       opts)
  -- buf_set_keymap('n', '<Leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',                    opts)
  -- buf_set_keymap('n', '<Leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n',    'gy',         '<cmd>lua vim.lsp.buf.type_definition()<CR>',                            opts)
  -- buf_set_keymap('n',    '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',                                     opts)
  buf_set_keymap('n',    '<Leader>ac', '<cmd>lua vim.lsp.buf.code_action()<CR>',                                opts)
  buf_set_keymap('n',    'gr',         '<cmd>lua vim.lsp.buf.references()<CR>',                                 opts)
  -- buf_set_keymap('n', '<Leader>e',  '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',               opts)
  buf_set_keymap('n',    '[d',         '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',                           opts)
  buf_set_keymap('n',    ']d',         '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',                           opts)
  -- buf_set_keymap('n', '<Leader>q',  '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',                         opts)

  buf_set_keymap('n', '<Leader>rn', '<cmd>lua require("config.lsp.custom").rename()<CR>', opts)

  -- vim.api.nvim_exec([[
  --   nnoremap <silent> <leader>ac :Lspsaga code_action<CR>
  --   vnoremap <silent> <leader>ac :<C-U>Lspsaga range_code_action<CR>
  --   nnoremap <silent> K :Lspsaga hover_doc<CR>
  --   nnoremap <silent> <C-k> :Lspsaga signature_help<CR>
  --   nnoremap <silent> <Leader>rn :Lspsaga rename<CR>
  --   nnoremap <silent> [d :Lspsaga diagnostic_jump_prev<CR>
  --   nnoremap <silent> ]d :Lspsaga diagnostic_jump_next<CR>
  -- ]], false)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    }
  }

  return {
    capabilities = capabilities,
    on_attach = on_attach,
  }
end

local function setup_lsp_servers()
  lsp_install.setup()

  null_ls.setup({
    on_attach = function(client, bufnr)
      if client.resolved_capabilities.document_formatting then
        vim.cmd("nnoremap <silent><buffer> <Leader>f :lua vim.lsp.buf.formatting()<CR>")
        -- format on save
        vim.cmd("autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()")
      end

      if client.resolved_capabilities.document_range_formatting then
        vim.cmd("xnoremap <silent><buffer> <Leader>f :lua vim.lsp.buf.range_formatting({})<CR>")
      end
    end,
  })

  local eslint = require("eslint")
  eslint.setup({
    bin = 'eslint_d',
  })

  local prettier = require("prettier")
  prettier.setup({
    bin = 'prettier',
  })

  local servers = lsp_install.installed_servers()

  for _, server in pairs(servers) do
    local config = make_config()

    if server == "lua" then
      local runtime_path = { "./?.lua", "lua/?.lua", "lua/?/init.lua" }

      local workspace_library = { vim.fn.expand("$VIMRUNTIME/lua") }
      for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do
        local lua_path = path .. "/lua/";
        if vim.fn.isdirectory(lua_path) then
          table.insert(workspace_library, lua_path)
        end
      end

      config.settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
            path = runtime_path,
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = workspace_library,
            maxPreload = 10000,
            preloadFileSize = 10000,
          },
          telemetry = {
            enable = false,
          },
        }
      }
    end

    if server == "typescript" then
      config.on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        require("lsp.typescript").patch_client(client)

        -- disable tsserver formatting
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
      end
    end

    lsp_config[server].setup(config)
  end
end

setup_lsp_servers()

-- automatically reload after `:LspInstall <server>`
lsp_install.post_install_hook = function()
  setup_lsp_servers() -- reloads installed servers
  vim.cmd("bufdo e") -- triggers the FileType autocmd that starts the server
end

compe.setup({
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 2;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '', '', ' ', '', '', '', ' ' },
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  },
  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    luasnip = true;
  },
})

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn['vsnip#available'](1) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn['vsnip#jumpable'](-1) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

vim.api.nvim_exec([[
  inoremap <silent><expr> <C-Space> compe#complete()
  inoremap <silent><expr> <CR>      compe#confirm('<CR>')
  " inoremap <silent><expr> <C-e>     compe#close('<C-e>')
  " inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
  " inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
]], false)

trouble.setup({
  action_keys = {
    close = "gq",
  },
})

vim.api.nvim_exec([[
  nnoremap <silent> <Leader>xx :TroubleToggle<CR>
]], false)

-- lsp_saga.init_lsp_saga({
--   code_action_keys = {
--     quit = { '<Esc>', 'q' },
--   },
--   finder_action_keys = {
--     quit = { '<Esc>', 'q' },
--   },
--   rename_action_keys = {
--     quit = { '<Esc>' },
--   },
-- })

vim.api.nvim_exec([[
  autocmd CursorHold,CursorHoldI * lua require("nvim-lightbulb").update_lightbulb()
]], false)
