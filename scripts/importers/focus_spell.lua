function import(node, value)
  local spell = Finder.getRecordGlobally(value, { "spell", "reference.spells", "spelldesc" })
  local name = DB.getValue(spell, "name", "")

  if Spell.exists(node, spell) then
    return name .. " already exists"
  else
    CharManager.addSpellToClass(node, "Focus Spells", name)
    return value .. " imported as " .. name
  end
end