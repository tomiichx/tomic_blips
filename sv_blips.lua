local organisationMembers = {}

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    for i = 1, #shared.allowedOrganisations do
        if xPlayer.job.name == shared.allowedOrganisations[i] then
            organisationMembers[playerId] = { name = GetPlayerName(playerId), job = xPlayer.job.name, source = playerId }
        end
    end
end)

AddEventHandler('esx:playerDropped', function(playerId)
    organisationMembers[playerId] = nil
end)

AddEventHandler('esx:setJob', function(playerId, job)
    organisationMembers[playerId] = nil
    for i = 1, #shared.allowedOrganisations do
        if job.name == shared.allowedOrganisations[i] then
            organisationMembers[playerId] = { name = GetPlayerName(playerId), job = job.name, source = playerId }
        end
    end
end)

CreateThread(function()
    while true do
        Wait(shared.refreshRate)
        TriggerClientEvent('tomic_blips:organisationMembers', -1, organisationMembers)
    end
end)

local function checkForUpdates()
    local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
    PerformHttpRequest('https://api.github.com/repos/tomiichx/tomic_blips/releases/latest', function(code, response)
        if code ~= 200 then
            return print('devTomic | There was an error while checking for updates.')
        end

        local returnedData = json.decode(response)
        local latestVersion, downloadLink = returnedData.tag_name, returnedData.html_url

        if currentVersion == latestVersion then
            return print('devTomic | You are using the latest version of ' .. GetCurrentResourceName())
        end

        print('\n')
        print('devTomic | There is a new update available for ' .. GetCurrentResourceName())
        print('devTomic | Your version: ' .. currentVersion .. ' | New version: ' .. latestVersion)
        print('devTomic | Download it from: ' .. downloadLink)
        print('\n')
    end, 'GET')
end

checkForUpdates()