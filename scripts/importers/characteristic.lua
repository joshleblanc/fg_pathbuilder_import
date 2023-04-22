local map = {
  str = "strength",
  dex = "dexterity",
  con = "constitution",
  int = "intelligence",
  wis = "wisdom",
  cha = "charisma"
}

--[[
  				<bonus type="number">1</bonus>
					<bonusmodifier type="number">0</bonusmodifier>
					<chargen type="number">12</chargen>
					<damage type="number">0</damage>
					<miscmod type="number">0</miscmod>
					<score type="number">12</score>
					<tempmod type="number">0</tempmod>
]]

function import(node, value, key)
  local abilitiesNode = DB.createChild(node, "abilities")
  local characteristicNode = DB.createChild(abilitiesNode, map[key])
  

  -- this isn't working. It's creating the records in the db.xml, but they're not showing up in the window
  -- bonus isn't being set to 1, it's being set to 0. Might be why?
  DB.setValue(characteristicNode, "bonus", "number", "1")
  DB.setValue(characteristicNode, "bonusmodifier", "number", 0)
  DB.setValue(characteristicNode, "damage", "number", 0)
  DB.setValue(characteristicNode, "tempmod", "number", 0)
  DB.setValue(characteristicNode, "chargen", "number", value)
  DB.setValue(characteristicNode, "score", "number", value)
end