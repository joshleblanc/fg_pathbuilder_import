function findHeritage(value)
  local records = DB.getChildrenGlobal("reference.lookupdata")

  --Debug.console(records)
  for _, record in pairs(records) do
    local sRecordName = StringManager.trim(DB.getValue(record, "name", ""))

    -- deity is free text on pathbuilder, so do our best
    if sRecordName:lower() == value:lower() then
        return record
    end
  end
end

function import(node, value)
  local heritage = findHeritage(value)

  if not heritage then return end 

  CharManager.addInfoDB(node, "reference_lookupdata", heritage.getNodeName())
end