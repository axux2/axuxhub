-- Axex Hub | Custom UI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ==================== STATE ====================
local FlyEnabled = false
local FlySpeed = 50
local TPWalkEnabled = false
local TPWalkSpeed = 10
local SpeedEnabled = false
local SpeedValue = 16
local FlingEnabled = false
local NoFallEnabled = false
local InfJumpEnabled = false
local ESPEnabled = false
local ESPObjects = {}
local DefaultSpeed = 16
local flyConn, tpConn, tpNoclipConn, flingConn, jumpConn

-- ==================== KEY SYSTEM ====================
local VALID_KEY = "FREEFEMBOYS"

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "AxexKeySystem"
KeyGui.ResetOnSpawn = false
KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KeyGui.Parent = CoreGui

local KeyBG = Instance.new("Frame")
KeyBG.Size = UDim2.fromScale(1, 1)
KeyBG.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
KeyBG.BackgroundTransparency = 0
KeyBG.BorderSizePixel = 0
KeyBG.Parent = KeyGui

local KeyCard = Instance.new("Frame")
KeyCard.Size = UDim2.new(0, 380, 0, 260)
KeyCard.Position = UDim2.new(0.5, -190, 0.5, -130)
KeyCard.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
KeyCard.BorderSizePixel = 0
KeyCard.Parent = KeyBG
Instance.new("UICorner", KeyCard).CornerRadius = UDim.new(0, 16)

local KeyStroke = Instance.new("UIStroke", KeyCard)
KeyStroke.Color = Color3.fromRGB(120, 80, 255)
KeyStroke.Thickness = 1.5
KeyStroke.Transparency = 0.3

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 50)
KeyTitle.Position = UDim2.new(0, 0, 0, 20)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "AXEX HUB"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 26
KeyTitle.Parent = KeyCard

local KeySub = Instance.new("TextLabel")
KeySub.Size = UDim2.new(1, 0, 0, 20)
KeySub.Position = UDim2.new(0, 0, 0, 68)
KeySub.BackgroundTransparency = 1
KeySub.Text = "Enter your access key to continue"
KeySub.TextColor3 = Color3.fromRGB(120, 120, 150)
KeySub.Font = Enum.Font.Gotham
KeySub.TextSize = 13
KeySub.Parent = KeyCard

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -48, 0, 44)
KeyBox.Position = UDim2.new(0, 24, 0, 110)
KeyBox.BackgroundColor3 = Color3.fromRGB(18, 18, 30)
KeyBox.BorderSizePixel = 0
KeyBox.PlaceholderText = "Enter key..."
KeyBox.PlaceholderColor3 = Color3.fromRGB(80, 80, 110)
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(200, 200, 255)
KeyBox.Font = Enum.Font.GothamBold
KeyBox.TextSize = 14
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = KeyCard
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 10)
local KeyBoxStroke = Instance.new("UIStroke", KeyBox)
KeyBoxStroke.Color = Color3.fromRGB(80, 80, 120)
KeyBoxStroke.Thickness = 1

local KeyError = Instance.new("TextLabel")
KeyError.Size = UDim2.new(1, -48, 0, 20)
KeyError.Position = UDim2.new(0, 24, 0, 158)
KeyError.BackgroundTransparency = 1
KeyError.Text = ""
KeyError.TextColor3 = Color3.fromRGB(255, 80, 80)
KeyError.Font = Enum.Font.Gotham
KeyError.TextSize = 12
KeyError.TextXAlignment = Enum.TextXAlignment.Left
KeyError.Parent = KeyCard

local KeyBtn = Instance.new("TextButton")
KeyBtn.Size = UDim2.new(1, -48, 0, 44)
KeyBtn.Position = UDim2.new(0, 24, 0, 186)
KeyBtn.BackgroundColor3 = Color3.fromRGB(120, 80, 255)
KeyBtn.BorderSizePixel = 0
KeyBtn.Text = "UNLOCK"
KeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBtn.Font = Enum.Font.GothamBold
KeyBtn.TextSize = 14
KeyBtn.Parent = KeyCard
Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 10)

-- Never saves, always prompts fresh on every run
KeyBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == VALID_KEY then
        TweenService:Create(KeyBG, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(KeyCard, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        task.wait(0.45)
        KeyGui:Destroy()
        buildHub()
    else
        KeyError.Text = "Invalid key. Please try again."
        TweenService:Create(KeyBoxStroke, TweenInfo.new(0.1), {Color = Color3.fromRGB(255, 80, 80)}):Play()
        task.wait(1.5)
        KeyError.Text = ""
        TweenService:Create(KeyBoxStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(80, 80, 120)}):Play()
    end
end)

