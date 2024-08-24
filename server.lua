

function getSteamId(player)
    for k, v in pairs(GetPlayerIdentifiers(player)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        end
    end
    return steamid
end


AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    deferrals.defer()
    local steamHEX = getSteamId(source)
    if steamHEX == nil then deferrals.done(Config.Lang['steamNotOpen']) return end
    local steamstr = string.sub(getSteamId(source), 7)
    local steamID = tonumber(steamstr, 16)

    PerformHttpRequest(("https://api.steampowered.com/IPlayerService/GetSteamLevel/v1/?key=%s&steamid=%s"):format(Config.SteamWebApiKey, steamID), function(err, data, headers)
        if err == 200 then 
            local decodedData = json.decode(data)
            if decodedData.response.player_level >= 1 then
                deferrals.done() 
            end

            deferrals.done(Config.Lang['minSteamLevel'])
        else 
            print('ERROR : your Steam Api Web Key is INVALID')
        end
    end)
end)