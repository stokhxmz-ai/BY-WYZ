-- ===== BANNER BY WYZ =====
print([[
  ____   __   __  __      __  ______  ____
 | __ )  \ \ / /  \ \    / / |__  /  |___ \
 |  _ \   \ V /    \ \  / /    / /     __) |
 | |_) |   | |      \ \/ /    / /_    / __/
 |____/    |_|       \__/    /____|  |_____|

                BY WYZ
]])

-- ===== SERVICE =====
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ===== WHITELIST =====
local AUTHORIZED_USERNAMES = {}
local function isAuthorized(username)
    if #AUTHORIZED_USERNAMES == 0 then return true end
    for _, name in ipairs(AUTHORIZED_USERNAMES) do
        if string.lower(name) == string.lower(username) then return true end
    end
    return false
end
if not isAuthorized(player.Name) then
    warn("[Terrain Tools] Kamu tidak punya akses.")
    return
end

-- ===== TERRAIN =====
local Terrain = workspace.Terrain

local function doTerrainFill(shape, position, size, radius, height, material, color)
    if material and color then
        if material == Enum.Material.Water then
            Terrain.WaterColor = color
        else
            pcall(function() Terrain:SetMaterialColor(material, color) end)
        end
    end
    if shape == "Block" then
        Terrain:FillBlock(CFrame.new(position), size, material)
    elseif shape == "Ball" then
        Terrain:FillBall(position, radius, material)
    elseif shape == "Cylinder" then
        Terrain:FillCylinder(CFrame.new(position), height, radius, material)
    end
end

local function doTerrainErase(shape, position, size, radius)
    if shape == "Ball" then
        Terrain:FillBall(position, radius, Enum.Material.Air)
    else
        Terrain:FillBlock(CFrame.new(position), size, Enum.Material.Air)
    end
end

-- ===== MATERIALS =====
local MATERIALS = {
    {name = "Grass", material = Enum.Material.Grass, shades = {
        Color3.fromRGB(86, 171, 47), Color3.fromRGB(120, 190, 33), Color3.fromRGB(60, 140, 60),
        Color3.fromRGB(155, 200, 60), Color3.fromRGB(34, 120, 60), Color3.fromRGB(150, 180, 90),
        Color3.fromRGB(45, 100, 45), Color3.fromRGB(100, 160, 80), Color3.fromRGB(180, 210, 100),
        Color3.fromRGB(70, 130, 50),
    }},
    {name = "Rock", material = Enum.Material.Rock, shades = {
        Color3.fromRGB(120, 113, 108), Color3.fromRGB(90, 90, 92), Color3.fromRGB(160, 160, 160),
        Color3.fromRGB(70, 70, 74), Color3.fromRGB(140, 130, 120), Color3.fromRGB(110, 100, 95),
        Color3.fromRGB(180, 175, 170), Color3.fromRGB(60, 60, 65), Color3.fromRGB(150, 140, 130),
        Color3.fromRGB(100, 105, 110),
    }},
    {name = "Ground", material = Enum.Material.Ground, shades = {
        Color3.fromRGB(101, 67, 33), Color3.fromRGB(139, 90, 43), Color3.fromRGB(160, 120, 80),
        Color3.fromRGB(87, 58, 30), Color3.fromRGB(120, 80, 50), Color3.fromRGB(180, 140, 100),
        Color3.fromRGB(70, 45, 25), Color3.fromRGB(150, 100, 60), Color3.fromRGB(110, 70, 40),
        Color3.fromRGB(200, 160, 120),
    }},
    {name = "Pavement", material = Enum.Material.Pavement, shades = {
        Color3.fromRGB(160, 160, 160), Color3.fromRGB(190, 190, 190), Color3.fromRGB(130, 130, 130),
        Color3.fromRGB(210, 210, 210), Color3.fromRGB(100, 100, 105), Color3.fromRGB(170, 165, 160),
        Color3.fromRGB(80, 80, 85), Color3.fromRGB(150, 150, 155), Color3.fromRGB(220, 220, 215),
        Color3.fromRGB(115, 115, 118),
    }},
    {name = "Sand", material = Enum.Material.Sand, shades = {
        Color3.fromRGB(237, 201, 175), Color3.fromRGB(222, 184, 135), Color3.fromRGB(244, 217, 165),
        Color3.fromRGB(210, 170, 120), Color3.fromRGB(250, 230, 190), Color3.fromRGB(195, 155, 105),
        Color3.fromRGB(230, 195, 150), Color3.fromRGB(180, 140, 90), Color3.fromRGB(245, 225, 200),
        Color3.fromRGB(200, 180, 140),
    }},
    {name = "Water", material = Enum.Material.Water, shades = {
        Color3.fromRGB(59, 130, 246), Color3.fromRGB(14, 116, 144), Color3.fromRGB(56, 189, 248),
        Color3.fromRGB(30, 64, 175), Color3.fromRGB(6, 182, 212), Color3.fromRGB(37, 99, 235),
        Color3.fromRGB(103, 232, 249), Color3.fromRGB(29, 78, 216), Color3.fromRGB(125, 211, 252),
        Color3.fromRGB(8, 47, 73),
    }},
    {name = "Ice", material = Enum.Material.Ice, shades = {
        Color3.fromRGB(200, 240, 245), Color3.fromRGB(224, 247, 250), Color3.fromRGB(178, 235, 242),
        Color3.fromRGB(165, 220, 230), Color3.fromRGB(210, 245, 250), Color3.fromRGB(140, 210, 220),
        Color3.fromRGB(235, 250, 252), Color3.fromRGB(120, 195, 210), Color3.fromRGB(190, 230, 235),
        Color3.fromRGB(150, 200, 215),
    }},
    {name = "Lava", material = Enum.Material.CrackedLava, shades = {
        Color3.fromRGB(255, 80, 20), Color3.fromRGB(220, 40, 10), Color3.fromRGB(255, 140, 30),
        Color3.fromRGB(180, 20, 10), Color3.fromRGB(255, 170, 60), Color3.fromRGB(150, 15, 10),
        Color3.fromRGB(255, 100, 40), Color3.fromRGB(255, 200, 80), Color3.fromRGB(200, 30, 15),
        Color3.fromRGB(120, 10, 5),
    }},
}

