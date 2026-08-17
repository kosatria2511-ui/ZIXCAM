-- LocalScript named "ZIX👑"
-- Place inside StarterPlayerScripts or StarterGui

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
frame.Size = UDim2.new(0, 280, 0, 140)
frame.Position = UDim2.new(0.5, -140, 0.1, -200)
frame.BorderSizePixel = 3
frame.BackgroundTransparency = 0.2
frame.Parent = screenGui

local welcomeText = Instance.new("TextLabel")
welcomeText.Size = UDim2.new(1, 0, 0.3, 0)
welcomeText.Position = UDim2.new(0, 0, 0, 10)
welcomeText.Text = "Welcome to ZIX VIP!"
welcomeText.TextScaled = true
welcomeText.Font = Enum.Font.GothamBold
welcomeText.TextColor3 = Color3.new(1,1,1)
welcomeText.BackgroundTransparency = 1
welcomeText.Parent = frame

-- 🔧 Customizable Button Settings
local buttonSize = 30
local buttonStyle = "Rainbow" -- options: "LiquidGlass", "Rainbow"
local buttonShape = "Round"

-- 🖼️ Toggle Button with ZIX👑 Premium Image
local toggleButton = Instance.new("ImageButton")
toggleButton.Size = UDim2.new(0, buttonSize, 0, buttonSize)
toggleButton.Position = UDim2.new(1, -(buttonSize+10), 1, -(buttonSize+10))
toggleButton.Image = "rbxassetid://87364137514855"
toggleButton.BackgroundTransparency = 0.3
toggleButton.Parent = frame

-- Shape logic
if buttonShape == "Round" then
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1,0)
	corner.Parent = toggleButton
end

-- Intro Animation
local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
TweenService:Create(frame, tweenInfo, {Position = UDim2.new(0.5, -140, 0.1, 0)}):Play()

-- Theme Manager
local themes = {
	["Rainbow"] = function(hue) return Color3.fromHSV(hue, 1, 1) end,
	["LiquidGlass"] = function(hue) return Color3.fromHSV(hue, 0.2, 1) end
}
local hue = 0

RunService.RenderStepped:Connect(function(dt)
	hue = (hue + dt * 0.25) % 1
	local color = themes[buttonStyle](hue)
	toggleButton.ImageColor3 = color
	toggleButton.BorderColor3 = color
end)

-- Toggle GUI
local guiEnabled = true
toggleButton.MouseButton1Click:Connect(function()
	guiEnabled = not guiEnabled
	if guiEnabled then
		frame.Visible = true
		TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 0.2}):Play()
	else
		TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
		wait(0.5)
		frame.Visible = false
	end
end)

-- ✨ Shimmer Loop (Liquid Glass Glow)
local function shimmer()
	while true do
		local tweenIn = TweenService:Create(toggleButton, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {ImageTransparency = 0.2})
		local tweenOut = TweenService:Create(toggleButton, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
		tweenIn:Play()
		tweenIn.Completed:Wait()
		tweenOut:Play()
		tweenOut.Completed:Wait()
	end
end
task.spawn(shimmer)

-- ✨ Auto Generator Effect (DBD-style rhythm)
local function autoGenerator()
	while true do
		local tweenIn = TweenService:Create(toggleButton, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			ImageTransparency = 0.15,
			ImageColor3 = Color3.fromRGB(255, 255, 255)
		})
		tweenIn:Play()
		tweenIn.Completed:Wait()

		local tweenOut = TweenService:Create(toggleButton, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
			ImageTransparency = 0.3,
			ImageColor3 = Color3.fromRGB(200, 200, 255)
		})
		tweenOut:Play()
		tweenOut.Completed:Wait()

		wait(0.2) -- perfect rhythm delay
	end
end
task.spawn(autoGenerator)

-- 🌞 Fullbright + No Fog Toggles
local fullbrightEnabled = false
local noFogEnabled = false

local fullbrightBtn = Instance.new("TextButton")
fullbrightBtn.Size = UDim2.new(0, 100, 0, 30)
fullbrightBtn.Position = UDim2.new(0, 10, 1, -40)
fullbrightBtn.Text = "Fullbright: OFF"
fullbrightBtn.Font = Enum.Font.GothamBold
fullbrightBtn.TextScaled = true
fullbrightBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
fullbrightBtn.TextColor3 = Color3.new(1,1,1)
fullbrightBtn.Parent = frame

local fogBtn = Instance.new("TextButton")
fogBtn.Size = UDim2.new(0, 100, 0, 30)
fogBtn.Position = UDim2.new(0, 120, 1, -40)
fogBtn.Text = "No Fog: OFF"
fogBtn.Font = Enum.Font.GothamBold
fogBtn.TextScaled = true
fogBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
fogBtn.TextColor3 = Color3.new(1,1,1)
fogBtn.Parent = frame

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

-- Camera Settings
camera.FieldOfView = 80
camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	local aspectRatio = camera.ViewportSize.X / camera.ViewportSize.Y
	if aspectRatio > 1.7 then
		camera.FieldOfView = 85
	else
		camera.FieldOfView = 75
	end
end)

local targetCFrame
RunService.RenderStepped:Connect(function(dt)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local root = player.Character.HumanoidRootPart
		targetCFrame = CFrame.new(root.Position - root.CFrame.LookVector * 10 + Vector3.new(0,5,0), root.Position)
		camera.CFrame = camera.CFrame:Lerp(targetCFrame, 0.1)
	end
end)
