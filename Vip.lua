-- ========== ZIXCAM VIP - FIXED SCRIPT MODULE ==========
-- Fixed: GUI and script module now both show properly.
-- Issue was premature return if PlayerGui not ready. Now uses WaitForChild.

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Wait for PlayerGui properly so GUI can be created even if script loads before GUI
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
if not PlayerGui then
    warn("ZIXCAM: PlayerGui not found")
    return
end

local function SafeWait(cond, timeout)
    local start = tick()
    repeat task.wait() until cond() or tick() - start > timeout
end

SafeWait(function() return LocalPlayer and LocalPlayer.Character end, 10)
SafeWait(function() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end, 5)

local Character = LocalPlayer.Character
local Humanoid = Character and Character:FindFirstChild("Humanoid")
local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

if not Character or not Humanoid or not RootPart then 
    warn("ZIXCAM: Character not ready")
    return 
end

-- CONFIG
local Config = {
    Smoothness = 0.08,
    RotationSpeed = 0.15,
    PitchMin = -20,
    PitchMax = 60,
    ZoomMin = 2.5,
    ZoomMax = 10,
    CurrentZoom = 6,
    FOV = 70,
    AspectRatio = 1.777,
    AspectEnabled = false,
    Stiffness = 0.5,
    StiffnessEnabled = false,
    Moonwalk = false,
    MoonwalkSpeed = 1.2,
    AntiAutoParry = false,
    WingsEnabled = false,
    WingsColor = Color3.fromRGB(255, 200, 0),
    HaloEnabled = false,
    HaloColor = Color3.fromRGB(255, 255, 255)
}

local CurrentPitch = 15
local CurrentYaw = 0
local TargetZoom = Config.CurrentZoom
local OriginalWalkSpeed = Humanoid.WalkSpeed
local IsMoonwalking = false
local Wings = nil
local Halo = nil
local WingParticles = {}

-- ========== ANTI AUTO PARRY MODULE ==========
local function AntiAutoParry()
    if not Config.AntiAutoParry then return end
    
    local animator = Humanoid:FindFirstChildOfClass("Animator")
    if not animator then return end
    
    local tracks = animator:GetPlayingAnimationTracks()
    for _, track in pairs(tracks) do
        if track.Name and (string.find(track.Name:lower(), "slash") or string.find(track.Name:lower(), "attack") or string.find(track.Name:lower(), "swing")) then
            local randomSpeed = math.random(70, 150) / 100
            track:AdjustSpeed(randomSpeed)
            
            local randomTime = math.random(-30, 30) / 100
            local currentTime = track.TimePosition
            track:Play(math.clamp(currentTime + randomTime, 0, track.Length))
            
            track.Priority = Enum.AnimationPriority.Core
        end
    end
    
    local animId = Humanoid:FindFirstChild("Animator")
    if animId then
        local fakeId = "rbxassetid://" .. tostring(math.random(100000000, 999999999))
        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
            if track.Animation then
                -- Spoof only ID string, not actual animation data
                track.Animation.AnimationId = fakeId
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if Config.AntiAutoParry then
        AntiAutoParry()
    end
end)

local function HookAttacks()
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") and string.find(obj.Name:lower(), "attack") then
            local oldFire = obj.FireServer
            obj.FireServer = function(self, ...)
                if Config.AntiAutoParry then
                    task.wait(math.random(0, 50) / 1000)
                end
                return oldFire(self, ...)
            end
        end
    end
end

task.spawn(HookAttacks)