local SHAPES = {"Block", "Ball", "Cylinder"}

local state = {
    materialIndex = 1, colorIndex = 1, shape = "Block",
    brushSize = 6, eraseMode = false, toolActive = false, actions = {},
}

local function currentMaterialData() return MATERIALS[state.materialIndex] end
local function currentColor() return currentMaterialData().shades[state.colorIndex] end

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    obj.Parent = parent
    return obj
end
local function corner(obj, radius)
    make("UICorner", {CornerRadius = UDim.new(0, radius or 6)}, obj)
end

-- ===== CODE GENERATOR =====
local function materialCodeName(mat)
    return "Enum.Material." .. mat.Name
end
local function colorCode(c)
    return string.format("Color3.fromRGB(%d, %d, %d)", math.round(c.R * 255), math.round(c.G * 255), math.round(c.B * 255))
end

function regenerateCode()
    local lines = {
        "-- ================================================",
        "-- TERRAIN SCRIPT (generated by Terrain Tools by Wyz Verse)",
        "-- Taruh script ini di ServerScriptService",
        "-- ================================================",
        "local Terrain = workspace.Terrain",
        "",
    }
    local lastColorForMaterial = {}
    for _, action in ipairs(state.actions) do
        if action.type == "fill" then
            local matCode = materialCodeName(action.material)
            if lastColorForMaterial[action.material] ~= action.color then
                if action.material == Enum.Material.Water then
                    table.insert(lines, string.format("Terrain.WaterColor = %s", colorCode(action.color)))
                else
                    table.insert(lines, string.format("Terrain:SetMaterialColor(%s, %s)", matCode, colorCode(action.color)))
                end
                lastColorForMaterial[action.material] = action.color
            end
            if action.shape == "Block" then
                table.insert(lines, string.format(
                    "Terrain:FillBlock(CFrame.new(%.1f, %.1f, %.1f), Vector3.new(%.1f, %.1f, %.1f), %s)",
                    action.position.X, action.position.Y, action.position.Z,
                    action.size.X, action.size.Y, action.size.Z, matCode))
            elseif action.shape == "Ball" then
                table.insert(lines, string.format(
                    "Terrain:FillBall(Vector3.new(%.1f, %.1f, %.1f), %.1f, %s)",
                    action.position.X, action.position.Y, action.position.Z, action.radius, matCode))
            elseif action.shape == "Cylinder" then
                table.insert(lines, string.format(
                    "Terrain:FillCylinder(CFrame.new(%.1f, %.1f, %.1f), %.1f, %.1f, %s)",
                    action.position.X, action.position.Y, action.position.Z, action.height, action.radius, matCode))
            end
        elseif action.type == "erase" then
            if action.shape == "Ball" then
                table.insert(lines, string.format(
                    "Terrain:FillBall(Vector3.new(%.1f, %.1f, %.1f), %.1f, Enum.Material.Air)",
                    action.position.X, action.position.Y, action.position.Z, action.radius))
            else
                table.insert(lines, string.format(
                    "Terrain:FillBlock(CFrame.new(%.1f, %.1f, %.1f), Vector3.new(%.1f, %.1f, %.1f), Enum.Material.Air)",
                    action.position.X, action.position.Y, action.position.Z,
                    action.size.X, action.size.Y, action.size.Z))
            end
        end
    end
    return table.concat(lines, "\n")
