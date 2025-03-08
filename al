if not game:IsLoaded() then game.Loaded:Wait() end
local ToBuy = {
    "Soul Dust",
    "Artifacts",
    "Resplendant Essence",
    "Memory Fragment",
    "Phoenix Tear",
    "Lineage Shard",
    "Corealloy Manablade",
    "Invisibility"
}
local Players = game.Players
local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Play"):InvokeServer()

local Character = Player.Character or Player.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

local MerchantName = "Mysterious Merchant"
local Time = tostring(game:GetService("ReplicatedStorage"):WaitForChild("ServerAge").Value):split(":")
local Start = tick()
if tonumber(Time[3]) < 10 and tonumber(Time[2]) > 0 then
    warn("YO")
    local Trader = workspace.NPCs:FindFirstChild(MerchantName)
    if Trader then
        warn("TRADER!!!!!")
        
        local Body = Trader.WorldPivot
        local Proximity = Trader:FindFirstChild("ProximityPrompt", true)
        local function GetDialogue()
            for _ = 1, 1000 do
                if PlayerGui:FindFirstChild("NPCDialogue") then
                    return PlayerGui:FindFirstChild("NPCDialogue")
                end
                HRP.CFrame = Body
                fireproximityprompt(Proximity)
                task.wait(0.01)
            end
            return false
        end
        local function CheckOptions(Dialogue)
            local Options = Dialogue.BG.Options
            for _, Option in ipairs(Options:GetChildren()) do
                if Option.Name ~= "Option" then
                    continue
                end
                local SelledItem = Option.Text
                for _, Item in ToBuy do
                    if SelledItem:find(Item) then
                        return SelledItem
                    end
                end
            end
            return false
        end
        
        local Dialogue = GetDialogue()
        if Dialogue then
            local Remote = Dialogue.RemoteEvent
            local FoundItem = CheckOptions(Dialogue)
            print(31125125152)
            if FoundItem then
                Remote:FireServer(FoundItem)
                task.wait(9e99)
            end
        end
    end
end
local End = tick()
if End - Start < 7.5 then
    task.wait(End - Start)
end

local TeleportService = cloneref(game:GetService("TeleportService"))
local HttpService = cloneref(game:GetService("HttpService"))
local httprequest = (syn and syn.request) or (http and http.request) or http_request or request
local PlaceId, JobId = game.PlaceId, game.JobId
if httprequest then
    while true do
        local servers = {}
        warn(pcall(function()
            local req = httprequest({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", PlaceId)})
            local body = HttpService:JSONDecode(req.Body)

            if body and body.data then
                for i, v in next, body.data do
                    if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= JobId then
                        table.insert(servers, 1, v.id)
                    end
                end
            end
            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], Player)
            else
                return warn("Serverhop", "Couldn't find a server.")
            end
            warn(1331)
        end))
        task.wait(5)
    end
end
