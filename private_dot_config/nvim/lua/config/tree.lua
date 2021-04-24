local tree_config = require('nvim-tree.config')

local cb = tree_config.nvim_tree_callback

vim.g.nvim_tree_width = 40
vim.g.nvim_tree_gitignore = 1
vim.g.nvim_tree_quit_on_open = 1
vim.g.nvim_tree_follow = 1
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_hide_dotfiles = 1
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_highlight_opened_files = 1
vim.g.nvim_tree_root_folder_modifier = ':~'
vim.g.nvim_tree_tab_open = 1
vim.g.nvim_tree_auto_resize = 0
vim.g.nvim_tree_disable_netrw = 0
vim.g.nvim_tree_hijack_netrw = 0
vim.g.nvim_tree_add_trailing = 1
vim.g.nvim_tree_group_empty = 0
vim.g.nvim_tree_lsp_diagnostics = 1
vim.g.nvim_tree_disable_window_picker = 1
vim.g.nvim_tree_hijack_cursor = 0
vim.g.nvim_tree_icon_padding = ' '
vim.g.nvim_tree_update_cwd = 1

vim.g.nvim_tree_disable_default_keybindings = 1

vim.g.nvim_tree_bindings = {
  { key = "h",     cb = cb("close_node")         },
  { key = "l",     cb = cb("edit")               },
  { key = "<BS>",  cb = cb("dir_up")             },
  { key = "<CR>",  cb = cb("cd")                 },
  { key = "<C-v>", cb = cb("vsplit")             },
  { key = "<C-x>", cb = cb("split")              },
  { key = "<C-t>", cb = cb("tabnew")             },
  { key = "gp",    cb = cb("preview")            },
  { key = "g.",    cb = cb("toggle_dotfiles")    },
  { key = "gi",    cb = cb("toggle_ignored")     },
  { key = "gr",    cb = cb("refresh")            },
  { key = "a",     cb = cb("create")             },
  { key = "dd",    cb = cb("cut")                },
  { key = "yy",    cb = cb("copy")               },
  { key = "yn",    cb = cb("copy_name")          },
  { key = "yp",    cb = cb("copy_path")          },
  { key = "yP",    cb = cb("copy_absolute_path") },
  { key = "p",     cb = cb("paste")              },
  { key = "dF",    cb = cb("remove")             },
  { key = "r",     cb = cb("rename")             },
  { key = "R",     cb = cb("full_rename")        },
  { key = "[",     cb = cb("first_sibling")      },
  { key = "]",     cb = cb("last_sibling")       },
  { key = "{",     cb = cb("prev_sibling")       },
  { key = "}",     cb = cb("next_sibling")       },
  { key = "<",     cb = cb("parent_node")        },
  { key = "[c",    cb = cb("prev_git_item")      },
  { key = "]c",    cb = cb("next_git_item")      },
  { key = "gq",    cb = cb("close")              },
  { key = "g?",    cb = cb("toggle_help")        },
}

vim.api.nvim_exec([[
  nnoremap <silent> <Leader>e :NvimTreeToggle<CR>
]], false)
