function findBackground(value)
  local backgroundRecords = DB.getChildrenGlobal("reference.backgrounds")
  for _, backgroundNode in pairs(backgroundRecords) do
      local sRecordName = StringManager.trim(DB.getValue(backgroundNode, "name", ""))

      if (sRecordName:lower() == background:lower()) then
        return backgroundNode
      end
  end
end

function import(node, value)
  local background = findBackground(value)

  if not background then return end 

  CharManager.addInfoDB(node, "reference_background", background.getNodeName())
end