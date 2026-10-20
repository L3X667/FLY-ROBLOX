local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local sharedEnv = _G
local envOk, executorEnv = pcall(function()
    if type(getgenv) == "function" then
        return getgenv()
    end
end)
if envOk and type(executorEnv) == "table" then
    sharedEnv = executorEnv
end

if type(sharedEnv.__CrezFlyCleanup) == "function" then
    pcall(sharedEnv.__CrezFlyCleanup)
end

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local Config = {
    enabled = false,
    speed = 50,
    minSpeed = 10,
    maxSpeed = 200,
    keyToggle = Enum.KeyCode.F
}

local guiParent = player:WaitForChild("PlayerGui")
pcall(function()
    if type(gethui) == "function" then
        local hiddenGui = gethui()
        if hiddenGui then
            guiParent = hiddenGui
        end
    end
end)

local oldGui = guiParent:FindFirstChild("CrezFlyPanel")
if oldGui then
    oldGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CrezFlyPanel"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 9999
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = guiParent

local function addCorner(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = object
    return corner
end

local function addStroke(object, color, thickness, transparency)
    local outline = Instance.new("UIStroke")
    outline.Color = color
    outline.Thickness = thickness
    outline.Transparency = transparency or 0
    outline.Parent = object
    return outline
end

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.fromOffset(320, 420)
panel.Position = UDim2.fromOffset(24, 80)
panel.BackgroundColor3 = Color3.fromRGB(17, 21, 32)
panel.BorderSizePixel = 0
panel.ClipsDescendants = true
panel.Active = true
panel.Parent = screenGui
addCorner(panel, 16)
addStroke(panel, Color3.fromRGB(73, 91, 125), 1.2, 0.2)

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 58)
header.BackgroundColor3 = Color3.fromRGB(42, 105, 205)
header.BorderSizePixel = 0
header.Active = true
header.Parent = panel
addCorner(header, 16)

local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new(
    Color3.fromRGB(57, 137, 245),
    Color3.fromRGB(39, 83, 180)
)
headerGradient.Rotation = 20
headerGradient.Parent = header

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Position = UDim2.fromOffset(17, 6)
title.Size = UDim2.new(1, -115, 0, 27)
title.BackgroundTransparency = 1
title.Text = "FLY PANEL"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 19
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Position = UDim2.fromOffset(18, 32)
subtitle.Size = UDim2.new(1, -115, 0, 16)
subtitle.BackgroundTransparency = 1
subtitle.Text = "FLIGHT CONTROL"
subtitle.TextColor3 = Color3.fromRGB(212, 228, 255)
subtitle.TextSize = 10
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.ZIndex = 3
subtitle.Parent = header

local hotkeyBadge = Instance.new("TextLabel")
hotkeyBadge.Name = "HotkeyBadge"
hotkeyBadge.Position = UDim2.new(1, -105, 0, 16)
hotkeyBadge.Size = UDim2.fromOffset(58, 26)
hotkeyBadge.BackgroundColor3 = Color3.fromRGB(20, 48, 105)
hotkeyBadge.BackgroundTransparency = 0.25
hotkeyBadge.BorderSizePixel = 0
hotkeyBadge.Text = "F  TOGGLE"
hotkeyBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
hotkeyBadge.TextSize = 9
hotkeyBadge.Font = Enum.Font.GothamBold
hotkeyBadge.ZIndex = 3
hotkeyBadge.Parent = header
addCorner(hotkeyBadge, 8)

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "Minimize"
minimizeButton.Position = UDim2.new(1, -41, 0, 14)
minimizeButton.Size = UDim2.fromOffset(28, 28)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.BackgroundTransparency = 0.82
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "−"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 20
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.AutoButtonColor = false
minimizeButton.ZIndex = 4
minimizeButton.Parent = header
addCorner(minimizeButton, 8)

local content = Instance.new("Frame")
content.Name = "Content"
content.Position = UDim2.new(0, 0, 0, 58)
content.Size = UDim2.new(1, 0, 1, -58)
content.BackgroundTransparency = 1
content.Parent = panel

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 16)
padding.PaddingRight = UDim.new(0, 16)
padding.PaddingTop = UDim.new(0, 14)
padding.PaddingBottom = UDim.new(0, 14)
padding.Parent = content

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 10)
layout.Parent = content

