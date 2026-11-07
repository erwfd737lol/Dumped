-- decompiled by Velocity decompiler v1.0.3

Gui = script.Parent
Player = game.Players.LocalPlayer
PlayingEnabled = false
ScriptReady = false
local ReplicatedStorage = game:GetService("ReplicatedStorage")
PianoId = nil
Connector = ReplicatedStorage:WaitForChild("GlobalPianoConnector")

local function Receive(a0, ...)
    local t1 = {...}
    if not ScriptReady then
        return
    end

    if a0 == "activate" then
        if not PlayingEnabled then
            Activate(t1[1], t1[2])
            return
            -- branch continues at 47
        end
    end

    if a0 == "deactivate" then
        if PlayingEnabled then
            Deactivate()
            return
            -- branch continues at 47
        end
    end

    if a0 == "play" and Player ~= t1[1] then
        PlayNoteServer(t1[2], t1[3], t1[4], t1[5])
    end
end

Receive = Receive

local function Activate(a0, a1)
    PlayingEnabled = true
    MakeHumanoidConnections()
    MakeKeyboardConnections()
    MakeGuiConnections()
    SetCamera(a0)
    SetSounds(a1)
    ShowPiano()
end

Activate = Activate

local function Deactivate()
    PlayingEnabled = false
    BreakHumanoidConnections()
    BreakKeyboardConnections()
    BreakGuiConnections()
    HidePiano()
    HideSheets()
    ReturnCamera()
    Jump()
end

Deactivate = Deactivate

local function PlayNoteClient(a0)
    PlayNoteSound(a0)
    HighlightPianoKey(a0)
    Connector:FireServer("play", a0)
end

PlayNoteClient = PlayNoteClient

local function PlayNoteServer(a0, a1, a2)
    PlayNoteSound(a0, a1, a2)
end

PlayNoteServer = PlayNoteServer

local function Abort()
    Connector:FireServer("abort")
end

Abort = Abort
Connector.OnClientEvent:connect(Receive)
InputService = game:GetService("UserInputService")
Mouse = Player:GetMouse()
TextBoxFocused = false
FocusLost = false
ShiftLock = false

local function LetterToNote(a0, a1)
    local v1 = string.char(a0)
    if a1 then
        if tonumber(v1) then
            local v2 = tonumber(v1) + 1
            v1 = string.sub(")!@#$%^&*(", v2, tonumber(v1) + 1)
        else
            v1 = string.upper(v1)
        end
    end

    local v3 = string.find("1!2@34$5%6^78*9(0qQwWeErtTyYuiIoOpPasSdDfgGhHjJklLzZxcCvVbBnm", v1, 1, true)
    if v3 then
        return v3
    end
end

LetterToNote = LetterToNote

local function KeyDown(a0)
    if TextBoxFocused then
        return
    end

    local Value = a0.KeyCode.Value
    local v6 = InputService:IsKeyDown(303) or InputService:IsKeyDown(304)
    if 97 > Value or Value > 122 then
        if 48 <= Value then
            if Value > 57 then
                -- jump to 55
            end

            -- branch continues at 55
        end
    end

    local v7 = LetterToNote(Value, v6 == not ShiftLock)
    if v7 then
        PlayNoteClient(v7)
        return
        if Value == 8 then
            Deactivate()
            return
        end

        if Value == 32 then
            ToggleSheets()
            return
        end

        if Value == 13 then
            ToggleCaps()
        end
    end
end

KeyDown = KeyDown

local function Input(a0)
    if a0.UserInputType.Name == "Keyboard" then
        if a0.UserInputState.Name == "Begin" then
            if FocusLost then
                FocusLost = false
                return
            end

            KeyDown(a0)
        end
    end
end

Input = Input

local function TextFocus()
    TextBoxFocused = true
end

TextFocus = TextFocus

local function TextUnfocus()
    FocusLost = true
    TextBoxFocused = false
end

TextUnfocus = TextUnfocus
KeyboardConnection = nil
JumpConnection = nil
FocusConnection = InputService.TextBoxFocused:connect(TextFocus)
UnfocusConnection = InputService.TextBoxFocusReleased:connect(TextUnfocus)

local function MakeKeyboardConnections()
    KeyboardConnection = InputService.InputBegan:connect(Input)
end

MakeKeyboardConnections = MakeKeyboardConnections

local function BreakKeyboardConnections()
    KeyboardConnection:disconnect()
end

BreakKeyboardConnections = BreakKeyboardConnections
PianoGui = Gui.PianoGui
SheetsGui = Gui.SheetsGui
SheetsVisible = false

local function ShowPiano()
    local v8 = UDim2.new(0.5, -380, 1, -250)
    PianoGui:TweenPosition(v8, Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true)
