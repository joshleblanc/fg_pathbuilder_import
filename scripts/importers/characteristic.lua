local MAP = {
  str = "strength",
  dex = "dexterity",
  con = "constitution",
  int = "intelligence",
  wis = "wisdom",
  cha = "charisma"
}


-- this is being overwritten the first time you open the character sheet 
function import(node, value, key)

  local numToAdd = 0
  local ones = value - 18

  if ones > 0 then 
    numToAdd = ones + 4
  else
    numToAdd = (value - 10) / 2
  end

  for i=1,numToAdd do
    DB.setValue(node, "chargentracker.abilities.pathbuilder_import_" .. key .. "_" .. i, "string", map(key))
  end
end

function map(value)
  return MAP[value]
end