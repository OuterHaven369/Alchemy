local M = {}

-- Commit all changes in the current repository.
-- Adds untracked files and provides basic error handling.
function M.commit(message)
  print("Committing with message:", message)

  local in_repo = vim.fn.systemlist("git rev-parse --is-inside-work-tree")[1]
  if in_repo ~= "true" then
    print("Not inside a Git repository.")
    return
  end

  local add_output = vim.fn.system("git add -A")
  if vim.v.shell_error ~= 0 then
    print("Error staging files:", add_output)
    return
  end

  local cmd = string.format("git commit -m %q", message)
  local result = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    print("Commit failed:", result)
  else
    print("Commit successful:", result)
  end
end

-- Push changes to a remote repository.
function M.push(remote, branch)
  remote = remote or "origin"
  branch = branch or "HEAD"
  local cmd = string.format("git push %s %s", remote, branch)
  local result = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    print("Push failed:", result)
  else
    print("Push successful:", result)
  end
end

-- Pull changes from a remote repository.
function M.pull(remote, branch)
  remote = remote or "origin"
  branch = branch or ""
  local cmd = string.format("git pull %s %s", remote, branch)
  local result = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    print("Pull failed:", result)
  else
    print("Pull successful:", result)
  end
end

return M
