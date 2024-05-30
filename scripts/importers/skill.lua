-- CharManager.trainSkill(node, skillName)
function import(node, value, key)
  local skill = CharManager.getSkillNode(node, key)

  if not skill then 
    return key .. " not found"
  end

  local level = IMPBData.proficiencyLevels[value]
  CharManager.setProficiency(skill, level)

  return key .. " " .. level
end