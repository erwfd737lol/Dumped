
local t1 = {}
local t2 = {}
local v1 = nil
local t3 = {}
local v2 = require(script.Parent.Parent.Utility)
local v3 = false
local v4 = nil
local v5 = nil
local CurrentCamera = workspace.CurrentCamera

local function start(a0) --[[ Upvalues: v4 (ref), v1 (ref), t1 (copy), v2 (copy), v5 (copy), v3 (ref), CurrentCamera (copy) ]]
    v4 = a0
    v1 = v4.iconsDictionary
    local v6 = nil
    for k1, k2 in pairs(v4.container) do
        if v6 == nil and k2.ScreenInsets == Enum.ScreenInsets.TopbarSafeInsets then
            v6 = k2
        end

        local v10 = k2.Holders:GetChildren()
        for k3, k4 in pairs(v10) do
            if k4:GetAttribute("IsAHolder") then
                t1[k4.Name] = k4
            end
        end
    end

    local v14 = false
    local v15 = v2.createStagger(0.1, function(a0) --[[ Upvalues: v14 (ref), v5 (upvalue) ]]
        if not v14 then
            return
        end

        if not a0 then
            v5.updateAvailableIcons("Center")
        end

        v5.updateBoundary("Left")
        v5.updateBoundary("Right")
    end)
    task.delay(0.5, function() --[[ Upvalues: v14 (ref), v15 (copy) ]]
        v14 = true
        v15()
    end)
    task.delay(2, function() --[[ Upvalues: v3 (upvalue), v15 (copy) ]]
        v3 = true
        v15()
    end)
    v4.iconAdded:Connect(v15)
    v4.iconRemoved:Connect(v15)
    v4.iconChanged:Connect(v15)
    local v16 = CurrentCamera:GetPropertyChangedSignal("ViewportSize")
    v16:Connect(function() --[[ Upvalues: v15 (copy) ]]
        v15(true)
    end)
    local v17 = v6:GetPropertyChangedSignal("AbsoluteSize")
    v17:Connect(function() --[[ Upvalues: v15 (copy) ]]
        v15(true)
    end)
end

local function getWidth(a0, a1)
    local widget = a0.widget
    local v19 = widget:GetAttribute("TargetWidth") or widget.AbsoluteSize.X
    return v19
end

local function getAvailableIcons(a0) --[[ Upvalues: t2 (copy), v5 (copy) ]]
    local v22 = t2[a0] or v5.updateAvailableIcons(a0)
    return v22
end

local function updateAvailableIcons(a0) --[[ Upvalues: v1 (ref), t3 (copy), t2 (copy) ]]
    local v23 = 0
    local t4 = {}
    for k5, k6 in pairs(v1) do
        local parentIconUID = k6.parentIconUID
        local v29 = not parentIconUID or t3[parentIconUID]
        parentIconUID = t3[k6.UID]
        if v29 and k6.alignment == a0 and not parentIconUID and k6.isEnabled then
            table.insert(t4, k6)
            v23 = v23 + 1
        end
    end

    if v23 <= 0 then
        return {}
    end

    table.sort(t4, function(a0, a1)
        local LayoutOrder = a0.widget.LayoutOrder
        local LayoutOrder1 = a1.widget.LayoutOrder
        local parentIconUID1 = a0.parentIconUID
        local parentIconUID2 = a1.parentIconUID
        if parentIconUID1 == parentIconUID2 then
            if LayoutOrder < LayoutOrder1 then
                return true
            end

            if LayoutOrder1 < LayoutOrder then
                return false
            end

            return a0.widget.AbsolutePosition.X < a1.widget.AbsolutePosition.X
        end

        if parentIconUID2 then
            return false
        end

        if parentIconUID1 then
            return true
        end

        return nil
    end)
    t2[a0] = t4
    return t4
end

local function getRealXPositions(a0, a1) --[[ Upvalues: t1 (copy), v2 (copy), v5 (copy) ]]
    local v30 = a0 == "Left"
    local v31 = t1[a0]
    local X1 = v31.AbsolutePosition.X
    local Offset = v31.UIListLayout.Padding.Offset
    local v34 = {}
    if v30 then
        v2.reverseTable(a1)
    end

    for i1 = #a1, 1, -1 do
        X1 = a1[i1]
        local v37 = v5.getWidth(X1)
        local v38
        if not v30 then
            v38 = v38 - v37
        end

        v34[X1.UID] = v38
        if v30 then
            v38 = v38 + v37
        end

        v38 = v38 + (v30 and Offset or -Offset)
    end

    return v34
end

local t5 = {}
local v41 = false

