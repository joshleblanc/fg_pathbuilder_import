function fixString(str)
  if not str then return "" end

  str = GameSystem.removeActionSymbols(str)
  str = str:lower()
  str = str:gsub("(.+) %(.+%)", "%1")
  str = StringManager.trim(str)

  return str
end

function getLookupDataRecordGlobally(sRecordName, sLookupDataType)
	local aDataMap = { "lookupdata", "reference.lookupdata" }

  sLookupDataType = fixString(sLookupDataType)
  sRecordName = fixString(sRecordName)

	for _, topLevelNodeName in pairs(aDataMap) do
		local recordNodes = DB.getChildrenGlobal(topLevelNodeName)

		for _, recordNode in pairs(recordNodes) do
      local recordCheckType = fixString(DB.getValue(recordNode, "lookupdatatype", ""))

			if recordCheckType == sLookupDataType then
				local recordCheckName = fixString(DB.getValue(recordNode, "name", ""))

				if recordCheckName == sRecordName then
					return recordNode
				end
			end
		end
	end
end

function getRecordGlobally(sRecordName, aDataMap)
	sRecordName = fixString(sRecordName)

	for _, topLevelNodeName in pairs(aDataMap) do
		local recordNodes = DB.getChildrenGlobal(topLevelNodeName)

		for _, recordNode in pairs(recordNodes) do
			local recordCheckName = fixString(DB.getValue(recordNode, "name", ""))

			if recordCheckName == sRecordName then
        return recordNode
			end
		end
	end
end

function getFeat(sFeatName, sTrait)
	if not sFeatName or sFeatName == "" then return end

	if not sTrait then
		sTrait = "";
	end

  sFeatName = fixString(sFeatName)
  sTrait = fixString(sTrait)

	local featNodes = DB.getChildrenGlobal("feat")

  if not featNodes then return end

  for _, featNode in pairs(featNodes) do
    local featCheckName = fixString(DB.getValue(featNode, "name", ""))
    local featCheckTraits = fixString(DB.getValue(featNode, "traits", ""))

    if featCheckName == sFeatName and string.find(featCheckTraits, sTrait) then
      return featNode
    end
  end

  local featReferenceNodes = DB.getChildrenGlobal("reference.feats")

  if not featReferenceNodes then return end

  for _,featNode in pairs(featReferenceNodes) do
    local featCheckName = fixString(DB.getValue(featNode, "name", ""))
    local featCheckTraits = fixString(DB.getValue(featNode, "traits", ""))

    if featCheckName == sFeatName and string.find(featCheckTraits, sTrait) then
      return featNode
    end
  end
end