-- ========== VISUAL WINGS ==========
local function CreateWings()
    if Wings then
        Wings:Destroy()
        Wings = nil
    end
    if not Config.WingsEnabled then return end
    
    Wings = Instance.new("Model")
    Wings.Name = "ZIXWings"
    Wings.Parent = Character
    
    local colors = {
        Config.WingsColor,
        Color3.fromRGB(Config.WingsColor.R * 0.7, Config.WingsColor.G * 0.7, Config.WingsColor.B * 0.7)
    }
    
    local leftWing = Instance.new("Part")
    leftWing.Size = Vector3.new(6, 0.2, 3)
    leftWing.Position = RootPart.Position + Vector3.new(-2, 1, 0)
    leftWing.Anchored = false
    leftWing.CanCollide = false
    leftWing.Material = Enum.Material.Neon
    leftWing.Color = colors[1]
    leftWing.Transparency = 0.2
    leftWing.Parent = Wings
    
    local leftWeld = Instance.new("Weld")
    leftWeld.Part0 = RootPart
    leftWeld.Part1 = leftWing
    leftWeld.C0 = CFrame.new(-2, 1, 0) * CFrame.Angles(0, 0.3, -0.2)
    leftWeld.Parent = leftWing
    
    local rightWing = Instance.new("Part")
    rightWing.Size = Vector3.new(6, 0.2, 3)
    rightWing.Position = RootPart.Position + Vector3.new(2, 1, 0)
    rightWing.Anchored = false
    rightWing.CanCollide = false
    rightWing.Material = Enum.Material.Neon
    rightWing.Color = colors[1]
    rightWing.Transparency = 0.2
    rightWing.Parent = Wings
    
    local rightWeld = Instance.new("Weld")
    rightWeld.Part0 = RootPart
    rightWeld.Part1 = rightWing
    rightWeld.C0 = CFrame.new(2, 1, 0) * CFrame.Angles(0, -0.3, 0.2)
    rightWeld.Parent = rightWing
    
    for i = 1, 10 do
        local particle = Instance.new("Part")
        particle.Size = Vector3.new(0.5, 0.5, 0.5)
        particle.Shape = Enum.PartType.Ball
        particle.Anchored = false
        particle.CanCollide = false
        particle.Material = Enum.Material.Neon
        particle.Color = colors[2]
        particle.Transparency = 0.4
        particle.Parent = Wings
        
        local attachment = Instance.new("Attachment")
        attachment.Parent = i % 2 == 0 and leftWing or rightWing
        attachment.Position = Vector3.new(i % 2 == 0 and -3 or 3, math.random(-1, 1), math.random(-1, 1))
        
        local align = Instance.new("AlignPosition")
        align.Parent = particle
        align.Attachment0 = attachment
        align.Attachment1 = Instance.new("Attachment")
        align.Attachment1.Parent = particle
        align.RigidityEnabled = false
        
        local ts = TweenService:Create(particle, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
            Transparency = 0.1,
            Size = Vector3.new(0.8, 0.8, 0.8)
        })
        ts:Play()
        
        table.insert(WingParticles, particle)
    end
    
    task.spawn(function()
        while Wings and Wings.Parent do
            local flap = math.sin(tick() * 2) * 0.15
            if leftWing and rightWing then
                leftWing.CFrame = leftWing.CFrame:Lerp(
                    CFrame.Angles(0, 0.3 + flap, -0.2 + flap * 0.5),
                    0.1
                )
                rightWing.CFrame = rightWing.CFrame:Lerp(
                    CFrame.Angles(0, -0.3 - flap, 0.2 - flap * 0.5),
                    0.1
                )
            end
            task.wait(0.05)
        end
    end)
    
    return Wings
end

-- ========== HALO ==========
local function CreateHalo()
    if Halo then
        Halo:Destroy()
        Halo = nil
    end
    if not Config.HaloEnabled then return end
    
    Halo = Instance.new("Part")
    Halo.Name = "ZIXHalo"
    Halo.Size = Vector3.new(2.5, 0.1, 2.5)
    Halo.Position = RootPart.Position + Vector3.new(0, 3.5, 0)
    Halo.Shape = Enum.PartType.Cylinder
    Halo.Anchored = false
    Halo.CanCollide = false
    Halo.Material = Enum.Material.Neon
    Halo.Color = Config.HaloColor
    Halo.Transparency = 0.15
    Halo.Parent = Character
    
    local weld = Instance.new("Weld")
    weld.Part0 = RootPart
    weld.Part1 = Halo
    weld.C0 = CFrame.new(0, 3.5, 0) * CFrame.Angles(0, 0, 0)
    weld.Parent = Halo
    
    local glow = Instance.new("Part")
    glow.Size = Vector3.new(3, 0.05, 3)
    glow.Shape = Enum.PartType.Cylinder
    glow.Anchored = false
    glow.CanCollide = false
    glow.Material = Enum.Material.Neon
    glow.Color = Config.HaloColor
    glow.Transparency = 0.5
    glow.Parent = Halo
    
    local glowWeld = Instance.new("Weld")
    glowWeld.Part0 = Halo
    glowWeld.Part1 = glow
    glowWeld.C0 = CFrame.new(0, 0.1, 0)
    glowWeld.Parent = glow
    
    task.spawn(function()
        while Halo and Halo.Parent do
            Halo.CFrame = Halo.CFrame * CFrame.Angles(0, 0.02, 0)
            task.wait(0.05)
        end
    end)
    
    return Halo
end

