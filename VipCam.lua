-- ZIXCAM VIP👑 - With Logo (rbxassetid://87364137514855)
-- Full script with toggleable logo image

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

repeat task.wait() until LocalPlayer.Character

local Character = LocalPlayer.Character
local Humanoid = Character:FindFirstChild("Humanoid")
local RootPart = Character:FindFirstChild("HumanoidRootPart")

if not RootPart or not Humanoid then return end

-- CONFIG
local Config = {
    Offset = Vector3.new(0, 4.5, 6),
    Smoothness = 0.08,
    RotationSpeed = 0.15,
    PitchMin = -20,
    PitchMax = 60,
    ZoomMin = 2.5,
    ZoomMax = 10,
    CurrentZoom = 6,
    CollisionOffset = 0.3,
    TouchSensitivity = 0.5,
    FOV = 70,
    AspectRatio = 1.777,
    AspectEnabled = false,
    Stiffness = 0.5,
    StiffnessEnabled = false,
    Moonwalk = false,
    LogoVisible = true
}

local CurrentPitch = 15
local CurrentYaw = 0
local TargetZoom = Config.CurrentZoom
local IsTouching = false
local LastTouchPos = nil
local LastTouchDist = nil

Humanoid.AutoRotate = false

-- Mouse
if UserInputService.MouseEnabled then
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    UserInputService.MouseIconEnabled = false
end

-- Touch rotation
UserInputService.TouchBegan:Connect(function(input)
    IsTouching = true
    LastTouchPos = input.Position
end)

UserInputService.TouchMoved:Connect(function(input)
    if not IsTouching then return end
    local delta = input.Position - LastTouchPos
    LastTouchPos = input.Position
    CurrentYaw = CurrentYaw - delta.X * Config.TouchSensitivity * 0.01
    CurrentPitch = math.clamp(CurrentPitch - delta.Y * Config.TouchSensitivity * 0.01, Config.PitchMin, Config.PitchMax)
end)

UserInputService.TouchEnded:Connect(function()
    IsTouching = false
    LastTouchPos = nil
end)

-- Pinch zoom
local function GetTouchDist()
    local t = UserInputService:GetTouchPositions()
    if #t >= 2 then return (t[1] - t[2]).Magnitude end
    return nil
end

RunService.RenderStepped:Connect(function()
    local t = UserInputService:GetTouchPositions()
    if #t >= 2 then
        local d = GetTouchDist()
        if LastTouchDist and d then
            TargetZoom = math.clamp(TargetZoom - (d - LastTouchDist) * 0.01, Config.ZoomMin, Config.ZoomMax)
            Config.CurrentZoom = TargetZoom
        end
        LastTouchDist = d
    else
        LastTouchDist = nil
    end
end)

-- Mouse wheel zoom
if UserInputService.MouseEnabled then
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            TargetZoom = math.clamp(TargetZoom - input.Position.Z * 0.5, Config.ZoomMin, Config.ZoomMax)
            Config.CurrentZoom = TargetZoom
        end
    end)
end

-- Mouse rotation
RunService.RenderStepped:Connect(function()
    if UserInputService.MouseEnabled and not IsTouching then
        local d = UserInputService:GetMouseDelta()
        CurrentYaw = CurrentYaw - d.X * Config.RotationSpeed
        CurrentPitch = math.clamp(CurrentPitch - d.Y * Config.RotationSpeed, Config.PitchMin, Config.PitchMax)
    end
end)

