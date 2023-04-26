function findBackground(value)
  return Finder.getRecordGlobally(value, { "reference.backgrounds" })
end

function import(node, value)
  local background = findBackground(value)

  if not background then 
    return value .. " not found"
  end

  CharManager.addInfoDB(node, "reference_background", background.getNodeName())

  return value .. " imported as " .. DB.getValue(background, "name", "")
end