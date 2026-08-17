-- LocalScript: ZIX test silent aim
-- Place inside StarterPlayerScripts

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZIX test silent aim"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,420,0,320)
frame.Position = UDim2.new(0.5,-210,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BackgroundTransparency = 0.3
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.Text = "⚔️ ZIX Silent Aim Library"
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextStrokeTransparency = 0.3
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Logo button (toggle GUI visibility)
local iconBtn = Instance.new("TextButton")
iconBtn.Size = UDim2.new(0,60,0,60)
iconBtn.Position = UDim2.new(0,10,1,-70)
iconBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
iconBtn.BorderSizePixel = 2
iconBtn.BorderColor3 = Color3.fromRGB(255,255,255)
iconBtn.Text = "ZIX"
iconBtn.TextColor3 = Color3.fromRGB(255,255,255)
iconBtn.TextStrokeTransparency = 0.3
iconBtn.Font = Enum.Font.GothamBold
iconBtn.TextScaled = true
iconBtn.Parent = screenGui

local guiVisible = true
iconBtn.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    frame.Visible = guiVisible
end)

-- Tab buttons
local tabs = {"ESP","Silent Aim","Prediction"}
local tabFrames = {}

local function makeTabButton(name,pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,130,0,30)
    btn.Position = pos
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
    btn.TextStrokeTransparency = 0.3
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Parent = frame
    return btn
end

-- Create subframes for each library
for i,name in ipairs(tabs) do
    local subFrame = Instance.new("Frame")
    subFrame.Size = UDim2.new(1,0,1,-40)
    subFrame.Position = UDim2.new(0,0,0,40)
    subFrame.BackgroundTransparency = 1
    subFrame.Visible = (i==1) -- show ESP by default
    subFrame.Parent = frame
    tabFrames[name] = subFrame

    local btn = makeTabButton(name, UDim2.new(0,(i-1)*140,0,0))
    btn.MouseButton1Click:Connect(function()
        for _,f in pairs(tabFrames) do f.Visible = false end
        subFrame.Visible = true
    end)
end

-- Helper for buttons
local function makeButton(parent,text,pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,180,0,30)
    btn.Position = pos
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
    btn.TextStrokeTransparency = 0.3
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Parent = parent
    return btn
end

-- ESP tab content
local espFrame = tabFrames["ESP"]
local survivorBtn = makeButton(espFrame,"Survivor ESP: OFF", UDim2.new(0,10,0,10))
local killerBtn   = makeButton(espFrame,"Killer ESP: OFF",   UDim2.new(0,210,0,10))
local zombieBtn   = makeButton(espFrame,"Zombie ESP: OFF",   UDim2.new(0,10,0,50))
local genBtn      = makeButton(espFrame,"Generator ESP: OFF",UDim2.new(0,210,0,50))
local palletBtn   = makeButton(espFrame,"Pallet ESP: OFF",   UDim2.new(0,10,0,90))
local windowBtn   = makeButton(espFrame,"Window ESP: OFF",   UDim2.new(0,210,0,90))

-- Silent Aim tab content
local saFrame = tabFrames["Silent Aim"]
local silentAimBtn = makeButton(saFrame,"Silent Aim: OFF", UDim2.new(0,10,0,10))

-- Prediction tab content
local predFrame = tabFrames["Prediction"]
local autoPredBtn = makeButton(predFrame,"Auto Prediction: OFF", UDim2.new(0,10,0,10))

-- State
local espEnabled = {
    Survivor = false,
    Killer = false,
    Zombie = false,
    Generator = false,
    Pallet = false,
    Window = false,
}
local silentAim = false
local autoPrediction = false

-- Toggle logic
survivorBtn.MouseButton1Click:Connect(function()
    espEnabled.Survivor = not espEnabled.Survivor
    survivorBtn.Text = "Survivor ESP: "..(espEnabled.Survivor and "ON" or "OFF")
end)
killerBtn.MouseButton1Click:Connect(function()
    espEnabled.Killer = not espEnabled.Killer
    killerBtn.Text = "Killer ESP: "..(espEnabled.Killer and "ON" or "OFF")
end)
zombieBtn.MouseButton1Click:Connect(function()
    espEnabled.Zombie = not espEnabled.Zombie
    zombieBtn.Text = "Zombie ESP: "..(espEnabled.Zombie and "ON" or "OFF")
end)
genBtn.MouseButton1Click:Connect(function()
    espEnabled.Generator = not espEnabled.Generator
    genBtn.Text = "Generator ESP: "..(espEnabled.Generator and "ON" or "OFF")
end)
palletBtn.MouseButton1Click:Connect(function()
    espEnabled.Pallet = not espEnabled.Pallet
    palletBtn.Text = "Pallet ESP: "..(espEnabled.Pallet and "ON" or "OFF")
end)
windowBtn.MouseButton1Click:Connect(function()
    espEnabled.Window = not espEnabled.Window
    windowBtn.Text = "Window ESP: "..(espEnabled.Window and "ON" or "OFF")
end)

silentAimBtn.MouseButton1Click:Connect(function()
    silentAim = not silentAim
    silentAimBtn.Text = "Silent Aim: "..(silentAim and "ON" or "OFF")
end)

autoPredBtn.MouseButton1Click:Connect(function()
    autoPrediction = not autoPrediction
    autoPredBtn.Text = "Auto Prediction: "..(autoPrediction and "ON" or "OFF")
end)

-- Spear throw function with hitsound
local function throwSpear(target)
    local spear = Instance.new("Part")
    spear.Size = Vector3.new(0.3,0.3,2)
    spear.Position = player.Character.Head.Position
    spear.Anchored = false
    spear.CanCollide = true
    spear.Parent = workspace

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    bv.Parent = spear

    local connection
    connection = RunService.Heartbeat:Connect(function()
        if spear.Parent and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = target.Character.HumanoidRootPart
            local predictedPos = autoPrediction and (hrp.Position + hrp.Velocity * 0.3) or hrp.Position
            local dir = (predictedPos - spear.Position).Unit
            bv.Velocity = dir * 100
        else
            connection:Disconnect()
        end
    end)

    spear.Touched:Connect(function(hit)
        if hit.Parent == target.Character then
            local hum = hit.Parent:FindFirstChild("Humanoid")
            if hum then hum:TakeDamage(20) end

            -- Play classic Roblox "oof" sound
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://130113322" -- Roblox oof
            sound.Volume = 1
            sound.Parent = spear
            sound:Play()

            spear:Destroy()
        end
    end)
end
