-- ZIXCAM VIP SHORT
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

local Config={Smoothness=0.08,RotationSpeed=0.15,PitchMin=-20,PitchMax=60,CurrentZoom=6,FOV=70,Moonwalk=false,AntiAutoParry=false,WingsEnabled=false,HaloEnabled=false}

local function Galaxy(parent)
 local g=Instance.new("Frame")
 g.Size=UDim2.new(1,0,1,0)
 g.BackgroundColor3=Color3.fromRGB(5,0,20)
 g.Parent=parent
 for i=1,80 do
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
 if not RootPart or not Humanoid then return end
 Camera.FieldOfView=Config.FOV
 local delta=UserInputService:GetMouseDelta()
 local y=math.rad(delta.X*Config.RotationSpeed)
 local p=math.rad(math.clamp(delta.Y*Config.RotationSpeed,Config.PitchMin,Config.PitchMax))
 local dist=Config.CurrentZoom
 local dir=Vector3.new(math.sin(y)*math.cos(p),math.sin(p),math.cos(y)*math.cos(p))
 local desired=RootPart.Position+Vector3.new(0,4.5,0)+dir*dist
 Camera.CFrame=Camera.CFrame:Lerp(CFrame.new(desired,RootPart.Position+Vector3.new(0,1.5,0)),Config.Smoothness)
end)

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

function ShowMain()
 local SG=Instance.new("ScreenGui")
 SG.Parent=PlayerGui
 SG.ResetOnSpawn=false

 Galaxy(SG)

 local Main=Instance.new("Frame")
 Main.Size=UDim2.new(0,350,0,450)
 Main.Position=UDim2.new(0.5,-175,0.5,-225)
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
 MainTitle.Position=UDim2.new(0,0,0.1,0)
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

 local M1=Instance.new("Frame")
 M1.Size=UDim2.new(0.9,0,0,150)
 M1.Position=UDim2.new(0.05,0,0.22,0)
 M1.BackgroundColor3=Color3.fromRGB(15,15,35)
 M1.BorderSizePixel=2
 M1.BorderColor3=Color3.fromRGB(255,0,0)
 M1.Parent=Main

 local M1Corner=Instance.new("UICorner")
 M1Corner.CornerRadius=UDim.new(0,10)
 M1Corner.Parent=M1

 local M1Title=Instance.new("TextLabel")
 M1Title.Size=UDim2.new(1,0,0,30)
 M1Title.BackgroundTransparency=1
 M1Title.Text="Violence District"
 M1Title.Font=Enum.Font.GothamBold
 M1Title.TextSize=18
 M1Title.Parent=M1

 local M1Status=Instance.new("TextLabel")
 M1Status.Size=UDim2.new(1,0,0,25)
 M1Status.Position=UDim2.new(0,0,0.3,0)
 M1Status.BackgroundTransparency=1
 M1Status.Text="COMING SOON"
 M1Status.TextColor3=Color3.fromRGB(255,100,100)
 M1Status.Parent=M1

 local M1Btn=Instance.new("TextButton")
 M1Btn.Size=UDim2.new(0.5,0,0,35)
 M1Btn.Position=UDim2.new(0.25,0,0.65,0)
 M1Btn.BackgroundColor3=Color3.fromRGB(200,0,0)
 M1Btn.Text="🔒 LOCKED"
 M1Btn.TextColor3=Color3.fromRGB(255,255,255)
 M1Btn.Parent=M1

 local M2=Instance.new("Frame")
 M2.Size=UDim2.new(0.9,0,0,150)
 M2.Position=UDim2.new(0.05,0,0.58,0)
 M2.BackgroundColor3=Color3.fromRGB(15,15,35)
 M2.BorderSizePixel=2
 M2.BorderColor3=Color3.fromRGB(150,150,150)
 M2.Parent=Main

 local M2Corner=Instance.new("UICorner")
 M2Corner.CornerRadius=UDim.new(0,10)
 M2Corner.Parent=M2

 local M2Title=Instance.new("TextLabel")
 M2Title.Size=UDim2.new(1,0,0,30)
 M2Title.BackgroundTransparency=1
 M2Title.Text="VD CAM"
 M2Title.Font=Enum.Font.GothamBold
 M2Title.TextSize=18
 M2Title.Parent=M2

 local M2Status=Instance.new("TextLabel")
 M2Status.Size=UDim2.new(1,0,0,25)
 M2Status.Position=UDim2.new(0,0,0.3,0)
 M2Status.BackgroundTransparency=1
 M2Status.Text="BETA"
 M2Status.TextColor3=Color3.fromRGB(255,200,100)
 M2Status.Parent=M2

 local M2Btn=Instance.new("TextButton")
 M2Btn.Size=UDim2.new(0.5,0,0,35)
 M2Btn.Position=UDim2.new(0.25,0,0.65,0)
 M2Btn.BackgroundColor3=Color3.fromRGB(150,150,150)
 M2Btn.Text="🔒 LOCKED"
 M2Btn.TextColor3=Color3.fromRGB(255,255,255)
 M2Btn.Parent=M2

 local unlocked=false
 M2Btn.MouseButton1Click:Connect(function()
  if not unlocked then
   unlocked=true
   M2Btn.BackgroundColor3=Color3.fromRGB(0,200,0)
   M2Btn.Text="🔓 UNLOCKED"
   M2.BorderColor3=Color3.fromRGB(0,255,0)
  end
 end)
end
