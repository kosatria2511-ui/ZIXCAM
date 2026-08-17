-- DBD Camera - Mobile Full Support - RGB UI - Min/Max
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local Camera=workspace.CurrentCamera
local LocalPlayer=Players.LocalPlayer
local Character=LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid=Character:WaitForChild("Humanoid")
local HumanoidRootPart=Character:WaitForChild("HumanoidRootPart")
local FOV=120 local MaxFOV=300 local MinFOV=30
local CameraSensitivity=0.5 local Smoothness=0.15
local CurrentCameraDistance=8 local MinCameraDistance=1 local MaxCameraDistance=40
local IsCameraEnabled=true local CameraAngleX=0 local CameraAngleY=0
local IsRightMouseDown=false local TouchStartPos=nil

if getgenv().CameraGUI then getgenv().CameraGUI:Destroy() end

local ScreenGui=Instance.new("ScreenGui") ScreenGui.Name="CameraGUI" ScreenGui.ResetOnSpawn=false ScreenGui.IgnoreGuiInset=true ScreenGui.Parent=LocalPlayer:WaitForChild("PlayerGui") getgenv().CameraGUI=ScreenGui

local MainContainer=Instance.new("Frame") MainContainer.Size=UDim2.new(0,280,0,200) MainContainer.Position=UDim2.new(0.5,-140,0.5,-100) MainContainer.BackgroundColor3=Color3.fromRGB(10,10,15) MainContainer.BackgroundTransparency=0.1 MainContainer.BorderSizePixel=0 MainContainer.Parent=ScreenGui
local MainCorner=Instance.new("UICorner") MainCorner.CornerRadius=UDim.new(0,12) MainCorner.Parent=MainContainer

local ParticleContainer=Instance.new("Frame") ParticleContainer.Size=UDim2.new(1,0,1,0) ParticleContainer.BackgroundTransparency=1 ParticleContainer.ZIndex=0 ParticleContainer.Parent=MainContainer

local function CreateParticle()
    local Particle=Instance.new("Frame") Particle.Size=UDim2.new(0,math.random(3,8),0,math.random(3,8)) Particle.Position=UDim2.new(math.random(0,100)/100,0,math.random(0,100)/100,0) Particle.BackgroundColor3=Color3.fromHSV(math.random()*360,1,1) Particle.BorderSizePixel=0 Particle.BackgroundTransparency=0.5 Particle.ZIndex=0 Particle.Parent=ParticleContainer
    local Corner=Instance.new("UICorner") Corner.CornerRadius=UDim.new(1,0) Corner.Parent=Particle
    spawn(function() local Start=UDim2.new(math.random(0,100)/100,0,math.random(0,100)/100,0) local End=UDim2.new(math.random(0,100)/100,math.random(-50,50),math.random(0,100)/100,math.random(-50,50)) local T=0 local D=math.random(20,40)/10
        while T<D do T=T+RunService.RenderStepped:Wait() local A=T/D Particle.Position=Start:Lerp(End,A) Particle.BackgroundTransparency=0.5+A*0.5 Particle.BackgroundColor3=Color3.fromHSV((tick()*100)%360,1,1) end Particle:Destroy() end)
end

spawn(function() while ParticleContainer.Parent do CreateParticle() wait(math.random(5,15)/10) end end)

local TitleLabel=Instance.new("TextLabel") TitleLabel.Size=UDim2.new(1,0,0,30) TitleLabel.Position=UDim2.new(0,0,0,10) TitleLabel.BackgroundTransparency=1 TitleLabel.Text="DBD CAMERA" TitleLabel.TextColor3=Color3.fromRGB(255,255,255) TitleLabel.TextSize=18 TitleLabel.Font=Enum.Font.GothamBold TitleLabel.ZIndex=5 TitleLabel.Parent=MainContainer

local MinimizeButton=Instance.new("TextButton") MinimizeButton.Size=UDim2.new(0,35,0,35) MinimizeButton.Position=UDim2.new(1,-45,0,5) MinimizeButton.BackgroundColor3=Color3.fromRGB(255,0,0) MinimizeButton.BorderSizePixel=0 MinimizeButton.Text="—" MinimizeButton.TextColor3=Color3.fromRGB(255,255,255) MinimizeButton.TextSize=20 MinimizeButton.Font=Enum.Font.GothamBold MinimizeButton.AutoButtonColor=false MinimizeButton.ZIndex=10 MinimizeButton.Parent=MainContainer
local MinCorner=Instance.new("UICorner") MinCorner.CornerRadius=UDim.new(0,8) MinCorner.Parent=MinimizeButton

