
function import(node, value, key)
    local save = DB.getChild(node, "saves." .. key);

    if not save then 
        return key .. " not found"
    end

    if value == 2 then
        CharManager.setProficiency(save, "trained")
    elseif value == 4 then 
        CharManager.setProficiency(save, "expert")
    elseif value == 6 then
        CharManager.setProficiency(save, "master")
    elseif value == 8 then 
        CharManager.setProficiency(save, "legendary")
    end
end