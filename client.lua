local objs = {}
local Config = {}
local PlayerData = {}
local currentBlip

local function radiusBlip(coords)
    local offsetSign = math.random(-100, 100)/100
    local blip = AddBlipForRadius(coords, 100.0)
    SetBlipHighDetail(blip, true)
    SetBlipAlpha(blip, 100)
    SetBlipColour(blip, 2)
    return blip
end

local function cleanupHunt()
    exports['qb-target']:RemoveZone("START_SCAV")
    for k in pairs(objs) do
        if DoesEntityExist(objs[k]) then
            DeleteEntity(objs[k])
        end
    end
    if DoesBlipExist(currentBlip) then
        RemoveBlip(currentBlip)
        currentBlip = nil
    end
    table.wipe(objs)
    table.wipe(Config)
    table.wipe(PlayerData)
end

local function scavengerEvent(stage)
    if not stage then return end

    if stage ~= 5 then -- assuming 5 is the last stage
        local label = Config.Locations[stage].bar.label
        local duration = Config.Locations[stage].bar.duration
        QBCore.Functions.Progressbar('_', label, duration, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
            local continue, newStage = lib.callback.await('stag_hunt:server:updateStage', false, stage)
            if continue and newStage then
                SetEntityVisible(objs[stage], false)
                local coords = Config.Locations[newStage].coords
                if DoesBlipExist(currentBlip) then RemoveBlip(currentBlip) end
                currentBlip = radiusBlip(coords.xyz)
                QBCore.Functions.Notify('Move on to the next location!', 'success', 5000)
            end
        end, function() -- Cancel
            QBCore.Functions.Notify('Cancelled..', 'error', 5000)
        end)
    else
        local label = Config.Locations[stage].bar.label
        local duration = Config.Locations[stage].bar.duration
        QBCore.Functions.Progressbar('_', label, duration, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
            local isComplete = lib.callback.await('stag_hunt:server:finalStage', false)
            if isComplete then
                if DoesBlipExist(currentBlip) then
                    RemoveBlip(currentBlip)
                    currentBlip = nil
                end
                for k in pairs(objs) do
                    if DoesEntityExist(objs[k]) then
                        SetEntityVisible(objs[k], true)
                    end
                end
                
            end
        end, function() -- Cancel
            QBCore.Functions.Notify('Cancelled..', 'error', 5000)
        end)
    end
end

local function setupScavenger()
    local data = Config.StartLocation
    exports['qb-target']:AddCircleZone("START_SCAV", vector3(data.coords.x, data.coords.y, data.coords.z), 0.6, { 
        name = "START_SCAV", 
        debugPoly = false, 
        useZ=true, 
    }, { 
        options = { 
            { 
                icon = data.icon, 
                label = data.label,
                action = function()
                    QBCore.Functions.Progressbar('reading_map', "Reading the map", 5000, false, true, {
                        disableMovement = true,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                    }, {}, {}, {}, function()
                        if not QBCore.Functions.HasItem(Config.StartLocation.item) then return end
                        local continue, newStage = lib.callback.await('stag_hunt:server:updateStage', false)
                        if continue then
                            local coords = Config.Locations[newStage].coords
                            currentBlip = radiusBlip(coords.xyz)
                            QBCore.Functions.Notify('Move on to the first location!', 'success', 5000)
                        end
                    end, function() -- Cancel
                        QBCore.Functions.Notify('Cancelled....', 'error', 5000)
                    end)
                end,
                canInteract = function()
                    return not PlayerData.metadata.scav or PlayerData.metadata.scav == 0
                end,
            }, 
        }, 
        distance = 1.5 
    })
    for k,v in pairs(Config.Locations) do
        if not DoesEntityExist(objs[k]) then
            lib.requestModel(Config.PropModel, 2000)
            objs[k] = CreateObject(Config.PropModel, v.coords.x, v.coords.y, v.coords.z - 1.0, false, false, false)
            SetModelAsNoLongerNeeded(Config.PropModel)
            SetEntityHeading(objs[k], v.coords.w)
            SetEntityAsMissionEntity(objs[k], true, true)
            FreezeEntityPosition(objs[k], true)
            exports['qb-target']:AddTargetEntity(objs[k], {
                options = {
                    {
                        label = v.label,
                        icon = v.icon,
                        action = function()
                            scavengerEvent(k)
                        end,
                        -- item = v.item,
                        canInteract = function()
                            return PlayerData.metadata.scav == k
                        end,
                    },
                },
                distance = 3.0
            })
        end
    end
end

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
end)

RegisterNetEvent('stag_hunt:client:cacheConfig', function(data)
    if GetInvokingResource() or not LocalPlayer.state.isLoggedIn or not data then return end
    PlayerData = QBCore.Functions.GetPlayerData()
    Config = data
    setupScavenger()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    cleanupHunt()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    cleanupHunt()
end)

RegisterCommand('huntdata', function(source)
    print(PlayerData.metadata.scav)
end)
