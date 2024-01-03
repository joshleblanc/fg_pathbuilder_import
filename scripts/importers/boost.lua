local MAP = {
  Str = "strength",
  Dex = "dexterity",
  Con = "constitution",
  Int = "intelligence",
  Wis = "wisdom",
  Cha = "charisma"
}

function import(node, value, key, index)
    local name = ""
    if key == "ancestryFree" then 
      name = "ancestry_boost_" .. tostring(index + 2)
    elseif key == "backgroundBoosts" then 
      name = "background_boost_" .. tostring(index)
    elseif key == "classBoosts" then 
      name = "class_keyability"
    elseif key == "1" then
      name = "free_boost_" .. tostring(index)
    else
      num = tonumber(key)
      if num > 1 and num <= 20 then
        name = "level" .. key .. "_ability_boost_" .. index
      end
    end

    DB.setValue(node, "chargentracker.abilities." .. name, "string", MAP[value])

    return value
  end