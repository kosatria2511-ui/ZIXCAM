-- yeban.cc Violence District Script - Full Mobile/Delta/Camera/GitHub Support
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local Lighting=game:GetService("Lighting")
local Camera=workspace.CurrentCamera
local LocalPlayer=Players.LocalPlayer

-- Очистка старого GUI
if getgenv().yebanGUI then getgenv().yebanGUI:Destroy() end

-- Создание GUI с мобильной поддержкой
local ScreenGui=Instance.new("ScreenGui")
ScreenGui.Name="yebanGUI"
ScreenGui.ResetOnSpawn=false
ScreenGui.IgnoreGuiInset=true
ScreenGui.Parent=LocalPlayer:WaitForChild("PlayerGui")
getgenv().yebanGUI=ScreenGui

local MainFrame=Instance.new("Frame")
MainFrame.Size=UDim2.new(0,300,0,400)
MainFrame.Position=UDim2.new(0.5,-150,0.5,-200)
MainFrame.BackgroundColor3=Color3.fromRGB(20,20,20)
MainFrame.BorderSizePixel=0
MainFrame.Parent=ScreenGui

local MainCorner=Instance.new("UICorner")
MainCorner.CornerRadius=UDim.new(0,8)
MainCorner.Parent=MainFrame

-- Заголовок
local TitleLabel=Instance.new("TextLabel")
TitleLabel.Size=UDim2.new(1,0,0,35)
TitleLabel.BackgroundColor3=Color3.fromRGB(30,30,30)
TitleLabel.Text="VIOLENCE DISTRICT"
TitleLabel.TextColor3=Color3.fromRGB(255,0,0)
TitleLabel.TextSize=16
TitleLabel.Font=Enum.Font.GothamBold
TitleLabel.Parent=MainFrame

-- Вкладки
local TabFrame=Instance.new("Frame")
TabFrame.Size=UDim2.new(1,0,0,30)
TabFrame.Position=UDim2.new(0,0,0,40)
TabFrame.BackgroundTransparency=1
TabFrame.Parent=MainFrame

local CombatTab=Instance.new("TextButton")
CombatTab.Size=UDim2.new(0.33,0,1,0)
CombatTab.BackgroundColor3=Color3.fromRGB(50,50,50)
CombatTab.Text="COMBAT"
CombatTab.TextColor3=Color3.fromRGB(255,255,255)
CombatTab.TextSize=11
CombatTab.Font=Enum.Font.GothamBold
CombatTab.Parent=TabFrame

local VisualTab=Instance.new("TextButton")
VisualTab.Size=UDim2.new(0.33,0,1,0)
VisualTab.Position=UDim2.new(0.33,0,0,0)
VisualTab.BackgroundColor3=Color3.fromRGB(40,40,40)
VisualTab.Text="VISUAL"
VisualTab.TextColor3=Color3.fromRGB(255,255,255)
VisualTab.TextSize=11
VisualTab.Font=Enum.Font.GothamBold
VisualTab.Parent=TabFrame

local MiscTab=Instance.new("TextButton")
MiscTab.Size=UDim2.new(0.34,0,1,0)
MiscTab.Position=UDim2.new(0.66,0,0,0)
MiscTab.BackgroundColor3=Color3.fromRGB(40,40,40)
MiscTab.Text="MISC"
MiscTab.TextColor3=Color3.fromRGB(255,255,255)
MiscTab.TextSize=11
MiscTab.Font=Enum.Font.GothamBold
MiscTab.Parent=TabFrame

-- Страницы
local CombatPage=Instance.new("ScrollingFrame")
CombatPage.Size=UDim2.new(1,-10,1,-80)
CombatPage.Position=UDim2.new(0,5,0,75)
CombatPage.BackgroundTransparency=1
CombatPage.ScrollBarThickness=3
CombatPage.ScrollingEnabled=true
CombatPage.Parent=MainFrame

local VisualPage=Instance.new("ScrollingFrame")
VisualPage.Size=UDim2.new(1,-10,1,-80)
VisualPage.Position=UDim2.new(0,5,0,75)
VisualPage.BackgroundTransparency=1
VisualPage.ScrollBarThickness=3
VisualPage.ScrollingEnabled=true
VisualPage.Visible=false
VisualPage.Parent=MainFrame

