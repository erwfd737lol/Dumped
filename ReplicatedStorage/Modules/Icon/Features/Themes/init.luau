
local v1 = require(script.Parent.Parent.Utility)
local v2 = require(script.Default)

local function getThemeValue(a0, a1, a2, a3)
    if a0 then
        for k1, k2 in pairs(a0) do
            local v6, v7, v8 = unpack(k2)
            if a1 == v6 and a2 == v7 then
                return v8
            end
        end
    end

    return nil
end

local function getInstanceValue(a0, a1)
    local v9, v10 = pcall(function() --[[ Upvalues: a0 (copy), a1 (copy) ]]
        return a0[a1]
    end)
    if not v9 then
        v10 = a0:GetAttribute(a1)
    end

    return v10
end

local function getRealInstance(a0)
    if not a0:GetAttribute("IsAClippedClone") then
        return
    end

    local OriginalInstance = a0:FindFirstChild("OriginalInstance")
    if not OriginalInstance then
        return
    end

    return OriginalInstance.Value
end

local function getClippedClone(a0)
    if not a0:GetAttribute("HasAClippedClone") then
        return
    end

    local ClippedClone = a0:FindFirstChild("ClippedClone")
    if not ClippedClone then
        return
    end

    return ClippedClone.Value
end

local v11 = nil

local function refresh(a0, a1, a2) --[[ Upvalues: v11 (copy) ]]
    if a2 then
        local v12 = a0:getStateGroup()
        local v15 = v11.getThemeValue(v12, a1.Name, a2) or v11.getInstanceValue(a1, a2)
        v11.apply(a0, a1, a2, v15, true)
        return
    end

    local v16 = a0:getStateGroup()
    if not v16 then
        return
    end

    local v17 = {[a1.Name] = a1}
    local v18 = a1:GetDescendants()
    for k3, k4 in pairs(v18) do
        local v22 = k4:GetAttribute("Collective")
        if v22 then
            v17[v22] = k4
        end

        v17[k4.Name] = k4
    end

    for k5, k6 in pairs(v16) do
        local v26, v27, v28 = unpack(k6)
        local v29 = v17[v26]
        if v29 then
            v11.apply(a0, v29.Name, v27, v28, true)
        end
    end
end

local function apply(a0, a1, a2, a3, a4) --[[ Upvalues: v11 (copy) ]]
    if a0.isDestroyed then
        return
    end

    local v30 = a1
    local v31
    if typeof(a1) == "Instance" then
        local v32 = {a1}
        v31 = v32
        v30 = a1.Name
    else
        v31 = a0:getInstanceOrCollective(a1)
    end

    local v33 = v30 .. "-" .. a2
    v30 = a0.customBehaviours[v33]
    for k7, k8 in pairs(v31) do
        v33 = v11.getClippedClone(k8)
        if v33 then
            table.insert(v31, v33)
        end
    end

    for k9, k10 in pairs(v31) do
        if a2 == "Position" and v11.getClippedClone(k10) then
        else
            if not (a2 == "Size" and v11.getRealInstance(k10)) then
                local v40 = v11.getInstanceValue(k10, a2)
                if a4 or a3 ~= v40 then
                    if v30 then
                        local v42 = v30(a3, k10, a2)
                        if v42 ~= nil then
                            a3 = v42
                        end
                    end

                    if not pcall(function() --[[ Upvalues: k10 (copy), a2 (copy), a3 (ref) ]]
                        k10[a2] = a3
                    end) then
                        k10:SetAttribute(a2, a3)
                    end
                end
            end
        end
    end
end

local function getModifications(a0)
    if typeof(a0[1]) ~= "table" then
        local v43 = {a0}
        a0 = v43
    end

    return a0
end

local function merge(a0, a1, a2) --[[ Upvalues: v11 (copy) ]]
    local v44, v45, v46, v47 = table.unpack(a1)
    local v48, v49, v50, v51 = table.unpack(a0)
    if v44 == v48 and v45 == v49 and v11.statesMatch(v47, v51) then
        a0[3] = v46
        if a2 then
            a2(a0)
        end

        return true
    end

    return false
end

local function modify(a0, a1, a2) --[[ Upvalues: v1 (copy), v11 (copy) ]]
    task.spawn(function() --[[ Upvalues: a2 (ref), v1 (upvalue), a1 (ref), v11 (upvalue), a0 (copy) ]]
        local v54 = a2 or v1.generateUID()
        a2 = v54
        a1 = v11.getModifications(a1)
        for k11, k12 in pairs(a1) do
            local v58, v59, v60, v61 = table.unpack(k12)
            if v61 == nil then
                local v62 = {v58, v59, v60, "Selected"}
                v11.modify(a0, v62, a2)
                v62 = {v58, v59, v60, "Viewing"}
                v11.modify(a0, v62, a2)
            end

            local v63 = v1.formatStateName(v61 or "Deselected")
            v61 = a0:getStateGroup(v63)

            local function nowSetIt() --[[ Upvalues: v63 (copy), a0 (upvalue), v11 (upvalue), v58 (copy), v59 (copy), v60 (copy) ]]
                if v63 == a0.activeState then
                    v11.apply(a0, v58, v59, v60)
                end
            end

            local function updateRecord() --[[ Upvalues: v61 (copy), v11 (upvalue), k12 (copy), a2 (upvalue), v63 (copy), a0 (upvalue), v58 (copy), v59 (copy), v60 (copy) ]]
                for k13, k14 in pairs(v61) do
                    if v11.merge(k14, k12, function(a0) --[[ Upvalues: a2 (upvalue), v63 (upvalue), a0 (upvalue), v11 (upvalue), v58 (upvalue), v59 (upvalue), v60 (upvalue) ]]
                        a0[5] = a2
                        if v63 == a0.activeState then
                            v11.apply(a0, v58, v59, v60)
                        end

                    end) then
                        return
                    end
                end

                local v67 = {v58, v59, v60, v63, a2}
                table.insert(v61, v67)
                if v63 == a0.activeState then
                    v11.apply(a0, v58, v59, v60)
                end
            end

            updateRecord()
        end

    end)
    return a2
