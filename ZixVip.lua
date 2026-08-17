-- ZIX VIP👑 - Violence District Premium Script
-- Версия: VIP 5.0.0
-- Добавлено: Camera Stiffness, Aspect Ratio Slider, GUI Logo (rbxassetid://87364137514855)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

-- ZIX VIP Конфигурация
local ZIXConfig = {
    SilentAim = {
        Enabled = false,
        FOV = 180,
        Prediction = 0.2,
        HitPart = "Head",
        VisibleCheck = false,
        TeamCheck = false,
        HitChance = 100,
        AutoPrediction = true,
        VeilSilentAim = false,
        TwistOfFateSilentAim = false,
        VeilStrength = 0.8,
        TwistIntensity = 0.5,
        TwistAngle = 15
    },
    Aimbot = {
        Enabled = false,
        FOV = 150,
        Smoothness = 3,
        Prediction = 0.15,
        VisibleCheck = false,
        TargetBone = "Head",
        AutoShoot = false,
        Stiffness = 0.5,
        StiffnessEnabled = true
    },
    CameraSettings = {
        Stiffness = 0.5,
        StiffnessEnabled = false,
        CameraStiffnessX = 0.5,
        CameraStiffnessY = 0.5,
        CameraStiffnessZ = 0.5
    },
    ESP = {
        Enabled = false,
        Boxes = true,
        Names = true,
        Distance = true,
        Health = true,
        Tracers = true,
        TeamCheck = false,
        Skeleton = false,
        Chams = false,
        HealthBar = true,
        Weapon = true,
        Rank = true
    },
    Triggerbot = {
        Enabled = false,
        Delay = 0.03,
        UseKeybind = false,
        Keybind = Enum.KeyCode.E,
        SmartTrigger = true
    },
    Visuals = {
        FOVChanger = 70,
        CustomCrosshair = false,
        CrosshairSize = 20,
        CrosshairColor = Color3.fromRGB(255, 0, 0),
        HitMarker = true,
        HitMarkerSound = true,
        KillEffect = true,
        AspectRatio = 1.7777777777777777,
        AspectRatioEnabled = false,
        AspectRatioX = 16,
        AspectRatioY = 9
    },
    Misc = {
        Speed = 16,
        JumpPower = 50,
        FlyEnabled = false,
        FlySpeed = 100,
        NoClip = false,
        AntiAFK = true,
        FullBright = false,
        ThirdPerson = false,
        Spinbot = false,
        SpinSpeed = 10,
        InfiniteJump = false,
        AutoRespawn = false,
        GodMode = false,
        TeleportToEnemy = false,
        CharacterStiffness = 0,
        StiffnessEnabled = false
    },
    Weapon = {
        NoRecoil = false,
        NoSpread = false,
        RapidFire = false,
        FireRate = 0.01,
        InfiniteAmmo = false,
        NoReload = false,
        BulletSpeed = 1000,
        DamageMultiplier = 1
    },
    GUI = {
        LogoVisible = true,
        LogoSize = 50,
        LogoTransparency = 0,
        LogoPosition = UDim2.new(0.5, -25, 0, 10),
        Reappear = false,
        ReappearDelay = 2
    }
}

-- ZIX VIP GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZIXVIP"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Логотип GUI
local LogoFrame = Instance.new("Frame")
LogoFrame.Name = "ZIXLogo"
LogoFrame.Size = UDim2.new(0, ZIXConfig.GUI.LogoSize, 0, ZIXConfig.GUI.LogoSize)
LogoFrame.Position = ZIXConfig.GUI.LogoPosition
LogoFrame.BackgroundTransparency = ZIXConfig.GUI.LogoTransparency
LogoFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LogoFrame.BorderSizePixel = 0
LogoFrame.Parent = ScreenGui

local LogoImage = Instance.new("ImageLabel")
LogoImage.Name = "LogoImage"
LogoImage.Size = UDim2.new(1, 0, 1, 0)
LogoImage.Position = UDim2.new(0, 0, 0, 0)
LogoImage.BackgroundTransparency = 1
LogoImage.Image = "rbxassetid://87364137514855"
LogoImage.Parent = LogoFrame

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 10)
LogoCorner.Parent = LogoFrame

