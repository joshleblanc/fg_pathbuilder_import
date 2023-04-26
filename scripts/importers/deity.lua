function findDeity(value)
  return Finder.getLookupDataRecordGlobally(value, "deity")
end

function import(node, value)
  if value == "Not set" then return end

  local deity = findDeity(value)

  if not deity then 
    return value .. " not found"
  end 

  CharManager.addInfoDB(node, "reference_lookupdata", deity.getNodeName())

  return value .. " imported as " .. DB.getValue(deity, "name", "")
end