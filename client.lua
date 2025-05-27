local workbenches = {}

Citizen.CreateThread(function()
    for _, location in pairs(Config.WorkbenchLocations) do
        local model = Config.WorkbenchModel

        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(10)
        end

        local bench = CreateObject(model, location.x, location.y, location.z - 1.0, false, false, true)
        SetEntityHeading(bench, location.heading)
        PlaceObjectOnGroundProperly(bench)
        FreezeEntityPosition(bench, true)

        table.insert(workbenches, bench)

        exports.ox_target:addLocalEntity(bench, {
            {
                label = 'Repair Vehicle',
                icon = 'fa-solid fa-wrench',
                onSelect = function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                    if vehicle ~= 0 then
                        local netId = VehToNet(vehicle)
                        TriggerServerEvent('tts_repairbench:repairVehicle', netId)
                    else
                        exports['ox_lib']:notify({ description = 'You must be in a vehicle!', type = 'error' })
                    end
                end
            },
            {
                label = 'Vehicle Extras',
                icon = 'fa-solid fa-cogs',
                onSelect = function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                    if vehicle ~= 0 then
                        OpenExtrasMenu(vehicle)
                    else
                        exports['ox_lib']:notify({ description = 'You must be in a vehicle!', type = 'error' })
                    end
                end
            },
            {
                label = 'Change Livery',
                icon = 'fa-solid fa-palette',
                onSelect = function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                    if vehicle ~= 0 then
                        OpenLiveryMenu(vehicle)
                    else
                        exports['ox_lib']:notify({ description = 'You must be in a vehicle!', type = 'error' })
                    end
                end
            },
            {
                label = 'Respray Vehicle',
                icon = 'fa-solid fa-spray-can',
                onSelect = function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                    if vehicle ~= 0 then
                        OpenResprayMenu(vehicle)
                    else
                        exports['ox_lib']:notify({ description = 'You must be in a vehicle!', type = 'error' })
                    end
                end
            }
        })
    end
end)

function OpenExtrasMenu(vehicle)
    local extras = {}

    for i = 1, 14 do
        if DoesExtraExist(vehicle, i) then
            local enabled = IsVehicleExtraTurnedOn(vehicle, i)

            table.insert(extras, {
                title = ('Extra %d'):format(i),
                description = enabled and '✅ Enabled' or '❌ Disabled',
                icon = enabled and 'fa-check-circle' or 'fa-times-circle',
                onSelect = function()
                    ToggleExtra(vehicle, i)
                    OpenExtrasMenu(vehicle)
                end
            })
        end
    end

    exports['ox_lib']:registerContext({
        id = 'extras_menu',
        title = 'Vehicle Extras',
        options = extras
    })

    exports['ox_lib']:showContext('extras_menu')
end

