-- Pay & Spray Client (Improved)
local showing = false

-- Helper: Check if player is near a mechanic location
local function isNearMechanic()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    for _, loc in ipairs(PayNSpray.Locations) do
        if #(coords - vector3(loc.x, loc.y, loc.z)) < PayNSpray.DrawDistance then
            return loc
        end
    end
    return false
end

local function showPrompt()
    lib.showTextUI('[G] - Pay & Spray', { -- Changed E to G in prompt
        position = "top-center",
        icon = 'car',
        style = {
            borderRadius = 0,
            backgroundColor = '#292929',
            color = 'white'
        }
    })
end

local function hidePrompt()
    lib.hideTextUI()
end

-- Color and Tint Options
local function getColorOptions()
    return {
        { label = "Black", color = 0 },
        { label = "White", color = 111 },
        { label = "Red", color = 27 },
        { label = "Blue", color = 64 },
        { label = "Green", color = 55 },
        { label = "Yellow", color = 88 },
        { label = "Pink", color = 135 },
        { label = "Orange", color = 38 },
        { label = "Purple", color = 145 },
        { label = "Silver", color = 4 }
    }
end

local function getTintOptions()
    return {
        { label = "None", tint = 0 },
        { label = "Pure Black", tint = 1 },
        { label = "Darksmoke", tint = 2 },
        { label = "Lightsmoke", tint = 3 },
        { label = "Limo", tint = 4 },
        { label = "Green", tint = 5 }
    }
end

local function getUpgradeOptions()
    return {
        { label = "Engine Upgrade (Level 1)", modType = 11, modIndex = 0, price = 500 },
        { label = "Engine Upgrade (Level 2)", modType = 11, modIndex = 1, price = 1000 },
        { label = "Engine Upgrade (Level 3)", modType = 11, modIndex = 2, price = 2000 },
        { label = "Engine Upgrade (Level 4)", modType = 11, modIndex = 3, price = 4000 },
        { label = "Turbo", modType = 18, modIndex = 1, price = 2500 },
        { label = "Transmission Upgrade", modType = 13, modIndex = 2, price = 1500 },
        { label = "Suspension Upgrade", modType = 15, modIndex = 3, price = 1200 },
        { label = "Armor Upgrade", modType = 16, modIndex = 4, price = 3000 }
    }
end

-- Menu registration
lib.registerContext({
    id = 'paynspray_menu',
    title = 'Pay & Spray',
    options = {
        {
            title = 'Repair Vehicle ($' .. PayNSpray.RepairPrice .. ')',
            icon = 'wrench',
            onSelect = function()
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                if veh == 0 then
                    lib.notify({
                        title = 'Pay & Spray',
                        description = 'You must be in a vehicle!',
                        type = 'error'
                    })
                    return
                end
                TriggerServerEvent('paynspray:attemptRepair')
            end
        },
        {
            title = 'Change Vehicle Color',
            icon = 'palette',
            onSelect = function()
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                if veh == 0 then
                    lib.notify({
                        title = 'Pay & Spray',
                        description = 'You must be in a vehicle!',
                        type = 'error'
                    })
                    return
                end
                local colorOptions = {}
                for _, c in ipairs(getColorOptions()) do
                    table.insert(colorOptions, {
                        title = c.label,
                        onSelect = function()
                            TriggerServerEvent('paynspray:attemptColorChange', c.color)
                        end
                    })
                end
                lib.registerContext({
                    id = 'paynspray_color_menu',
                    title = 'Select Color',
                    options = colorOptions
                })
                lib.showContext('paynspray_color_menu')
            end
        },
        {
            title = 'Apply Window Tint',
            icon = 'window-maximize',
            onSelect = function()
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                if veh == 0 then
                    lib.notify({
                        title = 'Pay & Spray',
                        description = 'You must be in a vehicle!',
                        type = 'error'
                    })
                    return
                end
                local tintOptions = {}
                for _, t in ipairs(getTintOptions()) do
                    table.insert(tintOptions, {
                        title = t.label,
                        onSelect = function()
                            TriggerServerEvent('paynspray:attemptTintChange', t.tint)
                        end
                    })
                end
                lib.registerContext({
                    id = 'paynspray_tint_menu',
                    title = 'Select Window Tint',
                    options = tintOptions
                })
                lib.showContext('paynspray_tint_menu')
            end
        },
        {
            title = 'Upgrade Vehicle',
            icon = 'star',
            onSelect = function()
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                if veh == 0 then
                    lib.notify({
                        title = 'Pay & Spray',
                        description = 'You must be in a vehicle!',
                        type = 'error'
                    })
                    return
                end
                local upgradeOptions = {}
                for _, u in ipairs(getUpgradeOptions()) do
                    table.insert(upgradeOptions, {
                        title = u.label .. " ($" .. u.price .. ")",
                        onSelect = function()
                            TriggerServerEvent('paynspray:attemptUpgrade', u.modType, u.modIndex, u.price)
                        end
                    })
                end
                lib.registerContext({
                    id = 'paynspray_upgrade_menu',
                    title = 'Select Upgrade',
                    options = upgradeOptions
                })
                lib.showContext('paynspray_upgrade_menu')
            end
        }
    }
})