local MiscPage=Instance.new("ScrollingFrame")
MiscPage.Size=UDim2.new(1,-10,1,-80)
MiscPage.Position=UDim2.new(0,5,0,75)
MiscPage.BackgroundTransparency=1
MiscPage.ScrollBarThickness=3
MiscPage.ScrollingEnabled=true
MiscPage.Visible=false
MiscPage.Parent=MainFrame

CombatTab.MouseButton1Click:Connect(function() CombatPage.Visible=true VisualPage.Visible=false MiscPage.Visible=false end)
VisualTab.MouseButton1Click:Connect(function() CombatPage.Visible=false VisualPage.Visible=true MiscPage.Visible=false end)
MiscTab.MouseButton1Click:Connect(function() CombatPage.Visible=false VisualPage.Visible=false MiscPage.Visible=true end)

-- Мобильные касания для вкладок
CombatTab.TouchTap:Connect(function() CombatPage.Visible=true VisualPage.Visible=false MiscPage.Visible=false end)
VisualTab.TouchTap:Connect(function() CombatPage.Visible=false VisualPage.Visible=true MiscPage.Visible=false end)
MiscTab.TouchTap:Connect(function() CombatPage.Visible=false VisualPage.Visible=false MiscPage.Visible=true end)

-- Функция создания кнопки с мобильной поддержкой
local function CreateButton(Parent,Text,Y,Callback)
    local Button=Instance.new("TextButton")
    Button.Size=UDim2.new(1,-10,0,35)
    Button.Position=UDim2.new(0,5,0,Y)
    Button.BackgroundColor3=Color3.fromRGB(40,40,40)
    Button.BorderSizePixel=0
    Button.Text=Text
    Button.TextColor3=Color3.fromRGB(255,255,255)
    Button.TextSize=13
    Button.Font=Enum.Font.Gotham
    Button.Parent=Parent
    
    local Corner=Instance.new("UICorner")
    Corner.CornerRadius=UDim.new(0,4)
    Corner.Parent=Button
    
    Button.MouseButton1Click:Connect(Callback)
    Button.TouchTap:Connect(Callback)
end

-- Combat Features
local Y=0

CreateButton(CombatPage,"AIMBOT",Y,function()
    getgenv().Aimbot=not getgenv().Aimbot
    if getgenv().Aimbot then
        spawn(function()
            while getgenv().Aimbot do
                local Target=nil
                local MaxDistance=math.huge
                for _,Player in pairs(Players:GetPlayers()) do
                    if Player~=LocalPlayer and Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health>0 then
                        local Head=Player.Character:FindFirstChild("Head")
                        if Head then
                            local ScreenPos,OnScreen=Camera:WorldToScreenPoint(Head.Position)
                            if OnScreen then
                                local Distance=(Vector2.new(ScreenPos.X,ScreenPos.Y)-Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)).Magnitude
                                if Distance<MaxDistance then MaxDistance=Distance Target=Head end
                            end
                        end
                    end
                end
                if Target then Camera.CFrame=CFrame.new(Camera.CFrame.Position,Target.Position) end
                wait(0.01)
            end
        end)
    end
end)
Y=Y+40

CreateButton(CombatPage,"SILENT AIM",Y,function()
    getgenv().SilentAim=not getgenv().SilentAim
    if getgenv().SilentAim then
        local OldNamecall
        OldNamecall=hookmetamethod(game,"__namecall",function(Self,...)
            local Args={...}
            local Method=getnamecallmethod()
            if Method=="FireServer" and tostring(Self)=="RemoteEvent" then
                local Target=nil
                local MaxDistance=math.huge
                for _,Player in pairs(Players:GetPlayers()) do
                    if Player~=LocalPlayer and Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health>0 then
                        local Head=Player.Character:FindFirstChild("Head")
                        if Head then
                            local Distance=(Head.Position-Camera.CFrame.Position).Magnitude
                            if Distance<MaxDistance then MaxDistance=Distance Target=Head end
                        end
                    end
                end
                if Target then Args[2]=Target.Position end
            end
            return OldNamecall(Self,unpack(Args))
        end)
    end
end)
Y=Y+40