end

-- ===== AUTO-COPY =====
local function autoCopyToClipboard(text)
    if setclipboard then setclipboard(text); return true
    elseif toclipboard then toclipboard(text); return true
    elseif syn and syn.write_clipboard then syn.write_clipboard(text); return true
    end
    return false
end

-- ===== GUI =====
local screenGui = make("ScreenGui", {
    Name = "TerrainToolsGui", ResetOnSpawn = false, IgnoreGuiInset = true,
}, player:WaitForChild("PlayerGui"))

local camera = workspace.CurrentCamera
local baseScale = 1
local function updateScale()
    local viewport = camera and camera.ViewportSize or Vector2.new(1600, 720)
    baseScale = math.clamp(viewport.Y / 720, 0.7, 1.1)
end
updateScale()
if camera then camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale) end

-- ===== LAMPU SVG (CUMA PAKE FRAME + EMOJI) =====
local lampContainer = make("Frame", {
    Size = UDim2.new(0, 280, 0, 400),
    Position = UDim2.new(0.5, -140, 0.5, -200),
    BackgroundTransparency = 1,
}, screenGui)

-- Shade (mushroom)
local shade = make("Frame", {
    Size = UDim2.new(0, 200, 0, 100),
    Position = UDim2.new(0.5, -100, 0, 50),
    BackgroundColor3 = Color3.fromRGB(245, 240, 230),
    BorderSizePixel = 0,
}, lampContainer)
corner(shade, 100)

-- Base (tiang)
local base = make("Frame", {
    Size = UDim2.new(0, 20, 0, 180),
    Position = UDim2.new(0.5, -10, 0, 150),
    BackgroundColor3 = Color3.fromRGB(209, 204, 194),
    BorderSizePixel = 0,
}, lampContainer)
corner(base, 10)

-- Base bawah
local baseBottom = make("Frame", {
    Size = UDim2.new(0, 100, 0, 14),
    Position = UDim2.new(0.5, -50, 0, 320),
    BackgroundColor3 = Color3.fromRGB(209, 204, 194),
    BorderSizePixel = 0,
}, lampContainer)
corner(baseBottom, 7)

-- Cord (tali)
local cord = make("Frame", {
    Size = UDim2.new(0, 3, 0, 80),
    Position = UDim2.new(0.5, 40, 0, 130),
    BackgroundColor3 = Color3.fromRGB(85, 85, 85),
    BorderSizePixel = 0,
}, lampContainer)

-- Cord bead (buat ditarik)
local cordBead = make("TextButton", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(0.5, 27, 0, 200),
    BackgroundColor3 = Color3.fromRGB(212, 163, 115),
    BorderSizePixel = 0,
    Text = "",
    AutoButtonColor = false,
}, lampContainer)
corner(cordBead, 15)

