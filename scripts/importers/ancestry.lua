function findRace(value)
  return Finder.getRecordGlobally(value, LibraryData.getMappings("race"))
end

function import(node, value)
  local race = findRace(value)

  if not race then
    return value .. " not found"
  end

  CharManager.addInfoDB(node, "referencerace", race.getNodeName())

  return value .. " imported as " .. DB.getValue(race, "name", "")
end