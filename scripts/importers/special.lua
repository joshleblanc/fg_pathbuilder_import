function import(node, value)
  local adj = value:match(".+: (.+)")
  if not adj then
    adj = value
  end

  Debug.chat("Importing special " .. adj)

  local record = Finder.getLookupDataRecordGlobally(adj)

  if not record then
    return value .. " not found"
  end

  CharManager.addInfoDB(node, "referenceclassability", record.getNodeName())

  return value .. " imported as " .. DB.getValue(record, "name", "")
end