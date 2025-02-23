local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "blue night cheat🌃",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "로딩중...",
   LoadingSubtitle = "by 밤별",
   Theme = "DarkBlue", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("🎮메인 탭🎮", nil) -- Title, Image
local MainSection = MainTab:CreateSection("ESP")

Rayfield:Notify({
   Title = "스크립트 정상 실행 완료!",
   Content = "Thank you for using our script.",
   Duration = 5,
   Image = nil,
 })

local Button = MainTab:CreateButton({
   Name = "플레이어 윤곽선 ESP",
   Callback = function()
   local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- 윤곽선 강조 함수
local function highlightOutline(player)
    if not player.Character or not player.Character.PrimaryPart then
        return
    end

    -- 기존에 Highlight가 있으면 제거
    for _, child in ipairs(player.Character:GetChildren()) do
        if child:IsA("Highlight") then
            child:Destroy()
        end
    end

    -- 윤곽선 강조
    local highlight = Instance.new("Highlight")
    highlight.Parent = player.Character
    highlight.FillColor = Color3.new(0, 0, 1)  -- 윤곽선 내부 색상
    highlight.OutlineColor = Color3.new(1, 1, 0)  -- 윤곽선 색상
end

-- 플레이어가 새로 추가될 때마다 처리
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        highlightOutline(player)
    end)
end)

-- 모든 플레이어 강조 (윤곽선)
local function highlightPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        highlightOutline(player)
    end
end

-- 주기적으로 플레이어 강조
task.spawn(function()
    while true do
        highlightPlayers()
        task.wait(5) 
    end
end)

highlightPlayers()  -- 시작 시 모든 플레이어 강조

   end,
})

local Button = MainTab:CreateButton({
   Name = "플레이어 거리 ESP",
   Callback = function()
   local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local function highlightDistance(player)
    if not player.Character or not player.Character.PrimaryPart then
        return
    end

    -- 기존에 BillboardGui가 있으면 제거
    for _, child in ipairs(player.Character:GetChildren()) do
        if child:IsA("BillboardGui") then
            child:Destroy()
        end
    end

    -- 거리 표시
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.Adornee = player.Character.PrimaryPart
    billboard.Parent = player.Character.PrimaryPart
    billboard.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(0, 0, 1)  -- 텍스트 색상
    textLabel.TextStrokeColor3 = Color3.new(1, 1, 0)  -- 텍스트 윤곽선 색상
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextScaled = false
    textLabel.TextSize = 20  -- 텍스트 크기
    textLabel.Parent = billboard

    -- 거리 계산
    RunService.RenderStepped:Connect(function()
        if player.Character and player.Character.PrimaryPart then
            local localPlayer = Players.LocalPlayer
            if localPlayer and localPlayer.Character and localPlayer.Character.PrimaryPart then
                local distance = (player.Character.PrimaryPart.Position - localPlayer.Character.PrimaryPart.Position).Magnitude

                -- 텍스트에 거리 표시
                textLabel.Text = string.format("%d m", distance)
            end
        end
    end)
end

-- 플레이어들에 대해 거리 강조 적용
local function highlightPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        highlightDistance(player)
    end
end

-- 플레이어 추가시 거리 강조 적용
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        highlightDistance(player)
    end)
end)

-- 반복적으로 거리 강조 적용
task.spawn(function()
    while true do
        highlightPlayers()
        task.wait(5)
    end
end)

highlightPlayers()

   end,
})

local MainSection = MainTab:CreateSection("에임")

local Button = MainTab:CreateButton({
   Name = "에임봇",  -- 버튼 이름
   Callback = function()
            local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local camera = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer
local currentTarget = nil
local isRightMouseDown = false

-- FOV 설정
local FOV_RADIUS = 100  -- FOV 크기 설정 (적당한 크기)
local FOV_CIRCLE = Drawing.new("Circle")
FOV_CIRCLE.Radius = FOV_RADIUS
FOV_CIRCLE.Color = Color3.new(1, 1, 1)  -- 흰색 테두리
FOV_CIRCLE.Thickness = 2
FOV_CIRCLE.NumSides = 30
FOV_CIRCLE.Filled = false  -- 내부를 비워서 테두리만 보이게 수정
FOV_CIRCLE.Visible = false

-- 우클릭 감지
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isRightMouseDown = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isRightMouseDown = false
    end
end)

-- 특정 방향에 있는 가장 가까운 플레이어 찾기 (FOV 안에 들어와야 함)
local function getClosestPlayerInFOV()
    local closestPlayer = nil
    local minDistance = math.huge
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)  -- 화면 중앙

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") then
            -- 같은 팀인 플레이어는 제외
            if player.Team == localPlayer.Team then
                continue  -- 같은 팀은 넘어가고
            end

            -- 죽은 플레이어는 제외
            if player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                local head = player.Character.Head
                local headPos, onScreen = camera:WorldToViewportPoint(head.Position)  -- 3D 위치 → 2D 화면 좌표 변환

                if onScreen then
                    local distanceFromCenter = (Vector2.new(headPos.X, headPos.Y) - screenCenter).Magnitude
                    if distanceFromCenter <= FOV_RADIUS then  -- FOV 원 안에 들어왔는지 확인
                        local distance = (camera.CFrame.Position - head.Position).Magnitude
                        if distance < minDistance then
                            minDistance = distance
                            closestPlayer = player
                        end
                    end
                end
            end
        end
    end

    return closestPlayer
end

-- 1인칭인지 확인하는 함수 (Shift Lock 포함)
local function isFirstPerson()
    return UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter
