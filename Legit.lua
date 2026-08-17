-- ZIX LEGIT v1.0 (100% stable, no freeze, no camera lock, no character lock)
local camera = {}
local movement = {}

function camera.new(camSettings)
    local settings = camSettings or {
        Stiffness = 0.15,
        FOV = 70,
        Resolution = Vector2.new(1920, 1080),
        FlatMode = true
    }
    
    local player = game.Players.LocalPlayer
    local lastUpdate = 0
    local updateInterval = 0.03 -- 30 FPS camera update, no freeze
    
    local function apply()
        local now = tick()
        if now - lastUpdate < updateInterval then
            return
        end
        lastUpdate = now
        
        local character = player.Character
        if not character then
            return
        end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local head = character:FindFirstChild("Head")
        local cam = workspace.CurrentCamera
        
        if not humanoid or not head or not cam then
            return
        end
        
        pcall(function()
            cam.FieldOfView = settings.FOV
        end)
        
        pcall(function()
            humanoid.CameraMaxZoomDistance = 15
            humanoid.CameraMinZoomDistance = 5
        end)
        
        if settings.FlatMode then
            pcall(function()
                local targetCF = CFrame.new(cam.CFrame.Position, head.Position) * CFrame.new(0, 0, 8)
                cam.CFrame = cam.CFrame:Lerp(targetCF, math.clamp(settings.Stiffness, 0.01, 1))
            end)
        end
    end
    
    game:GetService("RunService").RenderStepped:Connect(apply)
    return settings
end

function movement.moonwalk(character, settings)
    local ms = settings or {
        Enabled = false,
        Speed = 8,
        Smoothness = 0.3,
        RealisticMode = true
    }
    
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local lastUpdate = 0
    local updateInterval = 0.03 -- 30 FPS movement update, no freeze
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if not ms.Enabled then
            return
        end
        
        local now = tick()
        if now - lastUpdate < updateInterval then
            return
        end
        lastUpdate = now
        
        if not character or not character.Parent then
            return
        end
        
        if not humanoid or not humanoid.Parent then
            return
        end
        
        if not rootPart or not rootPart.Parent then
            return
        end
        
        local moveDirection = humanoid.MoveDirection
        if moveDirection.Magnitude == 0 then
            return
        end
        
        pcall(function()
            local lookVector = rootPart.CFrame.LookVector
            local moonwalkDir = Vector3.new(-lookVector.X, 0, -lookVector.Z)
            local blendedDir = moveDirection:Lerp(moonwalkDir, ms.Smoothness)
            humanoid:Move(blendedDir * ms.Speed, false)
        end)
    end)
    
    return ms
end

-- Safe GUI container for Delta
local function getGuiContainer()
    local success, result = pcall(function()
        return gethui()
    end)
    if success and result then
        return result
    end
    
    success, result = pcall(function()
        return game.CoreGui
    end)
    if success and result then
        return result
    end
    
    success, result = pcall(function()
        return game.Players.LocalPlayer.PlayerGui
    end)
    if success and result then
        return result
    end
    
    return nil
end

local guiParent = getGuiContainer()
if not guiParent then
    return
end

-- Create GUI
local SG = Instance.new("ScreenGui", guiParent)
SG.Name = "ZixLegitGUI"
SG.ResetOnSpawn = false

local MF = Instance.new("Frame", SG)
MF.Size = UDim2.new(0, 250, 0, 30)
MF.Position = UDim2.new(0.5, -125, 0, 10)
MF.Active = true
MF.Draggable = true
MF.BackgroundColor3 = Color3.fromRGB(20,20,20)
MF.BorderSizePixel = 0

local TB = Instance.new("TextButton", MF)
TB.Size = UDim2.new(1, 0, 1, 0)
TB.Text = "ZIX LEGIT [ON]"
TB.BackgroundColor3 = Color3.fromRGB(35,35,35)
TB.BorderSizePixel = 0
TB.TextColor3 = Color3.fromRGB(255,255,255)
TB.Font = Enum.Font.Code
TB.TextSize = 14