local enableButton = Instance.new("TextButton")
enableButton.Name = "EnableButton"
enableButton.LayoutOrder = 1
enableButton.Size = UDim2.new(1, 0, 0, 46)
enableButton.BackgroundColor3 = Color3.fromRGB(48, 83, 136)
enableButton.BorderSizePixel = 0
enableButton.Text = "▶   ACTIVER LE VOL"
enableButton.TextColor3 = Color3.fromRGB(255, 255, 255)
enableButton.TextSize = 14
enableButton.Font = Enum.Font.GothamBold
enableButton.AutoButtonColor = false
enableButton.Parent = content
addCorner(enableButton, 10)
addStroke(enableButton, Color3.fromRGB(126, 170, 237), 1, 0.4)

local enableGradient = Instance.new("UIGradient")
enableGradient.Color = ColorSequence.new(
    Color3.fromRGB(62, 108, 174),
    Color3.fromRGB(39, 69, 119)
)
enableGradient.Rotation = 0
enableGradient.Parent = enableButton

local speedRow = Instance.new("Frame")
speedRow.Name = "SpeedRow"
speedRow.LayoutOrder = 2
speedRow.Size = UDim2.new(1, 0, 0, 24)
speedRow.BackgroundTransparency = 1
speedRow.Parent = content

local speedTitle = Instance.new("TextLabel")
speedTitle.Size = UDim2.new(0.5, 0, 1, 0)
speedTitle.BackgroundTransparency = 1
speedTitle.Text = "VITESSE"
speedTitle.TextColor3 = Color3.fromRGB(171, 184, 207)
speedTitle.TextSize = 11
speedTitle.Font = Enum.Font.GothamBold
speedTitle.TextXAlignment = Enum.TextXAlignment.Left
speedTitle.Parent = speedRow

local speedValue = Instance.new("TextLabel")
speedValue.AnchorPoint = Vector2.new(1, 0)
speedValue.Position = UDim2.new(1, 0, 0, 0)
speedValue.Size = UDim2.new(0.5, 0, 1, 0)
speedValue.BackgroundTransparency = 1
speedValue.TextColor3 = Color3.fromRGB(121, 190, 255)
speedValue.TextSize = 12
speedValue.Font = Enum.Font.GothamBold
speedValue.TextXAlignment = Enum.TextXAlignment.Right
speedValue.Parent = speedRow

local speedTrack = Instance.new("Frame")
speedTrack.Name = "SpeedSlider"
speedTrack.LayoutOrder = 3
speedTrack.Size = UDim2.new(1, 0, 0, 16)
speedTrack.BackgroundColor3 = Color3.fromRGB(43, 51, 68)
speedTrack.BorderSizePixel = 0
speedTrack.Parent = content
addCorner(speedTrack, 8)

local speedFill = Instance.new("Frame")
speedFill.Name = "Fill"
speedFill.Size = UDim2.new(0, 0, 1, 0)
speedFill.BackgroundColor3 = Color3.fromRGB(76, 166, 255)
speedFill.BorderSizePixel = 0
speedFill.ZIndex = 2
speedFill.Parent = speedTrack
addCorner(speedFill, 8)

local speedKnob = Instance.new("Frame")
speedKnob.Name = "Knob"
speedKnob.AnchorPoint = Vector2.new(0.5, 0.5)
speedKnob.Position = UDim2.new(0, 0, 0.5, 0)
speedKnob.Size = UDim2.fromOffset(16, 16)
speedKnob.BackgroundColor3 = Color3.fromRGB(245, 249, 255)
speedKnob.BorderSizePixel = 0
speedKnob.ZIndex = 3
speedKnob.Parent = speedTrack
addCorner(speedKnob, 8)
addStroke(speedKnob, Color3.fromRGB(75, 156, 255), 1.5, 0)

local controlsCard = Instance.new("Frame")
controlsCard.Name = "Controls"
controlsCard.LayoutOrder = 4
controlsCard.Size = UDim2.new(1, 0, 0, 104)
controlsCard.BackgroundColor3 = Color3.fromRGB(27, 33, 47)
controlsCard.BorderSizePixel = 0
controlsCard.Parent = content
addCorner(controlsCard, 10)
addStroke(controlsCard, Color3.fromRGB(67, 78, 101), 1, 0.45)

local controlsTitle = Instance.new("TextLabel")
controlsTitle.Position = UDim2.fromOffset(12, 8)
controlsTitle.Size = UDim2.new(1, -24, 0, 18)
controlsTitle.BackgroundTransparency = 1
controlsTitle.Text = "COMMANDES"
controlsTitle.TextColor3 = Color3.fromRGB(121, 190, 255)
controlsTitle.TextSize = 10
controlsTitle.Font = Enum.Font.GothamBold
controlsTitle.TextXAlignment = Enum.TextXAlignment.Left
controlsTitle.Parent = controlsCard

