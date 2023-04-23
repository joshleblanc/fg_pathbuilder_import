function fixString(str)
  str = GameSystem.removeActionSymbols(str)
  str = str:lower()
  str = str:gsub("(%w+) %(%w+%)", "%1")
  str = StringManager.trim(str)

  return str
end

function getLookupDataRecordGlobally(sRecordName, sLookupDataType)
	local aDataMap = { "lookupdata", "reference.lookupdata" }

  local sLookupDataType = fixString(sLookupDataType)
  local sRecordName = fixString(sRecordName)
	
	local recordMatchNode = nil;
	
	for _, topLevelNodeName in pairs(aDataMap) do
		local recordNodes = DB.getChildrenGlobal(topLevelNodeName)

		for _, recordNode in pairs(recordNodes) do
			if fixString(DB.getValue(recordNode, "lookupdatatype", "")) == sLookupDataType then
				local recordCheckName = fixString(DB.getValue(recordNode, "name", ""))
				if recordCheckName == sRecordName then
					recordMatchNode = recordNode
					break
				end
			end
		end

		if recordMatchNode ~= nil then break end
	end
	
	return recordMatchNode;
end

function getRecordGlobally(sRecordName, aDataMap)
	sRecordName = fixString(sRecordName)

	-- Get record nodes from the database paths in aDataMap
	local recordMatchNode = nil;
	
	for k, topLevelNodeName in pairs(aDataMap) do
		local recordNodes = DB.getChildrenGlobal(topLevelNodeName); 
		for k, recordNode in pairs(recordNodes) do
			local recordCheckName = fixString(DB.getValue(recordNode, "name", ""))
			if recordCheckName == sRecordName then
				recordMatchNode = recordNode;
				break;
			end
		end	
		if recordMatchNode ~= nil then
			break;
		end
	end
	
	return recordMatchNode;
end

function getFeat(sFeatName, sTrait)
	if not sFeatName or sFeatName == "" then
		return nil;	
	end
	if not sTrait then
		sTrait = "";
	end

  sFeatName = fixString(sFeatName)
  sTrait = fixString(sTrait)

	local featMatchNode = nil;
	local featNodes = DB.getChildrenGlobal("feat")
	if featNodes then
		for k, featNode in pairs(featNodes) do
			local featCheckName = fixString(DB.getValue(featNode, "name", ""))
			local featCheckTraits = fixString(DB.getValue(featNode, "traits", ""))
			if featCheckName == sFeatName and string.find(featCheckTraits, sTrait) then
				featMatchNode = featNode;
				break;
			end
		end
	end
	
	if featMatchNode == nil then
		local featReferenceNodes = DB.getChildrenGlobal("reference.feats")
		if featReferenceNodes then
			for _,featNode in pairs(featReferenceNodes) do
				local featCheckName = fixString(DB.getValue(featNode, "name", ""))
				local featCheckTraits = fixString(DB.getValue(featNode, "traits", ""))		
				if featCheckName == sFeatName and string.find(featCheckTraits, sTrait) then			
					featMatchNode = featNode;
					break
				end
			end	
		end
	end
	
	return featMatchNode
end