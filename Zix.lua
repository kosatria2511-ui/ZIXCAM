-- LocalScript named "ZIX👑"
-- Place inside StarterPlayerScripts or StarterGui

-- ✅ Game check: only allow Violence District
if game.PlaceId ~= 1234567890 then -- replace with Violence District's actual PlaceId
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ZIXCAM_Warning"
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local warning = Instance.new("TextLabel")
    warning.Size = UDim2.new(0.6, 0, 0.2, 0)
    warning.Position = UDim2.new(0.2, 0, 0.4, 0)
    warning.Text = "⚠️ Script only works on Violence District!!"
    warning.TextScaled = true
    warning.Font = Enum.Font.GothamBold
    warning.TextColor3 = Color3.fromHSV(0.6, 0.2, 1)
    warning.BackgroundTransparency = 0.3
    warning.BackgroundColor3 = Color3.fromHSV(0.6, 0.2, 1)
    warning.Parent = screenGui

    return -- stop script execution
end

-- 🔻 Main script continues if PlaceId matches
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZIX VIP👑"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 220)
frame.Position = UDim2.new(0.5, -160, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,35)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.Text = "ZIX VIP Control Panel"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Parent = frame

-- 🖼️ Toggle Button
local toggleButton = Instance.new("ImageButton")
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(1, -50, 1, -50)
toggleButton.Image = "rbxassetid://87364137514855"
toggleButton.BackgroundTransparency = 0.3
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1,0)
toggleCorner.Parent = toggleButton

local guiEnabled = true
toggleButton.MouseButton1Click:Connect(function()
    guiEnabled = not guiEnabled
    frame.Visible = guiEnabled
end)

-- 🌞 Fullbright + No Fog
local fullbrightBtn = Instance.new("TextButton")
fullbrightBtn.Size = UDim2.new(0, 100, 0, 30)
fullbrightBtn.Position = UDim2.new(0, 10, 1, -40)
fullbrightBtn.Text = "Fullbright: OFF"
fullbrightBtn.Parent = frame

local fogBtn = Instance.new("TextButton")
fogBtn.Size = UDim2.new(0, 100, 0, 30)
fogBtn.Position = UDim2.new(0, 120, 1, -40)
fogBtn.Text = "No Fog: OFF"
fogBtn.Parent = frame

local fullbrightEnabled = false
local noFogEnabled = false

fullbrightBtn.MouseButton1Click:Connect(function()
	fullbrightEnabled = not fullbrightEnabled
	if fullbrightEnabled then
		Lighting.Brightness = 2
		Lighting.Ambient = Color3.new(1,1,1)
		Lighting.OutdoorAmbient = Color3.new(1,1,1)
		fullbrightBtn.Text = "Fullbright: ON"
	else
		Lighting.Brightness = 1
		Lighting.Ambient = Color3.new(0.5,0.5,0.5)
		Lighting.OutdoorAmbient = Color3.new(0.5,0.5,0.5)
		fullbrightBtn.Text = "Fullbright: OFF"
	end
end)

fogBtn.MouseButton1Click:Connect(function()
	noFogEnabled = not noFogEnabled
	if noFogEnabled then
		Lighting.FogEnd = 100000
		fogBtn.Text = "No Fog: ON"
	else
		Lighting.FogEnd = 1000
		fogBtn.Text = "No Fog: OFF"
	end
end)

-- 🎥 Camera [Beta] Sliders
local fov, stiffness, aspect = 80, 0.1, 1.7
camera.FieldOfView = fov

local function createSlider(name, posY, default, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 80, 0, 25)
    label.Position = UDim2.new(0, 10, 0, posY)
    label.Text = name..": "..default
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.Parent = frame

    local slider = Instance.new("TextBox")
    slider.Size = UDim2.new(0, 200, 0, 25)
    slider.Position = UDim2.new(0, 100, 0, posY)
    slider.Text = tostring(default)
    slider.Font = Enum.Font.Gotham
    slider.TextScaled = true
    slider.BackgroundColor3 = Color3.fromRGB(50,50,50)
    slider.TextColor3 = Color3.new(1,1,1)
    slider.Parent = frame

    slider.FocusLost:Connect(function()
        local val = tonumber(slider.Text)
        if val then
            val = math.clamp(val, 0, 200)
            label.Text = name..": "..val
            callback(val)
        else
            slider.Text = tostring(default)
        end
    end)
end

-- FOV slider
createSlider("FOV", 60, fov, function(val)
    fov = val
    camera.FieldOfView = fov
end)

-- Stiffness slider
createSlider("Stiffness", 90, stiffness*100, function(val)
    stiffness = val/100
end)

-- Aspect Ratio slider
createSlider("Aspect", 120, aspect*100, function(val)
    aspect = val/100
end)

-- Smooth DBD-style follow (no freeze, free look preserved)
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local root = char.HumanoidRootPart
        local targetPos = root.Position + root.CFrame:VectorToWorldSpace(Vector3.new(0,5,-10))
        local targetCFrame = CFrame.new(targetPos, root.Position)
        camera.CFrame = camera.CFrame:Lerp(targetCFrame, stiffness)
    end
end)
