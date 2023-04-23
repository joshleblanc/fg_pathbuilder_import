function findBackground(value)

  -- pathbuilder backgrounds have variations (eg. Scholar (Arcana))
  -- we need to remove everything in the parenthesis
  value = value:gsub("(%w+) %(%w+%)", "%1")
  
  local backgroundRecords = DB.getChildrenGlobal("reference.backgrounds")
  for _, backgroundNode in pairs(backgroundRecords) do
      local sRecordName = StringManager.trim(DB.getValue(backgroundNode, "name", ""))

      if (sRecordName:lower() == value:lower()) then
        return backgroundNode
      end
  end
end

function import(node, value)
  local background = findBackground(value)

  if not background then return end

  CharManager.addInfoDB(node, "reference_background", background.getNodeName())
end