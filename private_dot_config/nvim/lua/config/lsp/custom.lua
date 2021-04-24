local Window = require("nui.window")

local mod = {}

function mod.rename()
  local curr_name = vim.fn.expand("<cword>")

  local params = vim.lsp.util.make_position_params()

  local window = Window:new({
    enter = true,
    border = {
      style = "rounded",
      highlight = "Normal",
      text = {
        top_left = "[Rename]",
      },
    },
    highlight = "Normal:Normal",
    relative = "buf",
    position = {
      row = params.position.line + 1,
      col = params.position.character,
    },
    size = {
      width = 25,
      height = 1,
    },
  })

  local function on_accept()
    local new_name = vim.fn.trim(vim.api.nvim_buf_get_lines(window.bufnr, 0, 1, false)[1])

    vim.cmd("stopinsert")

    window:unmount()

    if curr_name == new_name or not (new_name and #new_name > 0) then
      return
    end

    params.newName = new_name

    vim.lsp.buf_request(0, "textDocument/rename", params, function(_, _, result)
      if not result then
        return
      end

      local total_files = vim.tbl_count(result.changes)

      vim.lsp.util.apply_workspace_edit(result)

      print(string.format("Changed %s file%s. To save them run ':wa'", total_files, total_files > 1 and "s" or ""))
    end)
  end

  local function on_abort()
    vim.cmd("stopinsert")

    window:unmount()
  end

  window:mount()

  window:map("n", "<cr>", on_accept, { noremap = true })
  window:map("n", "<esc>", on_abort, { noremap = true })

  vim.fn.prompt_setprompt(window.bufnr, "")
  vim.fn.prompt_setcallback(window.bufnr, on_accept)
  vim.api.nvim_buf_set_option(window.bufnr, 'buftype', 'prompt')

  vim.api.nvim_feedkeys(curr_name, 'n', false)
  vim.cmd("startinsert!")
end

return mod
