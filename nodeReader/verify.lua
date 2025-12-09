--!strict
-- 25/12/05
-- @zyos

local package = script.Parent
local types = require(package.types)
type verified = types.verified

local function getNamedFolders(tree : Configuration, id : "Inputs" | "Outputs") : {Folder}
    local result = {}

    for _, descendant in tree:GetDescendants() do
        if not descendant:IsA("Folder") then continue end
        if descendant.Name ~= id then continue end
        if not descendant:GetAttribute("Enabled") then continue end

        table.insert(result, descendant)
    end

    return result
end

local function verifyOutputs(tree)
    local outputsFolders = getNamedFolders(tree, "Outputs")
    for _, outputFolder : Folder in outputsFolders do
        if #outputFolder:GetChildren() > 1 then
            
        end
    end
end


return function(tree) : verified

end