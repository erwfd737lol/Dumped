
local CorePackages = game:GetService("CorePackages")
local v1 = require(CorePackages.Packages.Dev.JestGlobals)
CorePackages = v1.describe
local expect = v1.expect
local it = v1.it
v1 = require(script.Parent.VRCameraTeleportDetector)
local shouldRecenter = v1.shouldRecenter
local JUMP_STUDS = v1.JUMP_STUDS
local SETTLED_STUDS = v1.SETTLED_STUDS
local DEBOUNCE_SECONDS = v1.DEBOUNCE_SECONDS
CorePackages("VRCameraTeleportDetector.shouldRecenter", function() --[[ Upvalues: it (copy), expect (copy), shouldRecenter (copy), JUMP_STUDS (copy), SETTLED_STUDS (copy), DEBOUNCE_SECONDS (copy) ]]
    it("fires on a discrete jump from rest (no prior step, never recentered)", function() --[[ Upvalues: expect (upvalue), shouldRecenter (upvalue), JUMP_STUDS (upvalue) ]]
        local v2 = JUMP_STUDS + 10
        local v3 = shouldRecenter(nil, v2, nil, 100)
        expect(v3).toBe(true)
    end)
    it("fires on a discrete jump preceded by a near-still frame", function() --[[ Upvalues: expect (upvalue), shouldRecenter (upvalue), SETTLED_STUDS (upvalue), JUMP_STUDS (upvalue) ]]
        local v4 = SETTLED_STUDS - 0.5
        local v5 = JUMP_STUDS + 10
        local v6 = shouldRecenter(v4, v5, nil, 100)
        expect(v6).toBe(true)
    end)
    it("does not fire for sub-threshold motion", function() --[[ Upvalues: expect (upvalue), shouldRecenter (upvalue), JUMP_STUDS (upvalue) ]]
        local v7 = JUMP_STUDS - 0.1
        local v8 = shouldRecenter(0, v7, nil, 100)
        expect(v8).toBe(false)
        local v9 = shouldRecenter(0, 0, nil, 100)
        expect(v9).toBe(false)
    end)
    it("does not fire when the previous frame was already moving (continuous motion)", function() --[[ Upvalues: expect (upvalue), shouldRecenter (upvalue), SETTLED_STUDS (upvalue), JUMP_STUDS (upvalue) ]]
        local v10 = SETTLED_STUDS + 0.1
        local v11 = JUMP_STUDS + 10
        local v12 = shouldRecenter(v10, v11, nil, 100)
        expect(v12).toBe(false)
    end)
    it("does not fire within the debounce interval", function() --[[ Upvalues: expect (upvalue), shouldRecenter (upvalue), JUMP_STUDS (upvalue), DEBOUNCE_SECONDS (upvalue) ]]
        local v13 = JUMP_STUDS + 10
        local v14 = shouldRecenter(nil, v13, 100, 100 + DEBOUNCE_SECONDS - 0.01)
        expect(v14).toBe(false)
    end)
    it("fires again once the debounce interval has elapsed", function() --[[ Upvalues: expect (upvalue), shouldRecenter (upvalue), JUMP_STUDS (upvalue), DEBOUNCE_SECONDS (upvalue) ]]
        local v15 = JUMP_STUDS + 10
        local v16 = shouldRecenter(nil, v15, 100, 100 + DEBOUNCE_SECONDS + 0.01)
        expect(v16).toBe(true)
    end)
    it("does not retrigger every frame under continuous per-frame CFrame writes (oscillation guard)", function() --[[ Upvalues: JUMP_STUDS (upvalue), shouldRecenter (upvalue), expect (upvalue) ]]
        local v17 = 0
        local v18 = nil
        local v19 = nil
        local v20 = 0
        local v21 = JUMP_STUDS + 10
        for i1 = 1, 120 do
            if shouldRecenter(v18, v21, v19, v17) then
                v20 = v20 + 1
                v19 = v17
            end

            v18 = v21
            v17 = v17 + 0.016666666666666666
        end

        expect(v20).toBe(1)
    end)
end)
