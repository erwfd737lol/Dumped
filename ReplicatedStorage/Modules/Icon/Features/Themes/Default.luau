
local t1 = {"IconCorners", "CornerRadius", UDim.new(1, 0)}
local v3 = {"Selection", "Size", UDim2.new(1, 0, 1, 1)}
local v5 = {"Selection", "Position", UDim2.new(0, 0, 0, 0)}
local v6 = Color3.fromRGB(255, 255, 255)
local v7 = ColorSequenceKeypoint.new(0, v6)
local v8 = Color3.fromRGB(86, 86, 86)
local v10 = {v7, ColorSequenceKeypoint.new(1, v8)}
local v12 = {"SelectionGradient", "Color", ColorSequence.new(v10)}
local v13 = UDim2.fromOffset(0, 0)
local v14 = Color3.fromRGB(18, 18, 21)
local v15 = UDim.new(0, 0)
local v16 = {"IconImageCorner", "CornerRadius", v15, "Deselected"}
local v17 = {"IconImageScale", "Value", 0.5, "Deselected"}
local v18 = {"IconButton", "BackgroundTransparency", 0.08, "Deselected"}
local v19 = {"IconButton", "BackgroundColor3", v14, "Deselected"}
local v20 = {"Widget", "BorderSize", 4, "Deselected"}
local v21 = {"Widget", "MinimumHeight", 44, "Deselected"}
local v22 = {"Widget", "MinimumWidth", 44, "Deselected"}
local v23 = {"Widget", "DesiredWidth", 44, "Deselected"}
local v24 = {"IconLabel", "Position", v13, "Deselected"}
local v25 = {"IconLabel", "Text", "", "Deselected"}
local v26 = {"IconImage", "Image", "", "Deselected"}
local v27 = {"Selection", "RotationSpeed", 1}
local v28 = Color3.fromRGB(255, 255, 255)
local v29 = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
local v30 = {"Menu", "Active", false, "Deselected"}
local v31 = {
    "ContentsList",
    "HorizontalAlignment",
    Enum.HorizontalAlignment.Center,
    "Deselected"
}
local v32 = Color3.fromRGB(18, 18, 21)
local v33 = {"Dropdown", "BackgroundColor3", v32, "Deselected"}
local v34 = {"Dropdown", "BackgroundTransparency", 0.08, "Deselected"}
local v35 = {"Dropdown", "MaxIcons", 4.5, "Deselected"}
local v36 = {"Menu", "MaxIcons", 4, "Deselected"}
local v37 = {"ClickRegion", "Active", true, "Deselected"}
local v38 = {"IconGradient", "Enabled", false, "Deselected"}
local v39 = {"IconSpotGradient", "Enabled", false, "Deselected"}
local v40 = {"IconOverlay", "BackgroundTransparency", 0.85, "Deselected"}
local v41 = {"IconSpot", "BackgroundTransparency", 1, "Deselected"}
local v42 = {"IconLabel", "TextSize", 16, "Deselected"}
local v43 = {"IconLabel", "FontFace", v29, "Deselected"}
local v44 = {"IconImageRatio", "AspectRatio", 1, "Deselected"}
local v45 = {"IconImage", "ImageTransparency", 0, "Deselected"}
t1 = {"IconImage", "ImageColor3", v28, "Deselected"}
local v46 = UDim2.new(1, -12, 0, -1)
t1 = {"Notice", "Position", v46, "Deselected"}
local v47 = UDim2.new(0, 20, 0, 20)
local v48 = {"Notice", "Size", v47, "Deselected"}
local v49 = {"NoticeLabel", "TextSize", 13, "Deselected"}
local v50 = UDim2.new(0, 9, 1, 0)
local v51 = {"PaddingLeft", "Size", v50, "Deselected"}
local v52 = UDim2.new(0, 11, 1, 0)
local v53 = {"PaddingRight", "Size", v52, "Deselected"}
local v54 = {"IconSpot", "BackgroundTransparency", 0.7, "Selected"}
local v55 = Color3.fromRGB(255, 255, 255)
local v56 = {"IconSpot", "BackgroundColor3", v55, "Selected"}
local v57 = {"IconSpotGradient", "Enabled", true, "Selected"}
local v58 = {"IconSpotGradient", "Rotation", 45, "Selected"}
local v59 = Color3.fromRGB(96, 98, 100)
local v60 = Color3.fromRGB(77, 78, 80)
local v61 = ColorSequence.new(v59, v60)
local v62 = {"IconSpotGradient", "Color", v61, "Selected"}
local t2 = {
    t1,
    v27,
    v3,
    v5,
    v12,
    v26,
    v25,
    v24,
    v23,
    v22,
    v21,
    v20,
    v19,
    v18,
    v17,
    v16,
    t1,
    v45,
    v44,
    v43,
    v42,
    v41,
    v40,
    v39,
    v38,
    v37,
    v30,
    v31,
    v33,
    v34,
    v35,
    v36,
    t1,
    v48,
    v49,
    v51,
    v53,
    v54,
    v56,
    v57,
    v58,
    v62
}
return t2
