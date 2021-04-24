local lsp = vim.lsp

local function fix_range(range)
  if range["end"].character == -1 then
    range["end"].character = 0
  end
  if range["end"].line == -1 then
    range["end"].line = 0
  end
  if range.start.character == -1 then
    range.start.character = 0
  end
  if range.start.line == -1 then
    range.start.line = 0
  end
end

local function validate_changes(changes)
  for _, _change in pairs(changes) do
    for _, change in ipairs(_change) do
      if change.range then
        fix_range(change.range)
      end
    end
  end
end

local function apply_edit_handler(_, _, workspace_edit)
  if workspace_edit.edit and workspace_edit.edit.changes then
    validate_changes(workspace_edit.edit.changes)
  end

  local status, result = pcall(lsp.util.apply_workspace_edit, workspace_edit.edit)
  return { applied = status, failureReason = result }
end

local M = {}

function M.patch_client (client)
  if not client._patched_workspace_apply_edit then
    client.handlers["workspace/applyEdit"] = apply_edit_handler
    client._patched_woor_apply_edit = true
  end

end

return M
