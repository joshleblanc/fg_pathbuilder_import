function findHeritage(value)
  return Finder.getLookupDataRecordGlobally(value, "heritage")
end

function import(node, value)
  local heritage = findHeritage(value)

  if not heritage then 
    return value .. " not found" 
  end 

  CharManager.addInfoDB(node, "reference_lookupdata", heritage.getNodeName())

  return value .. " imported as " .. DB.getValue(heritage, "name", "")
end