-- Hint text
local hint = make("TextLabel", {
    Size = UDim2.new(0, 400, 0, 30),
    Position = UDim2.new(0.5, -200, 0, 20),
    BackgroundTransparency = 1,
    Text = "TARIK LAMPU UNTUK MEMBUKA MENU",
    TextColor3 = Color3.fromRGB(212, 175, 55),
    TextSize = 14,
    Font = Enum.Font.GothamBold,
}, screenGui)

-- ===== TOMBOL TERRAIN TOOLS (awalnya hidden) =====
local toolsBtn = make("TextButton", {
    Size = UDim2.new(0, 180, 0, 50),
    Position = UDim2.new(0.5, -90, 0, 20),
    BackgroundColor3 = Color3.fromRGB(19, 20, 25),
    BorderSizePixel = 0,
    Text = "",
    AutoButtonColor = false,
    Visible = false,
}, screenGui)
corner(toolsBtn, 14)

local btnStroke = make("UIStroke", {Thickness = 2, Color = Color3.fromRGB(212, 175, 55)}, toolsBtn)

make("TextLabel", {
    Size = UDim2.new(0, 30, 1, 0),
    Position = UDim2.new(0, 12, 0, 0),
    BackgroundTransparency = 1,
    Text = "👑",
    TextSize = 22,
    Font = Enum.Font.GothamBold,
}, toolsBtn)

make("TextLabel", {
    Size = UDim2.new(1, -50, 1, 0),
    Position = UDim2.new(0, 45, 0, 0),
    BackgroundTransparency = 1,
    Text = "TERRAIN TOOLS",
    TextColor3 = Color3.fromRGB(212, 175, 55),
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
}, toolsBtn)

-- ===== PANEL =====
local panel = make("Frame", {
    Size = UDim2.new(0, 280, 0, 540),
    Position = UDim2.new(0.5, -140, 0.5, -270),
    BackgroundColor3 = Color3.fromRGB(19, 20, 25),
    BorderSizePixel = 0,
    Visible = false,
    AnchorPoint = Vector2.new(0.5, 0.5),
}, screenGui)
corner(panel, 16)
make("UIStroke", {Thickness = 2, Color = Color3.fromRGB(212, 175, 55)}, panel)

-- Header
local header = make("Frame", {
    Size = UDim2.new(1, 0, 0, 52),
    BackgroundColor3 = Color3.fromRGB(30, 30, 38),
    BorderSizePixel = 0,
}, panel)
corner(header, 16)
make("Frame", {
    Size = UDim2.new(1, 0, 0, 10),
    Position = UDim2.new(0, 0, 1, -10),
    BackgroundColor3 = Color3.fromRGB(30, 30, 38),
    BorderSizePixel = 0,
}, header)

make("TextLabel", {
    Size = UDim2.new(0, 30, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    Text = "👑",
    TextSize = 18,
    Font = Enum.Font.GothamBold,
}, header)

make("TextLabel", {
    Size = UDim2.new(1, -110, 1, 0),
    Position = UDim2.new(0, 45, 0, 0),
    BackgroundTransparency = 1,
    Text = "Terrain Tools",
    TextColor3 = Color3.fromRGB(212, 175, 55),
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
}, header)

local minBtn = make("TextButton", {
    Size = UDim2.new(0, 28, 0, 28),
    Position = UDim2.new(1, -70, 0.5, -14),
    BackgroundColor3 = Color3.fromRGB(45, 45, 55),
    BorderSizePixel = 0,
    Text = "—",
    TextColor3 = Color3.fromRGB(212, 175, 55),
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
}, header)
corner(minBtn, 7)

local closeBtn = make("TextButton", {
    Size = UDim2.new(0, 28, 0, 28),
    Position = UDim2.new(1, -38, 0.5, -14),
    BackgroundColor3 = Color3.fromRGB(60, 30, 30),
    BorderSizePixel = 0,
    Text = "✕",
    TextColor3 = Color3.fromRGB(255, 100, 100),
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
}, header)
corner(closeBtn, 7)

local content = make("ScrollingFrame", {
    Size = UDim2.new(1, -16, 1, -62),
    Position = UDim2.new(0, 8, 0, 58),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 5,
    ScrollBarImageColor3 = Color3.fromRGB(212, 175, 55),
    CanvasSize = UDim2.new(0, 0, 0, 540),
}, panel)

local function label(text, y)
    return make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        Position = UDim2.new(0, 0, 0, y),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(200, 180, 130),
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, content)
end

