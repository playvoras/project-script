-- game https://www.roblox.com/games/11364087119/Cart-Ride
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("", "DarkTheme")
local Tab = Window:NewTab("")
local Section = Tab:NewSection("")
Section:NewButton("Cart Spam Down", "Press Rejoin to Turn It Off", function()
    while true do wait(0.01)
        for i, v in pairs(workspace.ActiveCarts:GetDescendants()) do
            if v.Parent.Name == "Down" and v.ClassName == "ClickDetector" then
                spawn(function()
                    while true do
                        wait()
                        if v then
                            fireclickdetector(v)
                        else
                            break
                        end
                    end
                end)
            end
        end
    end
end)
Section:NewButton("Cart Spam Up", "Press Rejoin to Turn It Off", function()
    while true do wait(0.01)
        for i, v in pairs(workspace.ActiveCarts:GetDescendants()) do
            if v.Parent.Name == "Up" and v.ClassName == "ClickDetector" then
                spawn(function()
                    while true do
                        wait()
                        if v then
                            fireclickdetector(v)
                        else
                            break
                        end
                    end
                end)
            end
        end
    end
end)
Section:NewButton("Rejoin", "ButtonInfo", function()
local tpservice= game:GetService("TeleportService")
local plr = game.Players.LocalPlayer
tpservice:Teleport(game.PlaceId, plr)
end)
