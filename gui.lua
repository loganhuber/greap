local gui = {}

local libPath = reaper.GetExtState("Scythe v3", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Couldn't load the Scythe library. Please install 'Scythe library v3' from ReaPack, then run 'Script: Scythe_Set v3 library path.lua' in your Action List.", "Whoops!", 0)
    return
end

loadfile(libPath .. "scythe.lua")()
local GUI = require("gui.core")

function gui.open_window()
    local window = GUI.createWindow({
    name = "My Script",
    w = 1000,
    h = 600,
    })

    local layer = GUI.createLayer({
    name = "My Layer"
    })

    local button = GUI.createElement({
    name = "My Button",
    type = "Button",
    x = 16,
    y = 16,
    caption = "Hi!"
    })

    button.func = function() reaper.ShowMessageBox("You clicked the button!", "Yay!", 0) end

    layer:addElements(button)
    window:addLayers(layer)

    window:open()
    GUI.Main()
end



function gui.start()
    local window = GUI.createWindow({
        name = "Greap",
        w = 1000,
        h = 600
    })

    local layer1 = GUI.createLayer({
        name = 'Layer One'
    })

    local button = GUI.createElement({
        name = 'Next',
        type = 'Button',
        x = 16,
        y = 16,
        caption = "Next"
    })

    button.func = function() gui.open_window() end

    layer1:addElements(button)
    window:addLayers(layer1)

    window:open()
    GUI.Main()
end


return gui