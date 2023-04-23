function import(node, value)
  for i=1,value - 1 do
    CharManager.addLevel(node)

    -- these 2 fun functions only run when the character level changes while the screen is open
    -- as far as I can tell, anyway
    CharManager.calcLevel(node);

    CharManager.recalcProficiencies(node);
  end
end