local FOVLabel=Instance.new("TextLabel") FOVLabel.Size=UDim2.new(0,100,0,25) FOVLabel.Position=UDim2.new(0,10,0,50) FOVLabel.BackgroundTransparency=1 FOVLabel.Text="FOV: "..FOV FOVLabel.TextColor3=Color3.fromRGB(255,255,255) FOVLabel.TextSize=14 FOVLabel.Font=Enum.Font.GothamBold FOVLabel.ZIndex=5 FOVLabel.Parent=MainContainer

local SliderFrame=Instance.new("Frame") SliderFrame.Size=UDim2.new(1,-20,0,30) SliderFrame.Position=UDim2.new(0,10,0,80) SliderFrame.BackgroundColor3=Color3.fromRGB(30,30,40) SliderFrame.BorderSizePixel=0 SliderFrame.ZIndex=5 SliderFrame.Parent=MainContainer
local SliderCorner=Instance.new("UICorner") SliderCorner.CornerRadius=UDim.new(0,15) SliderCorner.Parent=SliderFrame

local SliderFill=Instance.new("Frame") SliderFill.Size=UDim2.new((FOV-MinFOV)/(MaxFOV-MinFOV),0,1,0) SliderFill.BackgroundColor3=Color3.fromRGB(255,0,0) SliderFill.BorderSizePixel=0 SliderFill.ZIndex=6 SliderFill.Parent=SliderFrame
local FillCorner=Instance.new("UICorner") FillCorner.CornerRadius=UDim.new(0,15) FillCorner.Parent=SliderFill

local SliderButton=Instance.new("TextButton") SliderButton.Size=UDim2.new(0,30,0,30) SliderButton.Position=UDim2.new((FOV-MinFOV)/(MaxFOV-MinFOV),-15,0,0) SliderButton.BackgroundColor3=Color3.fromRGB(255,255,255) SliderButton.BorderSizePixel=0 SliderButton.Text="" SliderButton.AutoButtonColor=false SliderButton.ZIndex=7 SliderButton.Parent=SliderFrame
local ButtonCorner=Instance.new("UICorner") ButtonCorner.CornerRadius=UDim.new(1,0) ButtonCorner.Parent=SliderButton

spawn(function() while SliderFill.Parent do SliderFill.BackgroundColor3=Color3.fromHSV((tick()*50)%360,1,1) SliderButton.BackgroundColor3=Color3.fromHSV((tick()*50+180)%360,1,1) RunService.RenderStepped:Wait() end end)

local ToggleButton=Instance.new("TextButton") ToggleButton.Size=UDim2.new(0,80,0,30) ToggleButton.Position=UDim2.new(0,10,0,120) ToggleButton.BackgroundColor3=Color3.fromRGB(0,150,0) ToggleButton.BorderSizePixel=0 ToggleButton.Text="ON" ToggleButton.TextColor3=Color3.fromRGB(255,255,255) ToggleButton.TextSize=14 ToggleButton.Font=Enum.Font.GothamBold ToggleButton.AutoButtonColor=false ToggleButton.ZIndex=5 ToggleButton.Parent=MainContainer
local ToggleCorner=Instance.new("UICorner") ToggleCorner.CornerRadius=UDim.new(0,8) ToggleCorner.Parent=ToggleButton

local ResetButton=Instance.new("TextButton") ResetButton.Size=UDim2.new(0,80,0,30) ResetButton.Position=UDim2.new(0,100,0,120) ResetButton.BackgroundColor3=Color3.fromRGB(50,50,60) ResetButton.BorderSizePixel=0 ResetButton.Text="RESET" ResetButton.TextColor3=Color3.fromRGB(255,255,255) ResetButton.TextSize=12 ResetButton.Font=Enum.Font.GothamBold ResetButton.AutoButtonColor=false ResetButton.ZIndex=5 ResetButton.Parent=MainContainer
local ResetCorner=Instance.new("UICorner") ResetCorner.CornerRadius=UDim.new(0,8) ResetCorner.Parent=ResetButton