label("MATERIAL", 0)
local matGrid = make("Frame", {
    Size = UDim2.new(1, 0, 0, 100),
    Position = UDim2.new(0, 0, 0, 22),
    BackgroundTransparency = 1,
}, content)

local matButtons = {}
local function refreshMatButtons()
    for i, btn in ipairs(matButtons) do
        btn.BackgroundColor3 = (i == state.materialIndex) and Color3.fromRGB(90, 75, 30) or Color3.fromRGB(30, 30, 35)
        btn.TextColor3 = (i == state.materialIndex) and Color3.fromRGB(212, 175, 55) or Color3.fromRGB(168, 162, 154)
    end
end
for i, m in ipairs(MATERIALS) do
    local col = (i - 1) % 4
    local row = math.floor((i - 1) / 4)
    local btn = make("TextButton", {
        Size = UDim2.new(0, 60, 0, 44),
        Position = UDim2.new(0, col * 64, 0, row * 48),
        BackgroundColor3 = Color3.fromRGB(30, 30, 35),
        BorderSizePixel = 0,
        Text = m.name,
        TextColor3 = Color3.fromRGB(168, 162, 154),
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
    }, matGrid)
    corner(btn, 7)
    matButtons[i] = btn
    btn.MouseButton1Click:Connect(function()
        state.materialIndex = i
        state.colorIndex = 1
        refreshMatButtons()
        refreshColorSwatches()
    end)
end
refreshMatButtons()

label("WARNA", 138)
local colorRow = make("Frame", {
    Size = UDim2.new(1, 0, 0, 44),
    Position = UDim2.new(0, 0, 0, 160),
    BackgroundTransparency = 1,
}, content)

local swatches, swatchStrokes = {}, {}
function refreshColorSwatches()
    local mat = currentMaterialData()
    for i, sw in ipairs(swatches) do
        sw.BackgroundColor3 = mat.shades[i]
        swatchStrokes[i].Enabled = (i == state.colorIndex)
    end
end
for i = 1, 10 do
    local col = (i - 1) % 5
    local row = math.floor((i - 1) / 5)
    local sw = make("TextButton", {
        Size = UDim2.new(0, 44, 0, 18),
        Position = UDim2.new(0, col * 48, 0, row * 22),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
    }, colorRow)
    corner(sw, 4)
    local stroke = make("UIStroke", {Color = Color3.fromRGB(255, 255, 255), Thickness = 2, Enabled = false}, sw)
    swatches[i] = sw
    swatchStrokes[i] = stroke
    sw.MouseButton1Click:Connect(function()
        state.colorIndex = i
        refreshColorSwatches()
    end)
end
refreshColorSwatches()

label("BENTUK", 216)
local shapeRow = make("Frame", {
    Size = UDim2.new(1, 0, 0, 34),
    Position = UDim2.new(0, 0, 0, 238),
    BackgroundTransparency = 1,
}, content)

local shapeButtons = {}
local function refreshShapeButtons()
    for name, btn in pairs(shapeButtons) do
        btn.BackgroundColor3 = (name == state.shape) and Color3.fromRGB(90, 75, 30) or Color3.fromRGB(30, 30, 35)
        btn.TextColor3 = (name == state.shape) and Color3.fromRGB(212, 175, 55) or Color3.fromRGB(168, 162, 154)
    end
end
for i, shapeName in ipairs(SHAPES) do
    local btn = make("TextButton", {
        Size = UDim2.new(0, 82, 0, 34),
        Position = UDim2.new(0, (i - 1) * 88, 0, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 35),
        BorderSizePixel = 0,
        Text = shapeName,
        TextColor3 = Color3.fromRGB(168, 162, 154),
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
    }, shapeRow)
    corner(btn, 7)
    shapeButtons[shapeName] = btn
    btn.MouseButton1Click:Connect(function()
        state.shape = shapeName
        refreshShapeButtons()
    end)
end
refreshShapeButtons()

