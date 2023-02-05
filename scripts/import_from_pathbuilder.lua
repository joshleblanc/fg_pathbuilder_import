function importFromPathbuilder(sCommand, sParams)
    Interface.openWindow("import_pathbuilder", "")
end

function onInit()
    Comm.registerSlashHandler("importpathbuilder", importFromPathbuilder)
    Comm.registerSlashHandler("impb", importFromPathbuilder)
end

function doPBImport()
    local nodeTarget = DB.createChild("charsheet");
    local nodeId = DB.getChild(nodeTarget, "name");
    -- Test setting the name
    DB.setValue(nodeTarget, "name", "string", "TESTER");
    local featName = "Unconventional Weaponry";
    featName = string.lower(featName);
    local featMatchNode = ManagerGetRefData.getFeat(featName);
    CharManager.addFeat(nodeTarget, "referencefeat", featMatchNode.getNodeName());
end