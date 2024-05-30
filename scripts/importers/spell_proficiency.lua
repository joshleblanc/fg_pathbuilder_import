local data = {
    castingDivine = "divine",
    castingOccult = "occult",
    castingPrimal = "primal",
    castingArcane = "arcane"
}

function import(node, value, key)
    local level = IMPBData.proficiencyLevels[value]

    if value == 0 then 
        return level
    end

    local profText = level .. " in " .. data[key] .. " spell attacks. " .. level .. " in " .. data[key] .. " spell dcs"

    CharManager.handleSpellProficiencies(node, profText)

    return level
end