-- ========== REALISTIC MOONWALK ==========
local function GetMoveDirection()
    local move = Vector3.new()
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(0,0,-1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move + Vector3.new(0,0,1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(-1,0,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(1,0,0) end
    return move.Magnitude > 0.1 and move.Unit or Vector3.new()
end

-- ========== MAIN LOOP ==========
RunService.Heartbeat:Connect(function()
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
        Camera.ViewportSize = Vector2.new(Workspace.CurrentCamera.ViewportSize.X, Workspace.CurrentCamera.ViewportSize.Y)
    end

    if UserInputService.MouseEnabled then
        local delta = UserInputService:GetMouseDelta()
        CurrentYaw = CurrentYaw - delta.X * Config.RotationSpeed
        CurrentPitch = math.clamp(CurrentPitch - delta.Y * Config.RotationSpeed, Config.PitchMin, Config.PitchMax)
    end

    local y = math.rad(CurrentYaw)
    local p = math.rad(CurrentPitch)
    local dist = Config.CurrentZoom
    local dir = Vector3.new(math.sin(y) * math.cos(p), math.sin(p), math.cos(y) * math.cos(p))
    local desired = RootPart.Position + Vector3.new(0, 4.5, 0) + dir * dist

    local ray = Ray.new(RootPart.Position + Vector3.new(0, 1.5, 0), (desired - RootPart.Position).Unit * dist)
    local hit, pos = Workspace:FindPartOnRay(ray, Character, false, true)
    if hit and pos then
        desired = pos + (RootPart.Position - pos).Unit * 0.3
    end

    if Config.StiffnessEnabled then
        local stiff = Config.Stiffness
        local currentPos = Camera.CFrame.Position
        local targetPos = desired
        local lerpFactor = 1 / (1 + stiff * 10)
        desired = currentPos:Lerp(targetPos, lerpFactor)
    end

    Camera.CFrame = Camera.CFrame:Lerp(
        CFrame.new(desired, RootPart.Position + Vector3.new(0, 1.5, 0)),
        Config.Smoothness
    )

    Humanoid.AutoRotate = false

    if Config.Moonwalk then
        local moveDir = GetMoveDirection()
        local isMoving = moveDir.Magnitude > 0.1
        if isMoving then
            IsMoonwalking = true
            local look = RootPart.CFrame.LookVector
            local forward = Vector3.new(look.X, 0, look.Z).Unit
            local right = RootPart.CFrame.RightVector
            local worldMove = (forward * -moveDir.Z) + (right * moveDir.X)
            Humanoid:MoveTo(RootPart.Position + worldMove * Config.MoonwalkSpeed * 2)
            Humanoid.AutoRotate = false
            local targetCF = CFrame.new(RootPart.Position, RootPart.Position + forward)
            RootPart.CFrame = RootPart.CFrame:Lerp(targetCF, 0.15)
            Humanoid.WalkSpeed = OriginalWalkSpeed * Config.MoonwalkSpeed
        else
            if IsMoonwalking then
                IsMoonwalking = false
                Humanoid.WalkSpeed = OriginalWalkSpeed
                Humanoid.AutoRotate = false
            end
        end
    else
        if IsMoonwalking then
            IsMoonwalking = false
            Humanoid.WalkSpeed = OriginalWalkSpeed
            Humanoid.AutoRotate = false
        end
    end

    if Config.WingsEnabled and not Wings then
        CreateWings()
    elseif not Config.WingsEnabled and Wings then
        Wings:Destroy()
        Wings = nil
    end

    if Config.HaloEnabled and not Halo then
        CreateHalo()
    elseif not Config.HaloEnabled and Halo then
        Halo:Destroy()
        Halo = nil
    end
end)

if UserInputService.MouseEnabled then
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            TargetZoom = math.clamp(TargetZoom - input.Position.Z * 0.5, Config.ZoomMin, Config.ZoomMax)
            Config.CurrentZoom = TargetZoom
        end
    end)
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Escape then
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
    end)
end

-- ========== GUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZIXCAM_GUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 44, 0, 44)
ToggleBtn.Position = UDim2.new(1, -54, 0, 12)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ToggleBtn.BackgroundTransparency = 0.15
ToggleBtn.BorderSizePixel = 2
ToggleBtn.BorderColor3 = Color3.fromRGB(255, 0, 200)
ToggleBtn.Text = "⚙"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 24
ToggleBtn.Font = Enum.Font.Gotham
ToggleBtn.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(1, 0)
BtnCorner.Parent = ToggleBtn

