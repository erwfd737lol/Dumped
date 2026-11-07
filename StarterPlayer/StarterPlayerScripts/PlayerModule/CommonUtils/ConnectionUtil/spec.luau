
local CorePackages = game:GetService("CorePackages")
local v1 = require(CorePackages.Packages.Dev.JestGlobals)
local describe = v1.describe
local expect = v1.expect
local it = v1.it
CorePackages = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local v2 = require(script.Parent.ConnectionUtil)
describe("ConnectionUtil", function() --[[ Upvalues: it (copy), v2 (copy), expect (copy), CorePackages (copy) ]]
    it("should instantiate", function() --[[ Upvalues: v2 (upvalue), expect (upvalue) ]]
        expect(v2.new()).never.toBeNil()
    end)
    it("should track a connection", function() --[[ Upvalues: v2 (upvalue), CorePackages (upvalue), expect (upvalue) ]]
        local v3 = CorePackages.new()
        local v4 = ""
        local v5 = v3:Connect(function(a0) --[[ Upvalues: v4 (ref) ]]
            v4 = a0
        end)
        v2.new():trackConnection("Signal", v5)
        v3:fire("Testing")
        expect(v4).toBe("Testing")
    end)
    it("should disconnect from signal", function() --[[ Upvalues: v2 (upvalue), CorePackages (upvalue), expect (upvalue) ]]
        local v6 = v2.new()
        local v7 = CorePackages.new()
        local v8 = ""
        local v9 = v7:Connect(function(a0) --[[ Upvalues: v8 (ref) ]]
            v8 = a0
        end)
        v6:trackConnection("Signal", v9)
        v6:disconnect("Signal")
        v7:fire("Testing")
        expect(v8).toBe("")
    end)
    it("should disconnect from all", function() --[[ Upvalues: v2 (upvalue), CorePackages (upvalue), expect (upvalue) ]]
        local v10 = v2.new()
        local v11 = CorePackages.new()
        local v12 = ""
        local v13 = ""
        local v14 = ""
        local v15 = v11:Connect(function(a0) --[[ Upvalues: v12 (ref) ]]
            v12 = a0
        end)
        v10:trackConnection("Signal", v15)
        local v16 = CorePackages.new():Connect(function(a0) --[[ Upvalues: v13 (ref) ]]
            v13 = a0
        end)
        v10:trackConnection("Signal1", v16)
        local v17 = CorePackages.new():Connect(function(a0) --[[ Upvalues: v14 (ref) ]]
            v14 = a0
        end)
        v10:trackConnection("Signal2", v17)
        v10:disconnectAll()
        v11:fire("TestingPrimary")
        v11:fire("TestingSecondary")
        v11:fire("TestingTertiary")
        expect(v12).toBe("")
        expect(v13).toBe("")
        expect(v14).toBe("")
    end)
    it("should call manual disconnect", function() --[[ Upvalues: v2 (upvalue), expect (upvalue) ]]
        local v18 = v2.new()
        local v19 = ""
        v18:trackBoundFunction("Manual", function() --[[ Upvalues: v19 (ref) ]]
            v19 = "Disconnected"
        end)
        v18:disconnect("Manual")
        expect(v19).toBe("Disconnected")
    end)
end)
