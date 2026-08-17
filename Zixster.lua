-- ZIXCAM VIP FINAL
local Players=game:GetService("Players")
local LocalPlayer=Players.LocalPlayer
local Camera=workspace.CurrentCamera
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local Workspace=game:GetService("Workspace")

local PlayerGui=LocalPlayer:WaitForChild("PlayerGui",15)
if not PlayerGui then return end

local function WaitChar(t)
 local s=tick()
 repeat task.wait()until(LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))or tick()-s>t
 return LocalPlayer.Character
end

local Character=WaitChar(15)
local Humanoid=Character and Character:FindFirstChild("Humanoid")
local RootPart=Character and Character:FindFirstChild("HumanoidRootPart")

local Config={Smoothness=0.08,RotationSpeed=0.15,PitchMin=-20,PitchMax=60,CurrentZoom=6,FOV=70,Moonwalk=false,AntiAutoParry=false,WingsEnabled=false,HaloEnabled=false,EspEnabled=false}

local CurrentYaw=0
local CurrentPitch=15

local function Galaxy(parent)
 local g=Instance.new("Frame")
 g.Size=UDim2.new(1,0,1,0)
 g.BackgroundColor3=Color3.fromRGB(5,0,20)
 g.Parent=parent
 for i=1,60 do
  local s=Instance.new("Frame")
  s.Size=UDim2.new(0,math.random(1,3),0,math.random(1,3))
  s.Position=UDim2.new(math.random(),0,math.random(),0)
  s.BackgroundColor3=Color3.fromRGB(255,255,255)
  s.BackgroundTransparency=math.random(0,50)/100
  s.BorderSizePixel=0
  s.Parent=g
  local c=Instance.new("UICorner")
  c.CornerRadius=UDim.new(1,0)
  c.Parent=s
 end
 return g
end

RunService.Heartbeat:Connect(function()
 if not RootPart or not Humanoid or not RootPart.Parent then return end
 Camera.FieldOfView=Config.FOV
 if UserInputService.MouseEnabled then
  local delta=UserInputService:GetMouseDelta()
  CurrentYaw=CurrentYaw-delta.X*Config.RotationSpeed
  CurrentPitch=math.clamp(CurrentPitch-delta.Y*Config.RotationSpeed,Config.PitchMin,Config.PitchMax)
 end
 local y=math.rad(CurrentYaw)
 local p=math.rad(CurrentPitch)
 local dist=Config.CurrentZoom
 local dir=Vector3.new(math.sin(y)*math.cos(p),math.sin(p),math.cos(y)*math.cos(p))
 local desired=RootPart.Position+Vector3.new(0,4.5,0)+dir*dist
 Camera.CFrame=Camera.CFrame:Lerp(CFrame.new(desired,RootPart.Position+Vector3.new(0,1.5,0)),Config.Smoothness)
 Humanoid.AutoRotate=false
end)