-- ==================== HUB UI ====================
function buildHub()

local HubGui = Instance.new("ScreenGui")
HubGui.Name = "AxexHub"
HubGui.ResetOnSpawn = false
HubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
HubGui.Parent = CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 520, 0, 560)
Main.Position = UDim2.new(0.5, -260, 0.5, -280)
Main.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = HubGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(100, 60, 240)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.2

local AccentBar = Instance.new("Frame")
AccentBar.Size = UDim2.new(1, 0, 0, 3)
AccentBar.BackgroundColor3 = Color3.fromRGB(120, 80, 255)
AccentBar.BorderSizePixel = 0
AccentBar.Parent = Main
Instance.new("UICorner", AccentBar).CornerRadius = UDim.new(0, 14)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 54)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = Main

local HubTitle = Instance.new("TextLabel")
HubTitle.Size = UDim2.new(0, 200, 1, 0)
HubTitle.Position = UDim2.new(0, 18, 0, 0)
HubTitle.BackgroundTransparency = 1
HubTitle.Text = "AXEX HUB"
HubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HubTitle.Font = Enum.Font.GothamBold
HubTitle.TextSize = 18
HubTitle.TextXAlignment = Enum.TextXAlignment.Left
HubTitle.Parent = TitleBar

local HubBadge = Instance.new("TextLabel")
HubBadge.Size = UDim2.new(0, 80, 0, 22)
HubBadge.Position = UDim2.new(0, 152, 0.5, -11)
HubBadge.BackgroundColor3 = Color3.fromRGB(120, 80, 255)
HubBadge.BorderSizePixel = 0
HubBadge.Text = "UNIVERSAL"
HubBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
HubBadge.Font = Enum.Font.GothamBold
HubBadge.TextSize = 10
HubBadge.Parent = TitleBar
Instance.new("UICorner", HubBadge).CornerRadius = UDim.new(0, 6)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -44, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)
CloseBtn.MouseButton1Click:Connect(function()
    HubGui:Destroy()
end)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -80, 0.5, -15)
MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
MinBtn.BorderSizePixel = 0
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(160, 160, 200)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 13
MinBtn.Parent = TitleBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
        Size = minimized and UDim2.new(0, 520, 0, 54) or UDim2.new(0, 520, 0, 560)
    }):Play()
end)

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, -36, 0, 1)
Divider.Position = UDim2.new(0, 18, 0, 54)
Divider.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
Divider.BorderSizePixel = 0
Divider.Parent = Main

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -62)
ScrollFrame.Position = UDim2.new(0, 0, 0, 62)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(120, 80, 255)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.Parent = Main

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.Parent = ScrollFrame

local ContentPad = Instance.new("UIPadding")
ContentPad.PaddingLeft = UDim.new(0, 18)
ContentPad.PaddingRight = UDim.new(0, 18)
ContentPad.PaddingTop = UDim.new(0, 14)
ContentPad.PaddingBottom = UDim.new(0, 14)
ContentPad.Parent = ScrollFrame

-- ==================== UI HELPERS ====================
local function SectionLabel(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 22)
    lbl.BackgroundTransparency = 1
    lbl.Text = text:upper()
    lbl.TextColor3 = Color3.fromRGB(120, 80, 255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = ScrollFrame
    return lbl
end

local rowOrder = 0
local function makeRow(name, desc)
    rowOrder += 1
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 58)
    row.BackgroundColor3 = Color3.fromRGB(14, 14, 24)
    row.BorderSizePixel = 0
    row.LayoutOrder = rowOrder
    row.Parent = ScrollFrame
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", row)
    stroke.Color = Color3.fromRGB(40, 40, 70)
    stroke.Thickness = 1

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.6, 0, 0, 22)
    nameLabel.Position = UDim2.new(0, 14, 0, 10)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(230, 230, 255)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = row

    if desc then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(0.7, 0, 0, 16)
        descLabel.Position = UDim2.new(0, 14, 0, 32)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = desc
        descLabel.TextColor3 = Color3.fromRGB(90, 90, 130)
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 11
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = row
    end

    return row
end

