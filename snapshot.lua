local snapshot = {}

local json = require('libraries.json')
local paths = require('paths')


function snapshot.next_number(directory)
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


function snapshot.build(name, data) -- joins name (ex: "V2") to snap data in one table, returns converted to json
    local snap = { [name] = data }
    local json_data = json.encode(snap)
    return json_data
end


function snapshot.save(json_data)
    local project_path = paths.project_path()
    
    local number = snapshot.next_number(project_path .. "/.greap")
    local output = string.format("%s/.greap/%04d.json", project_path, number)
    reaper.ShowConsoleMsg(output)
    
    local file, error_message = io.open(output, "w")
    reaper.ShowConsoleMsg(tostring(error_message))
    file:write(json_data)
    file:close()
end

-- TODO:

-- return the data from an existing snapshot by the snap name
-- local function snapshot.get_snapshot(name)
-- end

-- return a table including all snapshot names
-- local function snapshot.get_all_names()
-- return names
--end

return snapshot