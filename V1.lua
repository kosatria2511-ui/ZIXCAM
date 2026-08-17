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

local Config={
 Smoothness=0.08,RotationSpeed=0.15,PitchMin=-20,PitchMax=60,CurrentZoom=6,FOV=70,
 Moonwalk=false,AntiAutoParry=false,WingsEnabled=false,HaloEnabled=false,
 StiffnessEnabled=false,Stiffness=0.5,AspectEnabled=false,AspectRatio=1.777,
 EspKiller=false,EspSurvivor=false,EspZombie=false,EspPallet=false,EspWindow=false,EspGenerator=false
}

local CurrentYaw=0
local CurrentPitch=15
local CameraActive=false
local CameraConnection=nil

local function StartCamera()
 if CameraConnection then CameraConnection:Disconnect() end
 CameraActive=true
 CameraConnection=RunService.Heartbeat:Connect(function()
  if not CameraActive then return end
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
  if Config.AspectEnabled then
   local ar=Config.AspectRatio
   local vs=Camera.ViewportSize
   local newW=vs.X
   local newH=math.floor(vs.X/ar)
   if newH>vs.Y then newH=vs.Y newW=math.floor(vs.Y*ar) end
   Camera.ViewportSize=Vector2.new(newW,newH)
  end
 end)
end

local function Galaxy(parent)
 local g=Instance.new("Frame")
 g.Size=UDim2.new(1,0,1,0)
 g.BackgroundColor3=Color3.fromRGB(5,0,20)
 g.Parent=parent
 for i=1,40 do
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

local loaderThreads={}
local function StopLoaderThreads()
 for _,t in pairs(loaderThreads) do if t then t:Disconnect() end end
 loaderThreads={}
end

local function MakeDraggable(obj)
 local dragging=false
 local startPos=nil
 local startMouse=nil
 obj.InputBegan:Connect(function(input)
  if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
   dragging=true startPos=obj.Position startMouse=input.Position
  end
 end)
 UserInputService.InputChanged:Connect(function(input)
  if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
   local delta=input.Position-startMouse
   obj.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
  end
 end)
 UserInputService.InputEnded:Connect(function(input)
  if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
   dragging=false
  end
 end)
end

local function CreateSection(parent,title,y,height)
 local sec=Instance.new("Frame")
 sec.Size=UDim2.new(0.9,0,0,height)
 sec.Position=UDim2.new(0.05,0,y,0)
 sec.BackgroundColor3=Color3.fromRGB(15,15,30)
 sec.BackgroundTransparency=0.1
 sec.BorderSizePixel=1
 sec.BorderColor3=Color3.fromRGB(80,80,120)
 sec.Parent=parent
 local c=Instance.new("UICorner")
 c.CornerRadius=UDim.new(0,6)
 c.Parent=sec
 local lbl=Instance.new("TextLabel")
 lbl.Size=UDim2.new(1,0,0,20)
 lbl.BackgroundTransparency=1
 lbl.Text=title
 lbl.Font=Enum.Font.GothamBold
 lbl.TextSize=13
 lbl.TextColor3=Color3.fromRGB(255,255,255)
 lbl.Parent=sec
 return sec
end

