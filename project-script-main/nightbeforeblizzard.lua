game.Workspace.World.FireHitbox.Size = Vector3.new(2048,2048,2048)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("TITLE", "DarkTheme")
local Tab = Window:NewTab("TabName")
local Section = Tab:NewSection("Section Name")

local running = false

local function wins()
    while running do
        for _, locker in pairs(game.Workspace.World.Lockers:GetChildren()) do
            fireclickdetector(locker.ClickDetect.ClickDetector)
        end
        
        fireclickdetector(game.Workspace.World.FireAssets.Woods.W1.ClickDetector)

        local Winterhorn = game.Workspace:FindFirstChild("Winterhorn")
        if Winterhorn then
            game:GetService("ReplicatedStorage").RemoteEvents.Flash:FireServer()
        end

        wait(0.5)
    end
end

local toggle = Section:NewToggle("auto wins", "ToggleInfo", function(state)
    running = state
    if state then
        wins()
    end
end)
