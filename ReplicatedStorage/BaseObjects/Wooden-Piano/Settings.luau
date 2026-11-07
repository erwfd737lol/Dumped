
local t1 = {}
Piano = script.Parent
Box = Piano.Keys
t1.PianoSoundRange = 75
t1.KeyAesthetics = true
local v1 = {"233836579", "233844049", "233845680", "233852841", "233854135", "233856105"}
t1.PianoSounds = v1
t1.SoundSource = Box
t1.CameraCFrame = CFrame.new((Box.CFrame * CFrame.new(0, 2, -2)).p, (Box.CFrame * CFrame.new(0, 0, 0)).p)
return t1
