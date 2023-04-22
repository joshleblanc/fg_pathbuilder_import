
local data = {}
local DBMap = {}

function importFromPathbuilder(sCommand, sParams)
    Interface.openWindow("import_pathbuilder", "")
end

function onInit()
    Comm.registerSlashHandler("importpathbuilder", importFromPathbuilder)
    Comm.registerSlashHandler("impb", importFromPathbuilder)

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

-- trying to get the "legacy data" popups to stop showing
-- this didn't work
function buildRequiredRoots(node)
  local charGenTracker = DB.createChild(node, "chargentracker")
  DB.setValue(charGenTracker, "opened", "number", 1)

  DB.createChild(node, "ac")
  DB.createChild(node, "attackbonus")
  DB.createChild(node, "defenses")
  DB.createChild(node, "effects")
  DB.createChild(node, "encumbrance")
  DB.createChild(node, "featlist")
  DB.createChild(node, "hp")
  DB.createChild(node, "initiative")
  DB.createChild(node, "inventorylist")
  DB.createChild(node, "languagelist")
  DB.createChild(node, "proficiencies")
  DB.createChild(node, "saves")
  DB.createChild(node, "skilllist")
  DB.createChild(node, "skillpoints")
  DB.createChild(node, "specialabilitylist")
  DB.createChild(node, "speed")
  DB.createChild(node, "traitlist")
  DB.createChild(node, "wealth")
  DB.createChild(node, "coins")
  DB.createChild(node, "weaponlist")
end

-- NOTE: rulesets/PFRPG2.pak/campaign/scripts/manager_char.lua has some good stuff in it
function doPBImport(pcJson, importWindow)
    data = JSONUtil.parseJson(pcJson)
    local nodeChar = DB.createChild("charsheet");

    buildRequiredRoots(nodeChar)

    EachKey(function(key, value)
      if DBMap[key] then
        -- Debug.print("Importing: " .. key)
        DBMap[key](nodeChar, value, key)
      else
        -- Debug.print("No mapping found for: " .. key)
      end
    end)
end