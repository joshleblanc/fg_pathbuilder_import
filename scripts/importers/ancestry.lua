function findRace(value)
  local recordNodes = DB.getChildrenGlobal("reference.ancestries")
  for _, recordNode in pairs(recordNodes) do
      local sRecordName = StringManager.trim(DB.getValue(recordNode, "name", ""))

      if (sRecordName == value) then
          return recordNode
      end   
  end
  
end

function import(node, value)
  local race = findRace(value)

  if not race then return end 

  CharManager.addInfoDB(node, "referencerace", race.getNodeName())
end