local QUALIFIERS = {
  greater =  "greater",
  lesser = "lesser",
  major =  "major",
  moderate = "moderate",
  ["true"] = "prefix", -- this one is dumb, staff of healing (true) is staff of healing - true staff of healing in fgu
  ["type i"] = "i",
  ["type ii"] = "ii",
  ["type iii"] = "iii",
  ["type iv"] = "iv",
}

function fixString(str)
  if not str then return "" end

  str = GameSystem.removeActionSymbols(str)
  str = str:lower()

  qualifier = string.match(str, "%((.+)%)")

  -- Debug.chat(str, qualifier)
  str = str:gsub("(.+) %(.+%)", "%1")
  str = str:gsub("(.+) %[.+%]", "%1")
  str = StringManager.trim(str)

  for k, v in pairs(QUALIFIERS) do
    if qualifier == k then
      if v == "prefix" then
        return str .. " - " .. k .. str
      end
      return str .. " - " .. v
    end
  end

  return str 
end

local function find(sRecordName, aDataMap, fn)
  local names = {}
  local nodeMap = {}
  sRecordName = fixString(sRecordName)

	for _, topLevelNodeName in pairs(aDataMap) do
		local recordNodes = DB.getChildrenGlobal(topLevelNodeName)
    for _, recordNode in pairs(recordNodes) do
      if not fn or fn(recordNode) then 
        local recordCheckName = fixString(DB.getValue(recordNode, "name", ""))       

        table.insert(names, recordCheckName)
        nodeMap[recordCheckName] = recordNode
      end
    end
  end

  local results = Fzy.filter(sRecordName, names)
  table.sort(results, function(a,b) 
    return a[3] > b[3]
  end)

  local winner = results[1]

  if winner and winner[3] > 0 then
    local name = names[winner[1]]

    return nodeMap[name]
  else
    return nil
  end
end

function getLookupDataRecordGlobally(sRecordName, sLookupDataType, fn)
	local aDataMap = LibraryData.getMappings("lookupdata")

  if sLookupDataType then 
    sLookupDataType = fixString(sLookupDataType)
  end

  return find(sRecordName, aDataMap, function(node)
    local recordCheckType = fixString(DB.getValue(node, "lookupdatatype", ""))

    if fn and not fn(node) then return false end

    if not sLookupDataType or recordCheckType == sLookupDataType then
      return true
    end

    return false
  end)
end

function getRecordGlobally(sRecordName, aDataMap, fn)
	sRecordName = fixString(sRecordName)

  return find(sRecordName, aDataMap, fn)
end

function getFeat(sFeatName, sTrait, fn)
	if not sFeatName or sFeatName == "" then return end

	if not sTrait then
		sTrait = "";
	end

  sTrait = fixString(sTrait)

  return find(sFeatName, LibraryData.getMappings("feat"), function(node)
    local featCheckTraits = fixString(DB.getValue(node, "traits", ""))

    if fn and not fn(node) then return false end

    if string.find(featCheckTraits, sTrait) then
      return true
    end

    return false
  end)
end