local function ShowMain()
 local SG=Instance.new("ScreenGui")
 SG.Parent=PlayerGui
 SG.ResetOnSpawn=false
 Galaxy(SG)

 local Main=Instance.new("Frame")
 Main.Size=UDim2.new(0,420,0,560)
 Main.Position=UDim2.new(0.5,-210,0.5,-280)
 Main.BackgroundColor3=Color3.fromRGB(8,8,25)
 Main.BackgroundTransparency=0.05
 Main.Parent=SG
 MakeDraggable(Main)
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
 IconLabel.TextSize=30
 IconLabel.Parent=Icon

 local MainTitle=Instance.new("TextLabel")
 MainTitle.Size=UDim2.new(1,0,0,35)
 MainTitle.Position=UDim2.new(0,0,0.05,0)
 MainTitle.BackgroundTransparency=1
 MainTitle.Text="ZIXCAM VIP"
 MainTitle.Font=Enum.Font.GothamBold
 MainTitle.TextSize=22
 MainTitle.Parent=Main

 local Close=Instance.new("TextButton")
 Close.Size=UDim2.new(0,24,0,24)
 Close.Position=UDim2.new(1,-28,0,5)
 Close.BackgroundTransparency=1
 Close.Text="X"
 Close.TextColor3=Color3.fromRGB(255,80,80)
 Close.Parent=Main
 Close.MouseButton1Click:Connect(function() SG:Destroy() end)

 local Content=Instance.new("Frame")
 Content.Size=UDim2.new(0.96,0,0.65,0)
 Content.Position=UDim2.new(0.02,0,0.3,0)
 Content.BackgroundTransparency=1
 Content.Parent=Main

 local M1=Instance.new("Frame")
 M1.Size=UDim2.new(0.9,0,0,90)
 M1.Position=UDim2.new(0.05,0,0.12,0)
 M1.BackgroundColor3=Color3.fromRGB(15,15,35)
 M1.BorderSizePixel=2
 M1.BorderColor3=Color3.fromRGB(255,0,0)
 M1.Parent=Main
 local M1Corner=Instance.new("UICorner")
 M1Corner.CornerRadius=UDim.new(0,8)
 M1Corner.Parent=M1
 local M1Title=Instance.new("TextLabel")
 M1Title.Size=UDim2.new(1,0,0,25)
 M1Title.BackgroundTransparency=1
 M1Title.Text="Violence District"
 M1Title.Font=Enum.Font.GothamBold
 M1Title.TextSize=15
 M1Title.Parent=M1
 local M1Btn=Instance.new("TextButton")
 M1Btn.Size=UDim2.new(0.5,0,0,30)
 M1Btn.Position=UDim2.new(0.25,0,0.5,0)
 M1Btn.BackgroundColor3=Color3.fromRGB(200,0,0)
 M1Btn.Text="🔒 LOCKED"
 M1Btn.TextColor3=Color3.fromRGB(255,255,255)
 M1Btn.Font=Enum.Font.GothamBold
 M1Btn.TextSize=12
 M1Btn.Parent=M1

 local M2=Instance.new("Frame")
 M2.Size=UDim2.new(0.9,0,0,90)
 M2.Position=UDim2.new(0.05,0,0.3,0)
 M2.BackgroundColor3=Color3.fromRGB(15,15,35)
 M2.BorderSizePixel=2
 M2.BorderColor3=Color3.fromRGB(150,150,150)
 M2.Parent=Main
 local M2Corner=Instance.new("UICorner")
 M2Corner.CornerRadius=UDim.new(0,8)
 M2Corner.Parent=M2
 local M2Title=Instance.new("TextLabel")
 M2Title.Size=UDim2.new(1,0,0,25)
 M2Title.BackgroundTransparency=1
 M2Title.Text="VD CAM"
 M2Title.Font=Enum.Font.GothamBold
 M2Title.TextSize=15
 M2Title.Parent=M2
 local M2Btn=Instance.new("TextButton")
 M2Btn.Size=UDim2.new(0.5,0,0,30)
 M2Btn.Position=UDim2.new(0.25,0,0.5,0)
 M2Btn.BackgroundColor3=Color3.fromRGB(150,150,150)
 M2Btn.Text="🔒 LOCKED"
 M2Btn.TextColor3=Color3.fromRGB(255,255,255)
 M2Btn.Font=Enum.Font.GothamBold
 M2Btn.TextSize=12
 M2Btn.Parent=M2

 local unlocked=false
 M2Btn.MouseButton1Click:Connect(function()
  if not unlocked then
   unlocked=true
   M2Btn.BackgroundColor3=Color3.fromRGB(0,200,0)
   M2Btn.Text="🔓 UNLOCKED"
   M2.BorderColor3=Color3.fromRGB(0,255,0)
   task.wait(0.4)
   for _,v in pairs({M1,M2}) do TweenService:Create(v,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play() end
   task.wait(0.3)
   M1:Destroy() M2:Destroy()
   BuildTabs(Main,Content)
  end
 end)
end

function BuildTabs(Main,Content)
 local tabNames={"Movement","Visual","ESP","Camera"}
 local function ClearContent() for _,v in pairs(Content:GetChildren()) do v:Destroy() end end
 local function Toggle(text,y,get,set)
  local b=Instance.new("TextButton")
  b.Size=UDim2.new(0.9,0,0,26)
  b.Position=UDim2.new(0.05,0,y,0)
  b.BackgroundColor3=Color3.fromRGB(20,20,40)
  b.Text=text..(get() and " ON" or " OFF")
  b.TextColor3=get() and Color3.fromRGB(0,255,200) or Color3.fromRGB(170,170,190)
  b.Font=Enum.Font.Gotham
  b.TextSize=11
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
 local function Slider(text,y,min,max,val,set)
  local frame=Instance.new("Frame")
  frame.Size=UDim2.new(0.9,0,0,30)
  frame.Position=UDim2.new(0.05,0,y,0)
  frame.BackgroundTransparency=1
  frame.Parent=Content
  local label=Instance.new("TextLabel")
  label.Size=UDim2.new(0.6,0,0,14)
  label.BackgroundTransparency=1
  label.Text=text.." "..string.format("%.1f",val)
  label.TextColor3=Color3.fromRGB(200,200,230)
  label.Font=Enum.Font.Gotham
  label.TextSize=10
  label.Parent=frame
  local track=Instance.new("Frame")
  track.Size=UDim2.new(0.38,0,0,4)
  track.Position=UDim2.new(0.58,0,0.5,-2)
  track.BackgroundColor3=Color3.fromRGB(30,30,50)
  track.Parent=frame
  local fill=Instance.new("Frame")
  fill.Size=UDim2.new((val-min)/(max-min),0,1,0)
  fill.BackgroundColor3=Color3.fromRGB(255,0,200)
  fill.Parent=track
  local handle=Instance.new("TextButton")
  handle.Size=UDim2.new(0,10,0,10)
  handle.Position=UDim2.new((val-min)/(max-min),-5,0.5,-5)
  handle.BackgroundColor3=Color3.fromRGB(255,0,200)
  handle.Text=""
  handle.Parent=track
  local dragging=false
  handle.MouseButton1Down:Connect(function() dragging=true end)
  UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
  RunService.RenderStepped:Connect(function()
   if dragging then
    local mouse=LocalPlayer:GetMouse()
    local rel=math.clamp((mouse.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
    local v=min+(max-min)*rel
    v=math.floor(v*10)/10
    set(v)
    label.Text=text.." "..string.format("%.1f",v)
    fill.Size=UDim2.new(rel,0,1,0)
    handle.Position=UDim2.new(rel,-5,0.5,-5)
   end
  end)
 end
 local function SelectTab(name)
  ClearContent()
  if name=="Movement" then
   Toggle("Moonwalk",0.02,function() return Config.Moonwalk end,function(v) Config.Moonwalk=v end)
   Toggle("Anti Auto Parry",0.1,function() return Config.AntiAutoParry end,function(v) Config.AntiAutoParry=v end)
  elseif name=="Visual" then
   Toggle("Wings",0.02,function() return Config.WingsEnabled end,function(v) Config.WingsEnabled=v end)
   Toggle("Halo",0.1,function() return Config.HaloEnabled end,function(v) Config.HaloEnabled=v end)
  elseif name=="ESP" then
   Toggle("Killer",0.02,function() return Config.EspKiller end,function(v) Config.EspKiller=v end)
   Toggle("Survivor",0.1,function() return Config.EspSurvivor end,function(v) Config.EspSurvivor=v end)
   Toggle("Zombie",0.18,function() return Config.EspZombie end,function(v) Config.EspZombie=v end)
   Toggle("Pallet",0.26,function() return Config.EspPallet end,function(v) Config.EspPallet=v end)
   Toggle("Window",0.34,function() return Config.EspWindow end,function(v) Config.EspWindow=v end)
   Toggle("Generator",0.42,function() return Config.EspGenerator end,function(v) Config.EspGenerator=v end)
  elseif name=="Camera" then
   Toggle("Camera Stiffness",0.02,function() return Config.StiffnessEnabled end,function(v) Config.StiffnessEnabled=v end)
   Slider("Stiffness",0.1,0,1,Config.Stiffness,function(v) Config.Stiffness=v end)
   Toggle("DBD Cam",0.2,function() return CameraActive end,function(v)
    if v then StartCamera() else CameraActive=false if CameraConnection then CameraConnection:Disconnect() CameraConnection=nil end end
   end)
   Slider("FOV",0.28,30,120,Config.FOV,function(v) Config.FOV=v end)
   Toggle("Aspect Ratio",0.4,function() return Config.AspectEnabled end,function(v) Config.AspectEnabled=v end)
  end
 end
 for i,name in pairs(tabNames) do
  local btn=Instance.new("TextButton")
  btn.Size=UDim2.new(0.22,0,0,30)
  btn.Position=UDim2.new(0.02+(i-1)*0.24,0,0.5,0)
  btn.BackgroundColor3=Color3.fromRGB(20,20,40)
  btn.Text=name
  btn.TextColor3=Color3.fromRGB(200,200,230)
  btn.Font=Enum.Font.GothamBold
  btn.TextSize=12
  btn.Parent=Main
  local c=Instance.new("UICorner")
  c.CornerRadius=UDim.new(0,5)
  c.Parent=btn
  btn.MouseButton1Click:Connect(function() SelectTab(name) end)
 end
 SelectTab("Movement")
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
Title.Position=UDim2.new(0.1,0,0.3,0)
Title.BackgroundTransparency=1
Title.Text="Welcome to ZIX👑"
Title.Font=Enum.Font.GothamBlack
Title.TextSize=40
Title.Parent=LoaderFrame

local titleLoop=RunService.Heartbeat:Connect(function()
 if Title and Title.Parent then Title.TextColor3=Color3.fromHSV(tick()%2/2,1,1) end
end)
table.insert(loaderThreads,titleLoop)

local BigTri=Instance.new("TextLabel")
BigTri.Size=UDim2.new(0,150,0,150)
BigTri.Position=UDim2.new(0.5,-75,0.45,-75)
BigTri.BackgroundTransparency=1
BigTri.Text="▼"
BigTri.Font=Enum.Font.GothamBold
BigTri.TextSize=140
BigTri.Parent=LoaderFrame

local bigTriLoop=RunService.Heartbeat:Connect(function()
 if BigTri and BigTri.Parent then
  BigTri.Rotation=(BigTri.Rotation+5)%360
  BigTri.TextColor3=Color3.fromHSV(tick()%2/2,1,1)
 end
end)
table.insert(loaderThreads,bigTriLoop)

local Bar=Instance.new("Frame")
Bar.Size=UDim2.new(0.5,0,0,6)
Bar.Position=UDim2.new(0.25,0,0.68,0)
Bar.BackgroundColor3=Color3.fromRGB(30,30,50)
Bar.Parent=LoaderFrame

local Fill=Instance.new("Frame")
Fill.Size=UDim2.new(0,0,1,0)
Fill.BackgroundColor3=Color3.fromRGB(255,0,200)
Fill.Parent=Bar

local LoadingText=Instance.new("TextLabel")
LoadingText.Size=UDim2.new(1,0,0,20)
LoadingText.Position=UDim2.new(0,0,0.72,0)
LoadingText.BackgroundTransparency=1
LoadingText.Text="Loading..."
LoadingText.Font=Enum.Font.Gotham
LoadingText.TextSize=14
LoadingText.TextColor3=Color3.fromRGB(200,200,230)
LoadingText.Parent=LoaderFrame

task.spawn(function()
 for i=1,100 do
  if not LoaderGui or not LoaderGui.Parent then return end
  Fill.Size=UDim2.new(i/100,0,1,0)
  Fill.BackgroundColor3=Color3.fromHSV(i/100,1,1)
  LoadingText.Text="Loading... "..i.."%"
  task.wait(0.02)
 end
 StopLoaderThreads()
 LoaderGui:Destroy()
 ShowMain()
end)
