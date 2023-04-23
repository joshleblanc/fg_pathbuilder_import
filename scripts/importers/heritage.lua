function findHeritage(value)
  return Finder.getLookupDataRecordGlobally(value, "heritage")
end

function import(node, value)
  local heritage = findHeritage(value)

  if not heritage then return end 

  CharManager.addInfoDB(node, "reference_lookupdata", heritage.getNodeName())
end