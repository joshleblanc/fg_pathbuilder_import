local BAD_SOURCES = {
  "Troubles in Otari Player's Resource" -- heck this book and its level 4 classes
}

function find_class(value)
  return Finder.getRecordGlobally(value, LibraryData.getMappings("class"), function(node)
    
    if StringManager.contains(BAD_SOURCES, DB.getModule(node)) then
      return false
    end

    return true
  end)
end

function import(node, value)
  local class = find_class(value)

  if not class then 
    return value .. " not found" 
  end

  CharManager.addInfoDB(node, "referenceclass", class.getNodeName())

  return value .. " imported as " .. DB.getValue(class, "name", "")
end