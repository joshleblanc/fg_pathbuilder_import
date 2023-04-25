function import(node, value)
  local adj = value:match("%w+: (.+)")

  local record = Finder.getLookupDataRecordGlobally(adj, "class")

  if not record then
    return value .. " not found"
  end

  CharManager.addInfoDB(node, "referenceclassability", record.getNodeName())
end