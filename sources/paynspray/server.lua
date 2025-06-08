RegisterNetEvent('paynspray:attemptRepair', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local price = PayNSpray.RepairPrice
    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        TriggerClientEvent('paynspray:repairSuccess', src)

        TriggerClientEvent('chat:addMessage', src, {
            color = { 0, 255, 0 },
            multiline = false,
            args = { "^4[INFO]", "Your vehicle is being repaired for $" .. price .. "." }
        })
        TriggerClientEvent('chat:addMessage', src, {
            color = { 0, 200, 255 },
            multiline = false,
            args = { "^3[INFO]", "Thank you for using Pay & Spray! Drive safely." }
        })
    else
        TriggerClientEvent('paynspray:repairFailed', src, 'You do not have enough cash!')
        -- Failure chat messages
        TriggerClientEvent('chat:addMessage', src, {
            color = { 255, 0, 0 },
            multiline = false,
            args = { "^1ERROR", "You do not have enough cash for repairs! ($" .. price .. " required)" }
        })
        TriggerClientEvent('chat:addMessage', src, {
            color = { 255, 255, 0 },
            multiline = false,
            args = { "^3[INFO]", "Earn more money and come back soon!" }
        })
    end
end)

RegisterNetEvent('paynspray:attemptColorChange', function(color)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local price = PayNSpray.ColorPrice or 500
    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        TriggerClientEvent('paynspray:colorSuccess', src, color)
        TriggerClientEvent('chat:addMessage', src, {
            color = { 0, 255, 0 },
            multiline = false,
            args = { "^4[INFO]", "Your vehicle color is being changed for $" .. price .. "." }
        })
    else
        TriggerClientEvent('paynspray:colorFailed', src, 'You do not have enough cash!')
        TriggerClientEvent('chat:addMessage', src, {
            color = { 255, 0, 0 },
            multiline = false,
            args = { "^1ERROR", "You do not have enough cash for a color change! ($" .. price .. " required)" }
        })
    end
end)

RegisterNetEvent('paynspray:attemptTintChange', function(tint)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local price = PayNSpray.TintPrice or 350
    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        TriggerClientEvent('paynspray:tintSuccess', src, tint)
        TriggerClientEvent('chat:addMessage', src, {
            color = { 0, 255, 0 },
            multiline = false,
            args = { "^4[INFO]", "Your window tint is being applied for $" .. price .. "." }
        })
    else
        TriggerClientEvent('paynspray:tintFailed', src, 'You do not have enough cash!')
        TriggerClientEvent('chat:addMessage', src, {
            color = { 255, 0, 0 },
            multiline = false,
            args = { "^1ERROR", "You do not have $" .. price .. " for new window tint come back when you have enough cash." }
        })
    end
end)

RegisterNetEvent('paynspray:attemptUpgrade', function(modType, modIndex, price)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    price = tonumber(price) or 1000
    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        TriggerClientEvent('paynspray:upgradeSuccess', src, modType, modIndex)
        TriggerClientEvent('chat:addMessage', src, {
            color = { 0, 255, 0 },
            multiline = false,
            args = { "^3[INFO]", "Your vehicle upgrade is being installed for $" .. price .. "." }
        })
    else
        TriggerClientEvent('paynspray:upgradeFailed', src, 'You do not have enough cash!')
        TriggerClientEvent('chat:addMessage', src, {
            color = { 255, 0, 0 },
            multiline = false,
            args = { "^1ERROR", "You do not have enough cash for this upgrade! ($" .. price .. " required)" }
        })
    end
end)
