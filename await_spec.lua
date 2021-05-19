---
--- Created By 0xWaleed
--- DateTime: 5/18/21 11:01 PM
---

require('await')

describe('await', function()

    it('should exist', function()
        assert.not_nil(await)
    end)

    it('should have a metatable', function()
        assert.not_nil(getmetatable(await))
    end)

    it('should hook __index', function()
        assert.not_nil(getmetatable(await).__index)
    end)

    it('should not be nil when key is already in _G', function()
        _G.fake_func = spy()
        assert.not_nil(await.fake_func)
    end)

    it('should return a function for already exist function in _G', function()
        _G.fake_func = spy()
        assert.is_function(await.fake_func)
    end)

    it('should return nil when global key is not exist', function()
        assert.is_nil(await.fake_func_nil)
    end)

    it('should pass the callback as the first argument when we call a function that has no argument', function()
        _G.fake_func = spy()
        await.fake_func()
        assert.spy(fake_func).was_called_with(match.is_function())
    end)

    it('should pass the callback as the last argument when we call a function that takes arguments', function()
        _G.fake_func = spy()
        await.fake_func(1)
        assert.spy(fake_func).was_called_with(1, match.is_function())

        _G.fake_func = spy()
        await.fake_func(1, 2)
        assert.spy(fake_func).was_called_with(1, 2, match.is_function())
    end)

    it('should return the value resolved passed to callback', function()
        _G.fake_func = stub().invokes(function(cb) cb(5) end)
        local r      = await.fake_func()
        assert.is_equal(5, r)
    end)

    it('should return the value resolved passed to callback and wait for result', function()
        _G.fake_func = stub().invokes(function(cb)
            local co = coroutine.create(function()
                local t = os.time() + .2
                while t > os.time() do
                    cb(5)
                end
            end)
            coroutine.resume(co)
        end)
        local r      = await.fake_func()
        assert.is_equal(5, r)
    end)


end)
