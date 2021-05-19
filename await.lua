---
--- Created By 0xWaleed
--- DateTime: 5/18/21 11:02 PM
---

await = setmetatable({}, {
    __index = function(_, key)
        local theFunction = _G[key]
        if not theFunction then
            return nil
        end

        return function(...)

            local isYieldable   = coroutine.isyieldable()
            local result        = {}
            local isFinished    = false
            local args          = { ... }
            local argsCount     = #args

            args[argsCount + 1] = function(...)
                result     = { ... }
                isFinished = true
            end

            if isYieldable then
                theFunction(table.unpack(args))
                while not isFinished do
                    coroutine.yield()
                end
                return table.unpack(result)
            else
                return coroutine.wrap(function(...)
                    theFunction(table.unpack(args))
                    while not isFinished do
                        coroutine.yield()
                    end
                    return table.unpack(result)
                end)(...)
            end

        end
    end
})