-- Camera update
RunService.RenderStepped:Connect(function()
    if not RootPart or not RootPart.Parent then return end

    Camera.FieldOfView = Config.FOV

    if Config.AspectEnabled then
        local ar = Config.AspectRatio
        local vs = Camera.ViewportSize
        local newW = vs.X
        local newH = math.floor(vs.X / ar)
        if newH > vs.Y then
            newH = vs.Y
            newW = math.floor(vs.Y * ar)
        end
        Camera.ViewportSize = Vector2.new(newW, newH)
    else
        Camera.ViewportSize = Vector2.new(workspace.CurrentCamera.ViewportSize.X, workspace.CurrentCamera.ViewportSize.Y)
    end

    local y = math.rad(CurrentYaw)
    local p = math.rad(CurrentPitch)
    local dist = Config.CurrentZoom
    local dir = Vector3.new(math.sin(y)*math.cos(p), math.sin(p), math.cos(y)*math.cos(p))
    local desired = RootPart.Position + Vector3.new(0, Config.Offset.Y, 0) + dir * dist

    local ray = Ray.new(RootPart.Position + Vector3.new(0,1.5,0), (desired - RootPart.Position).Unit * dist)
    local hit, pos = Workspace:FindPartOnRay(ray, Character, false, true)
    if hit and pos then desired = pos + (RootPart.Position - pos).Unit * Config.CollisionOffset end

    if Config.StiffnessEnabled then
        local stiff = Config.Stiffness
        local currentPos = Camera.CFrame.Position
        local targetPos = desired
        local lerpFactor = 1 / (1 + stiff * 10)
        local newPos = currentPos:Lerp(targetPos, lerpFactor)
        desired = newPos
    end

    Camera.CFrame = Camera.CFrame:Lerp(
        CFrame.new(desired, RootPart.Position + Vector3.new(0,1.5,0)),
        Config.Smoothness
    )

    if Humanoid then Humanoid.AutoRotate = false end

    if Config.Moonwalk and Humanoid then
        local moveDirection = Humanoid.MoveDirection
        if moveDirection.Magnitude > 0.1 then
            local lookVector = RootPart.CFrame.LookVector
            local dot = lookVector:Dot(moveDirection)
            if dot > 0 then
                Humanoid:MoveTo(RootPart.Position - moveDirection * 10)
            end
        end
    end
end)

if UserInputService.MouseEnabled then
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Escape then
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
    end)
end

-- ========== GUI WITH LOGO ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZIXCAM_GUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Toggle Button with Logo Image
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(1, -65, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleBtn.BackgroundTransparency = 0.3
ToggleBtn.BorderSizePixel = 2
ToggleBtn.BorderColor3 = Color3.fromRGB(255, 0, 200)
ToggleBtn.Image = "rbxassetid://87364137514855"
ToggleBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.ScaleType = Enum.ScaleType.Fit
ToggleBtn.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(1, 0)
BtnCorner.Parent = ToggleBtn

-- Panel
local Panel = Instance.new("Frame")
Panel.Size = UDim2.new(0, 190, 0, 380)
Panel.Position = UDim2.new(1, -205, 0, 70)
Panel.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
Panel.BackgroundTransparency = 0.05
Panel.BorderSizePixel = 2
Panel.BorderColor3 = Color3.fromRGB(255, 0, 200)
Panel.Visible = false
Panel.Parent = ScreenGui

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 10)
PanelCorner.Parent = Panel

-- Chromatic Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 32)
Title.BackgroundTransparency = 1
Title.Text = "ZIXCAM VIP👑"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Panel

task.spawn(function()
    while true do
        local hue = tick() % 2 / 2
        local r = math.floor((math.sin(hue * 2 * math.pi) * 0.5 + 0.5) * 255)
        local g = math.floor((math.sin((hue + 0.33) * 2 * math.pi) * 0.5 + 0.5) * 255)
        local b = math.floor((math.sin((hue + 0.66) * 2 * math.pi) * 0.5 + 0.5) * 255)
        Title.TextColor3 = Color3.fromRGB(r, g, b)
        task.wait(0.05)
    end
end)

-- Close button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -26, 0, 3)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255,80,80)
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.TextSize = 16
CloseBtn.Parent = Panel
CloseBtn.MouseButton1Click:Connect(function()
    Panel.Visible = false
end)

-- Toggle GUI
local guiVisible = false
ToggleBtn.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    Panel.Visible = guiVisible
end)