CreateButton(CombatPage,"KILL AURA",Y,function()
    getgenv().KillAura=not getgenv().KillAura
    if getgenv().KillAura then
        spawn(function()
            while getgenv().KillAura do
                local Char=LocalPlayer.Character
                if Char and Char:FindFirstChild("HumanoidRootPart") then
                    for _,Player in pairs(Players:GetPlayers()) do
                        if Player~=LocalPlayer and Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health>0 then
                            local Dist=(Player.Character.HumanoidRootPart.Position-Char.HumanoidRootPart.Position).Magnitude
                            if Dist<20 then
                                for _,Remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                                    if Remote:IsA("RemoteEvent") then Remote:FireServer("Hit",Player.Character.HumanoidRootPart.Position) end
                                end
                            end
                        end
                    end
                end
                wait(0.1)
            end
        end)
    end
end)
Y=Y+40

CreateButton(CombatPage,"REACH",Y,function()
    getgenv().Reach=not getgenv().Reach
    if getgenv().Reach then
        spawn(function()
            while getgenv().Reach do
                local Char=LocalPlayer.Character
                if Char then
                    for _,Part in pairs(Char:GetDescendants()) do
                        if Part:IsA("Tool") or Part:IsA("Part") then
                            if Part.Name:lower():find("sword") or Part.Name:lower():find("knife") or Part.Name:lower():find("bat") then Part.Size=Part.Size*2 end
                        end
                    end
                end
                wait(0.5)
            end
        end)
    end
end)
Y=Y+40

CreateButton(CombatPage,"AUTO PARRY",Y,function() getgenv().AutoParry=not getgenv().AutoParry end)
Y=Y+40

CreateButton(CombatPage,"NO STUN",Y,function()
    getgenv().NoStun=not getgenv().NoStun
    if getgenv().NoStun then
        spawn(function()
            while getgenv().NoStun do
                local Char=LocalPlayer.Character
                if Char then
                    for _,Anim in pairs(Char:GetDescendants()) do
                        if Anim:IsA("Animator") then Anim:LoadAnimation(Char:FindFirstChild("Humanoid")) end
                    end
                end
                wait(0.1)
            end
        end)
    end
end)

-- Visual Features
local VY=0

CreateButton(VisualPage,"ESP PLAYERS",VY,function()
    getgenv().ESP=not getgenv().ESP
    if getgenv().ESP then
        spawn(function()
            while getgenv().ESP do
                for _,Player in pairs(Players:GetPlayers()) do
                    if Player~=LocalPlayer and Player.Character and Player.Character:FindFirstChild("Head") then
                        local Head=Player.Character.Head
                        local Billboard=Head:FindFirstChild("ESPLabel")
                        if not Billboard then
                            Billboard=Instance.new("BillboardGui")
                            Billboard.Name="ESPLabel"
                            Billboard.Size=UDim2.new(0,100,0,30)
                            Billboard.StudsOffset=Vector3.new(0,2,0)
                            Billboard.AlwaysOnTop=true
                            Billboard.Parent=Head
                            local Label=Instance.new("TextLabel")
                            Label.Size=UDim2.new(1,0,1,0)
                            Label.BackgroundTransparency=1
                            Label.Text=Player.Name
                            Label.TextColor3=Color3.fromRGB(255,0,0)
                            Label.TextSize=14
                            Label.Font=Enum.Font.GothamBold
                            Label.Parent=Billboard
                        end
                    end
                end
                wait(1)
            end
        end)
    end
end)
VY=VY+40

CreateButton(VisualPage,"CHAMS",VY,function()
    getgenv().Chams=not getgenv().Chams
    if getgenv().Chams then
        spawn(function()
            while getgenv().Chams do
                for _,Player in pairs(Players:GetPlayers()) do
                    if Player~=LocalPlayer and Player.Character then
                        for _,Part in pairs(Player.Character:GetDescendants()) do
                            if Part:IsA("BasePart") then Part.Material=Enum.Material.ForceField Part.Color=Color3.fromRGB(255,0,0) end
                        end
                    end
                end
                wait(1)
            end
        end)
    end
end)
VY=VY+40

