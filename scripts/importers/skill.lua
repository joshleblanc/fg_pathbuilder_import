local saves = {
  "will",
  "fortitude",
  "reflex"
}

-- CharManager.trainSkill(node, skillName)
function import(node, value, key)
  -- saves aren't skills 🙄
  if StringManager.contains(saves, value) then 
    return
  end

  local skill = CharManager.getSkillNode(node, key)

  if not skill then 
    return key .. " not found"
  end

  if value == 2 then
    CharManager.setProficiency(skill, "trained")
  elseif value == 4 then 
    CharManager.setProficiency(skill, "expert")
  elseif value == 6 then
    CharManager.setProficiency(skill, "master")
  elseif value == 8 then 
    CharManager.setProficiency(skill, "legendary")
  end
end