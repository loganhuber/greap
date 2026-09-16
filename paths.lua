local paths = {}

function paths.project_path()
    return reaper.GetProjectPath()
end

function paths.greap_path()
    return reaper.GetProjectPath() .. '/.greap/'
end

return paths