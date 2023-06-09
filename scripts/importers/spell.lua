
function exists(node, spell, spellLevel)
  local value = DB.getValue(spell, "name", "")

  local spellsets = DB.createChild(node, "spellset")

  if not spellLevel then 
    spellLevel = DB.getValue(spell, "level", 0)
  end

  for _, spellset in pairs(spellsets.getChildren()) do
    local levels = DB.createChild(spellset, "levels")
    local level = DB.createChild(levels, "level" .. spellLevel)
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

function createSpellLevel(node, spellLevel)
  local spellsets = DB.createChild(node, "spellset")

  for _, spellset in pairs(spellsets.getChildren()) do
    local levels = DB.createChild(spellset, "levels")
    local level = DB.createChild(levels, "level" .. spellLevel)

    DB.setValue(level, "level", "number", spellLevel)
  end
end

function import(node, value)
  local msgs = {}
  for _, spell in ipairs(value.spells) do
    createSpellLevel(node, spell.spellLevel)
    for _, spellName in ipairs(spell.list) do 
      local nSpell = Finder.getRecordGlobally(spellName, LibraryData.getMappings("spell"))
      local nSpellName = DB.getValue(nSpell, "name", "")

      if exists(node, nSpell, spell.spellLevel) then
        table.insert(msgs, "level " .. spell.spellLevel .. " " .. spellName .. " already exists")
      else
        table.insert(msgs, "level " .. spell.spellLevel .. " " .. spellName .. " imported as " .. nSpellName)
        CharManager.addSpellToClass(node, value.name, nSpellName, spell.spellLevel)
      end
    end
  end

  return msgs
end