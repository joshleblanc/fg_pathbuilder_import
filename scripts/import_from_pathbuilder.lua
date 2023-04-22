
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
      deity = Deity.import
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

function doPBImport(pcJson, importWindow)
    data = JSONUtil.parseJson(pcJson)
    local nodeChar = DB.createChild("charsheet");

    EachKey(function(key, value)
      if DBMap[key] then
        -- Debug.print("Importing: " .. key)
        DBMap[key](nodeChar, value, key)
      else
        -- Debug.print("No mapping found for: " .. key)
      end
    end)
end