local controlsText = Instance.new("TextLabel")
controlsText.Position = UDim2.fromOffset(12, 29)
controlsText.Size = UDim2.new(1, -24, 0, 65)
controlsText.BackgroundTransparency = 1
controlsText.Text = "Z / W  Avancer      Q / A  Gauche\nS  Reculer          D  Droite\nESPACE  Monter      SHIFT  Descendre"
controlsText.TextColor3 = Color3.fromRGB(184, 193, 210)
controlsText.TextSize = 11
controlsText.Font = Enum.Font.Gotham
controlsText.TextXAlignment = Enum.TextXAlignment.Left
controlsText.TextYAlignment = Enum.TextYAlignment.Top
controlsText.Parent = controlsCard

local statusCard = Instance.new("Frame")
statusCard.Name = "Status"
statusCard.LayoutOrder = 5
statusCard.Size = UDim2.new(1, 0, 0, 36)
statusCard.BackgroundColor3 = Color3.fromRGB(27, 33, 47)
statusCard.BorderSizePixel = 0
statusCard.Parent = content
addCorner(statusCard, 9)
addStroke(statusCard, Color3.fromRGB(67, 78, 101), 1, 0.45)

local statusDot = Instance.new("Frame")
statusDot.Position = UDim2.fromOffset(12, 13)
statusDot.Size = UDim2.fromOffset(10, 10)
statusDot.BackgroundColor3 = Color3.fromRGB(241, 96, 106)
statusDot.BorderSizePixel = 0
statusDot.Parent = statusCard
addCorner(statusDot, 5)