local InstructionLabel=Instance.new("TextLabel") InstructionLabel.Size=UDim2.new(1,-20,0,20) InstructionLabel.Position=UDim2.new(0,10,0,160) InstructionLabel.BackgroundTransparency=1 InstructionLabel.Text="RMB/Touch: Rotate | Wheel: Zoom" InstructionLabel.TextColor3=Color3.fromRGB(150,150,150) InstructionLabel.TextSize=10 InstructionLabel.Font=Enum.Font.Gotham InstructionLabel.ZIndex=5 InstructionLabel.Parent=MainContainer

local IsDraggingSlider=false
SliderButton.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then IsDraggingSlider=true end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then IsDraggingSlider=false end end)
UserInputService.InputChanged:Connect(function(input)
    if IsDraggingSlider then
        local MousePos=nil
        if input.UserInputType==Enum.UserInputType.MouseMovement then MousePos=Vector2.new(input.Position.X,input.Position.Y)
        elseif input.UserInputType==Enum.UserInputType.Touch then MousePos=Vector2.new(input.Position.X,input.Position.Y) end
        if MousePos then
            local SliderAbsolutePos=SliderFrame.AbsolutePosition local SliderAbsoluteSize=SliderFrame.AbsoluteSize
            local RelativeX=math.clamp(MousePos.X-SliderAbsolutePos.X,0,SliderAbsoluteSize.X)
            local Percent=RelativeX/SliderAbsoluteSize.X
            FOV=math.floor(MinFOV+(MaxFOV-MinFOV)*Percent)
            SliderFill.Size=UDim2.new(Percent,0,1,0) SliderButton.Position=UDim2.new(Percent,-15,0,0) FOVLabel.Text="FOV: "..FOV Camera.FieldOfView=FOV
        end
    end
end)

ToggleButton.MouseButton1Click:Connect(function() IsCameraEnabled=not IsCameraEnabled if IsCameraEnabled then ToggleButton.Text="ON" ToggleButton.BackgroundColor3=Color3.fromRGB(0,150,0) else ToggleButton.Text="OFF" ToggleButton.BackgroundColor3=Color3.fromRGB(150,0,0) end end)
ResetButton.MouseButton1Click:Connect(function() FOV=120 Camera.FieldOfView=FOV FOVLabel.Text="FOV: 120" SliderFill.Size=UDim2.new((120-MinFOV)/(MaxFOV-MinFOV),0,1,0) SliderButton.Position=UDim2.new((120-MinFOV)/(MaxFOV-MinFOV),-15,0,0) end)

MinimizeButton.MouseButton1Click:Connect(function()
    MainContainer.Visible=false
    local MinimizedButton=Instance.new("TextButton") MinimizedButton.Size=UDim2.new(0,50,0,50) MinimizedButton.Position=UDim2.new(0,10,0,10) MinimizedButton.BackgroundColor3=Color3.fromRGB(255,0,0) MinimizedButton.BorderSizePixel=0 MinimizedButton.Text="📷" MinimizedButton.TextColor3=Color3.fromRGB(255,255,255) MinimizedButton.TextSize=20 MinimizedButton.Font=Enum.Font.GothamBold MinimizedButton.AutoButtonColor=false MinimizedButton.ZIndex=100 MinimizedButton.Parent=ScreenGui
    local MinButtonCorner=Instance.new("UICorner") MinButtonCorner.CornerRadius=UDim.new(0,25) MinButtonCorner.Parent=MinimizedButton
    spawn(function() while MinimizedButton.Parent do MinimizedButton.BackgroundColor3=Color3.fromHSV((tick()*100)%360,1,1) RunService.RenderStepped:Wait() end end)
    MinimizedButton.MouseButton1Click:Connect(function() MainContainer.Visible=true MinimizedButton:Destroy() end)
end)

