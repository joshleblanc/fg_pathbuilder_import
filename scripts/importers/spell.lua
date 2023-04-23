
function import(node, value)
  for _, spell in ipairs(value.spells) do
    for _, spellName in ipairs(spell.list) do 
      CharManager.addSpellToClass(node, value.name, spellName)
    end
  end
end