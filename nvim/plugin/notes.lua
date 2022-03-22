function Journal()
    vim.cmd('e ' .. os.getenv("NOTES_DIR") .. "/journal/" .. os.date("%Y-%m-%d") .. ".md")
end