end

local function remove(a0, a1) --[[ Upvalues: v11 (copy) ]]
    for k15, k16 in pairs(a0.appearance) do
        for i1 = #k16, 1, -1 do
            if k16[i1][5] == a1 then
                table.remove(k16, i1)
            end
        end
    end

    v11.rebuild(a0)
end

local function removeWith(a0, a1, a2, a3) --[[ Upvalues: v11 (copy) ]]
    for k17, k18 in pairs(a0.appearance) do
        if not (a3 ~= k17 and a3) then
            for i2 = #k18, 1, -1 do
                local v78 = k18[i2]
                if v78[1] == a1 and v78[2] == a2 then
                    table.remove(k18, i2)
                end
            end
        end
    end

    v11.rebuild(a0)
end

local function change(a0) --[[ Upvalues: v11 (copy) ]]
    local v79 = a0:getStateGroup()
    for k19, k20 in pairs(v79) do
        local v83, v84, v85 = unpack(k20)
        v11.apply(a0, v83, v84, v85)
    end
end

local function set(a0, a1) --[[ Upvalues: v11 (copy) ]]
    local themesJanitor = a0.themesJanitor
    themesJanitor:clean()
    local v86 = a0.stateChanged:Connect(function() --[[ Upvalues: v11 (upvalue), a0 (copy) ]]
        v11.change(a0)
    end)
    themesJanitor:add(v86)
    if typeof(a1) == "Instance" and a1:IsA("ModuleScript") then
        a1 = require(a1)
    end

    a0.appliedTheme = a1
    v11.rebuild(a0)
end

local function statesMatch(a0, a1)
    local v89 = a0 and string.lower(a0)
    local v92 = a1 and string.lower(a1)
    local v93 = true
    if v89 ~= v92 then
        local v95 = not a0 or not a1
    end

    return v93
end

local function rebuild(a0) --[[ Upvalues: v11 (copy), v1 (copy), v2 (copy) ]]
    local t1 = {"Deselected", "Selected", "Viewing"}
    local appliedTheme = a0.appliedTheme

    local function generateTheme() --[[ Upvalues: t1 (copy), v11 (upvalue), v1 (upvalue), v2 (upvalue), appliedTheme (copy), a0 (copy) ]]
        for k21, k22 in pairs(t1) do
            local t2 = {}

            local function updateDetails(a0, a1) --[[ Upvalues: v11 (upvalue), v1 (upvalue), t2 (copy) ]]
                if not a0 then
                    return
                end

                for k23, k24 in pairs(a0) do
                    local v103 = k24[5]
                    if v11.statesMatch(a1, k24[4]) then
                        local v104 = k24[1] .. "-" .. k24[2]
                        local v105 = v1.copyTable(k24)
                        v105[5] = v103
                        t2[v104] = v105
                    end
                end
            end

            if k22 == "Selected" then
                updateDetails(v2, "Deselected")
            end

            updateDetails(v2, "Empty")
            updateDetails(v2, k22)
            if appliedTheme ~= v2 then
                if k22 == "Selected" then
                    updateDetails(appliedTheme, "Deselected")
                end

                updateDetails(v2, "Empty")
                updateDetails(appliedTheme, k22)
            end

            local v106 = {}
            local v107 = a0.appearance[k22]
            if v107 then
                for k25, k26 in pairs(v107) do
                    local v111 = k26[5]
                    if v111 ~= nil then
                        local v112 = {k26[1], k26[2], k26[3], k22, v111}
                        table.insert(v106, v112)
                    end
                end
            end

            updateDetails(v106, k22)
            v107 = {}
            for k27, k28 in pairs(t2) do
                table.insert(v107, k28)
            end

            a0.appearance[k22] = v107
        end

        v11.change(a0)
    end

    generateTheme()
end

v11 = {
    getThemeValue = getThemeValue,
    getInstanceValue = getInstanceValue,
    getRealInstance = getRealInstance,
    getClippedClone = getClippedClone,
    refresh = refresh,
    apply = apply,
    getModifications = getModifications,
    merge = merge,
    modify = modify,
    remove = remove,
    removeWith = removeWith,
    change = change,
    set = set,
    statesMatch = statesMatch,
    rebuild = rebuild
}
return v11
