local ESX = nil
local PlayerData = {}
local attachedWeapons = {}
local isPlayerDead = false
local isPlayerAiming = false
local isInVehicle = false

-- Initialize ESX
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

-- Player data event handlers
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

-- Utility functions
local function IsWeaponOnBack(weaponHash)
    for _, weapon in pairs(Config.WeaponCategories) do
        if GetHashKey(weapon) == weaponHash then
            return true
        end
    end
    return false
end

local function GetWeaponPosition(weaponName)
    return Config.WeaponPositions[weaponName] or Config.DefaultPosition
end

local function ShouldShowWeapons()
    if not Config.WeaponBack.enabled then return false end
    if Config.WeaponBack.hideWhenDead and isPlayerDead then return false end
    if Config.WeaponBack.hideInVehicle and isInVehicle then return false end
    if Config.WeaponBack.hideWhenAiming and isPlayerAiming then return false end
    if Config.WeaponBack.onlyOnDuty and PlayerData.job and PlayerData.job.name ~= 'police' then return false end
    
    return true
end

local function DebugPrint(message)
    if Config.Debug then
        print("[jr_weaponback] " .. message)
    end
end

-- Weapon attachment functions
local function AttachWeaponToBack(ped, weaponHash, weaponName)
    if attachedWeapons[weaponHash] then
        DebugPrint("Weapon already attached: " .. weaponName)
        return
    end

    local position = GetWeaponPosition(weaponName)
    local boneIndex = GetPedBoneIndex(ped, position.bone)
    
    if boneIndex == -1 then
        DebugPrint("Invalid bone index for weapon: " .. weaponName)
        return
    end

    -- Create weapon object
    local weaponObject = CreateObject(weaponHash, 0, 0, 0, true, true, false)
    
    if not DoesEntityExist(weaponObject) then
        DebugPrint("Failed to create weapon object: " .. weaponName)
        return
    end

    -- Attach weapon to back
    AttachEntityToEntity(
        weaponObject, ped, boneIndex,
        position.offset.x, position.offset.y, position.offset.z,
        position.rotation.x, position.rotation.y, position.rotation.z,
        true, true, false, true, 1, true
    )

    -- Store attached weapon info
    attachedWeapons[weaponHash] = {
        object = weaponObject,
        name = weaponName,
        bone = position.bone
    }

    DebugPrint("Attached weapon to back: " .. weaponName)
end

local function DetachWeaponFromBack(weaponHash, weaponName)
    if not attachedWeapons[weaponHash] then
        DebugPrint("Weapon not attached: " .. weaponName)
        return
    end

    local weaponData = attachedWeapons[weaponHash]
    
    if DoesEntityExist(weaponData.object) then
        DetachEntity(weaponData.object, true, false)
        DeleteEntity(weaponData.object)
    end

    attachedWeapons[weaponHash] = nil
    DebugPrint("Detached weapon from back: " .. weaponName)
end

local function DetachAllWeapons()
    for weaponHash, weaponData in pairs(attachedWeapons) do
        if DoesEntityExist(weaponData.object) then
            DetachEntity(weaponData.object, true, false)
            DeleteEntity(weaponData.object)
        end
    end
    attachedWeapons = {}
    DebugPrint("Detached all weapons from back")
end

-- Animation functions
local function PlayHolsterAnimation()
    local ped = PlayerPedId()
    RequestAnimDict("reaction@intimidation@1h")
    while not HasAnimDictLoaded("reaction@intimidation@1h") do
        Citizen.Wait(0)
    end
    TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 8.0, 1.0, -1, 50, 0, false, false, false)
    Citizen.Wait(1000)
end

local function PlayUnholsterAnimation()
    local ped = PlayerPedId()
    RequestAnimDict("reaction@intimidation@1h")
    while not HasAnimDictLoaded("reaction@intimidation@1h") do
        Citizen.Wait(0)
    end
    TaskPlayAnim(ped, "reaction@intimidation@1h", "outro", 8.0, 1.0, -1, 50, 0, false, false, false)
    Citizen.Wait(1000)
end

