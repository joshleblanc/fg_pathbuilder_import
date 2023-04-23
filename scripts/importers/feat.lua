function findFeat(value)
  return Finder.getFeat(value)
end

function isFeatDupe(nodeChar, nodeFeat)
  local featList = nodeChar.createChild("featlist");

  for _, el in pairs(featList.getChildren()) do
    if DB.getValue(el, "name", "") == DB.getValue(nodeFeat, "name", "") then
			return true;
		end
  end

  return false
end

--[[
  value is an array here
  Looks like: [Name, skill, Type, level attained]

  Skill isn't used. It would be included if you picked Skill Training for example,
  then [2] would be the skill you picked (eg. Intimidation). This'll be picked up in the
  skill importer

  [4] likewise isn't used. We don't care about the level
--]]
function import(node, value)
  local feat = findFeat(value[1])

  if not feat then return end 

  if isFeatDupe(node, feat) then return end

  CharManager.addInfoDB(node, "referencefeat", feat.getNodeName())
end