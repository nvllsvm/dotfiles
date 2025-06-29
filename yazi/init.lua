require("session"):setup {
    sync_yanked = true,
}

-- Setup function that runs when yazi starts
local function setup()
    -- Function to send OSC 7 sequence
    local function send_osc7()
        local cwd = tostring(cx.active.current.cwd)
        local hostname = os.getenv("HOSTNAME") or os.getenv("HOST") or "localhost"
        local osc7 = string.format('\027]7;file://%s%s\027\\', hostname, cwd)
        
        -- Write directly to terminal
        io.stderr:write(osc7)
        io.stderr:flush()
    end
    
    -- Subscribe to directory change events
    ps.sub("cd", send_osc7)
    
    -- Also send on initial load
    send_osc7()
end

-- Call setup
setup()