-- Main weapon management thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.RefreshRate)
        
        if ESX and PlayerData then
            local ped = PlayerPedId()
            local currentWeapon = GetSelectedPedWeapon(ped)
            
            -- Update player state
            isPlayerDead = IsEntityDead(ped)
            isPlayerAiming = IsPlayerFreeAiming(ped)
            isInVehicle = IsPedInAnyVehicle(ped, false)
            
            if ShouldShowWeapons() then
                -- Check all weapons in inventory
                for _, weaponName in pairs(Config.WeaponCategories) do
                    local weaponHash = GetHashKey(weaponName)
                    local hasWeapon = HasPedGotWeapon(ped, weaponHash, false)
                    
                    if hasWeapon and currentWeapon ~= weaponHash then
                        -- Player has weapon but it's not currently selected - show on back
                        if not attachedWeapons[weaponHash] then
                            AttachWeaponToBack(ped, weaponHash, weaponName)
                        end
                    else
                        -- Player doesn't have weapon or it's currently selected - remove from back
                        if attachedWeapons[weaponHash] then
                            DetachWeaponFromBack(weaponHash, weaponName)
                        end
                    end
                end
            else
                -- Should not show weapons - detach all
                DetachAllWeapons()
            end
        end
    end
end)

-- Weapon switch event handler
RegisterNetEvent('jr_weaponback:weaponSwitch')
AddEventHandler('jr_weaponback:weaponSwitch', function(oldWeapon, newWeapon)
    if not ShouldShowWeapons() then return end
    
    local ped = PlayerPedId()
    
    -- Handle old weapon (put on back if it's a back weapon)
    if oldWeapon and IsWeaponOnBack(oldWeapon) then
        local weaponName = nil
        for _, weapon in pairs(Config.WeaponCategories) do
            if GetHashKey(weapon) == oldWeapon then
                weaponName = weapon
                break
            end
        end
        
        if weaponName and not attachedWeapons[oldWeapon] then
            PlayHolsterAnimation()
            AttachWeaponToBack(ped, oldWeapon, weaponName)
        end
    end
    
    -- Handle new weapon (remove from back if it's a back weapon)
    if newWeapon and IsWeaponOnBack(newWeapon) then
        if attachedWeapons[newWeapon] then
            PlayUnholsterAnimation()
            DetachWeaponFromBack(newWeapon, "")
        end
    end
end)

-- Distance culling for performance optimization
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000) -- Check every 2 seconds
        
        if ESX and PlayerData then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            
            -- Get all players
            for _, playerId in ipairs(GetActivePlayers()) do
                if playerId ~= PlayerId() then
                    local otherPed = GetPlayerPed(playerId)
                    local otherCoords = GetEntityCoords(otherPed)
                    local distance = #(playerCoords - otherCoords)
                    
                    -- Hide/show weapons based on distance (optimization)
                    if distance > 50.0 then
                        -- Too far away, can hide detailed weapon models
                        -- This is handled automatically by GTA's LOD system
                    end
                end
            end
        end
    end
end)

-- Admin commands
RegisterCommand('weaponback_toggle', function(source, args, rawCommand)
    if PlayerData.group == 'admin' or PlayerData.group == 'superadmin' then
        Config.WeaponBack.enabled = not Config.WeaponBack.enabled
        local status = Config.WeaponBack.enabled and "enabled" or "disabled"
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            multiline = true,
            args = {"WeaponBack", "System " .. status}
        })
        
        if not Config.WeaponBack.enabled then
            DetachAllWeapons()
        end
    else
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"WeaponBack", "You don't have permission to use this command"}
        })
    end
end, false)

RegisterCommand('weaponback_debug', function(source, args, rawCommand)
    if PlayerData.group == 'admin' or PlayerData.group == 'superadmin' then
        Config.Debug = not Config.Debug
        local status = Config.Debug and "enabled" or "disabled"
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            multiline = true,
            args = {"WeaponBack", "Debug mode " .. status}
        })
    else
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"WeaponBack", "You don't have permission to use this command"}
        })
    end
end, false)

RegisterCommand('weaponback_reload', function(source, args, rawCommand)
    if PlayerData.group == 'admin' or PlayerData.group == 'superadmin' then
        DetachAllWeapons()
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            multiline = true,
            args = {"WeaponBack", "System reloaded - all weapons detached"}
        })
    else
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"WeaponBack", "You don't have permission to use this command"}
        })
    end
end, false)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DetachAllWeapons()
        DebugPrint("Resource stopped - cleaned up all weapons")
    end
end)

-- Player spawn handler
AddEventHandler('playerSpawned', function()
    Citizen.Wait(5000) -- Wait for player to fully spawn
    DetachAllWeapons() -- Clean slate on spawn
end)

-- Export functions for other resources
exports('AttachWeaponToBack', AttachWeaponToBack)
exports('DetachWeaponFromBack', DetachWeaponFromBack)
exports('DetachAllWeapons', DetachAllWeapons)
exports('IsWeaponOnBack', IsWeaponOnBack)