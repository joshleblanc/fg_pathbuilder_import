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
end