local IsDraggingFrame=false local DragStart=nil local FrameStart=nil
MainContainer.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        if input.Position.X>SliderFrame.AbsolutePosition.X and input.Position.X<SliderFrame.AbsolutePosition.X+SliderFrame.AbsoluteSize.X and input.Position.Y>SliderFrame.AbsolutePosition.Y and input.Position.Y<SliderFrame.AbsolutePosition.Y+SliderFrame.AbsoluteSize.Y then return end
        if input.Position.X>ToggleButton.AbsolutePosition.X and input.Position.X<ToggleButton.AbsolutePosition.X+ToggleButton.AbsoluteSize.X and input.Position.Y>ToggleButton.AbsolutePosition.Y and input.Position.Y<ToggleButton.AbsolutePosition.Y+ToggleButton.AbsoluteSize.Y then return end
        if input.Position.X>ResetButton.AbsolutePosition.X and input.Position.X<ResetButton.AbsolutePosition.X+ResetButton.AbsoluteSize.X and input.Position.Y>ResetButton.AbsolutePosition.Y and input.Position.Y<ResetButton.AbsolutePosition.Y+ResetButton.AbsoluteSize.Y then return end
        IsDraggingFrame=true DragStart=input.Position FrameStart=MainContainer.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if IsDraggingFrame then
        local Delta=nil
        if input.UserInputType==Enum.UserInputType.MouseMovement then Delta=input.Position-DragStart
        elseif input.UserInputType==Enum.UserInputType.Touch then Delta=input.Position-DragStart end
        if Delta then MainContainer.Position=UDim2.new(FrameStart.X.Scale,FrameStart.X.Offset+Delta.X,FrameStart.Y.Scale,FrameStart.Y.Offset+Delta.Y) end
    end
end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then IsDraggingFrame=false end end)

local function UpdateCamera()
    if not IsCameraEnabled then return end
    if not Character or not HumanoidRootPart then Character=LocalPlayer.Character if Character then Humanoid=Character:FindFirstChild("Humanoid") HumanoidRootPart=Character:FindFirstChild("HumanoidRootPart") end return end
    if UserInputService.TouchEnabled then
        if IsRightMouseDown and TouchStartPos then
            local TouchPos=UserInputService:GetMouseLocation() local DeltaX=TouchPos.X-TouchStartPos.X local DeltaY=TouchPos.Y-TouchStartPos.Y
            CameraAngleX=CameraAngleX-DeltaX*CameraSensitivity*0.008 CameraAngleY=math.clamp(CameraAngleY-DeltaY*CameraSensitivity*0.008,-85,85) TouchStartPos=TouchPos
        end
    else
        local MouseDelta=UserInputService:GetMouseDelta()
        if IsRightMouseDown then CameraAngleX=CameraAngleX-MouseDelta.X*CameraSensitivity*0.1 CameraAngleY=math.clamp(CameraAngleY-MouseDelta.Y*CameraSensitivity*0.1,-85,85) end
    end
    local Forward=Vector3.new(math.sin(CameraAngleX)*math.cos(CameraAngleY),math.sin(CameraAngleY),math.cos(CameraAngleX)*math.cos(CameraAngleY))
    local BasePosition=HumanoidRootPart.Position+Vector3.new(0,2.5,0)
    local ShoulderOffset=Vector3.new(-math.sin(CameraAngleX)*3,1.5,-math.cos(CameraAngleX)*3)
    local TargetPosition=BasePosition-Forward*CurrentCameraDistance+ShoulderOffset
    local LookAtPosition=BasePosition+Forward*10
    Camera.CFrame=Camera.CFrame:Lerp(CFrame.new(TargetPosition,LookAtPosition),Smoothness) Camera.FieldOfView=FOV
end

UserInputService.InputBegan:Connect(function(input,gameProcessed)
    if input.UserInputType==Enum.UserInputType.MouseButton2 then IsRightMouseDown=true
    elseif input.UserInputType==Enum.UserInputType.MouseWheel then CurrentCameraDistance=math.clamp(CurrentCameraDistance+input.Position.Z*0.5,MinCameraDistance,MaxCameraDistance)
    elseif input.UserInputType==Enum.UserInputType.Touch then local GuiObjects=LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(input.Position.X,input.Position.Y) if #GuiObjects==0 then IsRightMouseDown=true TouchStartPos=Vector2.new(input.Position.X,input.Position.Y) end end
end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton2 then IsRightMouseDown=false elseif input.UserInputType==Enum.UserInputType.Touch then IsRightMouseDown=false TouchStartPos=nil end end)

RunService.RenderStepped:Connect(UpdateCamera)
LocalPlayer.CharacterAdded:Connect(function(newCharacter) Character=newCharacter Humanoid=Character:WaitForChild("Humanoid") HumanoidRootPart=Character:WaitForChild("HumanoidRootPart") CameraAngleX=0 CameraAngleY=0 end)

getgenv().SetFOV=function(newFOV) FOV=math.clamp(newFOV,MinFOV,MaxFOV) Camera.FieldOfView=FOV end
getgenv().GetFOV=function() return FOV end
getgenv().ToggleCameraGUI=function() if getgenv().CameraGUI then getgenv().CameraGUI.Enabled=not getgenv().CameraGUI.Enabled end end