-- Функция появления/исчезновения логотипа
local function ToggleLogo()
    if ZIXConfig.GUI.LogoVisible then
        LogoFrame.Visible = true
        if ZIXConfig.GUI.Reappear then
            task.spawn(function()
                wait(ZIXConfig.GUI.ReappearDelay)
                LogoFrame.Visible = false
                wait(0.5)
                LogoFrame.Visible = true
            end)
        end
    else
        LogoFrame.Visible = false
    end
end

-- Анимация логотипа
local function AnimateLogo()
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {Rotation = 360}
    local tween = TweenService:Create(LogoFrame, tweenInfo, goal)
    tween:Play()
end

-- Главный фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Name = "ZIXMainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 500)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Градиентная рамка
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 100))
})
Gradient.Rotation = 45
Gradient.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

-- Заголовок с логотипом
local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TitleBar.Text = "👑 ZIX VIP - VIOLENCE DISTRICT v5.0 👑"
TitleBar.TextColor3 = Color3.fromRGB(255, 200, 0)
TitleBar.Font = Enum.Font.SourceSansBold
TitleBar.TextSize = 22
TitleBar.Parent = MainFrame

-- Логотип в заголовке
local TitleLogo = Instance.new("ImageLabel")
TitleLogo.Name = "TitleLogo"
TitleLogo.Size = UDim2.new(0, 30, 0, 30)
TitleLogo.Position = UDim2.new(0, 5, 0, 7)
TitleLogo.BackgroundTransparency = 1
TitleLogo.Image = "rbxassetid://87364137514855"
TitleLogo.Parent = TitleBar

-- Перетаскивание
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Вкладки
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(0, 130, 1, -45)
TabFrame.Position = UDim2.new(0, 0, 0, 45)
TabFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
TabFrame.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -130, 1, -45)
ContentFrame.Position = UDim2.new(0, 130, 0, 45)
ContentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ContentFrame.Parent = MainFrame

-- Функция создания кнопок вкладок
local function CreateTabButton(name, position, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.Position = UDim2.new(0, 0, 0, position)
    Button.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 14
    Button.Parent = TabFrame
    
    Button.MouseButton1Click:Connect(function()
        for _, child in ipairs(ContentFrame:GetChildren()) do
            child:Destroy()
        end
        callback()
    end)
    
    return Button
end

-- Функция создания переключателей
local function CreateToggle(name, position, callback, defaultState)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0.9, 0, 0, 30)
    Toggle.Position = UDim2.new(0.05, 0, 0, position)
    Toggle.BackgroundColor3 = defaultState and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50, 50, 60)
    Toggle.Text = name .. (defaultState and ": ON" or ": OFF")
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.Font = Enum.Font.SourceSans
    Toggle.TextSize = 13
    Toggle.Parent = ContentFrame
    
    Toggle.MouseButton1Click:Connect(function()
        local enabled = Toggle.Text:find("OFF") ~= nil
        if enabled then
            Toggle.Text = name .. ": ON"
            Toggle.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        else
            Toggle.Text = name .. ": OFF"
            Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        end
        callback(enabled)
    end)
    
    return Toggle
end

