local MAP = {
  str = "strength",
  dex = "dexterity",
  con = "constitution",
  int = "intelligence",
  wis = "wisdom",
  cha = "charisma"
}

--[[
  The chargentracker can add mandatory characteristic changes
  We need to iterate through the flaws and bonuses to get a new 
  starting point for our inserts
]]
function countExisting(node, name)
  local abilities = DB.getChildren(node, "chargentracker.abilities")

  local count = 0
  for k, v in pairs(abilities) do 
    local abilityName = v.getValue()

    if abilityName == name and string.find(k, "flaw") then
      count = count - 2
    end
  end

  for k, v in pairs(abilities) do 
    local abilityName = v.getValue()

    if abilityName == name and not string.find(k, "flaw") then
      if count >= 8 then 
        count = count + 1
      else
        count = count + 2
      end
    end
  end

  return count
end


-- this is being overwritten the first time you open the character sheet 
function import(node, value, key)
  local name = map(key)
  local numExisting = countExisting(node, name)

  value = value - numExisting

  local numToAdd = 0
  local ones = value - 18

  if ones > 0 then 
    numToAdd = ones + 4
  else
    numToAdd = (value - 10) / 2
  end

  for i=1,numToAdd do
    DB.setValue(node, "chargentracker.abilities.pathbuilder_import_" .. key .. "_" .. i, "string", name)
  end
end

function map(value)
  return MAP[value]
end