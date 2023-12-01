CreateThread(function()
    local prop = "prop_xmas_tree_int"
    lib.requestModel(prop, 500)

    local obj = CreateObject(prop, H.Pos.x, H.Pos.y ,H.Pos.z, false, false, false)
    FreezeEntityPosition(obj, true)

    if H.Oxtarget then
        exports.ox_target:addBoxZone({
            coords = vec3(H.Pos.x,H.Pos.y,H.Pos.z  + 1),
            size = vec3(2.0, 2.0, 2.0),
            options = {
                {
                    label = "Avaa kalenteri",
                    icon = "fas fa-gifts",
                    onSelect = function() adventcalendarmenu() end
                },
            },
        })
    end

    while true do 
        local playerPos = GetEntityCoords(PlayerPedId(), true)
        local distance = #(playerPos - vector3(H.Pos.x, H.Pos.y, H.Pos.z))

        if distance < H.TextDistance then
            if not H.Oxtarget then
                if IsControlJustPressed(0, 38) then
                    adventcalendarmenu()
                end
            end
            Draw3DText(vec3(H.Pos.x,H.Pos.y,H.Pos.z  + 2),H.Text,H.TextSize)
        end
        Wait(1)
    end
end)

adventcalendarmenu = function()
    local day,month,avatut = lib.callback.await('h_adventcalendar:server:data', false)

    avatuut = {}
    options = {}
    for v,k in pairs(avatut) do
        avatuut[k["luuku"]] = true
    end
            
    for i=1, 24 do
        disabled = false
        if month < 12 or (month == 12 and i > day) then
            disabled = true
        end
        if not avatuut[i] then 
            options[#options + 1] = {
                title = "Joulukuun "..i,
                icon = "fas fa-gift",
                disabled = disabled,
                serverEvent = "h_adventcalendar:server:claim",
                args = i,
            }
        end
    end

    lib.registerContext({
        id = 'joulu_kala',
        title = 'Joulukalenteri',
        options = options
      })
     
    lib.showContext('joulu_kala')
end

Draw3DText = function(coords, text, scale)
    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if not onScreen then return end
    SetTextScale(scale, scale)
    SetTextOutline()
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry('STRING')
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 215)
    AddTextComponentString(text)
    DrawText(x, y)
end