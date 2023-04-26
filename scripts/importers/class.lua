function find_class(value)
  return Finder.getRecordGlobally(value, { "reference.classes" })
end

function import(node, value)
  local class = find_class(value)

  if not class then 
    return value .. " not found" 
  end

  CharManager.addInfoDB(node, "referenceclass", class.getNodeName())

  return value .. " imported as " .. DB.getValue(class, "name", "")

  --DB.setValue(nodeClass, "name", "string", DB.getValue(class, "name", ""));
  --DB.setValue(nodeClass, "shortcut", "windowreference", "referenceclass", class.getNodeName());
end