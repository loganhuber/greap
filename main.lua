    -- declare package path
local script_path = debug.getinfo(1, "S").source:sub(2)
local script_dir = script_path:match("(.*/)")
package.path = script_dir .. "?.lua;" .. package.path

local extract = require('extract')
local paths = require('paths')
local json = require('libraries.json')


local function next_snapshot_number(directory)
    local highest = 0
    local index = 0

    while true do
        local filename = reaper.EnumerateFiles(directory, index)
        if not filename then
            break
        end

        local number = filename:match("^(%d+)%.json$")
        if number then
            highest = math.max(highest, tonumber(number))
        end

        index = index + 1
    end

    return highest + 1
end


local function take_snapshot(data)
    local project_path = paths.project_path()
    local json_data = json.encode(data)
    
    reaper.RecursiveCreateDirectory(project_path .. '/.greap', 0)
    
    local number = next_snapshot_number(project_path .. "/.greap")
    local output = string.format("%s/.greap/%04d.json", project_path, number)
    -- output = project_path .. '/.greap/0001.json'

    reaper.ShowConsoleMsg(output)
    -- reaper.ShowConsoleMsg(data)
    local file, error_message = io.open(output, "w")
    reaper.ShowConsoleMsg(tostring(error_message))
    -- local file = io.open(output, "w")
    file:write(json_data)
    file:close()
end



function main()

    local track_values = extract.all_track_values()
    take_snapshot(track_values)
    reaper.ShowConsoleMsg("\nSuccessfully took snapshot")
    -- reaper.ShowConsoleMsg(paths.project_path() .. '\n')
    -- reaper.ShowConsoleMsg(track_values .. "\n")

    
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
