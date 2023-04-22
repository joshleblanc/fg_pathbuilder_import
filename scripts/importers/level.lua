function import(node, value)
  DB.setValue(node, "level", "number", value)
  CharManager.recalcProficiencies(node)
end