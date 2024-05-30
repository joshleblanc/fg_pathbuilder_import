local data = {
    unarmored = "unarmored",
    light = "light armor",
    medium = "medium armor",
    heavy = "heavy armor"
}

function import(node, value, key)
    local level = IMPBData.proficiencyLevels[value]

    local profText = level .. " in " .. data[key]

    CharManager.handleWeaponAndArmorProficiencies(node, profText, "Armor")
end