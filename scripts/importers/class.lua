function import(node, value)
  local classRecords = DB.getChildrenGlobal("reference.classes");
  for _, classNode in pairs(classRecords) do
      local sRecordName = StringManager.trim(DB.getValue(classNode, "name", ""));
      --print('Record name: ' .. sRecordName);
      if (sRecordName:lower() == value:lower()) then
          -- class found, set the class (NOTE: Only doing 1 class now)
          --CharManager.addClass(nodeChar, "referenceclass", classNode.getNodeName());
          local nodeList = node.createChild("classes");
          nodeClass = nodeList.createChild();
          DB.setValue(nodeClass, "name", "string", sRecordName);
          DB.setValue(nodeClass, "level", "number", 1); -- TODO: Read Level
          DB.setValue(nodeClass, "shortcut", "windowreference", "referenceclass", classNode.getNodeName());
          break;
      end
      --error('Unable to find the background, make sure module is loaded');
  
  end
end