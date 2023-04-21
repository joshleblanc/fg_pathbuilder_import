function import(node, value)
  local recordNodes = DB.getChildrenGlobal("reference.ancestries")
  for _, recordNode in pairs(recordNodes) do
      local sRecordName = StringManager.trim(DB.getValue(recordNode, "name", ""))

      if (sRecordName == value) then
          -- ancestry found, set the ancestry
          DB.setValue(node, "race", "string", sRecordName)
          DB.setValue(node, "racelink", "windowreference", "referencerace", recordNode.getNodeName())
          break
      end   
  end
end