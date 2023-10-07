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

-- Pathbuilder often prefixes record names, such as Arcane School: Evocation
-- we only care about the Evocation part
function removePrefix(value)
  local withoutPrefix = value:match(".+: (.+)")

  if withoutPrefix then 
    return withoutPrefix 
  else
    return value
  end
end

-- Pathbuilder uses the suffix "Patron" when dealing with witch patrons
-- We need to remove that if we're importing a patron so we can match it against
-- fgu data
-- This applies to a few special data types. eg. mysteries, etc
function removeSuffix(value, suffix)
  local withoutSuffix = value:match("(.+) " .. suffix .. "$")

  if withoutSuffix then 
    return withoutSuffix
  else
    return value
  end
end


function import(node, value)
  value = removePrefix(value)
  value = removeSuffix(value, "Patron")
  value = removeSuffix(value, "Mystery")

  local record = Finder.getLookupDataRecordGlobally(value)

  if not record then
    return value .. " not found"
  end

  if exists(node, record) then
    return value .. " already exists"
  end

  CharManager.addInfoDB(node, "reference_lookupdata", record.getNodeName())

  return value .. " imported as " .. DB.getValue(record, "name", "")
end