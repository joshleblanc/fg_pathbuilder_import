function importFromPathbuilder(sCommand, sParams)
    Interface.openWindow("import_pathbuilder", "")
end

function onInit()
    Comm.registerSlashHandler("importpathbuilder", importFromPathbuilder)
    Comm.registerSlashHandler("impb", importFromPathbuilder)
end

function doPBImport(pcJson)
    
    local jsonTable = JSONUtil.parseJson(pcJson);

    local nodeTarget = DB.createChild("charsheet");
    local nodeId = DB.getChild(nodeTarget, "name");
    -- Test setting the name
    local name = jsonTable["build"]["name"];
    local ancestry = jsonTable["build"]["ancestry"];
    local ancestryNode = ManagerGetRefData.getLookupDataRecordGlobally("reference.ancestries.poppet@Pathfinder 2 RPG - Lost Omens The Grand Bazaar", "referencerace");

    DB.setValue(nodeTarget, "name", "string", name);
    

    --DB.setValue(nodeTarget, "race", "string", ancestry);
    --CharManager.addRace(nodeTarget, "referencerace", ancestryNode);

    --local featName = "Unconventional Weaponry";
    --featName = string.lower(featName);
    --local featMatchNode = ManagerGetRefData.getFeat(featName);
    --CharManager.addFeat(nodeTarget, "referencefeat", featMatchNode.getNodeName());
end