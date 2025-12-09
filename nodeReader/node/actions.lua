--!strict
-- 25/12/05
-- @zyos

local package = script.Parent.Parent
local types = require(package.types)

type node = types.node
type nodeTypes = types.nodeTypes
type nodeActions = types.nodeActions

local function command(node) : ModuleScript
    return node.Function
end

local function prompt(node) : StringValue
    return node.Text
end

local function lock(node) : BoolValue
    return node.Active
end

local functionMaps = {
    ["Prompt"] = prompt,
    ["Command"] = command,
    ["Lock"] = lock
}

return function(_type : nodeTypes, node) : nodeActions
    if _type == "Start" or _type == "End" or _type == "Response" then 
        print("returning") 
        return {} 
    end

    return functionMaps[_type](node)
end