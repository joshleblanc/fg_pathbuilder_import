
function exists(node, spell)
  local slot = 0
  local value = DB.getValue(spell, "name", "")
  
  if DB.getValue(spell, "spelltype", "") == "CANTRIP" then
    slot = 0
  else		
    slot = tostring(DB.getValue(spell, "level", 1))
  end

  local spellsets = DB.createChild(node, "spellset")

  for _, spellset in pairs(spellsets.getChildren()) do 
    local levels = DB.createChild(spellset, "levels")
    local level = DB.createChild(levels, "level" .. slot)
    local spells = DB.createChild(level, "spells")

    for _, spell in pairs(spells.getChildren()) do 
      local name = DB.getValue(spell, "name", "")
      if name == value then 
        return true
      end 
    end
  end

  return false
end

function import(node, value)
  local msgs = {}
  for _, spell in ipairs(value.spells) do
    for _, spellName in ipairs(spell.list) do 
      local nSpell = Finder.getRecordGlobally(spellName, { "spell", "reference.spells", "spelldesc" })
      local nSpellName = DB.getValue(nSpell, "name", "")

      if exists(node, nSpell) then
        table.insert(msgs, "level " .. spell.spellLevel .. " " .. spellName .. " already exists")
      else
        table.insert(msgs, "level " .. spell.spellLevel .. " " .. spellName .. " imported as " .. nSpellName)
        CharManager.addSpellToClass(node, value.name, nSpellName, spell.spellLevel)
      end
    end
  end

  return msgs
end