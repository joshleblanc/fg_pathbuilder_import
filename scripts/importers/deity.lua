--[[
  <deity type="string">Abadar (LN)</deity>
  <deitylink type="windowreference">
    <class>reference_lookupdata</class>
    <recordname>reference.lookupdata.abadarln@Pathfinder Second Edition Core Rules</recordname>
  </deitylink>
]]

function findDeity(value)
  local records = DB.getChildrenGlobal("reference.lookupdata")

  --Debug.console(records)
  for _, record in pairs(records) do
    local sRecordName = StringManager.trim(DB.getValue(record, "name", ""))

    -- deity is free text on pathbuilder, so do our best
    if StringManager.startsWith(sRecordName:lower(), value:lower()) then
        return record
    end
  end
end

function import(node, value)
  if value == "Not set" then return end

  local deity = findDeity(value)

  if not deity then return end 

  CharManager.addInfoDB(node, "reference_lookupdata", deity.getNodeName())
end