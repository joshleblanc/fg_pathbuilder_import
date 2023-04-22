
local data = {}
local DBMap = {}

function importFromPathbuilder(sCommand, sParams)
    Interface.openWindow("import_pathbuilder", "")
end

function onInit()
    Comm.registerSlashHandler("importpathbuilder", importFromPathbuilder)
    Comm.registerSlashHandler("impb", importFromPathbuilder)

    Interface.onWindowOpened = onWindowOpened

    DBMap = {
      name = Name.import,
      ancestry = Ancestry.import,
      background = Background.import,
      class = Class.import,
      alignment = Alignment.import,
      str = Characteristic.import,
      dex = Characteristic.import,
      con = Characteristic.import,
      int = Characteristic.import,
      wis = Characteristic.import,
      cha = Characteristic.import,
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
      survival = Skill.import,
      thievery = Skill.import,
      perception = Skill.import,
      fortitude = Skill.import,
      reflex = Skill.import,
      feats = Feat.import
    }
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

local windowsOpen = {}
local running = false

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

-- NOTE: rulesets/PFRPG2.pak/campaign/scripts/manager_char.lua has some good stuff in it
function doPBImport(pcJson, importWindow)
    running = true
    data = JSONUtil.parseJson(pcJson)
    local nodeChar = DB.createChild("charsheet");

    buildRequiredNodes(nodeChar)

    EachKey(function(key, value)
      if DBMap[key] then
        -- Debug.print("Importing: " .. key)

        -- if the value is an array, run the import on each element
        if type(value) == "table" then
          for _, el in ipairs(value) do
            DBMap[key](nodeChar, el, key)
          end
        -- otherwise just pass the value
        else 
          DBMap[key](nodeChar, value, key)
        end
        
      else
        -- Debug.print("No mapping found for: " .. key)
      end
    end)

    for _, window in ipairs(windowsOpen) do 
      window.close()
    end
    windowsOpen = {}

    DB.setValue(nodeChar, "chargentracker.opened", "number", 1)

    running = false

    Interface.dialogMessage(function() 
      -- do nothing
    end, "Import complete", "Pathbuilder Import")
end