local brushLabel = label("UKURAN BRUSH: 6", 286)
local sliderTrack = make("Frame", {
    Size = UDim2.new(1, 0, 0, 24),
    Position = UDim2.new(0, 0, 0, 308),
    BackgroundColor3 = Color3.fromRGB(30, 30, 35),
    BorderSizePixel = 0,
}, content)
corner(sliderTrack, 6)

local sliderKnob = make("Frame", {
    Size = UDim2.new(0, 16, 0, 16),
    Position = UDim2.new((state.brushSize - 1) / 23, -8, 0.5, -8),
    BackgroundColor3 = Color3.fromRGB(212, 175, 55),
    BorderSizePixel = 0,
}, sliderTrack)
corner(sliderKnob, 8)

local draggingSlider = false
local sliderInput = make("TextButton", {
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, 0),
    Text = "",
}, sliderTrack)
sliderInput.MouseButton1Down:Connect(function() draggingSlider = true end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = false
    end
end)
RunService.RenderStepped:Connect(function()
    if draggingSlider then
        local pos = UserInputService:GetMouseLocation()
        local rel = math.clamp((pos.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
        state.brushSize = math.floor(rel * 23) + 1
        sliderKnob.Position = UDim2.new(rel, -8, 0.5, -8)
        brushLabel.Text = "UKURAN BRUSH: " .. state.brushSize
    end
end)

local eraseBtn = make("TextButton", {
    Size = UDim2.new(0, 130, 0, 55),
    Position = UDim2.new(0, 0, 0, 346),
    BackgroundColor3 = Color3.fromRGB(30, 30, 35),
    BorderSizePixel = 0,
    Text = "ERASE\nOFF",
    TextColor3 = Color3.fromRGB(232, 90, 90),
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
}, content)
corner(eraseBtn, 10)

local undoBtn = make("TextButton", {
    Size = UDim2.new(0, 130, 0, 55),
    Position = UDim2.new(0, 138, 0, 346),
    BackgroundColor3 = Color3.fromRGB(30, 30, 35),
    BorderSizePixel = 0,
    Text = "UNDO",
    TextColor3 = Color3.fromRGB(212, 160, 60),
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
}, content)
corner(undoBtn, 10)

local startBtn = make("TextButton", {
    Size = UDim2.new(0, 130, 0, 55),
    Position = UDim2.new(0, 0, 0, 410),
    BackgroundColor3 = Color3.fromRGB(30, 30, 35),
    BorderSizePixel = 0,
    Text = "START\nTAP",
    TextColor3 = Color3.fromRGB(74, 201, 122),
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
}, content)
corner(startBtn, 10)

local viewBtn = make("TextButton", {
    Size = UDim2.new(0, 130, 0, 55),
    Position = UDim2.new(0, 138, 0, 410),
    BackgroundColor3 = Color3.fromRGB(30, 30, 35),
    BorderSizePixel = 0,
    Text = "LIHAT\nSCRIPT",
    TextColor3 = Color3.fromRGB(212, 175, 55),
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
}, content)
corner(viewBtn, 10)

-- ===== POPUP SCRIPT =====
local scriptOverlay = make("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.4,
    Visible = false,
    ZIndex = 20,
}, screenGui)

local scriptBox = make("Frame", {
    Size = UDim2.new(0.9, 0, 0.8, 0),
    Position = UDim2.new(0.05, 0, 0.1, 0),
    BackgroundColor3 = Color3.fromRGB(19, 20, 25),
    BorderSizePixel = 0,
    ZIndex = 21,
}, scriptOverlay)
corner(scriptBox, 14)
make("UIStroke", {Thickness = 2, Color = Color3.fromRGB(212, 175, 55), ZIndex = 21}, scriptBox)

local scriptHeader = make("Frame", {
    Size = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = Color3.fromRGB(30, 30, 38),
    BorderSizePixel = 0,
    ZIndex = 21,
}, scriptBox)
corner(scriptHeader, 14)

make("TextLabel", {
    Size = UDim2.new(1, -50, 1, 0),
    Position = UDim2.new(0, 12, 0, 0),
    BackgroundTransparency = 1,
    Text = "Script Terrain — Copy ke SSS",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 21,
}, scriptHeader)

local closePopupBtn = make("TextButton", {
    Size = UDim2.new(0, 34, 0, 30),
    Position = UDim2.new(1, -40, 0, 7),
    BackgroundColor3 = Color3.fromRGB(200, 40, 40),
    BorderSizePixel = 0,
    Text = "X",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    ZIndex = 22,
}, scriptHeader)
corner(closePopupBtn, 8)

local codeBox = make("TextBox", {
    Size = UDim2.new(1, -20, 1, -110),
    Position = UDim2.new(0, 10, 0, 54),
    BackgroundColor3 = Color3.fromRGB(10, 10, 12),
    TextColor3 = Color3.fromRGB(180, 255, 200),
    Font = Enum.Font.Code,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    ClearTextOnFocus = false,
    MultiLine = true,
    TextWrapped = true,
    Text = "-- Tap di dunia game untuk mulai generate script...",
    ZIndex = 21,
}, scriptBox)
corner(codeBox, 10)
make("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingTop = UDim.new(0, 6), PaddingRight = UDim.new(0, 8)}, codeBox)

local selectAllBtn = make("TextButton", {
    Size = UDim2.new(0.62, -15, 0, 44),
    Position = UDim2.new(0, 10, 1, -54),
    BackgroundColor3 = Color3.fromRGB(16, 200, 150),
    BorderSizePixel = 0,
    Text = "SELECT ALL & COPY",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    ZIndex = 21,
}, scriptBox)
corner(selectAllBtn, 10)

local deleteAllBtn = make("TextButton", {
    Size = UDim2.new(0.38, -15, 0, 44),
    Position = UDim2.new(0.62, 5, 1, -54),
    BackgroundColor3 = Color3.fromRGB(200, 40, 40),
    BorderSizePixel = 0,
    Text = "HAPUS SEMUA",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    ZIndex = 21,
}, scriptBox)
corner(deleteAllBtn, 10)

selectAllBtn.MouseButton1Click:Connect(function()
    local code = regenerateCode()
    codeBox.Text = code
    if autoCopyToClipboard(code) then
        selectAllBtn.Text = "✓ COPIED!"
        task.wait(1.5)
        selectAllBtn.Text = "SELECT ALL & COPY"
    else
        codeBox:CaptureFocus()
        codeBox.SelectionStart = 1
        codeBox.CursorPosition = #codeBox.Text + 1
    end
end)

deleteAllBtn.MouseButton1Click:Connect(function()
    for _, action in ipairs(state.actions) do
        doTerrainErase(action.shape, action.position, action.size, action.radius)
    end
    state.actions = {}
    codeBox.Text = "-- Tap di dunia game untuk mulai generate script..."
end)

viewBtn.MouseButton1Click:Connect(function()
    codeBox.Text = regenerateCode()
    scriptOverlay.Visible = true
end)
closePopupBtn.MouseButton1Click:Connect(function()
    scriptOverlay.Visible = false
end)

-- ===== DRAG LAMPU (CORD) =====
local draggingCord = false
local cordStartY = 0

cordBead.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingCord = true
        cordStartY = input.Position.Y
    end
end)

cordBead.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingCord = false
        -- Balikin posisi
        TweenService:Create(cordBead, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Position = UDim2.new(0.5, 27, 0, 200)
        }):Play()
        TweenService:Create(cord, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 3, 0, 80)
        }):Play()
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingCord and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local deltaY = math.clamp(input.Position.Y - cordStartY, 0, 60)
        cordBead.Position = UDim2.new(0.5, 27, 0, 200 + deltaY)
        cord.Size = UDim2.new(0, 3, 0, 80 + deltaY)
        
        -- Kalau ditarik > 40px → buka panel
        if deltaY > 40 then
            draggingCord = false
            openPanel()
        end
    end
