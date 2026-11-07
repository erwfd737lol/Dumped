
local StarterGui = game:GetService("StarterGui")
local v1 = false
local v2 = "StarterGui"

local function setCameraModeToastEnabled(a0) --[[ Upvalues: v1 (ref), v2 (copy) ]]
    if not a0 and not v1 then
        return
    end

    if not v1 then
        v1 = true
    end

    if not a0 then
        v2.setCameraModeToastOpen(false)
    end
end

local function setCameraModeToastOpen(a0) --[[ Upvalues: v1 (ref), StarterGui (copy) ]]
    assert(v1)
    if a0 then
        StarterGui:SetCore("SendNotification", {Title = "Camera Control Enabled", Text = "Right click to toggle", Duration = 3})
    end
end

v2 = {
    setCameraModeToastEnabled = setCameraModeToastEnabled,
    setCameraModeToastOpen = setCameraModeToastOpen
}
return v2
