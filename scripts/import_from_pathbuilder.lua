local data = {}
local DBMap = {}
local windowsOpen = {}
local running = false
local updateExclusions = {
  "class",
  "inventory",
  "gp", "sp", "pp", "cp",
  "ancestry",
  "heritage",
  "name",
  "background",
  "equipment",
  "weapons",
  "armor"
} 

DEPENDENCIES = {
  background = { "ancestry" },
  spellCasters = { "specials" },
  focusSpells = { "specials" },
  ancestryFree = { "ancestry", "background", "heritage" },
  classBoosts = { "ancestry", "background", "heritage" },
  str = { "ancestry", "background", "heritage" },
  dex = { "ancestry", "background", "heritage" },
  con = { "ancestry", "background", "heritage" },
  int = { "ancestry", "background", "heritage" },
  wis = { "ancestry", "background", "heritage" },
  cha = { "ancestry", "background", "heritage" },
}

function importFromPathbuilder(sCommand, sParams)
  Interface.openWindow("import_window", "")
end

function addError(nodeChar, key, value)
  local node = nodeChar.createChild("pb_import_errors")
  local a = node.createChild()
  local b = a.createChild("name", "string")
  b.setValue(key)
  local c = a.createChild("error", "string")
  c.setValue(value)
end

function registerErrors(node)
  DB.deleteChildren(node)
end

function onInit()
  Comm.registerSlashHandler("importpathbuilder", importFromPathbuilder)
  Comm.registerSlashHandler("impb", importFromPathbuilder)

  Interface.onWindowOpened = onWindowOpened
  Comm.onReceiveOOBMessage = onReceiveOOBMessage

  DBMap = {
    name = Basic.import,
    ancestry = Ancestry.import,
    background = Background.import,
    class = Class.import,
    alignment = Basic.import,
--    str = Characteristic.import,
--    dex = Characteristic.import,
--    con = Characteristic.import,
--    int = Characteristic.import,
--    wis = Characteristic.import,
--    cha = Characteristic.import,
    deity = Deity.import,
    keyability = KeyAbility.import,
    level = Level.import,
    heritage = Heritage.import,
    acrobatics = Skill.import,
    arcana = Skill.import,
    athletics = Skill.import,
    crafting = Skill.import,
    deception = Skill.import,
    diplomacy = Skill.import,
    intimidation = Skill.import,
    medicine = Skill.import,
    nature = Skill.import,
    occultism = Skill.import,
    performance = Skill.import,
    religion = Skill.import,
    society = Skill.import,
    stealth = Skill.import,
    survival = Skill.import,
    thievery = Skill.import,
    perception = Skill.import,
    fortitude = Save.import,
    reflex = Save.import,
    will = Save.import,
    feats = Feat.import,
    lores = Lore.import,
    gp = Currency.import,
    pp = Currency.import,
    sp = Currency.import,
    cp = Currency.import,
    equipment = Equipment.import,
    spellCasters = Spell.import,
    specials = Special.import,
    languages = Language.import,
    weapons = Weapon.import,
    armor = Weapon.import,
    focusSpells = FocusSpell.import,
    trained = Proficiency.import,
    expert = Proficiency.import,
    master = Proficiency.import,
    legendary = Proficiency.import,
    gender = Basic.import,
    age = Basic.import,
    size = Size.import,
    ancestryFree = Boost.import,
    backgroundBoosts = Boost.import, 
    classBoosts = Boost.import,
    light = ArmorProficiency.import,
    heavy = ArmorProficiency.import,
    medium = ArmorProficiency.import,
    unarmored = ArmorProficiency.import,
    unarmed = WeaponProficiency.import,
    simple = WeaponProficiency.import,
    martial = WeaponProficiency.import,
    advanced = WeaponProficiency.import,
    castingDivine = SpellProficiency.import,
    castingOccult = SpellProficiency.import,
    castingPrimal = SpellProficiency.import,
    castingArcane = SpellProficiency.import
  }

  for i=1,20 do 
    DBMap[tostring(i)] = Boost.import
  end
end

function EachKey(fn, root)
  root = root or data

  for k, v in pairs(root) do

    -- if it's a table and not an array
    if type(v) == "table" and not v[1] then
      EachKey(fn, v)
    else
      fn(k, v)
    end
  end

  return nil
end

function onWindowOpened(window)
  if running then
    table.insert(windowsOpen, window)
  end
end

--[[
  Some fields only get created when the character sheet window opens, but they're used
  during calculations. So we need to create them prior to beginning the import
]]
function buildRequiredNodes(node)
  node.createChild("saves.fortitude")
  node.createChild("saves.reflex")
  node.createChild("saves.will")
end

function importCharFromFile(window)
  Interface.dialogFileOpen(function(result, vPath)
    onImportFileSelection(result, vPath, window)
  end, { json = "Pathbuilder JSON" }, nil, false);
end

function onImportFileSelection(result, vPath, window)
  if result ~= "ok" then return; end

  jsonData = File.openTextFile(vPath);
  tryImport(jsonData);
end

function findChar(name)
  local chars = DB.getChildren("charsheet")
  for _, char in pairs(chars) do
    if DB.getValue(char, "name", "") == name then
      return char
    end
  end
end

