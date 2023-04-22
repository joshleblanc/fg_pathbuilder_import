local map = {
  str = "strength",
  dex = "dexterity",
  con = "constitution",
  int = "intelligence",
  wis = "wisdom",
  cha = "charisma"
}


function import(node, value)
  DB.setValue(node, "keyability", "string", Characteristic.map(value))
end