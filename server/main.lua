local ESX = nil

-- Initialize ESX
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Player weapon tracking
local playerWeapons = {}

-- Utility functions
local function DebugPrint(message)
    if Config.Debug then
        print("[jr_weaponback] [SERVER] " .. message)
    end
end

local function IsWeaponAllowed(weaponName)
    for _, weapon in pairs(Config.WeaponCategories) do
        if weapon == weaponName then
            return true
        end
    end
    return false
end

-- Player connection handlers
AddEventHandler('playerConnecting', function()
    local source = source
    playerWeapons[source] = {}
    DebugPrint("Player " .. source .. " connecting - initialized weapon tracking")
end)

AddEventHandler('playerDropped', function()
    local source = source
    if playerWeapons[source] then
        playerWeapons[source] = nil
        DebugPrint("Player " .. source .. " disconnected - cleaned up weapon tracking")
    end
end)

-- ESX player loaded handler
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    playerWeapons[playerId] = {}
    DebugPrint("ESX player loaded: " .. playerId .. " - initialized weapon tracking")
end)

-- Weapon validation and sync events
RegisterNetEvent('jr_weaponback:syncWeapon')
AddEventHandler('jr_weaponback:syncWeapon', function(weaponData)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then
        DebugPrint("Invalid player trying to sync weapon: " .. source)
        return
    end
    
    -- Validate weapon data
    if not weaponData or not weaponData.name or not weaponData.hash then
        DebugPrint("Invalid weapon data from player: " .. source)
        return
    end
    
    -- Check if weapon is allowed
    if not IsWeaponAllowed(weaponData.name) then
        DebugPrint("Player " .. source .. " tried to sync disallowed weapon: " .. weaponData.name)
        TriggerClientEvent('jr_weaponback:weaponDenied', source, weaponData.name)
        return
    end
    
    -- Check if player actually has the weapon
    local hasWeapon = false
    for _, weapon in pairs(xPlayer.getLoadout()) do
        if weapon.name == weaponData.name then
            hasWeapon = true
            break
        end
    end
    
    if not hasWeapon then
        DebugPrint("Player " .. source .. " tried to sync weapon they don't have: " .. weaponData.name)
        TriggerClientEvent('jr_weaponback:weaponDenied', source, weaponData.name)
        return
    end
    
    -- Update player weapon tracking
    if not playerWeapons[source] then
        playerWeapons[source] = {}
    end
    
    playerWeapons[source][weaponData.hash] = {
        name = weaponData.name,
        timestamp = os.time()
    }
    
    DebugPrint("Weapon sync approved for player " .. source .. ": " .. weaponData.name)
    
    -- Notify nearby players about weapon change
    TriggerClientEvent('jr_weaponback:playerWeaponUpdate', -1, source, weaponData)
end)

RegisterNetEvent('jr_weaponback:removeWeapon')
AddEventHandler('jr_weaponback:removeWeapon', function(weaponHash)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then
        DebugPrint("Invalid player trying to remove weapon: " .. source)
        return
    end
    
    if playerWeapons[source] and playerWeapons[source][weaponHash] then
        local weaponName = playerWeapons[source][weaponHash].name
        playerWeapons[source][weaponHash] = nil
        DebugPrint("Weapon removed for player " .. source .. ": " .. weaponName)
        
        -- Notify nearby players about weapon removal
        TriggerClientEvent('jr_weaponback:playerWeaponRemove', -1, source, weaponHash)
    end
end)