-- ========== UI HELPERS ==========
local function MakeToggle(text, y, getter, setter)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 28)
    btn.Position = UDim2.new(0.04, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(20,20,40)
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    local state = getter()
    btn.Text = text .. (state and " ON" or " OFF")
    btn.TextColor3 = state and Color3.fromRGB(0,255,200) or Color3.fromRGB(170,170,190)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Panel
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,4)
    c.Parent = btn
    btn.MouseButton1Click:Connect(function()
        local new = not getter()
        setter(new)
        btn.Text = text .. (new and " ON" or " OFF")
        btn.TextColor3 = new and Color3.fromRGB(0,255,200) or Color3.fromRGB(170,170,190)
        btn.BackgroundColor3 = new and Color3.fromRGB(20,50,60) or Color3.fromRGB(20,20,40)
    end)
    return btn
end

local function MakeSlider(text, y, min, max, default, getter, setter)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.92, 0, 0, 34)
    frame.Position = UDim2.new(0.04, 0, 0, y)
    frame.BackgroundTransparency = 1
    frame.Parent = Panel

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 16)
    label.BackgroundTransparency = 1
    label.Text = text .. " " .. string.format("%.1f", default)
    label.TextColor3 = Color3.fromRGB(200,200,230)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0.38, 0, 0, 4)
    track.Position = UDim2.new(0.58, 0, 0.5, -2)
    track.BackgroundColor3 = Color3.fromRGB(30,30,50)
    track.BorderSizePixel = 0
    track.Parent = frame
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0,2)
    tc.Parent = track

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255,0,200)
    fill.BorderSizePixel = 0
    fill.Parent = track

    local handle = Instance.new("TextButton")
    handle.Size = UDim2.new(0, 10, 0, 10)
    handle.Position = UDim2.new((default-min)/(max-min), -5, 0.5, -5)
    handle.BackgroundColor3 = Color3.fromRGB(255,0,200)
    handle.BorderSizePixel = 0
    handle.Text = ""
    handle.Parent = track

    local dragging = false
    handle.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouse = LocalPlayer:GetMouse()
            local rel = math.clamp((mouse.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local val = min + (max-min)*rel
            val = math.floor(val*10)/10
            setter(val)
            label.Text = text .. " " .. string.format("%.1f", val)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            handle.Position = UDim2.new(rel, -5, 0.5, -5)
        end
    end)
    return frame
end

-- ========== BUILD UI ==========
local y = 36
MakeToggle("Moonwalk", y, function() return Config.Moonwalk end, function(v) Config.Moonwalk = v end)
y = y + 32
MakeToggle("Stiffness", y, function() return Config.StiffnessEnabled end, function(v) Config.StiffnessEnabled = v end)
y = y + 32
MakeToggle("Aspect", y, function() return Config.AspectEnabled end, function(v) Config.AspectEnabled = v end)
y = y + 32
MakeToggle("Logo", y, function() return Config.LogoVisible end, function(v) 
    Config.LogoVisible = v
    ToggleBtn.ImageTransparency = v and 0 or 1
end)
y = y + 32

MakeSlider("Stiffness", y, 0, 1, 0.5, function() return Config.Stiffness end, function(v) Config.Stiffness = v end)
y = y + 38
MakeSlider("FOV", y, 50, 120, 70, function() return Config.FOV end, function(v) Config.FOV = v end)
y = y + 38
MakeSlider("Aspect", y, 0.8, 2.5, 1.777, function() return Config.AspectRatio end, function(v) Config.AspectRatio = v end)
y = y + 38
MakeSlider("Zoom", y, 2.5, 10, 6, function() return Config.CurrentZoom end, function(v) 
    Config.CurrentZoom = v
    TargetZoom = v
end)
y = y + 38
MakeSlider("Smooth", y, 0.02, 0.3, 0.08, function() return Config.Smoothness end, function(v) Config.Smoothness = v end)

print("ZIXCAM VIP👑 loaded with Logo (rbxassetid://87364137514855)")
