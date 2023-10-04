notes_dir = os.getenv("NOTES_DIR") or "~/notes"
function notes_journal()
    vim.cmd("e " .. notes_dir .. "/journal/" .. os.date("%Y-%m-%d") .. ".md")
end
vim.api.nvim_create_user_command('Journal', 'lua notes_journal()', {})
