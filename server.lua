local Config = lib.require('sv_config')


lib.callback.register('stag_hunt:server:updateStage', function(source, stage)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return false end

    local ped = GetPlayerPed(src)
    local pos = GetEntityCoords(ped)
    local coords = stage and Config.Locations[stage].coords or Config.StartLocation.coords

    if not coords or #(pos - coords.xyz) > 5.0 then -- Check if we are either near the spot.
        return false
    end

    local progress = Player.PlayerData.metadata.scav
    if not progress or progress == 0 then -- If we have no metadata then set us to 1.
        Player.Functions.SetMetaData('scav', 1)
        Player.Functions.AddItem(Config.StartLocation.itemAdd, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.StartLocation.itemAdd], 'add')
        Wait(100)
        Player.Functions.Save()
        return true, 1
    end

    Player.Functions.SetMetaData('scav', progress + 1)
    Player.Functions.AddItem(Config.Locations[progress].itemAdd, 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Locations[progress].itemAdd], 'add')
    return true, progress + 1
end)

lib.callback.register('stag_hunt:server:finalStage', function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return false end

    local ped = GetPlayerPed(src)
    local pos = GetEntityCoords(ped)
    local coords = Config.Locations[5].coords -- final stage
    local progress = Player.PlayerData.metadata.scav

    if not coords or #(pos - coords.xyz) > 5.0 or progress ~= 5 then
        return false
    end

    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Locations[progress].itemAdd], 'add')

    Player.Functions.SetMetaData('scav', 0)
    return true
end)




AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() or GetNumPlayerIndices() == 0 then return end

    SetTimeout(0, function()
        TriggerClientEvent('stag_hunt:client:cacheConfig', -1, Config)
    end)
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    local src = source
    SetTimeout(0, function()
        TriggerClientEvent('stag_hunt:client:cacheConfig', src, Config)
    end)
end)

RegisterCommand('resethunt', function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.SetMetaData('scav', 0)
    Wait(100)
    Player.Functions.Save()
    print("Hunt Data:",Player.PlayerData.metadata.scav)
end)