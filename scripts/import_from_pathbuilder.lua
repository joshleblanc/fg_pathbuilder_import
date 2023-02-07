function importFromPathbuilder(sCommand, sParams)
    Interface.openWindow("import_pathbuilder", "")
end

function onInit()
    Comm.registerSlashHandler("importpathbuilder", importFromPathbuilder)
    Comm.registerSlashHandler("impb", importFromPathbuilder)
end

function doPBImport(pcJson, importWindow)
    
    local jsonTable = JSONUtil.parseJson(pcJson);

    local nodeChar = DB.createChild("charsheet");

    -- Setting the name
    local name = jsonTable["build"]["name"];

    DB.setValue(nodeChar, "name", "string", name);
    
    local ancestry = jsonTable["build"]["ancestry"];
    
    -- List ancestries in modules
    local recordNodes = DB.getChildrenGlobal("reference.ancestries"); 
    for k, recordNode in pairs(recordNodes) do
        local sRecordName = StringManager.trim(DB.getValue(recordNode, "name", ""));

        if (sRecordName == ancestry) then
            -- ancestry found, set the ancestry
            DB.setValue(nodeChar, "race", "string", sRecordName);
	        DB.setValue(nodeChar, "racelink", "windowreference", "referencerace", recordNode.getNodeName());
            break;
        end
        --error('Unable to find the ancestry, make sure module is loaded');
    
    end

    local background = jsonTable["build"]["background"];
    local backgroundRecords = DB.getChildrenGlobal("reference.backgrounds");
    for k, backgroundNode in pairs(backgroundRecords) do
        local sRecordName = StringManager.trim(DB.getValue(backgroundNode, "name", ""));
        --print('Record name: ' .. sRecordName);
        if (sRecordName:lower() == background:lower()) then
            -- background found, set the background
            DB.setValue(nodeChar, "background", "string", sRecordName);
	        DB.setValue(nodeChar, "backgroundlink", "windowreference","reference_background", backgroundNode.getNodeName());
            break;
        end
        --error('Unable to find the background, make sure module is loaded');
    
    end

    -- Class
    local charClass = jsonTable["build"]["class"];
    

    local classRecords = DB.getChildrenGlobal("reference.classes");
    for k, classNode in pairs(classRecords) do
        local sRecordName = StringManager.trim(DB.getValue(classNode, "name", ""));
        --print('Record name: ' .. sRecordName);
        if (sRecordName:lower() == charClass:lower()) then
            -- class found, set the class (NOTE: Only doing 1 class now)
            --CharManager.addClass(nodeChar, "referenceclass", classNode.getNodeName());
            local nodeList = nodeChar.createChild("classes");
            nodeClass = nodeList.createChild();
            DB.setValue(nodeClass, "name", "string", sRecordName);
            DB.setValue(nodeClass, "level", "number", 1); -- TODO: Read Level
	        DB.setValue(nodeClass, "shortcut", "windowreference", "referenceclass", classNode.getNodeName());
            break;
        end
        --error('Unable to find the background, make sure module is loaded');
    
    end

    --local featName = "Unconventional Weaponry";
    --featName = string.lower(featName);
    --local featMatchNode = ManagerGetRefData.getFeat(featName);
    --CharManager.addFeat(nodeTarget, "referencefeat", featMatchNode.getNodeName());
end