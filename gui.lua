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

function gui.swap_layers(layer1, layer2)
    layer1:hide()
    layer2:show()
end

function gui.snapshot_modal()
    local layer = GUI.createLayer({
        name = 'save snapshot layer'
    })

    local label = GUI.createElement({
        type = 'label',
        caption = 'Enter a name',
        x = 500,
        y = 2
    })

    local textbox = GUI.createElement({
        name = 'snap_name',
        type = 'Textbox',
        x = 500,
        y = 50
    })

    local save_button = GUI.createElement({
        type = 'button',
        caption = 'Save Snapshot',
        x = 500,
        y = 100
    })

    layer:addElements(save_button)
    layer:addElements(label)
    layer:addElements(textbox) 

    return layer

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



function gui.home(snaps, modal)
    local layer = GUI.createLayer({
        name = 'home'
    })

    local list = {}

    for _, snap in ipairs(snaps) do
        if snap and snap.name then
            table.insert(list, snap.name)
        end
    end

    local listbox = GUI.createElement({
        name = 'snapshot names',
        type = 'listbox',
        x = 3,
        y = 3,
        w = 333,
        h = 550,
        pad = 3,
        multi = true,
        list = list
    })

    local button = GUI.createElement({
        name = 'take snap',
        type = 'button',
        x = 50,
        y = 560,
        caption = 'Take Snapshot'
    })

    button.func = function()
        gui.swap_layers(layer, modal)
    end
    
    layer:addElements(button)
    layer:addElements(listbox)
    return layer

end

function gui.start(snaps)
    local window = gui.init_window()
    -- local layer = gui.no_greap()

    -- All layers need to be created at startup
    local modal = gui.snapshot_modal()
    local home = gui.home(snaps, modal)

    modal:hide()

    window:addLayers(home)
    window:addLayers(modal)

    window:open()
    GUI.Main()
end


return gui