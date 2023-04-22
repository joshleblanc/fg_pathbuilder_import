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
  local abilitiesNode = DB.createChild(node, "abilities")
  local characteristicNode = DB.createChild(abilitiesNode, map(key))
  
  DB.setValue(characteristicNode, "bonus", "number", "1")
  DB.setValue(characteristicNode, "bonusmodifier", "number", 0)
  DB.setValue(characteristicNode, "damage", "number", 0)
  DB.setValue(characteristicNode, "tempmod", "number", 0)
  DB.setValue(characteristicNode, "chargen", "number", value)
  DB.setValue(characteristicNode, "miscmod", "number", 0)
  DB.setValue(characteristicNode, "score", "number", value)
end

function map(value)
  return MAP[value]
end