function onReceiveOOBMessage(data)
  if data.action == "start_import" then
    if Session.IsHost then
      local nChar = doPBImport(data.json, data.updateExisting == "1")
      if not nChar then
        Comm.deliverOOBMessage({ name = name, action = "import_failed" }, { data.user })
        return
      end

      local owner = DB.getOwner(nChar)
      if owner == nil or owner == "" then
        DB.setOwner(nChar, data.user)
      end

      local name = DB.getValue(nChar, "name", "")

      Comm.deliverOOBMessage({ name = name, action = "import_complete" }, { data.user })
    end
  end

  if data.action == "import_complete" then
    local importWindow = getImportWindow()
    local char = findChar(data.name)

    importWindow.errors.setDatabaseNode(char.getChild("pb_import_errors"))
    prompt("Import complete")
  end

  if data.action == "import_failed" then
    prompt("Failed to import character. Please double check your JSON")
  end
end

function getImportWindow()
  return Interface.findWindow("import_window", "")
end

function tryImport(json)
  local importWindow = getImportWindow()
  local updateExisting = importWindow.overwrite.getValue()

  prompt("Importing, please wait...")

  if Session.IsHost then
    if doPBImport(json, updateExisting) then
      prompt("Import complete")
    else
      prompt("Failed to import character. Please double check your JSON")
    end
  else
    Comm.deliverOOBMessage({
      action = "start_import",
      json = json,
      user = User.getUsername(),
      updateExisting = updateExisting
    })
  end
end

function prompt(msg)
  Interface.dialogMessage(function()
    -- do nothing
  end, msg, "Pathbuilder Import")
end

function importKey(key, doneMap, call, mappingCache)

  local arr = mappingCache[key]
  if not arr or doneMap[key] then return end

  if DEPENDENCIES[key] then
    for _, dep in ipairs(DEPENDENCIES[key]) do
      importKey(dep, doneMap, call, mappingCache)
    end
  end

  for index, el in ipairs(arr) do
    call(key, el, index)
  end

  doneMap[key] = true
end

-- NOTE: rulesets/PFRPG2.pak/campaign/scripts/manager_char.lua has some good stuff in it
function doPBImport(pcJson, updateExisting)
  local importWindow = getImportWindow()

  running = true

  local status, retVal = pcall(JSONUtil.parseJson, pcJson)
  data = retVal

  if not status then
    return
  end

  if type(data) ~= "table" or not data.build then
    return
  end

  local nodeChar
  if updateExisting then
    nodeChar = findChar(data.build.name)
  end

  if not nodeChar then
    nodeChar = DB.createChild("charsheet")
    updateExisting = false

    if OptionsManager.getOption("ACAD") == "on" then
      PCActivitiesManager.constructDefaultActivities(nodeChar);
    end	
  end

  if not nodeChar then
    return
  end

  -- if a client initiated this, the window might not be open on the host
  if importWindow then
    importWindow.errors.setDatabaseNode(nodeChar.createChild("pb_import_errors"))
  end

  DB.deleteChildren(nodeChar.createChild("pb_import_errors"))


  --[[
      As far as I can tell, this _has_ to be a callback.
      It must run in the middle of the addClass function.

      If we run it manually after adding a class, the PC level is 0 while calculating
      spell slots. If we run it before, there's no class present in the xml to increment it to 1

      We remove this handler after the import.
    ]]
  local onLevelChanged = function()
    -- we need to start at level 1, or spell slots will be off by 1
    CharManager.calcLevel(nodeChar);
    CharManager.recalcProficiencies(nodeChar);
  end

  DB.addHandler(DB.getPath(nodeChar, "classes"), "onChildUpdate", onLevelChanged);

  buildRequiredNodes(nodeChar)

  function call(key, el, index)

    if updateExisting and StringManager.contains(updateExclusions, key) then
      return
    end

    local msg = DBMap[key](nodeChar, el, key, index)

    if msg then
      if type(msg) == "table" then
        for _, m in ipairs(msg) do
          addError(nodeChar, key, m)
        end
      else
        addError(nodeChar, key, msg)
      end
    end
  end

  mappingCache = {}

  -- iterate every key in the json file and map it to the right import key
  EachKey(function(key, value)
    if DBMap[key] then

      -- if the value is an array, store each element
      if type(value) == "table" then
        for _, el in ipairs(value) do
          mappingCache[key] = mappingCache[key] or {}
          table.insert(mappingCache[key], el)
        end
        -- otherwise just store the value
      else
        mappingCache[key] = mappingCache[key] or {}
        table.insert(mappingCache[key], value)
      end
    end
  end)

  -- We want to import instincts first, so we know what instict the character is
  -- to properly map anmials, dragons, etc back to the character since pathbuilder exports those 
  -- as "Cat", "Black", etc.
  if mappingCache["specials"] then 
    table.sort(mappingCache["specials"], function(a,b)
      if StringManager.endsWith(a, "Instinct") then 
        return true
      end
      return false
    end)
  end

  Special.resetInstinct()

  local doneMap = {}

  for key, _ in pairs(DBMap) do
    importKey(key, doneMap, call, mappingCache)
  end

  for _, window in ipairs(windowsOpen) do
    pcall(function()
      window.close()
    end)
  end
  windowsOpen = {}

  DB.setValue(nodeChar, "chargentracker.opened", "number", 1)

  running = false

  DB.removeHandler(DB.getPath(nodeChar, "classes"), "onChildUpdate", onLevelChanged)

  return nodeChar
end
