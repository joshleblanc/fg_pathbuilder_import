function find_class(value)
  local classRecords = DB.getChildrenGlobal("reference.classes");
  for _, classNode in pairs(classRecords) do
    local sRecordName = StringManager.trim(DB.getValue(classNode, "name", ""));

    if (sRecordName:lower() == value:lower()) then
      return classNode
    end
  end
end

function import(node, value)
  local class = find_class(value)

  if not class then return end

  local nodeList = node.createChild("classes");
  nodeClass = nodeList.createChild();

  CharManager.addInfoDB(node, "referenceclass", class.getNodeName())

  --DB.setValue(nodeClass, "name", "string", DB.getValue(class, "name", ""));
  --DB.setValue(nodeClass, "shortcut", "windowreference", "referenceclass", class.getNodeName());
end