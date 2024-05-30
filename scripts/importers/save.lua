
function import(node, value, key)
    local save = DB.getChild(node, "saves." .. key);

    if not save then 
        return key .. " not found"
    end

    local level = IMPBData.proficiencyLevels[value]
    CharManager.setProficiency(save, level)

    return key .. " " .. level
end