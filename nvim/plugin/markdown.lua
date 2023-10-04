function mdlink(url)
  local pos = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local nline = line:sub(0, pos) .. '[' .. line:sub(pos + 1) .. '](' .. url .. ')'
  vim.api.nvim_set_current_line(nline)
end
vim.api.nvim_create_user_command(
    'MDLink',
    function(opts)
        mdlink(opts.args)
    end,
    {nargs='?'}
)

function trackingurl()
  local tracking_url = vim.fn.system {'tracking-url'}
  tracking_url = tracking_url:gsub("\n", '')
  print(tracking_url)
  mdlink(tracking_url)
end
vim.api.nvim_create_user_command('TrackingURL', trackingurl, {})

function clipboardurl()
  local url = vim.fn.system {'cbpaste'}
  url = url:gsub("\n", '')
  mdlink(url)
end
vim.api.nvim_create_user_command('MDLinkClipboard', clipboardurl, {})
