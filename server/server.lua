-----------------------------------------------------
---------------- Created for you by -----------------
-------------- NightRider & SG Studios  -------------
-----------------------------------------------------

RegisterServerEvent('sg-slashtire:sync')
AddEventHandler('sg-slashtire:sync', function(id, tireIndex)
    TriggerClientEvent('sg-slashtire:sync', id, tireIndex)
end)
