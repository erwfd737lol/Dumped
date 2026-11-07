
local CorePackages = game:GetService("CorePackages")
local v1 = require(CorePackages.Packages.Dev.JestGlobals)
local describe = v1.describe
local expect = v1.expect
local it = v1.it
CorePackages = require(script.Parent.CameraWrapper)
local waitForEvents = require(CorePackages.Workspace.Packages.TestUtils).DeferredLuaHelpers.waitForEvents
describe("CameraWrapper", function() --[[ Upvalues: it (copy), CorePackages (copy), expect (copy), waitForEvents (copy) ]]
    it("should instantiate", function() --[[ Upvalues: CorePackages (upvalue), expect (upvalue) ]]
        expect(CorePackages.new()).never.toBeNil()
    end)
    it("should return updated camera", function() --[[ Upvalues: CorePackages (upvalue), expect (upvalue), waitForEvents (upvalue) ]]
        local v2 = CorePackages.new()
        v2:Enable()
        local Camera = Instance.new("Camera")
        Camera.Parent = game.Workspace
        local v3 = v2:getCamera()
        expect(v3).toBe(game.Workspace.CurrentCamera)
        local v4 = v2:getCamera()
        expect(v4).never.toBe(Camera)
        game.Workspace.CurrentCamera = Camera
        waitForEvents()
        local v5 = v2:getCamera()
        expect(v5).toBe(game.Workspace.CurrentCamera)
        local v6 = v2:getCamera()
        expect(v6).toBe(Camera)
    end)
end)
