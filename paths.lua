local paths = {}

function paths.project_path()
    return reaper.GetProjectPath()
end

return paths