end

ShowPiano = ShowPiano

local function HidePiano()
    local v9 = UDim2.new(0.5, -380, 1, 0)
    PianoGui:TweenPosition(v9, Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true)
end

HidePiano = HidePiano

local function ShowSheets()
    local v10 = UDim2.new(0.5, -200, 1, -520)
    SheetsGui:TweenPosition(v10, Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true)
end

ShowSheets = ShowSheets

local function HideSheets()
    local v11 = UDim2.new(0.5, -200, 1, 0)
    SheetsGui:TweenPosition(v11, Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true)
end

HideSheets = HideSheets

local function ToggleSheets()
    SheetsVisible = not SheetsVisible
    if SheetsVisible then
        ShowSheets()
        return
    end

    HideSheets()
end

ToggleSheets = ToggleSheets

local function IsBlack(a0)
    if a0 % 12 == 2 or a0 % 12 == 4 or a0 % 12 == 7 or a0 % 12 == 9 or a0 % 12 == 11 then
        return true
    end
end

IsBlack = IsBlack

local function HighlightPianoKey(a0)
    local v12 = PianoGui.Keys[a0]
    if IsBlack(a0) then
        v12.BackgroundColor3 = Color3.new(0.19607843137254902, 0.19607843137254902, 0.19607843137254902)
    else
        v12.BackgroundColor3 = Color3.new(0.78431372549019607, 0.78431372549019607, 0.78431372549019607)
    end

    delay(0.5, function() --[[ Upvalues: a0 (copy) ]]
        RestorePianoKey(a0)
    end)
end

HighlightPianoKey = HighlightPianoKey

local function RestorePianoKey(a0)
    local v13 = PianoGui.Keys[a0]
    if IsBlack(a0) then
        v13.BackgroundColor3 = Color3.new(0, 0, 0)
        return
    end

    v13.BackgroundColor3 = Color3.new(1, 1, 1)
end

RestorePianoKey = RestorePianoKey

local function PianoKeyPressed(a0, a1)
    local Name = a0.UserInputType.Name
    if Name == "MouseButton1" or Name == "Touch" then
        PlayNoteClient(a1)
    end
end

PianoKeyPressed = PianoKeyPressed

local function ExitButtonPressed(a0)
    local Name1 = a0.UserInputType.Name
    if Name1 == "MouseButton1" or Name1 == "Touch" then
        Deactivate()
    end
end

ExitButtonPressed = ExitButtonPressed

local function SheetsButtonPressed(a0)
    local Name2 = a0.UserInputType.Name
    if Name2 == "MouseButton1" or Name2 == "Touch" then
        ToggleSheets()
    end
end

SheetsButtonPressed = SheetsButtonPressed

local function SheetsEdited(a0)
    if a0 == "Text" then
        SheetsGui.Sheet.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(14, SheetsGui.Sheet.ScrollingFrame.TextBox.TextBounds.Y))
    end
end

SheetsEdited = SheetsEdited

local function ToggleCaps()
    ShiftLock = not ShiftLock
    if ShiftLock then
        PianoGui.CapsButton.BackgroundColor3 = Color3.new(1, 0.66666666666666663, 0)
        PianoGui.CapsButton.BorderColor3 = Color3.new(0.60392156862745094, 0.40392156862745099, 0)
        PianoGui.CapsButton.TextColor3 = Color3.new(1, 1, 1)
        return
    end

    PianoGui.CapsButton.BackgroundColor3 = Color3.new(0.5490196078431373, 0.5490196078431373, 0.5490196078431373)
    PianoGui.CapsButton.BorderColor3 = Color3.new(0.26666666666666666, 0.26666666666666666, 0.26666666666666666)
    PianoGui.CapsButton.TextColor3 = Color3.new(0.70588235294117652, 0.70588235294117652, 0.70588235294117652)
end

ToggleCaps = ToggleCaps

local function CapsButtonPressed(a0)
    local Name3 = a0.UserInputType.Name
    if Name3 == "MouseButton1" or Name3 == "Touch" then
        ToggleCaps()
    end
end

CapsButtonPressed = CapsButtonPressed
PianoKeysConnections = {}
ExitButtonConnection = nil
SheetsButtonConnection = nil
SheetsEditedConnection = nil
CapsButtonConnection = nil

