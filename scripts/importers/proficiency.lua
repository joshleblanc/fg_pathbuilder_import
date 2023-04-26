function import(node, value, key)
  local weapon = Finder.getRecordGlobally(value, { "reference.weapon" })
  local armor = Finder.getRecordGlobally(value, { "reference.armor" })

  if weapon then 
    CharManager.addAttackProficiency(node, DB.getValue(weapon, "name", ""), "", key)

    return value .. " imported as " .. DB.getValue(weapon, "name", "")
  end

  if armor then
    CharManager.addDefenseProficiency(node, DB.getValue(armor, "name", ""), "", key)

    return value .. " imported as " .. DB.getValue(armor, "name", "")
  end

  if not weapon and not armor then
    return value .. " not found"
  end
end