-----------------------------------------------------
---------------- Created for you by -----------------
-------------- NightRider & SG Studios  -------------
-----------------------------------------------------

CreateThread(function()
    local bones = {
        'wheel_lf', 'wheel_rf', 'wheel_lm1', 'wheel_rm1',
        'wheel_lm2', 'wheel_rm2', 'wheel_lm3', 'wheel_rm3',
        'wheel_lr', 'wheel_rr'
    }

    local target = Config.TargetSystem

    if target == 'qtarget' then
        exports.qtarget:AddTargetBone(bones, {
            options = {
                {
                    event = 'sg-slashtire:slash',
                    icon = 'fas fa-info',
                    label = 'Slash Tire',
                    num = 1
                },
            },
            distance = 1
        })


    elseif target == 'qb-target' then
        exports['qb-target']:AddTargetBone(bones, {
            options = {
                {
                    event = 'sg-slashtire:slash',
                    icon = 'fas fa-info',
                    label = 'Slash Tire',
                    num = 1
                },
            },
            distance = 1
        })


    elseif target == 'ox_target' then
        exports.ox_target:addBone(bones, {
            {
                name = 'sg_slashtire_action',
                event = 'sg-slashtire:slash',
                icon = 'fas fa-info',
                label = 'Slash Tire'
            }
        })
    end
end)

RegisterNetEvent('sg-slashtire:slash', function()
    local vehicle = GetClosestVehicleToPlayer()
    if vehicle ~= 0 then
        if CanUseWeapon(Config.allowedWeapons) then
            local closestTire = GetClosestVehicleTire(vehicle)
            if closestTire ~= nil then
                if not IsVehicleTyreBurst(vehicle, closestTire.tireIndex, 0) then

                    local animDict = 'melee@knife@streamed_core_fps'
                    local animName = 'ground_attack_on_spot'
                    loadDict(animDict)

                    local animDuration = GetAnimDuration(animDict, animName)
                    TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, -8.0, animDuration, 15, 1.0, 0, 0, 0)

                    Wait((animDuration / 2) * 1000)

                    local driverId = GetDriverOfVehicle(vehicle)
                    local driverServId = GetPlayerServerId(driverId)

                    if driverServId == 0 then
                        SetEntityAsMissionEntity(vehicle, true, true)
                        SetVehicleTyreBurst(vehicle, closestTire.tireIndex, 0, 100.0)
                        SetEntityAsNoLongerNeeded(vehicle)
                    else
                        TriggerServerEvent('sg-slashtire:sync', driverServId, closestTire.tireIndex)
                    end

                    Wait((animDuration / 2) * 1000)
                    ClearPedTasks(PlayerPedId())
                    RemoveAnimDict(animDict)

                else
                    TriggerEvent('sg-slashtire:notify', Language['already_slashed'])
                end
            end
        else
            TriggerEvent('sg-slashtire:notify', Language['no_weapon'])
        end
    end
end)

RegisterNetEvent('sg-slashtire:sync')
AddEventHandler('sg-slashtire:sync', function(tireIndex)
    TriggerEvent('sg-slashtire:notify', Language['car_slashed'])
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    SetVehicleTyreBurst(vehicle, tireIndex, 0, 100.0)
end)

