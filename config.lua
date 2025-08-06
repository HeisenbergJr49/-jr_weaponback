Config = {}
Config.Locale = 'en'

-- General Settings
Config.Debug = false
Config.RefreshRate = 1000 -- How often to check for weapon changes (in ms)

-- Weapon Back Settings
Config.WeaponBack = {
    enabled = true,
    onlyOnDuty = false, -- Only show weapons when on duty (requires job check)
    hideInVehicle = true, -- Hide weapons when in vehicle
    hideWhenAiming = true, -- Hide weapons when aiming
    hideWhenDead = true, -- Hide weapons when dead
}

-- Weapon Categories that can be displayed on back
Config.WeaponCategories = {
    'WEAPON_ASSAULTRIFLE',
    'WEAPON_CARBINERIFLE',
    'WEAPON_ADVANCEDRIFLE',
    'WEAPON_SPECIALCARBINE',
    'WEAPON_BULLPUPRIFLE',
    'WEAPON_COMPACTRIFLE',
    'WEAPON_PUMPSHOTGUN',
    'WEAPON_SAWNOFFSHOTGUN',
    'WEAPON_ASSAULTSHOTGUN',
    'WEAPON_BULLPUPSHOTGUN',
    'WEAPON_MUSKET',
    'WEAPON_HEAVYSHOTGUN',
    'WEAPON_DBSHOTGUN',
    'WEAPON_AUTOSHOTGUN',
    'WEAPON_COMBATSHOTGUN',
    'WEAPON_MG',
    'WEAPON_COMBATMG',
    'WEAPON_GUSENBERG',
    'WEAPON_SNIPERRIFLE',
    'WEAPON_HEAVYSNIPER',
    'WEAPON_MARKSMANRIFLE',
    'WEAPON_RPG',
    'WEAPON_GRENADELAUNCHER',
    'WEAPON_MINIGUN',
    'WEAPON_FIREWORK',
    'WEAPON_RAILGUN',
    'WEAPON_HOMINGLAUNCHER',
    'WEAPON_COMPACTLAUNCHER',
    'WEAPON_COMBATPDW',
    'WEAPON_SMG',
    'WEAPON_ASSAULTSMG',
    'WEAPON_MICROSMG',
    'WEAPON_MINISMG'
}

-- Bone and offset settings for weapon positioning
Config.WeaponPositions = {
    ['WEAPON_ASSAULTRIFLE'] = {
        bone = 24818,
        offset = vector3(-0.25, -0.15, 0.0),
        rotation = vector3(0.0, 0.0, 0.0)
    },
    ['WEAPON_CARBINERIFLE'] = {
        bone = 24818,
        offset = vector3(-0.25, -0.15, 0.0),
        rotation = vector3(0.0, 0.0, 0.0)
    },
    -- Add more weapon positions as needed
}

-- Default position for weapons not specifically configured
Config.DefaultPosition = {
    bone = 24818, -- SKEL_SPINE_ROOT
    offset = vector3(-0.25, -0.15, 0.0),
    rotation = vector3(0.0, 0.0, 0.0)
}