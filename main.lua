    -- declare package path
local script_path = debug.getinfo(1, "S").source:sub(2)
local script_dir = script_path:match("(.*/)")
package.path = script_dir .. "?.lua;" .. package.path

local extract = require('extract')
local snapshot = require('snapshot')
-- local paths = require('paths')
-- local json = require('libraries.json')


-- creates hidden directory within reaper project dir to store json data
function init_greap()
    reaper.RecursiveCreateDirectory(project_path .. '/.greap', 0)
end



function main()
    local track_values = extract.all_track_values()
    -- take_snapshot(track_values)
    local name = 'V1'
    local json = snapshot.build(name, track_values)
    reaper.ShowConsoleMsg(json .. '\n\n')
    -- reaper.ShowConsoleMsg("\nSuccessfully took snapshot")
    -- reaper.ShowConsoleMsg(paths.project_path() .. '\n')
    -- reaper.ShowConsoleMsg(track_values .. "\n")
    snapshot.save(json)
    reaper.ShowConsoleMsg("Successfully saved snapshot")
    
    
end


main()

-- TODO

-- bool -> returns whether there is a /.greap dir within the project directory
-- function has_instance()
    -- return true/false
-- end



-- MAY BE USEFUL LATER
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
