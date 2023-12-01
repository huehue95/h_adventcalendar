lib.callback.register('h_adventcalendar:server:data', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = MySQL.query.await('SELECT `luuku` FROM `h_adventcalendar` WHERE `identifier` = ?', {
        xPlayer.identifier
    })

    local current_time = os.date("*t")
    current_time.isdst = false 
    local helsinki_time = os.time(current_time)

    return tonumber(os.date("%d", helsinki_time)),tonumber(os.date("%m", helsinki_time)),result
end)

RegisterNetEvent("h_adventcalendar:server:claim")
AddEventHandler("h_adventcalendar:server:claim",function(claim_day)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    local current_time = os.date("*t")
    current_time.isdst = false 
    local helsinki_time = os.time(current_time)

    local day,month = tonumber(os.date("%d", helsinki_time)),tonumber(os.date("%m", helsinki_time))

    local result = MySQL.query.await('SELECT `luuku` FROM `h_adventcalendar` WHERE `identifier` = ? AND `luuku` = ?', {
        xPlayer.identifier,claim_day
    })


    if month == 12 and claim_day <= day  and result[1] == nil then
        MySQL.insert('INSERT INTO `h_adventcalendar` (identifier, luuku) VALUES (?, ?)', {
            xPlayer.identifier, claim_day
        }, function(id)
            for _,i in pairs(H.Prize[claim_day]) do
                if i.item == "money" then
                    xPlayer.addMoney(i.count)
                else
                    xPlayer.addInventoryItem(i.item, i.count)
                end
            end
        end)
    end
end)