local instinct = nil

function resetInstinct()
  instinct = nil
end

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

-- Pathbuilder returns the animal instinct animal as just "Cat", so we have to handle this manually
function fixInstinctChoice(value)
  local choices = { 
    "Ape", "Bear", "Bull", "Cat", "Deer", "Frog", "Shark", "Snake", "Wolf",
  }

  for _, choice in ipairs(choices) do 
    if value == choice then 
      return "Rage - " .. value .. " (" .. instinct .. ")"
    end
  end

  return value
end

function fixAnimalInstictAbilities(value)
  local fixed = value:match("(.+) %(Instinct Ability%)$")

  if fixed then 
    return fixed .. " (Animal Instinct Ability)"
  end

  return value
end


function import(node, value)
  if StringManager.endsWith(value, "Instinct") then
    instinct = value
  end
  
  -- colors don't do anything automatically, no class feats for them.
  local colors = {
    "Black", "Blue", "Brass", "Brine", "Bronze", "Cloud", "Copper", "Crystal", "Forest", "Gold", "Green", "Magma", "Red", "Sea", "Silver", "Sky", "Sovereign", "Umbral", "Underworld", "White"
  }

  for _, color in ipairs(colors) do 
    if value == color then return end 
  end

  -- Elements don't do anything automatically
  local elements = {
    "Air", "Earth", "Fire", "Water"
  }

  for _, element in ipairs(elements) do 
    if value == element then return end 
  end

  value = removePrefix(value)
  value = removeSuffix(value, "Patron")
  value = removeSuffix(value, "Mystery")
  value = removeSuffix(value, "Methodology")
  value = removeSuffix(value, "Racket")
  value = removeSuffix(value, "Style") 

  value = fixAnimalInstictAbilities(value)
  value = fixInstinctChoice(value)

  -- Rage isn't an ability
  if value == "Rage" then return end 
  if instinct and StringManager.endsWith(value, "(" .. instinct .. " Ability)") then return end

  local record = Finder.getLookupDataRecordGlobally(value)

  if not record then
    return value .. " not found"
  end

  if exists(node, record) then
    return value .. " already exists"
  end

  CharManager.addInfoDB(node, "reference_lookupdata", record.getNodeName())

  Debug.chat(value .. " imported as " .. DB.getValue(record, "name", ""))
  return value .. " imported as " .. DB.getValue(record, "name", "")
end