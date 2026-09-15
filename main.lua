
function main()
    -- declare package path
    local script_path = debug.getinfo(1, "S").source:sub(2)
    local script_dir = script_path:match("(.*/)")
    package.path = script_dir .. "?.lua;" .. package.path

    local extract = require('extract')
    local paths = require('paths')
    local track_values = extract.all_track_values()

    reaper.ShowConsoleMsg(paths.project_path() .. '\n')
    reaper.ShowConsoleMsg(track_values .. "\n")

    
end


main()


--[[
local changes = reaper.GetProjectStateChangeCount()
local _, state = reaper.GetSetProjectInfo()
reaper.ShowConsoleMsg(state)
]]

-- write tmp file
--[[
output = "/tmp/tracks_state.json" 
local file = io.open(output, "w")
file:write(data)
file:close()
]]