end)

-- ===== OPEN PANEL =====
local isOpen = false
function openPanel()
    if isOpen then return end
    isOpen = true
    -- Lampu nyala
    shade.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TweenService:Create(shade, TweenInfo.new(0.5), {
        BackgroundColor3 = Color3.fromRGB(255, 255, 240)
    }):Play()
    
    -- Sembunyiin lampu, munculin tombol tools
    task.wait(0.4)
    lampContainer.Visible = false
    hint.Visible = false
    toolsBtn.Visible = true
    panel.Visible = true
end

function closePanel()
    isOpen = false
    panel.Visible = false
    toolsBtn.Visible = false
    lampContainer.Visible = true
    hint.Visible = true
    shade.BackgroundColor3 = Color3.fromRGB(245, 240, 230)
end

-- ===== DRAG TOMBOL TOOLS =====
local draggingBtn = false
local btnDragStart, btnStartPos
toolsBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingBtn = true
        btnDragStart = input.Position
        btnStartPos = toolsBtn.Position
    end
end)
toolsBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingBtn = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingBtn and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - btnDragStart
        toolsBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
    end
end)

-- ===== MINIMIZE / CLOSE =====
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    if minimized then
        panel.Size = UDim2.new(0, 280, 0, 52)
    else
        panel.Size = UDim2.new(0, 280, 0, 540)
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    closePanel()
    minimized = false
    content.Visible = true
    panel.Size = UDim2.new(0, 280, 0, 540)
