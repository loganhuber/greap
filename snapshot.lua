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
    if not name or name == "" then
        return nil, "Snapshot name is required"
    end

    local curr_snap = snapshot.filename(name)
    if curr_snap then
        return nil, "A snapshot named '" .. name .. "' already exists"
    end

    return {
        name = name,
        filename = nil,
        data = data
    }
end


function snapshot.save(snap_data) -- saves snapshot in a json file within the reaper project directory
    local project_path = paths.project_path()

    local number = snapshot.next_number(project_path .. "/.greap")
    local filename = string.format("%04d.json", number)
    local output = string.format("%s/.greap/%s", project_path, filename)

    snap_data.filename = filename

    local file, error_message = io.open(output, "w")
    if not file then
        reaper.ShowConsoleMsg(tostring(error_message))
        return nil, error_message
    end

    file:write(json.encode(snap_data))
    file:close()

    return output
end

function snapshot.read_all() -- returns a table of all snapshots currently saved in the reaper project directory
    local snapshots = {}
    local index = 0
    local directory = paths.greap_path()

    while true do
        local filename = reaper.EnumerateFiles(directory, index)
        if not filename then
            break
        end

        if filename:match("%.json$") then
            local filepath = directory .. '/' .. filename
            local file, error_message = io.open(filepath, 'r')

            if not file then
                return nil, error_message
            end

            local contents = file:read("*a")
            file:close()

            local success, decoded = pcall(json.decode, contents)
            if not success then
                return nil, "Invalid JSON in " .. filename .. ": " .. decoded
            end

            if decoded and not decoded.filename then
                decoded.filename = filename
            end

            table.insert(snapshots, decoded)
        end

        index = index + 1
    end
    return snapshots
end

function snapshot.read(filepath) -- returns a table of a single snapshot by the filepath
    local file, error_message = io.open(filepath, 'r')

    if not file then
        return nil, error_message
    end

    local contents = file:read("*a")
    file:close()

    local success, decoded = pcall(json.decode, contents)
    local filename = filepath:match("[^/\\]+$")
    if not success then
        return nil, "Invalid JSON in " .. filename .. ": " .. decoded
    end

    if decoded and not decoded.filename then
        decoded.filename = filename
    end

    return decoded
end

function snapshot.filename(name) -- returns the filename.json of a snapshot by user given name
    local index = 0
    local directory = paths.greap_path()

    while true do
        local filename = reaper.EnumerateFiles(directory, index)
        if not filename then
            return nil
        end

        if filename:match("%.json$") then
            local filepath = directory .. '/' .. filename
            local decoded = snapshot.read(filepath)
            if decoded and decoded.name == name then
                return decoded.filename or filename
            end
        end
        index = index + 1
    end
    return nil
end

function snapshot.delete(name) -- takes user given name and removes the json file
    if not name or name == "" then
        return false, "Snapshot name is required"
    end

    local filename = snapshot.filename(name)
    if not filename then
        return false, "No snapshot named '" .. name .. "' was found"
    end

    local filepath = paths.greap_path() .. filename
    local success, error_message = os.remove(filepath)
    if not success then
        return false, error_message or "Unable to delete snapshot"
    end

    return true
end

-- return values from two snaps that have changed
-- function snapshot.diff(snap1, snap2) 
--     ...
--  return diff
-- end

-- TODO:

-- return the data from an existing snapshot by the snap name
-- local function snapshot.get_snapshot(name)
-- end

-- return a table including all snapshot names
-- local function snapshot.get_all_names()
-- return names
--end

return snapshot