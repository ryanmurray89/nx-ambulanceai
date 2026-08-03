local QBCore = exports['qb-core']:GetCoreObject()

-- Version Check
local CURRENT_VERSION = '2.0.0'
local GITHUB_RAW_VERSION_URL = 'https://raw.githubusercontent.com/ryanmurray89/nx-ambulanceai/main/version.json'
CreateThread(function()
    Wait(2000)
    PerformHttpRequest(GITHUB_RAW_VERSION_URL, function(status, body)
        if status ~= 200 or not body then print('^3[nx-ambulanceai]^7 Version check failed') return end
        local data = json.decode(body)
        if not data or not data.version then return end
        if data.version ~= CURRENT_VERSION then
            print('^1[nx-ambulanceai] OUTDATED!^7 Your: '.. CURRENT_VERSION..' | Latest: '.. data.version)
            print('^1[nx-ambulanceai] Update: https://github.com/ryanmurray89/nx-ambulanceai^7')
        else
            print('^2[nx-ambulanceai] Up to date! ^7v'.. CURRENT_VERSION)
        end
    end, 'GET')
end)

local function GetOnDutyAmbulanceCount()
    local count = 0
    local players = QBCore.Functions.GetQBPlayers()
    for _, v in pairs(players) do
        if v and v.PlayerData.job.name == Config.JobName and v.PlayerData.job.onduty then count += 1 end
    end
    return count
end

RegisterNetEvent('nx-ambulanceai:server:reward', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if Player.PlayerData.job.name ~= Config.JobName then return end
    Player.Functions.AddMoney(Config.RewardType, Config.RewardAmount, 'ems-ai-call')
    TriggerClientEvent('ox_lib:notify', src, { title = 'EMS Payment', description = ('$%s received.'):format(Config.RewardAmount), type = 'success' })
end)

CreateThread(function()
    while true do
        Wait(Config.CallInterval * 60000)
        if GetOnDutyAmbulanceCount() == 0 then
            if Config.Debug then print('^3[nx-ambulanceai] ^7No EMS on duty, skipping') end
            goto continue
        end
        if math.random(1,100) > Config.CallChance then goto continue end
        local coords = Config.SpawnLocations[math.random(#Config.SpawnLocations)]
        local players = QBCore.Functions.GetQBPlayers()
        local available = {}
        for _, v in pairs(players) do if v.PlayerData.job.name == Config.JobName and v.PlayerData.job.onduty then available[#available+1] = v.PlayerData.source end end
        if #available > 0 then
            TriggerClientEvent('nx-ambulanceai:client:createScene', available[math.random(#available)], coords)
        end
        ::continue::
    end
end)