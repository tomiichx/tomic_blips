local PlayerData, organisationBlips = {}, {}

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
        if PlayerData.job?.name == v.job then
            local blip = AddBlipForCoord(v.coords)
            SetBlipSprite(blip, 1)
            SetBlipColour(blip, 1)
            SetBlipScale(blip, 0.8)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(string.format(shared.blipName, v.name))
            EndTextCommandSetBlipName(blip)
            organisationBlips[#organisationBlips + 1] = blip
        end
    end
end)
