    -- declare package path
local script_path = debug.getinfo(1, "S").source:sub(2)
local script_dir = script_path:match("(.*/)")
package.path = script_dir .. "?.lua;" .. package.path

local extract = require('extract')
local snapshot = require('snapshot')
local paths = require('paths')
local json = require('libraries.json')
local gui = require('gui')


-- creates hidden directory within reaper project dir to store json data
function init_greap()
    if has_instance() then
        reaper.ShowConsoleMsg("Already instance of greap")
        return nil
    end

    local project_path = paths.project_path()
    if project_path == '' then
        return false
    end
    reaper.RecursiveCreateDirectory(project_path .. '/.greap', 0)
    return true
end

function has_instance()
    local project_path = reaper.GetProjectPath()

    if not project_path or project_path == "" then
        return false -- project has not been saved yet
    end

    local index = 0

    while true do
        local directory = reaper.EnumerateSubdirectories(project_path, index)

        if not directory then
            return false
        end

        if directory == ".greap" then
            return true
        end

        index = index + 1
    end
end

local function take_snapshot(snap_name)
    local track_values = extract.all_track_values()
    local snap_data, error_message = snapshot.build(snap_name, track_values)
    -- reaper.ShowConsoleMsg(json .. '\n\n')
    if not snap_data then
        reaper.ShowConsoleMsg(error_message .. '\n')
        return
    else
        snapshot.save(snap_data)
        reaper.ShowConsoleMsg("\nSuccessfully saved snapshot: " .. snap_name .. '\n')
    end
end


-- /Users/logan/Library/Application Support/REAPER/Scripts/ReaTeam Scripts/Development/Scythe library v3/library/

function main()
    -- gui.start()

    -- if not has_instance() then
    --     init_greap()
    --     reaper.ShowConsoleMsg('greap instance created')
    -- else
    --     reaper.ShowConsoleMsg('there is already an instance')
    -- end

    -- take_snapshot('V1')
    -- local filename = snapshot.filename('V1')
    -- if filename then
    --     reaper.ShowConsoleMsg('Filename: ' .. filename .. '\n')
    -- end

    -- local snap = snapshot.read('/Users/logan/Documents/reaper_projects/projects/leg_day_vocal_demo/Media/.greap/0001.json')
    -- reaper.ShowConsoleMsg(json.encode(snap))

    -- local snaps = snapshot.read_all('/Users/logan/Documents/reaper_projects/projects/leg_day_vocal_demo/Media/.greap')
    -- -- reaper.ShowConsoleMsg(json.encode(snaps))
    -- gui.start(snaps)
    
end


main()


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
