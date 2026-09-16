    -- declare package path
local script_path = debug.getinfo(1, "S").source:sub(2)
local script_dir = script_path:match("(.*/)")
package.path = script_dir .. "?.lua;" .. package.path

local extract = require('extract')
local snapshot = require('snapshot')
-- local paths = require('paths')
local json = require('libraries.json')


-- creates hidden directory within reaper project dir to store json data
function init_greap()
    reaper.RecursiveCreateDirectory(project_path .. '/.greap', 0)
end

local function take_snapshot()
    local track_values = extract.all_track_values()
    local name = 'V1'
    local json = snapshot.build(name, track_values)
    reaper.ShowConsoleMsg(json .. '\n\n')
    snapshot.save(json)
    reaper.ShowConsoleMsg("\nSuccessfully saved snapshot")
end


function main()
    -- take_snapshot()
    -- local filename = snapshot.filename('V1')
    -- reaper.ShowConsoleMsg(filename)

    -- local snap = snapshot.read('/Users/logan/Documents/reaper_projects/projects/leg_day_vocal_demo/Media/.greap/0001.json')
    -- reaper.ShowConsoleMsg(json.encode(snap))

    -- local snaps = snapshot.read_all('/Users/logan/Documents/reaper_projects/projects/leg_day_vocal_demo/Media/.greap')
    -- reaper.ShowConsoleMsg(json.encode(snaps))
    
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