local function addToggle(row, defaultOn, callback)
    local togBG = Instance.new("Frame")
    togBG.Size = UDim2.new(0, 44, 0, 24)
    togBG.Position = UDim2.new(1, -58, 0.5, -12)
    togBG.BackgroundColor3 = defaultOn and Color3.fromRGB(120, 80, 255) or Color3.fromRGB(30, 30, 50)
    togBG.BorderSizePixel = 0
    togBG.Parent = row
    Instance.new("UICorner", togBG).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = defaultOn and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = togBG
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local on = defaultOn
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = togBG

    btn.MouseButton1Click:Connect(function()
        on = not on
        TweenService:Create(togBG, TweenInfo.new(0.2), {
            BackgroundColor3 = on and Color3.fromRGB(120, 80, 255) or Color3.fromRGB(30, 30, 50)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {
            Position = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        }):Play()
        callback(on)
    end)
end

local function addSliderRow(name, desc, min, max, default, callback)
    rowOrder += 1
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 72)
    row.BackgroundColor3 = Color3.fromRGB(14, 14, 24)
    row.BorderSizePixel = 0
    row.LayoutOrder = rowOrder
    row.Parent = ScrollFrame
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", row)
    stroke.Color = Color3.fromRGB(40, 40, 70)
    stroke.Thickness = 1

    local nameL = Instance.new("TextLabel")
    nameL.Size = UDim2.new(0.6, 0, 0, 20)
    nameL.Position = UDim2.new(0, 14, 0, 8)
    nameL.BackgroundTransparency = 1
    nameL.Text = name
    nameL.TextColor3 = Color3.fromRGB(200, 200, 240)
    nameL.Font = Enum.Font.Gotham
    nameL.TextSize = 13
    nameL.TextXAlignment = Enum.TextXAlignment.Left
    nameL.Parent = row

    local valL = Instance.new("TextLabel")
    valL.Size = UDim2.new(0.35, 0, 0, 20)
    valL.Position = UDim2.new(0.65, 0, 0, 8)
    valL.BackgroundTransparency = 1
    valL.Text = tostring(default)
    valL.TextColor3 = Color3.fromRGB(120, 80, 255)
    valL.Font = Enum.Font.GothamBold
    valL.TextSize = 13
    valL.TextXAlignment = Enum.TextXAlignment.Right
    valL.Parent = row

    local trackBG = Instance.new("Frame")
    trackBG.Size = UDim2.new(1, -28, 0, 6)
    trackBG.Position = UDim2.new(0, 14, 0, 44)
    trackBG.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    trackBG.BorderSizePixel = 0
    trackBG.Parent = row
    Instance.new("UICorner", trackBG).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(120, 80, 255)
    fill.BorderSizePixel = 0
    fill.Parent = trackBG
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local dragging = false
    trackBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = math.clamp((input.Position.X - trackBG.AbsolutePosition.X) / trackBG.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + rel * (max - min))
            fill.Size = UDim2.new(rel, 0, 1, 0)
            valL.Text = tostring(val)
            callback(val)
        end
    end)

    if desc then
        local dL = Instance.new("TextLabel")
        dL.Size = UDim2.new(0.6, 0, 0, 14)
        dL.Position = UDim2.new(0, 14, 0, 27)
        dL.BackgroundTransparency = 1
        dL.Text = desc
        dL.TextColor3 = Color3.fromRGB(80, 80, 120)
        dL.Font = Enum.Font.Gotham
        dL.TextSize = 11
        dL.TextXAlignment = Enum.TextXAlignment.Left
        dL.Parent = row
    end
end

-- ==================== TOGGLES ====================

SectionLabel("✦ Movement")

local flyRow = makeRow("Fly", "WASD + Space/Ctrl to fly")
addToggle(flyRow, false, function(val)
    FlyEnabled = val
    if val then
        local cam = workspace.CurrentCamera
        local bp = Instance.new("BodyPosition")
        local bg = Instance.new("BodyGyro")
        bp.MaxForce = Vector3.new(1e5,1e5,1e5)
        bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
        bg.P = 1e4
        bp.Parent = RootPart
        bg.Parent = RootPart
        Humanoid.PlatformStand = true
        flyConn = RunService.RenderStepped:Connect(function()
            if not FlyEnabled then return end
            local dir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
            if dir.Magnitude > 0 then dir = dir.Unit end
            bp.Position = RootPart.Position + dir * FlySpeed * 0.1
            bg.CFrame = cam.CFrame
        end)
    else
        if flyConn then flyConn:Disconnect() end
        for _, v in pairs({"BodyPosition","BodyGyro"}) do
            local o = RootPart:FindFirstChildOfClass(v)
            if o then o:Destroy() end
        end
        Humanoid.PlatformStand = false
    end
end)
addSliderRow("Fly Speed", nil, 1, 100, 50, function(v) FlySpeed = v end)

