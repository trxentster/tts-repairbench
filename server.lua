RegisterNetEvent('tts_repairbench:repairVehicle')
AddEventHandler('tts_repairbench:repairVehicle', function(netId)
    local src = source

    local vehicle = NetworkGetEntityFromNetworkId(netId)

    if not DoesEntityExist(vehicle) then
        TriggerClientEvent('ox_lib:notify', src, { 
            description = 'Invalid vehicle!', 
            type = 'error' 
        })
        return
    end

    local playerPed = GetPlayerPed(src)

    if GetVehiclePedIsIn(playerPed, false) ~= vehicle then
        TriggerClientEvent('ox_lib:notify', src, { 
            description = 'You must be in the vehicle!', 
            type = 'error' 
        })
        return
    end

    local plate = GetVehicleNumberPlateText(vehicle)
    print(('[tts_repairbench] Player %s is repairing vehicle %s'):format(GetPlayerName(src), plate))

    TriggerClientEvent('tts_repairbench:doRepair', src, netId)
end)
