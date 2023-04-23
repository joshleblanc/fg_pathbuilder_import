function import(node, value)
  local adj = value:match("%w+: (.+)")

  local record = Finder.getLookupDataRecordGlobally(adj, "class")

  Debug.console("Special record: ", record)
  if not record then return end 

  CharManager.addInfoDB(node, "referenceclassability", record.getNodeName())
end