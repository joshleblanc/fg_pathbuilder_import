function findItem(name)
  local searchPaths = { "reference.equipment", "reference.weapon", "reference.armor", "reference.magicitems", "item" }
  return Finder.getRecordGlobally(name, searchPaths);
end

--[[
  Value here is an array such that 
  [Item Name, Quantity]
]]
function import(node, value)
  if not value[1] then return "name missing" end 

  local inventoryList = DB.createChild(node, "inventorylist")
  local item = findItem(value[1])

  if not item then
    return value[1] .. " not found"
  end

  ItemManager.addItemToList(inventoryList, "item", item, false, value[2])
end