function OpenResprayMenu(vehicle)
    local colors = {
    {name = "Black", color = 0},
    {name = "Graphite", color = 1},
    {name = "Black Steel", color = 2},
    {name = "Dark Steel", color = 3},
    {name = "Silver", color = 4},
    {name = "Bluish Silver", color = 5},
    {name = "Rolled Steel", color = 6},
    {name = "Shadow Silver", color = 7},
    {name = "Stone Silver", color = 8},
    {name = "Midnight Silver", color = 9},
    {name = "Cast Iron Silver", color = 10},
    {name = "Red", color = 27},
    {name = "Torino Red", color = 28},
    {name = "Formula Red", color = 29},
    {name = "Lava Red", color = 150},
    {name = "Blaze Red", color = 30},
    {name = "Grace Red", color = 31},
    {name = "Garnet Red", color = 32},
    {name = "Sunset Red", color = 33},
    {name = "Cabernet Red", color = 34},
    {name = "Wine Red", color = 143},
    {name = "Candy Red", color = 35},
    {name = "Hot Pink", color = 135},
    {name = "Pfsiter Pink", color = 137},
    {name = "Salmon Pink", color = 136},
    {name = "Sunrise Orange", color = 36},
    {name = "Orange", color = 38},
    {name = "Bright Orange", color = 138},
    {name = "Gold", color = 99},
    {name = "Bronze", color = 90},
    {name = "Yellow", color = 88},
    {name = "Race Yellow", color = 89},
    {name = "Dew Yellow", color = 91},
    {name = "Dark Green", color = 49},
    {name = "Racing Green", color = 50},
    {name = "Sea Green", color = 51},
    {name = "Olive Green", color = 52},
    {name = "Bright Green", color = 53},
    {name = "Lime Green", color = 54},
    {name = "Midnight Blue", color = 141},
    {name = "Galaxy Blue", color = 61},
    {name = "Dark Blue", color = 62},
    {name = "Saxon Blue", color = 63},
    {name = "Blue", color = 64},
    {name = "Mariner Blue", color = 65},
    {name = "Harbor Blue", color = 66},
    {name = "Diamond Blue", color = 67},
    {name = "Surf Blue", color = 68},
    {name = "Nautical Blue", color = 69},
    {name = "Racing Blue", color = 73},
    {name = "Ultra Blue", color = 70},
    {name = "Light Blue", color = 74},
    {name = "Chocolate Brown", color = 96},
    {name = "Bison Brown", color = 101},
    {name = "Creeen Brown", color = 95},
    {name = "Feltzer Brown", color = 94},
    {name = "Maple Brown", color = 97},
    {name = "Beechwood Brown", color = 103},
    {name = "Sienna Brown", color = 104},
    {name = "Saddle Brown", color = 98},
    {name = "Moss Brown", color = 100},
    {name = "Woodbeech Brown", color = 102},
    {name = "Straw Brown", color = 99},
    {name = "Sandy Brown", color = 105},
    {name = "Bleached Brown", color = 106},
    {name = "Cream", color = 107},
    {name = "Ice White", color = 111},
    {name = "Frost White", color = 112},
    }

    local options = {}

    for _, clr in ipairs(colors) do
        table.insert(options, {
            title = clr.name,
            icon = 'fa-fill-drip',
            onSelect = function()
                SetVehicleColours(vehicle, clr.color, clr.color)
                exports['ox_lib']:notify({
                    description = clr.name .. ' respray applied!',
                    type = 'success'
                })
                OpenResprayMenu(vehicle)
            end
        })
    end

    exports['ox_lib']:registerContext({
        id = 'respray_menu',
        title = 'Respray Vehicle',
        options = options
    })

    exports['ox_lib']:showContext('respray_menu')
end

function ToggleExtra(vehicle, extra)
    local enabled = IsVehicleExtraTurnedOn(vehicle, extra)
    SetVehicleExtra(vehicle, extra, enabled and 1 or 0)

    exports['ox_lib']:notify({
        description = ('Extra %d %s'):format(extra, enabled and 'disabled' or 'enabled'),
        type = 'success'
    })
end

function OpenLiveryMenu(vehicle)
    local liveries = {}

    local liveryCount = GetVehicleLiveryCount(vehicle)
    if liveryCount == -1 or liveryCount == 0 then
        exports['ox_lib']:notify({
            description = 'This vehicle has no liveries.',
            type = 'error'
        })
        return
    end

    for i = 0, liveryCount - 1 do
        table.insert(liveries, {
            title = ('Livery %d'):format(i + 1),
            description = 'Preview this livery',
            icon = 'fa-paint-brush',
            onSelect = function()
                SetVehicleLivery(vehicle, i)
                exports['ox_lib']:notify({
                    description = ('Livery %d applied'):format(i + 1),
                    type = 'success'
                })
                OpenLiveryMenu(vehicle)
            end
        })
    end

    exports['ox_lib']:registerContext({
        id = 'livery_menu',
        title = 'Change Livery',
        options = liveries
    })

    exports['ox_lib']:showContext('livery_menu')
end

RegisterNetEvent('tts_repairbench:doRepair')
AddEventHandler('tts_repairbench:doRepair', function(netId)
    local vehicle = NetToVeh(netId)

    if not DoesEntityExist(vehicle) then
        print("[tts_repairbench] Vehicle does not exist.")
        return
    end

    exports['ox_lib']:progressCircle({
        duration = Config.RepairTime,
        label = 'Repairing vehicle...',
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true
        }
    })

    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleEngineHealth(vehicle, 1000.0)
    SetVehicleBodyHealth(vehicle, 1000.0)
    SetVehiclePetrolTankHealth(vehicle, 1000.0)

    exports['ox_lib']:notify({
        description = 'Vehicle repaired successfully!',
        type = 'success'
    })
end)
