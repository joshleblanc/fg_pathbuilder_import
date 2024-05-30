local data = {
    unarmed = "unarmed attacks",
    simple = "simple weapons",
    martial = "martial weapons",
    advanced = "advanced weapons"
}

function import(node, value, key)
    local level = IMPBData.proficiencyLevels[value]

    local profText = level .. " in " .. data[key]

    CharManager.handleWeaponAndArmorProficiencies(node, profText, "Weapons")
end