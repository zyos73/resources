--!strict
-- 25/12/04
-- @zyos

local package = script.Parent
local types = require(package.types)

local actions = require(script.actions)
local values = require(script.values)

type node = types.node
type nodeTypes = types.nodeTypes
type nodeActions = types.nodeActions

local node  = {}

function node:build(_node : Configuration) : node?

    if not _node:GetAttribute("verified") then
        warn(`{_node} is not verified. \n Parent: {_node.Parent}`)
        return nil
    end

    local nodeType : nodeTypes = _node:GetAttribute("Type") :: nodeTypes
    local nodeAction : nodeActions = actions(nodeType, _node)
    local nodeName :string = _node.Name

    local nodeTree = _node.Parent

    local nodeValues = values(_node)

    local build = {
        ["type"] = nodeType,
        ["action"] = nodeAction,
        ["name"] = nodeName,
        ["tree"] = nodeTree,
        ["link"] = _node,
        ["values"] = nodeValues
    }

    return build
end

return node