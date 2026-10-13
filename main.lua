local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("WTTagPosFix") then
        game:GetService("CoreGui").WTTagPosFix:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WTTagPosFix"
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 240)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -120)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.Active = true
MainFrame.Draggable = true

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(80, 150, 255)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
Title.Text = "تعديل النيم تاج بالنظام الإحداثي (L للإخفاء)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 11
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

local function createBox(placeholder, posY)
    local box = Instance.new("TextBox", MainFrame)
    box.Size = UDim2.new(0.9, 0, 0, 34)
    box.Position = UDim2.new(0.05, 0, 0, posY)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.Gotham
    box.TextSize = 12
    box.ClearTextOnFocus = false
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
    return box
end

local DisplayBox = createBox("الاسم الأوسط الرئيسي (مثال: DF_7)...", 45)
local UserBox = createBox("اليوزر السفلي (مثال: F_SA0D)...", 85)
local RoleBox = createBox("الرتبة العلوية (مثال: Soldier)...", 125)

local ApplyBtn = Instance.new("TextButton", MainFrame)
ApplyBtn.Size = UDim2.new(0.9, 0, 0, 38)
ApplyBtn.Position = UDim2.new(0.05, 0, 0, 175)
ApplyBtn.Text = "تطبيق التعديل في المكان الصحيح"
ApplyBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 220)
ApplyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyBtn.Font = Enum.Font.GothamBold
ApplyBtn.TextSize = 12
Instance.new("UICorner", ApplyBtn).CornerRadius = UDim.new(0, 8)

ApplyBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    
    local newDisplay = DisplayBox.Text
    local newUser = UserBox.Text
    local newRole = RoleBox.Text
    
    if hum and newDisplay ~= "" then hum.DisplayName = newDisplay end
    if newUser ~= "" then LocalPlayer.Name = newUser end
    
    if head then
        for _, gui in pairs(head:GetDescendants()) do
            if gui:IsA("BillboardGui") then
                local labels = {}
                for _, child in pairs(gui:GetDescendants()) do
                    if child:IsA("TextLabel") then
                        table.insert(labels, child)
                    end
                end
                
                -- ترتيب العناصر بحسب الموقع الرأسي Y من الأعلى للأسفل
                table.sort(labels, function(a, b)
                    return a.AbsolutePosition.Y < b.AbsolutePosition.Y
                end)
                
                -- إذا وُجدت 3 عناصر أو أكثر:
                for index, label in ipairs(labels) do
                    local txt = label.Text
                    
                    -- السطر الأول (العلوي - Soldier / Rank)
                    if index == 1 then
                        if newRole ~= "" then label.Text = newRole end
                    -- السطر الثاني (الأوسط - الاسم الأزرق الرئيسي)
                    elseif index == 2 then
                        if newDisplay ~= "" then label.Text = newDisplay end
                    -- السطر الثالث (السفلي - @Username)
                    elseif index == 3 or txt:sub(1,1) == "@" then
                        if newUser ~= "" then label.Text = "@" .. newUser end
                    -- أي سطر رابع زائد يتم إخفاؤه لمنع التكرار تحت اليوزر
                    else
                        label.Visible = false
                    end
                end
            end
        end
    end

    Title.Text = "تم التعديل في الموضع الصحيح!"
    task.wait(1.5)
    Title.Text = "تعديل النيم تاج بالنظام الإحداثي (L للإخفاء)"
end)

UserInputService.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    if input.KeyCode == Enum.KeyCode.L then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
