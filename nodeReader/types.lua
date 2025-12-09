-- 25/12/04
-- @zyos

export type bools = true | false

export type nodeTypes = "Lock" | "Command" | "Prompt" | "Response" | "Start" | "End"
export type nodeActions = {} | ModuleScript | StringValue | BoolValue
export type nodeOutputs = {
    {
        name : string,
        locks : {},
        output : {}?,
    }
}

export type nodeValues = {
    outputs : {} | nodeOutputs,
    inputs : {}  | {ObjectValue},
    commands : {}
}

export type node = {
    type : nodeTypes,
    action : nodeActions,
    name : string,
    tree : any,
    values : nodeValues,
    link : Configuration
}

export type verified = {
    outputs : bools,
    inputs : bools,
    attributes : bools,
    nodes : bools,
    tree : bools,
    types : bools,
    nodeTypes : bools,
    values : {
        correct : {},
        incorrect : {

        }
    }
}

return {}