local statusLabel = Instance.new("TextLabel")
statusLabel.Position = UDim2.fromOffset(31, 0)
statusLabel.Size = UDim2.new(1, -74, 1, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "VOL DÉSACTIVÉ"
statusLabel.TextColor3 = Color3.fromRGB(190, 197, 210)
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = statusCard

local statusKey = Instance.new("TextLabel")
statusKey.AnchorPoint = Vector2.new(1, 0.5)
statusKey.Position = UDim2.new(1, -10, 0.5, 0)
statusKey.Size = UDim2.fromOffset(30, 22)
statusKey.BackgroundColor3 = Color3.fromRGB(43, 51, 68)
statusKey.BorderSizePixel = 0
statusKey.Text = "F"
statusKey.TextColor3 = Color3.fromRGB(205, 218, 239)
statusKey.TextSize = 11
statusKey.Font = Enum.Font.GothamBold
statusKey.Parent = statusCard
addCorner(statusKey, 6)

local footer = Instance.new("TextLabel")
footer.Name = "Footer"
footer.LayoutOrder = 6
footer.Size = UDim2.new(1, 0, 0, 18)
footer.BackgroundTransparency = 1
footer.Text = "MAINTIENS LE TITRE POUR DÉPLACER"
footer.TextColor3 = Color3.fromRGB(111, 123, 145)
footer.TextSize = 9
footer.Font = Enum.Font.GothamMedium
footer.TextXAlignment = Enum.TextXAlignment.Center
footer.Parent = content

local function setSpeed(value)
    Config.speed = math.clamp(
        math.floor(value + 0.5),
        Config.minSpeed,
        Config.maxSpeed
    )

    local ratio = (Config.speed - Config.minSpeed) / (Config.maxSpeed - Config.minSpeed)
    speedFill.Size = UDim2.new(ratio, 0, 1, 0)
    speedKnob.Position = UDim2.new(ratio, 0, 0.5, 0)
    speedValue.Text = tostring(Config.speed) .. " studs/s"
end

local function setSpeedFromX(x)
    local width = speedTrack.AbsoluteSize.X
    if width <= 0 then
        return
    end

    local ratio = math.clamp(
        (x - speedTrack.AbsolutePosition.X) / width,
        0,
        1
    )
    setSpeed(Config.minSpeed + ratio * (Config.maxSpeed - Config.minSpeed))
end

setSpeed(Config.speed)

local flying = false
local bodyVelocity = nil
local bodyGyro = nil
local savedPlatformStand = nil
local savedAutoRotate = nil
local diedConnection = nil
local minimized = false
local draggingPanel = false
local draggingSlider = false
local dragStart = nil
local panelStart = nil
local connections = {}

local keys = {
    forward = false,
    backward = false,
    left = false,
    right = false,
    up = false,
    down = false
}

local function refreshUI()
    Config.enabled = flying

    if flying then
        enableButton.Text = "■   ARRÊTER LE VOL"
        enableGradient.Color = ColorSequence.new(
            Color3.fromRGB(43, 168, 127),
            Color3.fromRGB(29, 112, 91)
        )
        statusDot.BackgroundColor3 = Color3.fromRGB(86, 224, 151)
        statusLabel.Text = "VOL ACTIF"
        statusLabel.TextColor3 = Color3.fromRGB(130, 230, 172)
    else
        enableButton.Text = "▶   ACTIVER LE VOL"
        enableGradient.Color = ColorSequence.new(
            Color3.fromRGB(62, 108, 174),
            Color3.fromRGB(39, 69, 119)
        )
        statusDot.BackgroundColor3 = Color3.fromRGB(241, 96, 106)
        statusLabel.Text = "VOL DÉSACTIVÉ"
        statusLabel.TextColor3 = Color3.fromRGB(190, 197, 210)
    end
end

local function stopFly()
    local wasActive = flying or bodyVelocity ~= nil or bodyGyro ~= nil

    flying = false
    Config.enabled = false

    for key in pairs(keys) do
        keys[key] = false
    end

    if bodyVelocity then
        pcall(function()
            bodyVelocity:Destroy()
        end)
        bodyVelocity = nil
    end

    if bodyGyro then
        pcall(function()
            bodyGyro:Destroy()
        end)
        bodyGyro = nil
    end

    if wasActive and humanoid and humanoid.Parent then
        pcall(function()
            if savedPlatformStand ~= nil then
                humanoid.PlatformStand = savedPlatformStand
            end
            if savedAutoRotate ~= nil then
                humanoid.AutoRotate = savedAutoRotate
            end
            if humanoid.Health > 0 and savedPlatformStand ~= true then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
    end

    savedPlatformStand = nil
    savedAutoRotate = nil
    refreshUI()
end

local function startFly()
    if flying then
        return
    end

    if not humanoid
        or humanoid.Health <= 0
        or not rootPart
        or not rootPart.Parent
    then
        statusLabel.Text = "PERSONNAGE INDISPONIBLE"
        statusLabel.TextColor3 = Color3.fromRGB(241, 145, 112)
        return
    end

    savedPlatformStand = humanoid.PlatformStand
    savedAutoRotate = humanoid.AutoRotate

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "CrezFlyVelocity"
    bodyVelocity.MaxForce = Vector3.new(1000000000, 1000000000, 1000000000)
    bodyVelocity.P = 12500
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Name = "CrezFlyGyro"
    bodyGyro.MaxTorque = Vector3.new(1000000000, 1000000000, 1000000000)
    bodyGyro.P = 9000
    bodyGyro.D = 600
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart

    humanoid.PlatformStand = true
    humanoid.AutoRotate = false
    pcall(function()
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    end)

    flying = true
    refreshUI()
end

local function toggleFly()
    if flying then
        stopFly()
    else
        startFly()
    end
end

local function bindCharacter(newCharacter)
    if diedConnection then
        diedConnection:Disconnect()
        diedConnection = nil
    end

    character = newCharacter
    humanoid = newCharacter:WaitForChild("Humanoid")
    rootPart = newCharacter:WaitForChild("HumanoidRootPart")

    diedConnection = humanoid.Died:Connect(stopFly)
    refreshUI()
end

bindCharacter(character)

local keyActions = {
    [Enum.KeyCode.W] = "forward",
    [Enum.KeyCode.Z] = "forward",
    [Enum.KeyCode.Up] = "forward",

    [Enum.KeyCode.S] = "backward",
    [Enum.KeyCode.Down] = "backward",

    [Enum.KeyCode.A] = "left",
    [Enum.KeyCode.Q] = "left",
    [Enum.KeyCode.Left] = "left",

    [Enum.KeyCode.D] = "right",
    [Enum.KeyCode.Right] = "right",

    [Enum.KeyCode.Space] = "up",
    [Enum.KeyCode.LeftShift] = "down",
    [Enum.KeyCode.RightShift] = "down"
}

local function track(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(connections, connection)
    return connection
end

local function pointInside(guiObject, position)
    local guiPosition = guiObject.AbsolutePosition
    local guiSize = guiObject.AbsoluteSize

    return position.X >= guiPosition.X
        and position.X <= guiPosition.X + guiSize.X
        and position.Y >= guiPosition.Y
        and position.Y <= guiPosition.Y + guiSize.Y
end

track(player.CharacterAdded, function(newCharacter)
    stopFly()
    bindCharacter(newCharacter)
end)

track(enableButton.Activated, toggleFly)

track(minimizeButton.Activated, function()
    minimized = not minimized
    content.Visible = not minimized
    minimizeButton.Text = minimized and "+" or "−"

    local targetSize = minimized
        and UDim2.fromOffset(320, 58)
        or UDim2.fromOffset(320, 420)

    TweenService:Create(
        panel,
        TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        { Size = targetSize }
    ):Play()
end)

track(UserInputService.InputBegan, function(input, gameProcessed)
    local inputType = input.UserInputType

    if inputType == Enum.UserInputType.MouseButton1
        or inputType == Enum.UserInputType.Touch
    then
        local position = input.Position

        if not minimized and content.Visible and pointInside(speedTrack, position) then
            draggingSlider = true
            setSpeedFromX(position.X)
            return
        end

        if pointInside(header, position) then
            local headerRight = header.AbsolutePosition.X + header.AbsoluteSize.X
            if position.X < headerRight - 48 then
                draggingPanel = true
                dragStart = position
                panelStart = panel.Position
            end
        end

        return
    end

    if gameProcessed or UserInputService:GetFocusedTextBox() then
        return
    end

    if input.KeyCode == Config.keyToggle then
        toggleFly()
        return
    end

    if flying then
        local action = keyActions[input.KeyCode]
        if action then
            keys[action] = true
        end
    end
end)

track(UserInputService.InputChanged, function(input)
    local inputType = input.UserInputType

    if inputType ~= Enum.UserInputType.MouseMovement
        and inputType ~= Enum.UserInputType.Touch
    then
        return
    end

    if draggingSlider and not minimized then
        setSpeedFromX(input.Position.X)
    end

    if draggingPanel and dragStart and panelStart then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(
            panelStart.X.Scale,
            panelStart.X.Offset + delta.X,
            panelStart.Y.Scale,
            panelStart.Y.Offset + delta.Y
        )
    end
end)

track(UserInputService.InputEnded, function(input)
    local inputType = input.UserInputType

    if inputType == Enum.UserInputType.MouseButton1
        or inputType == Enum.UserInputType.Touch
    then
        draggingPanel = false
        draggingSlider = false
        dragStart = nil
        panelStart = nil
    end

    local action = keyActions[input.KeyCode]
    if action then
        keys[action] = false
    end
end)

track(RunService.Heartbeat, function()
    if not flying then
        return
    end

    if not humanoid
        or humanoid.Health <= 0
        or not rootPart
        or not rootPart.Parent
        or not bodyVelocity
        or not bodyGyro
    then
        stopFly()
        return
    end

    local camera = workspace.CurrentCamera
    if not camera then
        return
    end

    local cameraCFrame = camera.CFrame
    local moveDirection = Vector3.new(0, 0, 0)

    if keys.forward then
        moveDirection = moveDirection + cameraCFrame.LookVector
    end
    if keys.backward then
        moveDirection = moveDirection - cameraCFrame.LookVector
    end
    if keys.right then
        moveDirection = moveDirection + cameraCFrame.RightVector
    end
    if keys.left then
        moveDirection = moveDirection - cameraCFrame.RightVector
    end
    if keys.up then
        moveDirection = moveDirection + Vector3.new(0, 1, 0)
    end
    if keys.down then
        moveDirection = moveDirection - Vector3.new(0, 1, 0)
    end

    if moveDirection.Magnitude > 1 then
        moveDirection = moveDirection.Unit
    end

    bodyVelocity.Velocity = moveDirection * Config.speed

    local lookVector = cameraCFrame.LookVector
    local flatLook = Vector3.new(lookVector.X, 0, lookVector.Z)

    if flatLook.Magnitude > 0.001 then
        bodyGyro.CFrame = CFrame.lookAt(
            rootPart.Position,
            rootPart.Position + flatLook.Unit,
            Vector3.new(0, 1, 0)
        )
    end
end)

local cleaned = false
local cleanup

cleanup = function()
    if cleaned then
        return
    end
    cleaned = true

    stopFly()

    if diedConnection then
        diedConnection:Disconnect()
        diedConnection = nil
    end

    for _, connection in ipairs(connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end

    if screenGui and screenGui.Parent then
        screenGui:Destroy()
    end

    if sharedEnv.__CrezFlyCleanup == cleanup then
        sharedEnv.__CrezFlyCleanup = nil
    end
end

sharedEnv.__CrezFlyCleanup = cleanup