local Panel = Instance.new("Frame")
Panel.Size = UDim2.new(0, 210, 0, 470)
Panel.Position = UDim2.new(1, -225, 0, 65)
Panel.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
Panel.BackgroundTransparency = 0.05
Panel.BorderSizePixel = 2
Panel.BorderColor3 = Color3.fromRGB(255, 0, 200)
Panel.Visible = true
Panel.Parent = ScreenGui

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 10)
PanelCorner.Parent = Panel

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 28)
Title.BackgroundTransparency = 1
Title.Text = "ZIXCAM VIP👑"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Panel

task.spawn(function()
    while Panel and Panel.Parent do
        local hue = tick() % 2 / 2
        local r = math.floor((math.sin(hue * 2 * math.pi) * 0.5 + 0.5) * 255)
        local g = math.floor((math.sin((hue + 0.33) * 2 * math.pi) * 0.5 + 0.5) * 255)
        local b = math.floor((math.sin((hue + 0.66) * 2 * math.pi) * 0.5 + 0.5) * 255)
        Title.TextColor3 = Color3.fromRGB(r, g, b)
        task.wait(0.05)
    end
end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -24, 0, 3)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.TextSize = 14
CloseBtn.Parent = Panel
CloseBtn.MouseButton1Click:Connect(function()
    Panel.Visible = false
end)

local panelVisible = true
ToggleBtn.MouseButton1Click:Connect(function()
    panelVisible = not panelVisible
    Panel.Visible = panelVisible
end)

-- UI HELPERS
local function MakeToggle(text, y, getter, setter)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 24)
    btn.Position = UDim2.new(0.04, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    local state = getter()
    btn.Text = text .. (state and " ON" or " OFF")
    btn.TextColor3 = state and Color3.fromRGB(0, 255, 200) or Color3.fromRGB(170, 170, 190)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Panel
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = btn
    btn.MouseButton1Click:Connect(function()
        local new = not getter()
        setter(new)
        btn.Text = text .. (new and " ON" or " OFF")
        btn.TextColor3 = new and Color3.fromRGB(0, 255, 200) or Color3.fromRGB(170, 170, 190)
        btn.BackgroundColor3 = new and Color3.fromRGB(20, 50, 60) or Color3.fromRGB(20, 20, 40)
    end)
    return btn
end

local function MakeSlider(text, y, min, max, default, getter, setter)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.92, 0, 0, 30)
    frame.Position = UDim2.new(0.04, 0, 0, y)
    frame.BackgroundTransparency = 1
    frame.Parent = Panel

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 14)
    label.BackgroundTransparency = 1
    label.Text = text .. " " .. string.format("%.1f", default)
    label.TextColor3 = Color3.fromRGB(200, 200, 230)
    label.Font = Enum.Font.Gotham
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0.38, 0, 0, 4)
    track.Position = UDim2.new(0.58, 0, 0.5, -2)
    track.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    track.BorderSizePixel = 0
    track.Parent = frame
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 2)
    tc.Parent = track

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 0, 200)
    fill.BorderSizePixel = 0
    fill.Parent = track

    local handle = Instance.new("TextButton")
    handle.Size = UDim2.new(0, 10, 0, 10)
    handle.Position = UDim2.new((default - min) / (max - min), -5, 0.5, -5)
    handle.BackgroundColor3 = Color3.fromRGB(255, 0, 200)
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
            local val = min + (max - min) * rel
            val = math.floor(val * 10) / 10
            setter(val)
            label.Text = text .. " " .. string.format("%.1f", val)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            handle.Position = UDim2.new(rel, -5, 0.5, -5)
        end
    end)
    return frame
end

-- ========== GUI CONTENT ==========
MakeToggle("Anti Auto Parry", 30, function() return Config.AntiAutoParry end, function(v) Config.AntiAutoParry = v end)
MakeToggle("Wings", 58, function() return Config.WingsEnabled end, function(v) Config.WingsEnabled = v; if v then CreateWings() else if Wings then Wings:Destroy(); Wings = nil end end end)
MakeToggle("Halo", 86, function() return Config.HaloEnabled end, function(v) Config.HaloEnabled = v; if v then CreateHalo() else if Halo then Halo:Destroy(); Halo = nil end end end)
MakeToggle("Moonwalk", 114, function() return Config.Moonwalk end, function(v) Config.Moonwalk = v end)
MakeToggle("Stiffness", 142, function() return Config.StiffnessEnabled end, function(v) Config.StiffnessEnabled = v end)
MakeToggle("Aspect Ratio", 170, function() return Config.AspectEnabled en
