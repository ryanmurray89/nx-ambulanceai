local QBCore = exports['qb-core']:GetCoreObject()
local ActiveScenes = {}
local playerPed = cache.ped or PlayerPedId()

AddEventHandler('QBCore:Player:UpdatePlayerData', function() playerPed = cache.ped or PlayerPedId() end)
AddEventHandler('onResourceStart', function(name) if name == GetCurrentResourceName() then playerPed = cache.ped or PlayerPedId() end end)

local function Debug(msg) if not Config.Debug then return end print(('^3[nx-ambulanceai]^7 %s'):format(msg)) end
local function Notify(msg, type) lib.notify({ title = 'EMS Dispatch', description = msg, type = type or 'inform' }) end

local function LoadModel(model)
    local hash = joaat(model)
    if HasModelLoaded(hash) then return hash end
    RequestModel(hash)
    local timeout = 0
    while not HasModelLoaded(hash) and timeout < 1000 do Wait(0) timeout += 1 end
    return hash
end

local function CleanupScene(sceneId)
    local scene = ActiveScenes[sceneId]
    if not scene then return end
    Debug('Cleaning up scene '.. sceneId)
    if scene.blip and DoesBlipExist(scene.blip) then RemoveBlip(scene.blip) end
    if scene.ped and DoesEntityExist(scene.ped) then
        exports.ox_target:removeLocalEntity(scene.ped)
        DeleteEntity(scene.ped)
    end
    ActiveScenes[sceneId] = nil
end

local function CompleteCall(sceneId)
    local scene = ActiveScenes[sceneId]
    if not scene or not DoesEntityExist(scene.ped) then return end
    local ped = scene.ped
    playerPed = cache.ped or PlayerPedId()
    FreezeEntityPosition(ped, false)
    ClearPedTasksImmediately(ped)
    ResurrectPed(ped)
    SetEntityHealth(ped, 200)
    SetBlockingOfNonTemporaryEvents(ped, false)
    TaskTurnPedToFaceEntity(ped, playerPed, 1500)
    Wait(1500)
    TriggerEvent('chat:addMessage', { color = {0,255,0}, args = { "Civilian", ({ "Thank you!", "You saved me!", "I thought I was dead...", "Holy shit...", "Thanks EMS!" })[math.random(5)] } })
    TriggerServerEvent('nx-ambulanceai:server:reward')
    TaskWanderStandard(ped, 10.0, 10)
    Notify("Civilian revived successfully.", "success")
    SetTimeout(15000, function() CleanupScene(sceneId) end)
end

local function AddTarget(sceneId, ped, injury)
    exports.ox_target:addLocalEntity(ped, {{
        name = 'ems_assess_'.. sceneId,
        icon = 'fas fa-heartbeat', label = 'Assess Civilian', distance = 2.5,
        canInteract = function(entity) return DoesEntityExist(entity) end,
        onSelect = function()
            lib.registerContext({
                id = 'ems_assess_'.. sceneId, title = 'Civilian Assessment',
                options = {
                    { title = 'Observed Injuries', description = injury, icon = 'notes-medical' },
                    {
                        title = 'Revive Civilian', description = 'Requires Defib', icon = 'heart',
                        onSelect = function()
                            if exports.ox_inventory:Search('count', Config.RequiredItem) < 1 then Notify('You need a defib.', 'error') return end
                            if not lib.progressBar({ duration = 10000, label = 'Reviving civilian...', canCancel = true, disable = { move = true, car = true, combat = true }, anim = { dict = 'mini@cpr@char_a@cpr_str', clip = 'cpr_pumpchest' } }) then Notify('Revive cancelled.', 'error') return end
                            CompleteCall(sceneId)
                        end
                    }
                }
            })
            lib.showContext('ems_assess_'.. sceneId)
        end
    }})
end

local function CreateScene(coords)
    local sceneId = math.random(111111, 999999)
    local model = Config.PedModels[math.random(#Config.PedModels)]
    local injury = Config.Injuries[math.random(#Config.Injuries)]
    local hash = LoadModel(model)
    local ped = CreatePed(4, hash, coords.x, coords.y, coords.z - 1.0, coords.w, true, true)
    if not DoesEntityExist(ped) then SetModelAsNoLongerNeeded(hash) return end
    SetEntityAsMissionEntity(ped, true, true)
    NetworkRegisterEntityAsNetworked(ped)
    SetPedCanRagdoll(ped, true)
    SetEntityHealth(ped, 0)
    Wait(100)
    SetPedToRagdoll(ped, 999999, 0, true, true, false)
    FreezeEntityPosition(ped, true)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 153) SetBlipColour(blip, 1) SetBlipScale(blip, 0.9) SetBlipFlashes(blip, true)
    BeginTextCommandSetBlipName("STRING") AddTextComponentString("Down Civilian") EndTextCommandSetBlipName(blip)
    ActiveScenes[sceneId] = { ped = ped, blip = blip, injury = injury }
    AddTarget(sceneId, ped, injury)
    if Config.DispatchEnabled and GetResourceState('ps-dispatch') == 'started' then
        TriggerServerEvent('ps-dispatch:server:notify', {
            message = "Unconscious civilian reported", codeName = 'civdown', code = '10-69',
            icon = 'fas fa-face-dizzy', priority = 1, coords = vec3(coords.x, coords.y, coords.z),
            gender = 'Unknown', street = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z)),
            alertTime = 10, jobs = { 'ambulance', 'firefighter' }
        })
    end
    Notify('New EMS call received.', 'inform')
    Debug('Created scene '.. sceneId)
    SetTimeout(Config.SceneCleanup * 60000, function() CleanupScene(sceneId) end)
    SetModelAsNoLongerNeeded(hash)
end

RegisterNetEvent('nx-ambulanceai:client:createScene', function(coords)
    local PlayerData = QBCore.Functions.GetPlayerData()
    if Config.RequireJob and (not PlayerData.job or PlayerData.job.name ~= Config.JobName) then return end
    CreateScene(coords)
end)

RegisterCommand('testambu', function() CreateScene(Config.SpawnLocations[math.random(#Config.SpawnLocations)]) end, false)
AddEventHandler('onResourceStop', function(res) if res ~= GetCurrentResourceName() then return end for id in pairs(ActiveScenes) do CleanupScene(id) end end)