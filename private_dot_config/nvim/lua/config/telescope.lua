local telescope = require("telescope")

telescope.setup({
  defaults = {
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  }
})

telescope.load_extension('fzf')

vim.api.nvim_exec([[
  nnoremap <Leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
  nnoremap <Leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
  nnoremap <Leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
  nnoremap <Leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
]], false)