-- Admin commands server-side handling
RegisterNetEvent('jr_weaponback:adminCommand')
AddEventHandler('jr_weaponback:adminCommand', function(command, targetId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Check admin permissions
    if xPlayer.getGroup() ~= 'admin' and xPlayer.getGroup() ~= 'superadmin' then
        TriggerClientEvent('esx:showNotification', source, '~r~You don\'t have permission to use this command')
        return
    end
    
    if command == 'reload_all' then
        -- Force reload for all players
        TriggerClientEvent('jr_weaponback:forceReload', -1)
        TriggerClientEvent('esx:showNotification', source, '~g~Weapon back system reloaded for all players')
        DebugPrint("Admin " .. source .. " reloaded weapon back system for all players")
        
    elseif command == 'reload_player' and targetId then
        local targetPlayer = ESX.GetPlayerFromId(targetId)
        if targetPlayer then
            TriggerClientEvent('jr_weaponback:forceReload', targetId)
            TriggerClientEvent('esx:showNotification', source, '~g~Weapon back system reloaded for player ' .. targetId)
            DebugPrint("Admin " .. source .. " reloaded weapon back system for player " .. targetId)
        else
            TriggerClientEvent('esx:showNotification', source, '~r~Player not found')
        end
        
    elseif command == 'toggle_global' then
        -- This would require database storage to persist across restarts
        TriggerClientEvent('jr_weaponback:toggleGlobal', -1)
        TriggerClientEvent('esx:showNotification', source, '~y~Global weapon back toggle broadcasted')
        DebugPrint("Admin " .. source .. " toggled global weapon back system")
    end
end)

-- Anti-cheat and validation
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000) -- Check every 30 seconds
        
        for playerId, weapons in pairs(playerWeapons) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer then
                local currentTime = os.time()
                
                -- Clean up old weapon entries
                for weaponHash, weaponData in pairs(weapons) do
                    if currentTime - weaponData.timestamp > 300 then -- 5 minutes old
                        weapons[weaponHash] = nil
                        DebugPrint("Cleaned up old weapon entry for player " .. playerId .. ": " .. weaponData.name)
                    end
                end
                
                -- Validate current weapons against ESX loadout
                local loadout = xPlayer.getLoadout()
                local validWeapons = {}
                
                for _, weapon in pairs(loadout) do
                    if IsWeaponAllowed(weapon.name) then
                        validWeapons[GetHashKey(weapon.name)] = true
                    end
                end
                
                -- Remove weapons that player no longer has
                for weaponHash, weaponData in pairs(weapons) do
                    if not validWeapons[weaponHash] then
                        weapons[weaponHash] = nil
                        TriggerClientEvent('jr_weaponback:weaponDenied', playerId, weaponData.name)
                        DebugPrint("Removed invalid weapon for player " .. playerId .. ": " .. weaponData.name)
                    end
                end
            else
                -- Player no longer exists, clean up
                playerWeapons[playerId] = nil
            end
        end
    end
end)

-- Logging and statistics
local stats = {
    weaponsSynced = 0,
    weaponsRemoved = 0,
    adminCommands = 0,
    validationFailures = 0
}

RegisterNetEvent('jr_weaponback:updateStats')
AddEventHandler('jr_weaponback:updateStats', function(statType)
    if stats[statType] then
        stats[statType] = stats[statType] + 1
    end
end)

-- Export server stats for monitoring
RegisterCommand('weaponback_stats', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or (xPlayer.getGroup() ~= 'admin' and xPlayer.getGroup() ~= 'superadmin') then
        return
    end
    
    local message = string.format(
        "WeaponBack Stats:\nWeapons Synced: %d\nWeapons Removed: %d\nAdmin Commands: %d\nValidation Failures: %d\nActive Players: %d",
        stats.weaponsSynced,
        stats.weaponsRemoved,
        stats.adminCommands,
        stats.validationFailures,
        ESX.GetPlayerList() and #ESX.GetPlayerList() or 0
    )
    
    TriggerClientEvent('chat:addMessage', source, {
        color = {0, 255, 255},
        multiline = true,
        args = {"WeaponBack Stats", message}
    })
end, false)

-- Resource management
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DebugPrint("jr_weaponback server started")
        playerWeapons = {}
        
        -- Reset stats
        stats.weaponsSynced = 0
        stats.weaponsRemoved = 0
        stats.adminCommands = 0
        stats.validationFailures = 0
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DebugPrint("jr_weaponback server stopped")
        
        -- Notify all clients to clean up
        TriggerClientEvent('jr_weaponback:forceReload', -1)
        
        -- Clear tracking data
        playerWeapons = {}
    end
end)

-- Multi-language support
local Locales = {
    ['en'] = {
        ['weapon_denied'] = 'Weapon not allowed on back: %s',
        ['admin_only'] = 'This command is for administrators only',
        ['player_not_found'] = 'Player not found',
        ['system_reloaded'] = 'Weapon back system reloaded',
        ['invalid_weapon'] = 'Invalid weapon data received'
    },
    ['de'] = {
        ['weapon_denied'] = 'Waffe nicht erlaubt auf dem Rücken: %s',
        ['admin_only'] = 'Dieser Befehl ist nur für Administratoren',
        ['player_not_found'] = 'Spieler nicht gefunden',
        ['system_reloaded'] = 'Waffen-Rücken-System neu geladen',
        ['invalid_weapon'] = 'Ungültige Waffendaten erhalten'
    }
}

function GetLocalizedText(key, ...)
    local locale = Config.Locale or 'en'
    local text = Locales[locale] and Locales[locale][key] or Locales['en'][key] or key
    return string.format(text, ...)
end

-- Export functions for other resources
exports('GetPlayerWeapons', function(playerId)
    return playerWeapons[playerId] or {}
end)

exports('IsWeaponAllowed', IsWeaponAllowed)
exports('GetWeaponStats', function()
    return stats
end)