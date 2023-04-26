function import(node, value)
  local curLevel = DB.getValue(node, "level", "")
  local numLevelsToAdd = value - curLevel
  for i=1,numLevelsToAdd do
    CharManager.addLevel(node)
  end
end