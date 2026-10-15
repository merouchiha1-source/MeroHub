-- ====================================================
-- سكربت Mero Uchiha Hub | متحرك، قابل للتصغير، وسرعة مخصصة
-- ====================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

-- نسخ رابط الديسكورد تلقائياً للحافظة
pcall(function()
    if setclipboard then
        setclipboard("https://discord.gg/E7BTbVBsGy")
    end
    StarterGui:SetCore("SendNotification", {
        Title = "📋 Discord Copied!",
        Text = "تم نسخ رابط سيرفر الديسكورد تلقائياً!",
        Duration = 5
    })
end)

local SpeedActive = false
local InfJumpActive = false
local SpeedMultiplier = 1.5
local isMinimized = false

-- بناء الواجهة
if CoreGui:FindFirstChild("MeroSpeedHub") then
    CoreGui.MeroSpeedHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MeroSpeedHub"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -115)
MainFrame.Size = UDim2.new(0, 280, 0, 225)
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(138, 43, 226)
MainStroke.Thickness = 2

local TitleFrame = Instance.new("Frame")
TitleFrame.Parent = MainFrame
TitleFrame.BackgroundColor3 = Color3.fromRGB(30, 33, 45)
TitleFrame.Size = UDim2.new(1, 0, 0, 40)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TitleFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Size = UDim2.new(1, -60, 1, 0)
TitleLabel.Font = Enum.Font.FredokaOne
TitleLabel.Text = "⚡ Mero Uchiha Hub"
TitleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- زر التصغير والتكبير (-)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = TitleFrame
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 48, 65)
MinimizeBtn.Position = UDim2.new(1, -35, 0.5, -14)
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 16

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

-- محتوى القائمة (الأزرار والخانة)
local ContentHolder = Instance.new("Frame")
ContentHolder.Parent = MainFrame
ContentHolder.BackgroundTransparency = 1
ContentHolder.Position = UDim2.new(0, 0, 0, 40)
ContentHolder.Size = UDim2.new(1, 0, 1, -40)

-- خانة إدخال رقم السرعة
local SpeedBox = Instance.new("TextBox")
SpeedBox.Parent = ContentHolder
SpeedBox.BackgroundColor3 = Color3.fromRGB(35, 38, 52)
SpeedBox.Position = UDim2.new(0, 15, 0, 15)
SpeedBox.Size = UDim2.new(1, -30, 0, 40)
SpeedBox.Font = Enum.Font.GothamBold
SpeedBox.PlaceholderText = "اكتب رقم السرعة (مثال: 2)"
SpeedBox.Text = tostring(SpeedMultiplier)
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SpeedBox.TextSize = 14

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 8)
BoxCorner.Parent = SpeedBox

-- زر تفعيل وإيقاف السرعة
local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Parent = ContentHolder
SpeedBtn.BackgroundColor3 = Color3.fromRGB(35, 38, 52)
SpeedBtn.Position = UDim2.new(0, 15, 0, 65)
SpeedBtn.Size = UDim2.new(1, -30, 0, 40)
SpeedBtn.Font = Enum.Font.GothamBold
SpeedBtn.Text = "  تشغيل السرعة ⚡"
SpeedBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
SpeedBtn.TextSize = 14
SpeedBtn.TextXAlignment = Enum.TextXAlignment.Left

local BtnUICorner1 = Instance.new("UICorner")
BtnUICorner1.CornerRadius = UDim.new(0, 8)
BtnUICorner1.Parent = SpeedBtn

-- زر القفز اللانهائي
local InfJumpBtn = Instance.new("TextButton")
InfJumpBtn.Parent = ContentHolder
InfJumpBtn.BackgroundColor3 = Color3.fromRGB(35, 38, 52)
InfJumpBtn.Position = UDim2.new(0, 15, 0, 115)
InfJumpBtn.Size = UDim2.new(1, -30, 0, 40)
InfJumpBtn.Font = Enum.Font.GothamBold
InfJumpBtn.Text = "  قفز لانهائي 🦘"
InfJumpBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
InfJumpBtn.TextSize = 14
InfJumpBtn.TextXAlignment = Enum.TextXAlignment.Left

local BtnUICorner2 = Instance.new("UICorner")
BtnUICorner2.CornerRadius = UDim.new(0, 8)
BtnUICorner2.Parent = InfJumpBtn

-- منطق التصغير والتكبير
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MinimizeBtn.Text = "+"
        MainFrame:TweenSize(UDim2.new(0, 280, 0, 40), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        ContentHolder.Visible = false
    else
        MinimizeBtn.Text = "-"
        ContentHolder.Visible = true
        MainFrame:TweenSize(UDim2.new(0, 280, 0, 225), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
    end
end)

-- خاصية سحب وإفلات النافذة (Draggable)
local dragging, dragInput, dragStart, startPos

TitleFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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

TitleFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- تحديث قيمة السرعة
SpeedBox.FocusLost:Connect(function(enterPressed)
    local val = tonumber(SpeedBox.Text)
    if val then
        SpeedMultiplier = val
    else
        SpeedBox.Text = tostring(SpeedMultiplier)
    end
end)

SpeedBtn.MouseButton1Click:Connect(function()
    SpeedActive = not SpeedActive
    local val = tonumber(SpeedBox.Text)
    if val then SpeedMultiplier = val end
    
    if SpeedActive then
        SpeedBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
        SpeedBtn.Text = "  السرعة [شغال: " .. SpeedMultiplier .. "] ⚡"
    else
        SpeedBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
        SpeedBtn.Text = "  تشغيل السرعة [متوقف] ⚡"
    end
end)

InfJumpBtn.MouseButton1Click:Connect(function()
    InfJumpActive = not InfJumpActive
    if InfJumpActive then
        InfJumpBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
        InfJumpBtn.Text = "  قفز لانهائي [شغال] 🦘"
    else
        InfJumpBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
        InfJumpBtn.Text = "  قفز لانهائي [متوقف] 🦘"
    end
end)

-- تنفيذ السرعة
RunService.Heartbeat:Connect(function()
    if SpeedActive then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                if hum and root and hum.MoveDirection.Magnitude > 0 then
                    root.CFrame = root.CFrame + (hum.MoveDirection * SpeedMultiplier * 0.3)
                end
            end
        end)
    end
end)

-- تنفيذ القفز اللانهائي
UserInputService.JumpRequest:Connect(function()
    if InfJumpActive then
        pcall(function:Connect()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    end
end)
