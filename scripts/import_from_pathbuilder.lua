function importFromPathbuilder(sCommand, sParams)
    Interface.openWindow("import_pathbuilder", "")
end

function onInit()
    Comm.registerSlashHandler("importpathbuilder", importFromPathbuilder)
end