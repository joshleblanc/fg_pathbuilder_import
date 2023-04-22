function findFeat(value)
  local records = DB.getChildrenGlobal("reference.feats")

  for _, record in pairs(records) do
    local sRecordName = StringManager.trim(DB.getValue(record, "name", ""))

    if sRecordName:lower() == value:lower() then
        return record
    end
  end
end

function isFeatDupe(nodeChar, nodeFeat)
  local featList = nodeChar.createChild("featlist");

  Debug.console("FEAT LIST", featList.getChildren())

  for _, el in pairs(featList.getChildren()) do
    Debug.chat(DB.getValue(el, "name", "") .. " == ", DB.getValue(nodeFeat, "name", ""))
    if DB.getValue(el, "name", "") == DB.getValue(nodeFeat, "name", "") then
			return true;
		end
  end

  return false
end

--[[
  value is an array here
  Looks like: [Name, ?, Type, ?]

--]]
function import(node, value)
  local feat = findFeat(value[1])

  Debug.chat("Importing " .. value[1])

  if not feat then return end 

  if isFeatDupe(node, feat) then 
    Debug.chat("Feat is duplicate " .. value[1])
    return
  end

  CharManager.addInfoDB(node, "referencefeat", feat.getNodeName())
end