local function MakeGuiConnections()
    local v14 = PianoGui.Keys:GetChildren()
    for k1, k2 in pairs(v14) do
        PianoKeysConnections[k1] = k2.InputBegan:connect(function(a0) --[[ Upvalues: k2 (copy) ]]
            PianoKeyPressed(a0, tonumber(k2.Name))
        end)
    end

    ExitButtonConnection = PianoGui.ExitButton.InputBegan:connect(ExitButtonPressed)
    SheetsButtonConnection = PianoGui.SheetsButton.InputBegan:connect(SheetsButtonPressed)
    SheetsEditedConnection = SheetsGui.Sheet.ScrollingFrame.TextBox.Changed:connect(SheetsEdited)
    CapsButtonConnection = PianoGui.CapsButton.InputBegan:connect(CapsButtonPressed)
end

MakeGuiConnections = MakeGuiConnections

local function BreakGuiConnections()
    for k3, k4 in pairs(PianoKeysConnections) do
        k4:disconnect()
    end

    ExitButtonConnection:disconnect()
    SheetsButtonConnection:disconnect()
    SheetsEditedConnection:disconnect()
    CapsButtonConnection:disconnect()
end

BreakGuiConnections = BreakGuiConnections
ContentProvider = game:GetService("ContentProvider")
local v21 = {"233836579", "233844049", "233845680", "233852841", "233854135", "233856105"}
LocalSounds = v21
SoundFolder = Gui.SoundFolder
ExistingSounds = {}

local function PreloadAudio(a0)
    for k5, k6 in pairs(a0) do
        ContentProvider:Preload("rbxassetid://" .. k6)
    end
end

PreloadAudio = PreloadAudio

local function SetSounds(a0)
    PreloadAudio(a0)
    LocalSounds = a0
end

SetSounds = SetSounds

local function PlayNoteSound(a0, a1, a2, a3)
    local v27 = a3 or LocalSounds
    local v28 = (a0 - 1) % 12 + 1
    local v29 = math.ceil(a0 / 12)
    local v30 = math.ceil(v28 / 2)
    local v31 = (v29 - 1) * 16
    local v32 = v31 + 8 * (1 - v28 % 2)
    v28 = Instance.new("Sound", SoundFolder)
    v28.SoundId = "rbxassetid://" .. v27[v30]
    if a1 then
        v30 = 1 / a2 ^ 2
        local v33 = -v30 * (game.Workspace.CurrentCamera.CoordinateFrame.p - a1).magnitude ^ 2 + 1
        if v33 < 0.05 then
            v28:remove()
            return
        end

        v28.Volume = v33
    end

    v28.TimePosition = v32 + (v29 - 0.9) / 15
    v28:Play()
    table.insert(ExistingSounds, 1, v28)
    local v34 = #ExistingSounds
    if 10 <= v34 then
        ExistingSounds[10]:Stop()
        ExistingSounds[10] = nil
    end

    delay(4, function() --[[ Upvalues: v28 (copy) ]]
        v28:Stop()
        v28:remove()
    end)
end

PlayNoteSound = PlayNoteSound
Camera = game.Workspace.CurrentCamera

local function Jump()
    local Character = Player.Character
    if Character then
        local Humanoid1 = Character:FindFirstChild("Humanoid")
        if Humanoid1 then
            Humanoid1.Jump = true
        end
    end
end

Jump = Jump

local function HumanoidChanged(a0, a1)
    if a1 == "Jump" then
        a0.Jump = false
        return
    end

    if a1 == "Sit" then
        a0.Sit = true
        return
    end

    if a1 == "Parent" then
        Deactivate()
        Abort()
    end
end

HumanoidChanged = HumanoidChanged

local function HumanoidDied()
    Deactivate()
end

HumanoidDied = HumanoidDied

local function SetCamera(a0)
    Camera.CameraType = Enum.CameraType.Scriptable
    local v35 = a0 + a0.lookVector
    Camera:Interpolate(a0, v35, 0.5)
end

SetCamera = SetCamera

local function ReturnCamera()
    Camera.CameraType = Enum.CameraType.Custom
end

ReturnCamera = ReturnCamera
HumanoidChangedConnection = nil
HumanoidDiedConnection = nil

local function MakeHumanoidConnections()
    local Character1 = Player.Character
    if Character1 then
        local Humanoid3 = Character1:FindFirstChild("Humanoid")
        if Humanoid3 then
            HumanoidChangedConnection = Humanoid3.Changed:connect(function(a0) --[[ Upvalues: Humanoid3 (copy) ]]
                HumanoidChanged(Humanoid3, a0)
            end)
            HumanoidDiedConnection = Humanoid3.Died:connect(HumanoidDied)
        end
    end
end

MakeHumanoidConnections = MakeHumanoidConnections

local function BreakHumanoidConnections()
    HumanoidChangedConnection:disconnect()
    HumanoidDiedConnection:disconnect()
end

BreakHumanoidConnections = BreakHumanoidConnections
ScriptReady = true