end

-- 카메라 고정
RunService.RenderStepped:Connect(function()
    local inFirstPerson = isFirstPerson()

    -- FOV 원을 1인칭에서만 보이게 하고 Shift Lock에서는 보이지 않게 처리
    if inFirstPerson then
        FOV_CIRCLE.Visible = true
        FOV_CIRCLE.Position = UserInputService:GetMouseLocation()
    else
        FOV_CIRCLE.Visible = false
    end

    -- 우클릭을 눌렀고, 1인칭 상태일 때만 작동
    if isRightMouseDown and inFirstPerson then
        local targetPlayer = getClosestPlayerInFOV()

        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
            local head = targetPlayer.Character.Head

            -- 에임을 대상 머리에 고정
            camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)

            currentTarget = targetPlayer
        else
            currentTarget = nil
        end
    else
        currentTarget = nil
    end
end)
   end,
})

local MainTab = Window:CreateTab("👑관리자 탭👑", nil) -- Title, Image

local MainSection = MainTab:CreateSection("권한")

local Button = MainTab:CreateButton({
   Name = "어드민 권한",
   Callback = function()
   loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
   end,
})

local Button = MainTab:CreateButton({
   Name = "TP툴 아이템",
   Callback = function()
   local Tele = Instance.new("Tool", game.Players.LocalPlayer.Backpack)
Tele.RequiresHandle = false
Tele.RobloxLocked = true
Tele.Name = "TPTool"
Tele.ToolTip = "Teleport Tool"
Tele.Equipped:connect(function(Mouse)
	Mouse.Button1Down:connect(function()
		if Mouse.Target then
			game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name).HumanoidRootPart.CFrame = (CFrame.new(Mouse.Hit.x, Mouse.Hit.y + 5, Mouse.Hit.z))
		end
	end)
end)
   end,
})

local Button = MainTab:CreateButton({
   Name = "벽 통과",
   Callback = function()
   --[[
	MIT License

	Copyright (c) 2019 WeAreDevs wearedevs.net

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
--]]

_G.noclip = not _G.noclip
print(_G.noclip)

if not game:GetService('Players').LocalPlayer.Character:FindFirstChild("LowerTorso") then
	while _G.noclip do
		game:GetService("RunService").Stepped:wait()
		game.Players.LocalPlayer.Character.Head.CanCollide = false
		game.Players.LocalPlayer.Character.Torso.CanCollide = false
	end
else
	if _G.InitNC ~= true then     
		_G.NCFunc = function(part)      
			local pos = game:GetService('Players').LocalPlayer.Character.LowerTorso.Position.Y  
			if _G.noclip then             
				if part.Position.Y > pos then                 
					part.CanCollide = false             
				end        
			end    
		end      
		_G.InitNC = true 
	end 
	 
	game:GetService('Players').LocalPlayer.Character.Humanoid.Touched:connect(_G.NCFunc) 
end
   end,
})

local MainTab = Window:CreateTab("🌍기타 탭🌍", nil) -- Title, Image

local MainSection = MainTab:CreateSection("재미")

local Button = MainTab:CreateButton({
   Name = "ㅈㅇ 하는 스크립트",
   Callback = function()
   loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
   end,
})

local Button = MainTab:CreateButton({
   Name = "백허그 기능 (H누르면 발동)",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/JSFKGBASDJKHIOAFHDGHIUODSGBJKLFGDKSB/fe/refs/heads/main/FEHUGG"))()
   end,
})

local MainTab = Window:CreateTab("☢️스크립트 모음☢️", nil) -- Title, Image

local MainSection = MainTab:CreateSection("게임 종류 ")

local Button = MainTab:CreateButton({
   Name = "피쉬 스크립트(Speed HUB)",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
   end,
})

local Button = MainTab:CreateButton({
   Name = "파괴 시뮬레이터(돈 핵)",
   Callback = function()
   _G.MoneyBoostEnabled = true

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local generateBoostEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("generateBoost")

local function generateMoneyBoost()
    while _G.MoneyBoostEnabled do
        generateBoostEvent:FireServer("Coins", 480, 3000000)
        task.wait(0)
    end
end

task.spawn(function()
    while task.wait(0.1) do
        if _G.MoneyBoostEnabled then
            generateMoneyBoost()
        end
    end
end)
   end,
})

local Button = MainTab:CreateButton({
   Name = "타워게임 칼얻기,올킬",
   Callback = function()
   -- .gg/localx
local Players = game:GetService('Players')
local client = Players.LocalPlayer

local function dbug(txt)
print(`[LocalX]: {txt}`)
end

dbug('칼 찾는중...')
local gotsword = false
local sword = nil

local findsword = workspace.ChildAdded:Connect(function(obj)
if obj:IsA('Tool') and obj:WaitForChild('Handle') then
dbug('칼 얻음!')
client.Character.Humanoid:EquipTool(obj)
gotsword = true
sword = obj
end
end)
repeat task.wait() until gotsword
findsword:Disconnect()

print(sword)

while task.wait() do
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= client then
pcall(function()
firetouchinterest(sword.Handle, plr.Character:FindFirstChild('Head'), 0)
task.wait()
firetouchinterest(sword.Handle, plr.Character:FindFirstChild('Head'), 1)

end)
end
end
end
   end,
})

local Button = MainTab:CreateButton({
   Name = "프리즌 라이프(올킬 지원)",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/thaibao/main/TbaohubPrisonLife"))()
   end,
})