end)

-- ===== DRAG PANEL =====
local draggingPanel = false
local panelDragStart, panelStartPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if input.Target == minBtn or input.Target == closeBtn then return end
        draggingPanel = true
        panelDragStart = input.Position
        panelStartPos = panel.Position
    end
end)
header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingPanel = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingPanel and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - panelDragStart
        panel.Position = UDim2.new(panelStartPos.X.Scale, panelStartPos.X.Offset + delta.X, panelStartPos.Y.Scale, panelStartPos.Y.Offset + delta.Y)
    end
end)

-- ===== TAP HANDLER =====
local function doTap(hitPosition)
    local size = Vector3.new(state.brushSize, state.brushSize, state.brushSize)
    local radius = state.brushSize / 2
    local matData = currentMaterialData()

    if state.eraseMode then
        table.insert(state.actions, {type = "erase", shape = state.shape, position = hitPosition, size = size, radius = radius})
        doTerrainErase(state.shape, hitPosition, size, radius)
    else
        table.insert(state.actions, {
            type = "fill", shape = state.shape, position = hitPosition, size = size,
            radius = radius, height = state.brushSize, material = matData.material, color = currentColor(),
        })
        doTerrainFill(state.shape, hitPosition, size, radius, state.brushSize, matData.material, currentColor())
    end
end

mouse.Button1Down:Connect(function()
    if not state.toolActive then return end
    if not mouse.Hit then return end
    doTap(mouse.Hit.Position)
end)

eraseBtn.MouseButton1Click:Connect(function()
    if state.eraseMode then
        state.eraseMode = false
        eraseBtn.Text = "ERASE\nOFF"
        eraseBtn.TextColor3 = Color3.fromRGB(232, 90, 90)
    else
        state.eraseMode = true
        eraseBtn.Text = "ERASE\nON"
        eraseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

undoBtn.MouseButton1Click:Connect(function()
    local lastAction = table.remove(state.actions)
    if not lastAction then return end
    doTerrainErase(lastAction.shape, lastAction.position, lastAction.size, lastAction.radius)
end)

startBtn.MouseButton1Click:Connect(function()
    state.toolActive = not state.toolActive
    if state.toolActive then
        startBtn.Text = "STOP\nTAP"
        startBtn.TextColor3 = Color3.fromRGB(232, 90, 90)
    else
        startBtn.Text = "START\nTAP"
        startBtn.TextColor3 = Color3.fromRGB(74, 201, 122)
    end
end)

local indicator = make("Part", {
    Name = "TerrainBrushIndicator", Anchored = true, CanCollide = false,
    CanQuery = false, Material = Enum.Material.Neon, Transparency = 0.5,
    Color = Color3.fromRGB(74, 222, 128),
}, workspace)

RunService.RenderStepped:Connect(function()
    if state.toolActive and mouse.Hit then
        indicator.Transparency = 0.5
        indicator.Color = state.eraseMode and Color3.fromRGB(239, 68, 68) or currentColor()
        indicator.Size = Vector3.new(state.brushSize, 1, state.brushSize)
        indicator.CFrame = CFrame.new(mouse.Hit.Position)
    else
        indicator.Transparency = 1
    end
end)

print("[Terrain Tools] Ready! Tarik lampu buat buka panel.")