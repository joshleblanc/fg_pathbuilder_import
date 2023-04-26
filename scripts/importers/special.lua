function exists(nodeChar, nodeFeature)
  local sClassName = StringManager.strip(DB.getValue(nodeFeature, "...name", ""))
  local sFeatureStrip = StringManager.strip(DB.getValue(nodeFeature, "name", ""))

  local nodeTargetList = nodeChar.createChild("specialabilitylist")
  
  local sFeatureStripLower, _, sFeatureSuffix = CharManager.parseFeatureName(sFeatureStrip);

  for _,v in pairs(nodeTargetList.getChildren()) do
    local sStrip = StringManager.strip(DB.getValue(v, "name", ""))
    local sLower, _, sSuffix = CharManager.parseFeatureName(sStrip)
    
    if sLower == sFeatureStripLower then
      local sSource = StringManager.strip(DB.getValue(v, "source", ""));
      if sSource ~= sClassName and sSource ~= "" then
        return false;
      end

      if sSuffix or sFeatureSuffix then
        return false
      end

      return true
    end
  end
  return false
end


function import(node, value)
  local adj = value:match(".+: (.+)")
  if not adj then
    adj = value
  end

  local record = Finder.getLookupDataRecordGlobally(adj)

  if not record then
    return value .. " not found"
  end

  if exists(node, record) then
    return value .. " already exists"
  end

  CharManager.addInfoDB(node, "referenceclassability", record.getNodeName())

  return value .. " imported as " .. DB.getValue(record, "name", "")
end