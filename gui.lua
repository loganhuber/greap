local gui = {}

local libPath = reaper.GetExtState("Scythe v3", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Couldn't load the Scythe library. Please install 'Scythe library v3' from ReaPack, then run 'Script: Scythe_Set v3 library path.lua' in your Action List.", "Whoops!", 0)
    return
end

loadfile(libPath .. "scythe.lua")()
local GUI = require("gui.core")

function gui.init_window()
    local window = GUI.createWindow({
        name = 'Greap',
        w = 1000,
        h = 600
    })
    return window
end

function gui.no_greap() 
    local layer = GUI.createLayer({
        name = 'No Greap'
    })

    local label = GUI.createElement({
        name = 'no greap label',
        x = 16,
        y = 16,
        type = "Label",
        caption = "Greap session has not started. Would you like to start?"
    })

    local button = GUI.createElement({
        name = 'no greap button',
        type = 'Button',
        caption = 'yes',
        x = 300,
        y = 300
    })

    button.func = function() reaper.ShowMessageBox("You clicked yes", '', 0) end

    layer:addElements(button)
    layer:addElements(label)
    return layer
end



function gui.home(snaps)
    local layer = GUI.createLayer({
        name = 'home'
    })

    local list = {}

    for name, _ in pairs(snaps) do
        table.insert(list, name)
    end

    local listbox = GUI.createElement({
        name = 'snapshot names',
        type = 'listbox',
        x = 3,
        y = 3,
        w = 333,
        h = 596,
        pad = 3,
        multi = true,
        list = list
    })


    layer:addElements(listbox)
    return layer

end



function gui.start(snaps)
    local window = gui.init_window()
    -- local layer = gui.no_greap()
    local layer = gui.home(snaps)

    window:addLayers(layer)

    window:open()
    GUI.Main()

end

-- function gui.open_window()
--     local window = GUI.createWindow({
--     name = "My Script",
--     w = 1000,
--     h = 600,
--     })

--     local layer = GUI.createLayer({
--     name = "My Layer"
--     })

--     local button = GUI.createElement({
--     name = "My Button",
--     type = "Button",
--     x = 16,
--     y = 16,
--     caption = "Hi!"
--     })

--     button.func = function() reaper.ShowMessageBox("You clicked the button!", "Yay!", 0) end

--     layer:addElements(button)
--     window:addLayers(layer)

--     window:open()
--     GUI.Main()
-- end



-- function gui.start()
--     local window = GUI.createWindow({
--         name = "Greap",
--         w = 1000,
--         h = 600
--     })

--     local layer1 = GUI.createLayer({
--         name = 'Layer One'
--     })

--     local button = GUI.createElement({
--         name = 'Next',
--         type = 'Button',
--         x = 16,
--         y = 16,
--         caption = "Next"
--     })

--     button.func = function() gui.open_window() end

--     layer1:addElements(button)
--     window:addLayers(layer1)

--     window:open()
--     GUI.Main()
-- end


return gui