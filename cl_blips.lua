local PlayerData, organisationBlips = {}, {}

CreateThread(function()
    ESX = exports['es_extended']:getSharedObject()
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('tomic_blips:organisationMembers')
AddEventHandler('tomic_blips:organisationMembers', function(organisationMembers)
    if organisationBlips ~= nil then
        for k, v in pairs(organisationBlips) do
            RemoveBlip(v)
        end
    end

    organisationBlips = {}

    for k, v in pairs(organisationMembers) do
        local serverPed = GetPlayerFromServerId(v.source)
        local playerCoords = GetEntityCoords(GetPlayerPed(serverPed))
        local blip = AddBlipForCoord(playerCoords)

        if PlayerData.job.name ~= v.job then
            SetBlipDisplay(blip, 0)
        end

        SetBlipSprite(blip, 1)
        SetBlipColour(blip, 1)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(string.format(shared.blipName, v.name))
        EndTextCommandSetBlipName(blip)
        organisationBlips[#organisationBlips + 1] = blip
    end
end)