function ShowMain()
 local SG=Instance.new("ScreenGui")
 SG.Parent=PlayerGui
 SG.ResetOnSpawn=false
 Galaxy(SG)

 local Main=Instance.new("Frame")
 Main.Size=UDim2.new(0,350,0,480)
 Main.Position=UDim2.new(0.5,-175,0.5,-240)
 Main.BackgroundColor3=Color3.fromRGB(8,8,25)
 Main.BackgroundTransparency=0.1
 Main.Parent=SG
 local Corner=Instance.new("UICorner")
 Corner.CornerRadius=UDim.new(0,15)
 Corner.Parent=Main

 local Icon=Instance.new("Frame")
 Icon.Size=UDim2.new(0,80,0,80)
 Icon.Position=UDim2.new(0.5,-40,0,-40)
 Icon.BackgroundColor3=Color3.fromRGB(20,20,40)
 Icon.BorderSizePixel=3
 Icon.Parent=Main
 local IconCorner=Instance.new("UICorner")
 IconCorner.CornerRadius=UDim.new(1,0)
 IconCorner.Parent=Icon
 task.spawn(function()
  while Icon and Icon.Parent do
   Icon.BorderColor3=Color3.fromHSV(tick()%3/3,1,1)
   task.wait(0.1)
  end
 end)
 local IconLabel=Instance.new("TextLabel")
 IconLabel.Size=UDim2.new(1,0,1,0)
 IconLabel.BackgroundTransparency=1
 IconLabel.Text="ZIX👑"
 IconLabel.Font=Enum.Font.GothamBlack
 IconLabel.TextSize=28
 IconLabel.Parent=Icon

 local MainTitle=Instance.new("TextLabel")
 MainTitle.Size=UDim2.new(1,0,0,35)
 MainTitle.Position=UDim2.new(0,0,0.08,0)
 MainTitle.BackgroundTransparency=1
 MainTitle.Text="ZIXCAM VIP"
 MainTitle.Font=Enum.Font.GothamBold
 MainTitle.TextSize=20
 MainTitle.Parent=Main

 local Close=Instance.new("TextButton")
 Close.Size=UDim2.new(0,24,0,24)
 Close.Position=UDim2.new(1,-28,0,5)
 Close.BackgroundTransparency=1
 Close.Text="X"
 Close.TextColor3=Color3.fromRGB(255,80,80)
 Close.Parent=Main
 Close.MouseButton1Click:Connect(function() SG:Destroy() end)

 local tabs={"Movement","Visual","ESP","Camera"}
 local currentTab=nil

 local function CreateTab(name,y)
  local btn=Instance.new("TextButton")
  btn.Size=UDim2.new(0.22,0,0,30)
  btn.Position=UDim2.new(0.02+(#tabs-1)*0.24,0,y,0)
  btn.BackgroundColor3=Color3.fromRGB(20,20,40)
  btn.Text=name
  btn.TextColor3=Color3.fromRGB(200,200,230)
  btn.Font=Enum.Font.GothamBold
  btn.TextSize=12
  btn.Parent=Main
  local c=Instance.new("UICorner")
  c.CornerRadius=UDim.new(0,5)
  c.Parent=btn
  return btn
 end

 local Movement=CreateTab("Movement",0.18)
 local Visual=CreateTab("Visual",0.18)
 local ESP=CreateTab("ESP",0.18)
 local Cam=CreateTab("Camera",0.18)

 local Content=Instance.new("Frame")
 Content.Size=UDim2.new(0.96,0,0.62,0)
 Content.Position=UDim2.new(0.02,0,0.28,0)
 Content.BackgroundTransparency=1
 Content.Parent=Main

 local function ClearContent()
  for _,v in pairs(Content:GetChildren()) do v:Destroy() end
 end

 local function Toggle(text,y,get,set)
  local b=Instance.new("TextButton")
  b.Size=UDim2.new(0.9,0,0,28)
  b.Position=UDim2.new(0.05,0,y,0)
  b.BackgroundColor3=Color3.fromRGB(20,20,40)
  b.Text=text..(get() and " ON" or " OFF")
  b.TextColor3=get() and Color3.fromRGB(0,255,200) or Color3.fromRGB(170,170,190)
  b.Font=Enum.Font.Gotham
  b.TextSize=12
  b.Parent=Content
  local c=Instance.new("UICorner")
  c.CornerRadius=UDim.new(0,4)
  c.Parent=b
  b.MouseButton1Click:Connect(function()
   local new=not get()
   set(new)
   b.Text=text..(new and " ON" or " OFF")
   b.TextColor3=new and Color3.fromRGB(0,255,200) or Color3.fromRGB(170,170,190)
  end)
  return b
 end

 Movement.MouseButton1Click:Connect(function()
  ClearContent()
  Toggle("Moonwalk",0.02,function() return Config.Moonwalk end,function(v) Config.Moonwalk=v end)
  Toggle("Anti Auto Parry",0.12,function() return Config.AntiAutoParry end,function(v) Config.AntiAutoParry=v end)
 end)

 Visual.MouseButton1Click:Connect(function()
  ClearContent()
  Toggle("Wings",0.02,function() return Config.WingsEnabled end,function(v) Config.WingsEnabled=v end)
  Toggle("Halo",0.12,function() return Config.HaloEnabled end,function(v) Config.HaloEnabled=v end)
 end)

 ESP.MouseButton1Click:Connect(function()
  ClearContent()
  Toggle("ESP",0.02,function() return Config.EspEnabled end,function(v) Config.EspEnabled=v end)
 end)

 Cam.MouseButton1Click:Connect(function()
  ClearContent()
  Toggle("Stiffness",0.02,function() return false end,function(v) end)
 end)

 Movement.MouseButton1Click:Fire()
end

-- Loader
local LoaderGui=Instance.new("ScreenGui")
LoaderGui.Parent=PlayerGui
LoaderGui.ResetOnSpawn=false

local LoaderFrame=Instance.new("Frame")
LoaderFrame.Size=UDim2.new(1,0,1,0)
LoaderFrame.BackgroundTransparency=1
LoaderFrame.Parent=LoaderGui

Galaxy(LoaderFrame)

local Title=Instance.new("TextLabel")
Title.Size=UDim2.new(0.8,0,0,60)
Title.Position=UDim2.new(0.1,0,0.35,0)
Title.BackgroundTransparency=1
Title.Text="Welcome to ZIX👑"
Title.Font=Enum.Font.GothamBlack
Title.TextSize=40
Title.Parent=LoaderFrame

task.spawn(function()
 while Title and Title.Parent do
  Title.TextColor3=Color3.fromHSV(tick()%2/2,1,1)
  task.wait(0.05)
 end
end)

for i=1,5 do
 local tri=Instance.new("TextLabel")
 tri.Size=UDim2.new(0,60,0,60)
 tri.Position=UDim2.new(0.5,-30+(i-3)*70,0.55,-30)
 tri.BackgroundTransparency=1
 tri.Text="▼"
 tri.Font=Enum.Font.GothamBold
 tri.TextSize=50
 tri.Parent=LoaderFrame
 task.spawn(function()
  while tri and tri.Parent do
   tri.Rotation=(tri.Rotation+8)%360
   tri.TextColor3=Color3.fromHSV((tick()%2/2+i*0.1)%1,1,1)
   task.wait(0.05)
  end
 end)
end

local Bar=Instance.new("Frame")
Bar.Size=UDim2.new(0.6,0,0,6)
Bar.Position=UDim2.new(0.2,0,0.75,0)
Bar.BackgroundColor3=Color3.fromRGB(30,30,50)
Bar.Parent=LoaderFrame

local Fill=Instance.new("Frame")
Fill.Size=UDim2.new(0,0,1,0)
Fill.BackgroundColor3=Color3.fromRGB(255,0,200)
Fill.Parent=Bar

task.spawn(function()
 for i=1,100 do
  Fill.Size=UDim2.new(i/100,0,1,0)
  Fill.BackgroundColor3=Color3.fromHSV(i/100,1,1)
  task.wait(0.02)
 end
 LoaderGui:Destroy()
 ShowMain()
end)
