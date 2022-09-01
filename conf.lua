--[[ Global ]]--
ConfigMgr = nil



--[[ Callbacks ]]--
function love.conf(t)
    t.window.title = "Stack"
    t.window.width = 320
    t.window.height = 480
    t.console = true

    ConfigMgr = t
end