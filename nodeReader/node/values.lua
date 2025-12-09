--!strict
-- 25/12/05
-- @zyos

local package = script.Parent.Parent
local types = require(package.types)

type nodeValues = types.nodeValues
type nodeOutputs = types.nodeOutputs

local function getFolders(descendants : {any}) : (Folder?, {Folder})
    local inputFolder = nil
    local outputFolders : {} = {}

    for _, descendant : any in descendants do
        if not descendant:IsA("Folder") then continue end

        if descendant.Name == "Inputs" then
            inputFolder = descendant
        end

        if descendant.Name == "Outputs" then
            table.insert(outputFolders, descendant)
        end
    end

    return inputFolder, outputFolders
end

local function removeLocks(folder : Folder) : {}
    local result : {} = {}

    for _, v in folder:GetChildren() do
        if v.Name == "Lock" then continue end

        table.insert(result, v)
    end

    return result
end

local function groupLocks(outputFolder : Folder) : ({}, {})
    local locks : {} = {}
    local outputs = outputFolder:GetChildren()

    for _, output in outputs do
        if output.Name ~= "Lock" then continue end
        
        table.insert(locks, output)
        
        local i = table.find(outputs, output)
        table.remove(outputs, i)
    end

    return locks, outputs
end

local function seperateCommands(array : {ObjectValue}) : {}
    local commands : {} = {}

    for _, value in array do
        if value.Name ~= "Command" then continue end

        table.insert(commands, value)

        local i = table.find(array, value)
        table.remove(array, i)
    end

    return commands, array
end

local function createOutputs(outputFolders : {Folder}) : nodeOutputs
    local result : {} = {}

    for _, folder : Folder in outputFolders do
        if folder.Parent == nil then continue end

        local name = folder.Parent.Name
        local locks, outputs = groupLocks(folder)

        table.insert(result, {
            ["name"] = name, 
            ["locks"] = locks,
            ["output"] = outputs[1]
        })
    end

    return result
end

return function(_node : Configuration) : nodeValues
    local descendants = _node:GetDescendants()

    local inputFolder, outputFolders = getFolders(descendants)

    local inputs : {} = {}
    local outputs : nodeOutputs = {}

    local commands : {} = {}

    if next(outputFolders) ~= nil then
        outputs = createOutputs(outputFolders)
    end

    if inputFolder ~= nil then
        inputs = removeLocks(inputFolder)

        local commands2 : {} = {}
        commands2, inputs = seperateCommands(inputs)

        for _, command in commands2 do
            table.insert(commands, command)
        end
    end
    
    return {
        ["outputs"] = outputs,
        ["inputs"] = inputs,
        ["commands"] = commands
    }
end