local function updateBoundary(a0) --[[ Upvalues: t1 (copy), v5 (copy), t5 (copy), v4 (ref), t3 (copy), v41 (ref), v3 (ref), v2 (copy) ]]
    local v42 = t1[a0]
    local UIListLayout = v42.UIListLayout
    local X2 = v42.AbsolutePosition.X
    local X3 = v42.AbsoluteSize.X
    local Offset1 = UIListLayout.Padding.Offset
    local Offset2 = UIListLayout.Padding.Offset
    UIListLayout = v5.updateAvailableIcons(a0)
    local v43 = 0
    local v44 = 0
    for k7, k8 in pairs(UIListLayout) do
        v43 = v43 + (v5.getWidth(k8) + Offset2)
        v44 = v44 + 1
    end

    if v44 <= 0 then
        return
    end

    v43 = a0 == "Left"
    Offset2 = not v43
    local v48 = t5[a0]
    if not v48 then
        if not (a0 == "Center") then
            if 0 < #UIListLayout then
                local v49
                if v43 then
                    v49 = -9999999
                else
                    v49 = 9999999
                end

                v48 = v4.new()
                v48:setImage(6069276526, "Deselected")
                v48:setName("Overflow" .. a0)
                v48:setOrder(v49)
                v48:setAlignment(a0)
                v48:autoDeselect(false)
                v48.isAnOverflow = true
                v48:select("OverflowStart", v48)
                v48:setEnabled(false)
                t5[a0] = v48
                t3[v48.UID] = true
                if not v4.closeableOverflowMenus then
                    local v50 = v48:getInstance("IconSpot")
                    v50.Visible = false
                end
            end
        end
    end

    local v51
    if a0 == "Left" then
        v51 = "Right"
    else
        v51 = "Left"
    end

    local v52 = v5.updateAvailableIcons(v51)
    local v54
    if not (v43 and v52[1]) then
        local v56 = Offset2 and v52[#v52]
    end

    k7 = t5[v51]
    local v59
    if v54 then
        local v60 = v5.getRealXPositions(v51, v52)
        local v61 = v60[v54.UID]
        v60 = v5.getWidth(v54)
        local v63
        if not (v43 and v61 - Offset1) then
            v63 = v61 + v60 + Offset1
        end

        v59 = v63
    end

    local v64 = 0

    local function checkToShiftCentralIcon() --[[ Upvalues: v5 (upvalue), v43 (copy), v41 (upvalue), a0 (copy), UIListLayout (copy), Offset2 (copy), Offset1 (copy), v3 (upvalue), v64 (ref), checkToShiftCentralIcon (copy) ]]
        local v65 = v5.getAvailableIcons("Center")
        local v66
        if v43 then
            v66 = 1
        else
            v66 = #v65
        end

        local v67 = v65[v66]

        local function secondaryCheck() --[[ Upvalues: v41 (upvalue), v5 (upvalue), a0 (upvalue) ]]
            if not v41 then
                v41 = true
                task.delay(3, v5.updateBoundary, a0)
            end
        end

        if v67 then
            if not v67.hasRelocatedInOverflow then
                local v68
                if not (v43 and UIListLayout[#UIListLayout]) then
                    local v70 = Offset2 and UIListLayout[1]
                end

                local X4 = v67.widget.AbsolutePosition.X
                local X5 = v68.widget.AbsolutePosition.X
                local v71 = v5.getWidth(v68)
                local v72
                if not (v43 and X4 - Offset1) then
                    local v73 = X4 + v5.getWidth(v67)
                    v72 = v73 + Offset1
                end

                v71 = false
                if v43 then
                    if v72 < (v43 and X5 + v71 or X5) then
                        if not v3 then
                            if not v41 then
                                v41 = true
                                task.delay(3, v5.updateBoundary, a0)
                            end

                            return
                        end

                        v67:align("Left")
                        v67.hasRelocatedInOverflow = true
                        v71 = true
                        -- branch continues at 131
                    end
                else
                    if Offset2 then
                        if (v43 and X5 + v71 or X5) < v72 then
                            if not v3 or (v43 and X5 + v71 or X5) < 0 then
                                if not v41 then
                                    v41 = true
                                    task.delay(3, v5.updateBoundary, a0)
                                end

                                return
                            end

                            v67:align("Right")
                            v67.hasRelocatedInOverflow = true
                            v71 = true
                        end
                    end
                end

                if v71 then
                    v64 = v64 + 1
                    if v64 <= 4 then
                        v5.updateAvailableIcons("Center")
                        checkToShiftCentralIcon()
                    end
                end
            end
        end
    end

    checkToShiftCentralIcon()
    if v48 then
        v51 = v48:getInstance("Menu")
        local v75 = X3
        if v51 then
            if k7 then
                local X6 = k7.widget.AbsolutePosition.X
                local v76 = v5.getWidth(k7)
                local v78
                if not (v43 and X6 - Offset1) then
                    v78 = X6 + v76 + Offset1
                end

                X6 = k7:getInstance("Menu")
                X6 = X2 + X3 / 2
                local v80
                if not (v43 and X6 - Offset1 / 2) then
                    v80 = X6 + Offset1 / 2
                end

                local v81 = v80
                if X6.AbsoluteCanvasSize.X <= v51.AbsoluteCanvasSize.X then
                    v81 = v78
                end

                v75 = v43 and v81 - X2 or X2 + X3 - v81
            end
        end

        local v85 = v51 and v51:GetAttribute("MaxWidth")
        v75 = v2.round(v75)
        if v51 and v85 ~= v75 then
            v51:SetAttribute("MaxWidth", v75)
        end
    end

    k7 = false
    X3 = v5.getRealXPositions(a0, UIListLayout)
    for i2 = #UIListLayout, 1, -1 do
        X2 = UIListLayout[i2]
        local v88 = v5.getWidth(X2)
        local v89 = X3[X2.UID]
        if not v43 or v59 > v89 + v88 then
            if Offset2 then
                if v89 > v59 then
                    -- jump to 320
                end

                -- branch continues at 320
            end
        end

        k7 = true
    end

    for i3 = #UIListLayout, 1, -1 do
        v59 = UIListLayout[i3]
        if not t3[v59.UID] then
            if k7 and not v59.parentIconUID then
                v59:joinMenu(v48)
            else
                if not k7 and v59.parentIconUID then
                    v59:leave()
                end
            end
        end
    end

    if v48.isEnabled ~= k7 then
        v48:setEnabled(k7)
    end

    if v48.isEnabled and not v48.overflowAlreadyOpened then
        v48.overflowAlreadyOpened = true
        v48:select()
    end
end

v5 = {
    start = start,
    getWidth = getWidth,
    getAvailableIcons = getAvailableIcons,
    updateAvailableIcons = updateAvailableIcons,
    getRealXPositions = getRealXPositions,
    updateBoundary = updateBoundary
}
return v5