local tpRow = makeRow("TP Walk", "Camera-relative noclip teleport walk")
addToggle(tpRow, false, function(val)
    TPWalkEnabled = val
    if val then
        tpNoclipConn = RunService.Stepped:Connect(function()
            if not TPWalkEnabled then return end
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
        tpConn = RunService.RenderStepped:Connect(function()
            if not TPWalkEnabled then return end
            local cam = workspace.CurrentCamera
            local camFlat = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z).Unit
            local camRight = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z).Unit
            local mv = Humanoid.MoveDirection
            local forward = Vector3.new(mv.X, 0, mv.Z)
            local moveDir = camFlat * camFlat:Dot(forward) + camRight * camRight:Dot(forward)
            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit
                RootPart.CFrame = RootPart.CFrame + moveDir * TPWalkSpeed
                local _, ry, _ = CFrame.new(RootPart.Position, RootPart.Position + moveDir):ToEulerAnglesYXZ()
                RootPart.CFrame = CFrame.new(RootPart.Position) * CFrame.Angles(0, ry, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                RootPart.CFrame = RootPart.CFrame + Vector3.new(0, TPWalkSpeed * 0.5, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                RootPart.CFrame = RootPart.CFrame - Vector3.new(0, TPWalkSpeed * 0.5, 0)
            end
        end)
    else
        if tpConn then tpConn:Disconnect() end
        if tpNoclipConn then tpNoclipConn:Disconnect() end
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end)
addSliderRow("TP Walk Speed", nil, 1, 50, 10, function(v) TPWalkSpeed = v end)

local speedRow = makeRow("Speed", "Modify walk speed")
addToggle(speedRow, false, function(val)
    SpeedEnabled = val
    Humanoid.WalkSpeed = val and SpeedValue or DefaultSpeed
end)
addSliderRow("Walk Speed", nil, 1, 500, 16, function(v)
    SpeedValue = v
    if SpeedEnabled then Humanoid.WalkSpeed = v end
end)

SectionLabel("✦ Combat")

local flingRow = makeRow("Fling All", "Launch all players with force")
addToggle(flingRow, false, function(val)
    FlingEnabled = val
    if val then
        flingConn = RunService.Heartbeat:Connect(function()
            if not FlingEnabled then return end
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local root = plr.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local vel = Instance.new("BodyVelocity")
                        vel.Velocity = Vector3.new(math.random(-500,500), math.random(200,500), math.random(-500,500))
                        vel.MaxForce = Vector3.new(1e9,1e9,1e9)
                        vel.Parent = root
                        game:GetService("Debris"):AddItem(vel, 0.1)
                    end
                end
            end
        end)
    else
        if flingConn then flingConn:Disconnect() end
    end
end)

SectionLabel("✦ Misc")

local noFallRow = makeRow("No Fall Damage", "Disables fall damage state")
addToggle(noFallRow, false, function(val)
    NoFallEnabled = val
    if val then
        Humanoid.StateChanged:Connect(function(_, new)
            if new == Enum.HumanoidStateType.Freefall then
                Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            end
        end)
    else
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    end
end)

local infJumpRow = makeRow("Infinite Jump", "Jump anytime, anywhere")
addToggle(infJumpRow, false, function(val)
    InfJumpEnabled = val
    if val then
        jumpConn = UserInputService.JumpRequest:Connect(function()
            if InfJumpEnabled then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if jumpConn then jumpConn:Disconnect() end
    end
end)

SectionLabel("✦ Visuals")

local function createESP(player)
    if player == LocalPlayer then return end
    local folder = Instance.new("Folder")
    folder.Name = player.Name
    folder.Parent = CoreGui

    local function buildOnChar(char)
        for _, v in pairs(folder:GetChildren()) do v:Destroy() end
        local root = char:WaitForChild("HumanoidRootPart", 5)
        local head = char:FindFirstChild("Head")
        if not root then return end

        local bb = Instance.new("BillboardGui")
        bb.Adornee = root
        bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 60, 0, 90)
        bb.StudsOffset = Vector3.new(0, 1, 0)
        bb.Parent = folder

        local frame = Instance.new("Frame")
        frame.Size = UDim2.fromScale(1, 1)
        frame.BackgroundTransparency = 1
        frame.BorderSizePixel = 0
        frame.Parent = bb

        local function makeLine(pos, size, color)
            local l = Instance.new("Frame")
            l.BackgroundColor3 = color
            l.BorderSizePixel = 0
            l.Position = pos
            l.Size = size
            l.Parent = frame
        end
        local c = Color3.fromRGB(120, 80, 255)
        makeLine(UDim2.new(0,0,0,0),  UDim2.new(1,0,0,2),  c)
        makeLine(UDim2.new(0,0,1,-2), UDim2.new(1,0,0,2),  c)
        makeLine(UDim2.new(0,0,0,0),  UDim2.new(0,2,1,0),  c)
        makeLine(UDim2.new(1,-2,0,0), UDim2.new(0,2,1,0),  c)

        local nameBB = Instance.new("BillboardGui")
        nameBB.Adornee = head or root
        nameBB.AlwaysOnTop = true
        nameBB.Size = UDim2.new(0, 100, 0, 20)
        nameBB.StudsOffset = Vector3.new(0, 3.5, 0)
        nameBB.Parent = folder

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.fromScale(1, 1)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Parent = nameBB

        local distBB = Instance.new("BillboardGui")
        distBB.Adornee = root
        distBB.AlwaysOnTop = true
        distBB.Size = UDim2.new(0, 80, 0, 16)
        distBB.StudsOffset = Vector3.new(0, -1.5, 0)
        distBB.Parent = folder

        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.fromScale(1, 1)
        distLabel.BackgroundTransparency = 1
        distLabel.TextColor3 = Color3.fromRGB(180, 140, 255)
        distLabel.TextStrokeTransparency = 0
        distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        distLabel.TextScaled = true
        distLabel.Font = Enum.Font.Gotham
        distLabel.Parent = distBB

        local hpBB = Instance.new("BillboardGui")
        hpBB.Adornee = root
        hpBB.AlwaysOnTop = true
        hpBB.Size = UDim2.new(0, 6, 0, 90)
        hpBB.StudsOffset = Vector3.new(-2.2, 1, 0)
        hpBB.Parent = folder

        local hpBg = Instance.new("Frame")
        hpBg.Size = UDim2.fromScale(1, 1)
        hpBg.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        hpBg.BorderSizePixel = 0
        hpBg.Parent = hpBB

        local hpBar = Instance.new("Frame")
        hpBar.AnchorPoint = Vector2.new(0, 1)
        hpBar.Position = UDim2.fromScale(0, 1)
        hpBar.Size = UDim2.fromScale(1, 1)
        hpBar.BackgroundColor3 = Color3.fromRGB(120, 80, 255)
        hpBar.BorderSizePixel = 0
        hpBar.Parent = hpBg

        local hum = char:FindFirstChildOfClass("Humanoid")
        local updateConn = RunService.RenderStepped:Connect(function()
            if not ESPEnabled or not root or not root.Parent then return end
            local dist = math.floor((RootPart.Position - root.Position).Magnitude)
            distLabel.Text = dist .. " studs"
            if hum then
                local pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                hpBar.Size = UDim2.fromScale(1, pct)
                hpBar.BackgroundColor3 = Color3.fromRGB(
                    math.floor(255 * (1 - pct)),
                    math.floor(120 * pct),
                    math.floor(255 * pct)
                )
            end
        end)
        ESPObjects[player] = { folder = folder, conn = updateConn }
    end

    if player.Character then buildOnChar(player.Character) end
    player.CharacterAdded:Connect(buildOnChar)
end

local function removeESP(player)
    local obj = ESPObjects[player]
    if obj then
        if obj.conn then obj.conn:Disconnect() end
        if obj.folder then obj.folder:Destroy() end
        ESPObjects[player] = nil
    end
end
local function clearAllESP()
    for p in pairs(ESPObjects) do removeESP(p) end
end

local espRow = makeRow("ESP", "Box, name, distance & health bar")
addToggle(espRow, false, function(val)
    ESPEnabled = val
    if val then
        for _, plr in pairs(Players:GetPlayers()) do createESP(plr) end
        Players.PlayerAdded:Connect(function(plr) if ESPEnabled then createESP(plr) end end)
        Players.PlayerRemoving:Connect(removeESP)
    else
        clearAllESP()
    end
end)

-- ==================== RESPAWN HANDLER ====================
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
    FlyEnabled = false
    TPWalkEnabled = false
    SpeedEnabled = false
    FlingEnabled = false
    ESPEnabled = false
    clearAllESP()
end)

end -- end buildHub()