local SF = Instance.new("Frame", MF)
SF.Size = UDim2.new(0, 250, 0, 200)
SF.Position = UDim2.new(0, 0, 0, 35)
SF.BackgroundColor3 = Color3.fromRGB(25,25,25)
SF.BorderSizePixel = 0
SF.Visible = true

local vis = true
TB.MouseButton1Click:Connect(function()
    vis = not vis
    SF.Visible = vis
    TB.Text = vis and "ZIX LEGIT [ON]" or "ZIX LEGIT [OFF]"
end)

-- Camera settings
local CS = camera.new({
    Stiffness = 0.15,
    FOV = 70,
    Resolution = Vector2.new(1920, 1080),
    FlatMode = true
})

local function CSL(name, min, max, def, cb, pos)
    local L = Instance.new("TextLabel", SF)
    L.Size = UDim2.new(1, -10, 0, 20)
    L.Position = UDim2.new(0, 5, 0, pos)
    L.BackgroundTransparency = 1
    L.Text = name .. ": " .. tostring(def)
    L.TextColor3 = Color3.fromRGB(255,255,255)
    L.Font = Enum.Font.Code
    L.TextSize = 12
    
    local S = Instance.new("TextBox", SF)
    S.Size = UDim2.new(1, -10, 0, 25)
    S.Position = UDim2.new(0, 5, 0, pos+20)
    S.BackgroundColor3 = Color3.fromRGB(45,45,45)
    S.BorderSizePixel = 0
    S.Text = tostring(def)
    S.TextColor3 = Color3.fromRGB(255,255,255)
    S.Font = Enum.Font.Code
    S.TextSize = 12
    
    S.FocusLost:Connect(function()
        local v = math.clamp(tonumber(S.Text) or def, min, max)
        S.Text = tostring(v)
        cb(v)
        L.Text = name .. ": " .. tostring(v)
    end)
end

local MS = {
    Enabled = false,
    Speed = 8,
    Smoothness = 0.3,
    RealisticMode = true
}

local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(function(char)
    movement.moonwalk(char, MS)
end)
if player.Character then
    movement.moonwalk(player.Character, MS)
end

local MT = Instance.new("TextButton", SF)
MT.Size = UDim2.new(1, -10, 0, 30)
MT.Position = UDim2.new(0, 5, 0, 60)
MT.BackgroundColor3 = Color3.fromRGB(45,45,45)
MT.BorderSizePixel = 0
MT.Text = "Moonwalk: OFF"
MT.TextColor3 = Color3.fromRGB(255,255,255)
MT.Font = Enum.Font.Code
MT.TextSize = 12

local MWGui = Instance.new("Frame", SG)
MWGui.Size = UDim2.new(0, 150, 0, 40)
MWGui.Position = UDim2.new(0, 10, 0, 50)
MWGui.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
MWGui.BorderSizePixel = 0
MWGui.Visible = false
MWGui.Active = true
MWGui.Draggable = true

local MWLabel = Instance.new("TextLabel", MWGui)
MWLabel.Size = UDim2.new(1, 0, 1, 0)
MWLabel.BackgroundTransparency = 1
MWLabel.Text = "moonwalk"
MWLabel.TextColor3 = Color3.fromRGB(255,255,255)
MWLabel.Font = Enum.Font.Code
MWLabel.TextSize = 24
MWLabel.TextStrokeTransparency = 0

MT.MouseButton1Click:Connect(function()
    MS.Enabled = not MS.Enabled
    MT.Text = "Moonwalk: " .. (MS.Enabled and "ON" or "OFF")
    MT.BackgroundColor3 = MS.Enabled and Color3.fromRGB(0,80,0) or Color3.fromRGB(45,45,45)
    MWGui.Visible = MS.Enabled
end)

CSL("Stiffness", 0.01, 200, CS.Stiffness, function(v) CS.Stiffness = math.clamp(v, 0.01, 1) end, 100)
CSL("FOV", 30, 200, CS.FOV, function(v) CS.FOV = v end, 145)

-- Safe optimization for Delta
pcall(function()
    UserSettings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

pcall(function()
    game:GetService("Lighting").GlobalShadows = false
end)

print("ZIX LEGIT loaded - 100% stable")