-- Main thread for prompt and menu
CreateThread(function()
    while true do
        Wait(0)
        local nearLoc = isNearMechanic()
        if nearLoc then
            if not showing then
                showPrompt()
                showing = true
            end
            if IsControlJustReleased(0, 47) then -- G key (was 38 for E)
                TriggerEvent('paynspray:openMenu')
            end
        else
            if showing then
                hidePrompt()
                showing = false
            end
            Wait(500)
        end
    end
end)

RegisterNetEvent('paynspray:openMenu', function()
    lib.showContext('paynspray_menu')
end)

RegisterNetEvent('paynspray:repairSuccess', function()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh == 0 then return end
    lib.progressCircle({
        duration = 4000,
        label = 'Repairing vehicle...',
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = { move = true, car = true, mouse = false, combat = true }
    })
    SetVehicleFixed(veh)
    SetVehicleDirtLevel(veh, 0.0)
    lib.notify({
        title = 'Pay & Spray',
        description = 'Your vehicle has been repaired!',
        type = 'success'
    })
    TriggerEvent('chat:addMessage', {
        color = { 0, 255, 0 },
        multiline = true,
        args = { "^4[INFO]", "You have successfully customized your vehicle." }
    })
end)

RegisterNetEvent('paynspray:repairFailed', function(reason)
    lib.notify({
        title = 'Pay & Spray',
        description = reason or 'Not enough cash!',
        type = 'error'
    })
end)

-- Color change success/fail
RegisterNetEvent('paynspray:colorSuccess', function(color)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh == 0 then return end
    lib.progressCircle({
        duration = 2500,
        label = 'Changing color...',
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = { move = true, car = true, mouse = false, combat = true }
    })
    -- Set both primary and secondary color for best effect
    SetVehicleColours(veh, color, color)
    -- For pearlescent/extra color, you can also use SetVehicleExtraColours(veh, color, color)
    WashDecalsFromVehicle(veh, 1.0)
    SetVehicleDirtLevel(veh, 0.0)
    lib.notify({
        title = 'Pay & Spray',
        description = 'Color applied!',
        type = 'success'
    })
end)

RegisterNetEvent('paynspray:colorFailed', function(reason)
    lib.notify({
        title = 'Pay & Spray',
        description = reason or 'Could not change color!',
        type = 'error'
    })
end)

-- Tint change success/fail
RegisterNetEvent('paynspray:tintSuccess', function(tint)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh == 0 then return end
    lib.progressCircle({
        duration = 2000,
        label = 'Applying window tint...',
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = { move = true, car = true, mouse = false, combat = true }
    })
    SetVehicleWindowTint(veh, tint)
    lib.notify({
        title = 'Pay & Spray',
        description = 'Window tint applied!',
        type = 'success'
    })
end)

RegisterNetEvent('paynspray:tintFailed', function(reason)
    lib.notify({
        title = 'Pay & Spray',
        description = reason or 'Could not apply tint!',
        type = 'error'
    })
end)

-- Upgrade success/fail
RegisterNetEvent('paynspray:upgradeSuccess', function(modType, modIndex)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh == 0 then return end
    lib.progressCircle({
        duration = 2500,
        label = 'Upgrading vehicle...',
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = { move = true, car = true, mouse = false, combat = true }
    })
    SetVehicleModKit(veh, 0)
    SetVehicleMod(veh, modType, modIndex, false)
    if modType == 18 then -- Turbo
        ToggleVehicleMod(veh, 18, true)
    end
    lib.notify({
        title = 'Pay & Spray',
        description = 'Upgrade applied!',
        type = 'success'
    })
end)

RegisterNetEvent('paynspray:upgradeFailed', function(reason)
    lib.notify({
        title = 'Pay & Spray',
        description = reason or 'Could not apply upgrade!',
        type = 'error'
    })
end)