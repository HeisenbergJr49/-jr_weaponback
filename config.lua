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
    maxDistance = 50.0, -- Distance culling for performance (meters)
    animationEnabled = true, -- Enable holster/unholster animations
}

-- Performance Settings
Config.Performance = {
    enableDistanceCulling = true,
    cullDistance = 100.0,
    updateInterval = 2000, -- Distance check interval (ms)
    maxAttachedWeapons = 3, -- Maximum weapons that can be attached per player
}

-- Animation Settings
Config.Animations = {
    holster = {
        dict = "reaction@intimidation@1h",
        anim = "intro",
        duration = 1000
    },
    unholster = {
        dict = "reaction@intimidation@1h", 
        anim = "outro",
        duration = 1000
    }
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
        bone = 24818, -- SKEL_SPINE_ROOT
        offset = vector3(-0.25, -0.15, 0.0),
        rotation = vector3(0.0, 0.0, 0.0)
    },
    ['WEAPON_CARBINERIFLE'] = {
        bone = 24818,
        offset = vector3(-0.25, -0.15, 0.0),
        rotation = vector3(0.0, 0.0, 0.0)
    },
    ['WEAPON_SPECIALCARBINE'] = {
        bone = 24818,
        offset = vector3(-0.22, -0.12, 0.05),
        rotation = vector3(0.0, 0.0, 0.0)
    },
    ['WEAPON_ADVANCEDRIFLE'] = {
        bone = 24818,
        offset = vector3(-0.28, -0.18, -0.02),
        rotation = vector3(0.0, 0.0, 0.0)
    },
    ['WEAPON_BULLPUPRIFLE'] = {
        bone = 24818,
        offset = vector3(-0.20, -0.10, 0.08),
        rotation = vector3(0.0, 0.0, 0.0)
    },
    ['WEAPON_PUMPSHOTGUN'] = {
        bone = 24818,
        offset = vector3(-0.30, -0.20, 0.05),
        rotation = vector3(0.0, 0.0, 0.0)
    },
    ['WEAPON_SAWNOFFSHOTGUN'] = {
        bone = 24818,
        offset = vector3(-0.18, -0.08, 0.10),
        rotation = vector3(0.0, 0.0, 0.0)
    },
    ['WEAPON_ASSAULTSHOTGUN'] = {
        bone = 24818,
        offset = vector3(-0.32, -0.22, 0.03),
        rotation = vector3(0.0, 0.0, 0.0)
    },
    ['WEAPON_SNIPERRIFLE'] = {
        bone = 24818,
        offset = vector3(-0.35, -0.25, -0.05),
        rotation = vector3(0.0, 0.0, 0.0)
    },
    ['WEAPON_HEAVYSNIPER'] = {
        bone = 24818,
        offset = vector3(-0.40, -0.30, -0.08),
        rotation = vector3(0.0, 0.0, 0.0)
    },
    ['WEAPON_MG'] = {
        bone = 24818,
        offset = vector3(-0.35, -0.25, -0.10),
        rotation = vector3(0.0, 0.0, 0.0)
    },
    ['WEAPON_COMBATMG'] = {
        bone = 24818,
        offset = vector3(-0.38, -0.28, -0.12),
        rotation = vector3(0.0, 0.0, 0.0)
    },
    ['WEAPON_RPG'] = {
        bone = 24818,
        offset = vector3(-0.45, -0.35, -0.15),
        rotation = vector3(0.0, 0.0, 0.0)
    },
    ['WEAPON_MINIGUN'] = {
        bone = 24818,
        offset = vector3(-0.50, -0.40, -0.20),
        rotation = vector3(0.0, 0.0, 0.0)
    }
}

-- Default position for weapons not specifically configured
Config.DefaultPosition = {
    bone = 24818, -- SKEL_SPINE_ROOT
    offset = vector3(-0.25, -0.15, 0.0),
    rotation = vector3(0.0, 0.0, 0.0)
}

-- Job-specific settings
Config.JobSettings = {
    ['police'] = {
        allowedWeapons = {
            'WEAPON_CARBINERIFLE',
            'WEAPON_PUMPSHOTGUN',
            'WEAPON_SMG'
        },
        alwaysShow = true
    },
    ['ambulance'] = {
        allowedWeapons = {},
        alwaysShow = false
    },
    ['mechanic'] = {
        allowedWeapons = {},
        alwaysShow = false
    }
}

-- Localization
Config.Locales = {
    ['en'] = {
        ['weapon_attached'] = 'Weapon attached to back',
        ['weapon_detached'] = 'Weapon removed from back',
        ['system_enabled'] = 'Weapon back system enabled',
        ['system_disabled'] = 'Weapon back system disabled',
        ['no_permission'] = 'You don\'t have permission to use this command',
        ['weapon_not_allowed'] = 'This weapon cannot be displayed on back',
        ['admin_reload'] = 'System reloaded by administrator',
        ['debug_enabled'] = 'Debug mode enabled',
        ['debug_disabled'] = 'Debug mode disabled'
    },
    ['de'] = {
        ['weapon_attached'] = 'Waffe am Rücken befestigt',
        ['weapon_detached'] = 'Waffe vom Rücken entfernt',
        ['system_enabled'] = 'Waffen-Rücken-System aktiviert',
        ['system_disabled'] = 'Waffen-Rücken-System deaktiviert',
        ['no_permission'] = 'Sie haben keine Berechtigung für diesen Befehl',
        ['weapon_not_allowed'] = 'Diese Waffe kann nicht am Rücken angezeigt werden',
        ['admin_reload'] = 'System von Administrator neu geladen',
        ['debug_enabled'] = 'Debug-Modus aktiviert',
        ['debug_disabled'] = 'Debug-Modus deaktiviert'
    }
}

-- Custom weapon models (for servers with custom weapons)
Config.CustomWeapons = {
    -- Example:
    -- ['WEAPON_AK47'] = {
    --     bone = 24818,
    --     offset = vector3(-0.25, -0.15, 0.0),
    --     rotation = vector3(0.0, 0.0, 0.0),
    --     model = 'w_ar_assaultrifle'
    -- }
}

-- Advanced settings
Config.Advanced = {
    syncRate = 5000, -- How often to sync with server (ms)
    cleanupInterval = 60000, -- How often to cleanup old data (ms)
    maxSyncRetries = 3, -- Maximum sync retries before giving up
    enableAntiCheat = true, -- Enable server-side validation
    logLevel = 'INFO' -- DEBUG, INFO, WARN, ERROR
}