CreateButton(VisualPage,"FULL BRIGHT",VY,function()
    getgenv().FullBright=not getgenv().FullBright
    if getgenv().FullBright then Lighting.Brightness=3 Lighting.ClockTime=14 Lighting.FogEnd=100000 Lighting.GlobalShadows=false
    else Lighting.Brightness=1 Lighting.ClockTime=14 Lighting.FogEnd=1000 Lighting.GlobalShadows=true end
end)
VY=VY+40

CreateButton(VisualPage,"NO FOG",VY,function()
    getgenv().NoFog=not getgenv().NoFog
    if getgenv().NoFog then Lighting.FogEnd=100000 Lighting.FogStart=0 else Lighting.FogEnd=1000 Lighting.FogStart=500 end
end)
VY=VY+40

CreateButton(VisualPage,"ZOOM",VY,function()
    getgenv().Zoom=not getgenv().Zoom
    if getgenv().Zoom then spawn(function() while getgenv().Zoom do Camera.FieldOfView=30 wait(0.1) end end) else Camera.FieldOfView=70 end
end)

-- Misc Features
local MY=0

CreateButton(MiscPage,"INFINITE JUMP",MY,function()
    getgenv().InfiniteJump=not getgenv().InfiniteJump
    if getgenv().InfiniteJump then
        spawn(function()
            while getgenv().InfiniteJump do
                local Char=LocalPlayer.Character
                if Char and Char:FindFirstChild("Humanoid") then Char.Humanoid.Jump=true end
                wait(0.1)
            end
        end)
    end
end)
MY=MY+40

CreateButton(MiscPage,"SPEED HACK",MY,function()
    getgenv().SpeedHack=not getgenv().SpeedHack
    if getgenv().SpeedHack then
        spawn(function()
            while getgenv().SpeedHack do
                local Char=LocalPlayer.Character
                if Char and Char:FindFirstChild("Humanoid") then Char.Humanoid.WalkSpeed=50 end
                wait(0.1)
            end
        end)
    else local Char=LocalPlayer.Character if Char and Char:FindFirstChild("Humanoid") then Char.Humanoid.WalkSpeed=16 end end
end)
MY=MY+40

CreateButton(MiscPage,"FLY",MY,function()
    getgenv().Fly=not getgenv().Fly
    if getgenv().Fly then
        spawn(function()
            local Char=LocalPlayer.Character
            local HRP=Char and Char:FindFirstChild("HumanoidRootPart")
            local BV=nil
            if HRP then BV=Instance.new("BodyVelocity") BV.MaxForce=Vector3.new(100000,100000,100000) BV.Velocity=Vector3.new(0,0,0) BV.Parent=HRP end
            while getgenv().Fly do
                if BV then
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then BV.Velocity=Vector3.new(0,50,0)
                    elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then BV.Velocity=Vector3.new(0,-50,0)
                    else BV.Velocity=Vector3.new(0,0,0) end
                end
                wait(0.05)
            end
            if BV then BV:Destroy() end
        end)
    end
end)
MY=MY+40

CreateButton(MiscPage,"NOCLIP",MY,function()
    getgenv().Noclip=not getgenv().Noclip
    if getgenv().Noclip then
        spawn(function()
            while getgenv().Noclip do
                local Char=LocalPlayer.Character
                if Char then
                    for _,Part in pairs(Char:GetDescendants()) do
                        if Part:IsA("BasePart") then Part.CanCollide=false end
                    end
                end
                wait(0.1)
            end
        end)
    end
end)

-- Перетаскивание GUI (ПК и мобильный)
local Dragging=false
local DragStart=nil
local FrameStart=nil

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        Dragging=true DragStart=input.Position FrameStart=MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Dragging then
        local Delta=nil
        if input.UserInputType==Enum.UserInputType.MouseMovement then Delta=input.Position-DragStart
        elseif input.UserInputType==Enum.UserInputType.Touch then Delta=input.Position-DragStart end
        if Delta then MainFrame.Position=UDim2.new(FrameStart.X.Scale,FrameStart.X.Offset+Delta.X,FrameStart.Y.Scale,FrameStart.Y.Offset+Delta.Y) end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then Dragging=false end
end)

print("yeban.cc Violence District Script Loaded - Full Mobile/Delta Support")
