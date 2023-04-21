function import(node, value)
  local background = value
  local backgroundRecords = DB.getChildrenGlobal("reference.backgrounds")
  for _, backgroundNode in pairs(backgroundRecords) do
      local sRecordName = StringManager.trim(DB.getValue(backgroundNode, "name", ""))

      if (sRecordName:lower() == background:lower()) then
          DB.setValue(node, "background", "string", sRecordName)
          DB.setValue(node, "backgroundlink", "windowreference","reference_background", backgroundNode.getNodeName())
          break
      end
  end
end