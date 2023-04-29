function import(node, value)
  local curLevel = DB.getValue(node, "level", 0)

  local numLevelsToAdd = value - curLevel
  for i=1,numLevelsToAdd do
    CharManager.addLevel(node)
  end
end