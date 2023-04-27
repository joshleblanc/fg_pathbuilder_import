function fixString(str)
  if not str then return "" end

  str = GameSystem.removeActionSymbols(str)
  str = str:lower()
  str = str:gsub("(.+) %(.+%)", "%1")
  str = StringManager.trim(str)

  return str
end

function find(sRecordName, aDataMap, fn)
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

  if winner then
    local name = names[winner[1]]

    return nodeMap[name]
  else
    return nil
  end
end

function compare(a, b)
  if Fzy.has_match(a, b) then 
    return Fzy.score(a, b) > 7
  end

  return false
end

function getLookupDataRecordGlobally(sRecordName, sLookupDataType, fn)
	local aDataMap = { "lookupdata", "reference.lookupdata" }

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

  return find(sFeatName, { "feat", "reference.feats" }, function(node)
    local featCheckTraits = fixString(DB.getValue(node, "traits", ""))

    if fn and not fn(node) then return false end

    if string.find(featCheckTraits, sTrait) then
      return true
    end

    return false
  end)
end