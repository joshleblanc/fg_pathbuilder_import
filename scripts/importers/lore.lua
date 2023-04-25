--[[
  Lores are imported as an array. Each value looks like 
  ["Lore Name", Proficiency as a multiple of 2]
]]
function import(node, value)
  local lore = value[1]
  local prof = value[2]
  local skill = CharManager.getSkillNode(node, Interface.getString("skill_value_lore"), lore)

  if not skill then 
    return lore .. " not found"
  end
  
  -- this'll add the trained skill, as well as add additional lores to the char sheet if needed
  BackgroundManager.addLoreSkill(node, lore)

  -- this'll upgrade the training of said new skill
  if prof == 4 then 
    CharManager.setProficiency(skill, "expert")
  elseif prof == 6 then
    CharManager.setProficiency(skill, "master")
  elseif prof == 8 then 
    CharManager.setProficiency(skill, "legendary")
  end
end