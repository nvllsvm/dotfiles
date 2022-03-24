notes_dir = os.getenv("NOTES_DIR") or '~/notes'
function Journal()
    vim.cmd('e ' .. notes_dir .. "/journal/" .. os.date("%Y-%m-%d") .. ".md")
end
