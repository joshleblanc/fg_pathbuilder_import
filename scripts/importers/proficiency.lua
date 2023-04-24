function import(node, value, key)
  local weapon = Finder.getRecordGlobally(value, { "reference.weapon" })
  local armor = Finder.getRecordGlobally(value, { "reference.armor" })

  if weapon then 
    CharManager.addAttackProficiency(node, DB.getValue(weapon, "name", ""), "", key)
  end

  if armor then
    CharManager.addDefenseProficiency(node, DB.getValue(armor, "name", ""), "", key)
  end
end