function findRace(value)
  return Finder.getRecordGlobally(value, { "reference.ancestries" }) 
end

function import(node, value)
  local race = findRace(value)

  if not race then return end 

  CharManager.addInfoDB(node, "referencerace", race.getNodeName())
end