-- Функция создания слайдеров
local function CreateSlider(name, position, min, max, default, callback)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.9, 0, 0, 20)
    Label.Position = UDim2.new(0.05, 0, 0, position)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(255, 200, 0)
    Label.Font = Enum.Font.SourceSansBold
    Label.TextSize = 13
    Label.Parent = ContentFrame
    
    local Slider = Instance.new("TextButton")
    Slider.Size = UDim2.new(0.9, 0, 0, 8)
    Slider.Position = UDim2.new(0.05, 0, 0, position + 20)
    Slider.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
    Slider.Text = ""
    Slider.Parent = ContentFrame
    
    Slider.MouseButton1Down:Connect(function()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                local mouse = LocalPlayer:GetMouse()
                local relativeX = math.clamp((mouse.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
                local value = min + (max - min) * relativeX
                value = math.floor(value * 100) / 100
                Label.Text = name .. ": " .. value
                callback(value)
            else
                connection:Disconnect()
            end
        end)
    end)
    
    return Label, Slider
end

-- Система Camera Stiffness
local CameraStiffnessConnection = nil

local function StartCameraStiffness()
    if CameraStiffnessConnection then
        CameraStiffnessConnection:Disconnect()
    end
    
    CameraStiffnessConnection = RunService.RenderStepped:Connect(function()
        if ZIXConfig.CameraSettings.StiffnessEnabled then
            local stiffness = ZIXConfig.CameraSettings.Stiffness
            local character = LocalPlayer.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            
            if rootPart then
                -- Применяем stiffness к камере
                local targetCFrame = CFrame.new(rootPart.Position + Vector3.new(0, 3, 0))
                local currentCFrame = Camera.CFrame
                
                -- Применяем stiffness по осям
                local stiffX = ZIXConfig.CameraSettings.CameraStiffnessX
                local stiffY = ZIXConfig.CameraSettings.CameraStiffnessY
                local stiffZ = ZIXConfig.CameraSettings.CameraStiffnessZ
                
                local lerpFactor = 1 / (1 + stiffness)
                
                -- Интерполяция с stiffness
                local newPosition = Vector3.new(
                    currentCFrame.Position.X + (targetCFrame.Position.X - currentCFrame.Position.X) * lerpFactor * stiffX,
                    currentCFrame.Position.Y + (targetCFrame.Position.Y - currentCFrame.Position.Y) * lerpFactor * stiffY,
                    currentCFrame.Position.Z + (targetCFrame.Position.Z - currentCFrame.Position.Z) * lerpFactor * stiffZ
                )
                
                local newCFrame = CFrame.new(newPosition, currentCFrame.Position + Camera.CFrame.LookVector * 10)
                Camera.CFrame = newCFrame
            end
        end
    end)
end

-- Система Silent Aim
local function GetClosestPlayer(fov, hitPart)
    local closest = nil
    local shortestDistance = fov or ZIXConfig.SilentAim.FOV
    
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if not ZIXConfig.SilentAim.TeamCheck or player.Team ~= LocalPlayer.Team then
                local targetPart = player.Character:FindFirstChild(hitPart or ZIXConfig.SilentAim.HitPart) or player.Character:FindFirstChild("Head")
                if targetPart then
                    local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            closest = player
                        end
                    end
                end
            end
        end
    end
    
    return closest
end

-- Veil Silent Aim функция
local function GetVeilSilentAimTarget()
    local target = GetClosestPlayer()
    if not target or not target.Character then return nil end
    
    local head = target.Character:FindFirstChild("Head")
    if not head then return nil end
    
    local veilStrength = ZIXConfig.SilentAim.VeilStrength
    local randomOffset = Vector3.new(
        math.random(-100, 100) * veilStrength,
        math.random(-50, 50) * veilStrength,
        math.random(-100, 100) * veilStrength
    ) / 100
    
    return head.Position + randomOffset
end

-- Twist of Fate Silent Aim функция
local function GetTwistOfFateTarget()
    local target = GetClosestPlayer()
    if not target or not target.Character then return nil end
    
    local head = target.Character:FindFirstChild("Head")
    local rootPart = target.Character:FindFirstChild("HumanoidRootPart")
    if not head or not rootPart then return nil end
    
    local twistAngle = math.rad(ZIXConfig.SilentAim.TwistAngle)
    local twistIntensity = ZIXConfig.SilentAim.TwistIntensity
    
    local velocity = rootPart.Velocity
    local predictedPos = head.Position + velocity * ZIXConfig.SilentAim.Prediction
    
    local direction = (predictedPos - Camera.CFrame.Position).Unit
    local rotatedDirection = CFrame.Angles(0, twistAngle * twistIntensity, 0) * direction
    
    return Camera.CFrame.Position + rotatedDirection * 100
end

-- Silent Aim Hook
local oldIndex = nil
oldIndex = hookmetamethod(game, "__index", function(self, key)
    if ZIXConfig.SilentAim.Enabled and key == "CFrame" and self == Camera then
        local targetPos = nil
        
        if ZIXConfig.SilentAim.VeilSilentAim then
            targetPos = GetVeilSilentAimTarget()
        elseif ZIXConfig.SilentAim.TwistOfFateSilentAim then
            targetPos = GetTwistOfFateTarget()
        else
            local target = GetClosestPlayer()
            if target and target.Character then
                local targetPart = target.Character:FindFirstChild(ZIXConfig.SilentAim.HitPart) or target.Character:FindFirstChild("Head")
                local rootPart = target.Character:FindFirstChild("HumanoidRootPart")
                if targetPart and rootPart then
                    local velocity = rootPart.Velocity
                    local prediction = ZIXConfig.SilentAim.AutoPrediction and (velocity.Magnitude * 0.001) or ZIXConfig.SilentAim.Prediction
                    targetPos = targetPart.Position + velocity * prediction
                end
            end
        end
        
        if targetPos then
            return CFrame.new(Camera.CFrame.Position, targetPos)
        end
    end
    return oldIndex(self, key)
end)

-- Stiffness система для персонажа
local function ApplyCharacterStiffness()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if ZIXConfig.Misc.StiffnessEnabled then
        humanoid.HipHeight = 0 + ZIXConfig.Misc.CharacterStiffness
        humanoid.WalkSpeed = ZIXConfig.Misc.Speed
        humanoid.JumpPower = ZIXConfig.Misc.JumpPower
        
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                track:AdjustSpeed(1 - ZIXConfig.Misc.CharacterStiffness)
            end
        end
    else
        humanoid.HipHeight = 0
    end
end

-- Aimbot с Stiffness
local AimbotConnection = nil

local function StartAimbot()
    if AimbotConnection then
        AimbotConnection:Disconnect()
    end
    
    AimbotConnection = RunService.RenderStepped:Connect(function()
        if ZIXConfig.Aimbot.Enabled then
            local target = GetClosestPlayer(ZIXConfig.Aimbot.FOV, ZIXConfig.Aimbot.TargetBone)
            if target and target.Character and target.Character:FindFirstChild("Head") then
                local head = target.Character:FindFirstChild(ZIXConfig.Aimbot.TargetBone) or target.Character.Head
                local rootPart = target.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local velocity = rootPart.Velocity
                    local predictedPos = head.Position + velocity * ZIXConfig.Aimbot.Prediction
                    local targetCFrame = CFrame.new(Camera.CFrame.Position, predictedPos)
                    
                    local smoothness = ZIXConfig.Aimbot.Smoothness
                    if ZIXConfig.Aimbot.StiffnessEnabled then
                        smoothness = smoothness / (1 + ZIXConfig.Aimbot.Stiffness)
                    end
                    
                    Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 / smoothness)
                    
                    if ZIXConfig.Aimbot.AutoShoot then
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, nil, 0)
                        wait(0.01)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, nil, 0)
                    end
                end
            end
        end
    end)
end

-- Aspect Ratio система
local function ApplyAspectRatio()
    if ZIXConfig.Visuals.AspectRatioEnabled then
        local aspectRatio = ZIXConfig.Visuals.AspectRatio
        local viewportSize = Camera.ViewportSize
        
        local newWidth = viewportSize.X
        local newHeight = math.floor(viewportSize.X / aspectRatio)
        
        if newHeight > viewportSize.Y then
            newHeight = viewportSize.Y
            newWidth = math.floor(viewportSize.Y * aspectRatio)
        end
        
        Camera.ViewportSize = Vector2.new(newWidth, newHeight)
    else
        Camera.ViewportSize = Vector2.new(workspace.CurrentCamera.ViewportSize.X, workspace.CurrentCamera.ViewportSize.Y)
    end
end

-- Обновление Aspect Ratio
RunService.RenderStepped:Connect(function()
    if ZIXConfig.Visuals.AspectRatioEnabled then
    
