# jr_weaponback - ESX Weapon on Back System

Advanced weapon display system for FiveM ESX framework that shows weapons on player's back with realistic positioning and animations.

## 🚀 Features

- **Advanced Weapon Display**: Shows weapons on player's back when not in use
- **ESX Framework Integration**: Full compatibility with ESX player management
- **Multiple Weapon Support**: Rifles, shotguns, SMGs, sniper rifles, and more
- **Configurable Positioning**: Custom positions and rotations for each weapon type
- **Performance Optimized**: Distance culling and efficient resource usage
- **Realistic Animations**: Holster/unholster animations for weapon switching
- **Multi-Language Support**: English and German localization included
- **Admin Commands**: Testing and management commands for administrators
- **Anti-Cheat Protection**: Server-side validation and weapon tracking
- **Custom Weapon Support**: Easy integration for custom weapon models

## 📋 Requirements

- **ESX Framework** (es_extended)
- **FiveM Server** with resource support
- **Basic LUA knowledge** for configuration

## 🔧 Installation

1. **Download** the resource to your FiveM server resources folder
2. **Extract** to `resources/[esx]/jr_weaponback/`
3. **Add** to your server.cfg:
   ```
   ensure jr_weaponback
   ```
4. **Restart** your server or start the resource:
   ```
   start jr_weaponback
   ```

## ⚙️ Configuration

### Basic Settings (`config.lua`)

```lua
Config.WeaponBack = {
    enabled = true,               -- Enable/disable the system
    onlyOnDuty = false,          -- Only show weapons when on duty
    hideInVehicle = true,        -- Hide weapons when in vehicle
    hideWhenAiming = true,       -- Hide weapons when aiming
    hideWhenDead = true,         -- Hide weapons when dead
    animationEnabled = true,     -- Enable holster/unholster animations
}
```

### Performance Settings

```lua
Config.Performance = {
    enableDistanceCulling = true,  -- Enable distance-based optimization
    cullDistance = 100.0,         -- Distance in meters for culling
    updateInterval = 2000,        -- Update interval in milliseconds
    maxAttachedWeapons = 3,       -- Maximum weapons per player
}
```

### Weapon Positioning

Configure custom positions for each weapon:

```lua
Config.WeaponPositions = {
    ['WEAPON_ASSAULTRIFLE'] = {
        bone = 24818,                              -- Bone index (SKEL_SPINE_ROOT)
        offset = vector3(-0.25, -0.15, 0.0),      -- Position offset
        rotation = vector3(0.0, 0.0, 0.0)         -- Rotation angles
    },
    -- Add more weapons...
}
```

### Job-Specific Settings

Control weapon visibility by job:

```lua
Config.JobSettings = {
    ['police'] = {
        allowedWeapons = {
            'WEAPON_CARBINERIFLE',
            'WEAPON_PUMPSHOTGUN',
            'WEAPON_SMG'
        },
        alwaysShow = true
    }
}
```

## 🎮 Usage

### For Players

The system works automatically once installed:

1. **Equip** any supported weapon from your inventory
2. **Switch** to another weapon or holster current weapon
3. **Previous weapon** will appear on your back automatically
4. **Animations** play when switching weapons (if enabled)

### Admin Commands

Available for administrators:

- `/weaponback_toggle` - Toggle the weapon back system
- `/weaponback_debug` - Toggle debug mode
- `/weaponback_reload` - Reload and clean up all weapons
- `/weaponback_stats` - Show system statistics

## 🔧 Advanced Configuration

### Custom Weapons

Add support for custom weapons:

```lua
Config.CustomWeapons = {
    ['WEAPON_AK47'] = {
        bone = 24818,
        offset = vector3(-0.25, -0.15, 0.0),
        rotation = vector3(0.0, 0.0, 0.0),
        model = 'w_ar_assaultrifle'  -- Custom model if needed
    }
}
```

### Animation Customization

Configure holster/unholster animations:

```lua
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
```

### Multi-Language Support

Add or modify translations:

```lua
Config.Locales = {
    ['en'] = {
        ['weapon_attached'] = 'Weapon attached to back',
        ['weapon_detached'] = 'Weapon removed from back',
        -- Add more translations...
    },
    ['de'] = {
        ['weapon_attached'] = 'Waffe am Rücken befestigt',
        ['weapon_detached'] = 'Waffe vom Rücken entfernt',
        -- Add more translations...
    }
}
```

## 🏗️ API / Exports

### Client-Side Exports

```lua
-- Manually attach a weapon
exports['jr_weaponback']:AttachWeaponToBack(ped, weaponHash, weaponName)

-- Detach a specific weapon
exports['jr_weaponback']:DetachWeaponFromBack(weaponHash, weaponName)

-- Detach all weapons
exports['jr_weaponback']:DetachAllWeapons()

-- Check if weapon can be displayed on back
exports['jr_weaponback']:IsWeaponOnBack(weaponHash)
```

### Server-Side Exports

```lua
-- Get player's attached weapons
local weapons = exports['jr_weaponback']:GetPlayerWeapons(playerId)

-- Check if weapon is allowed
local allowed = exports['jr_weaponback']:IsWeaponAllowed(weaponName)

-- Get system statistics
local stats = exports['jr_weaponback']:GetWeaponStats()
```

## 🐛 Troubleshooting

### Common Issues

1. **Weapons not appearing**:
   - Check if weapon is in `Config.WeaponCategories`
   - Verify ESX is loaded properly
   - Enable debug mode: `/weaponback_debug`

2. **Performance issues**:
   - Enable distance culling in config
   - Reduce `RefreshRate` value
   - Limit `maxAttachedWeapons`

3. **Position problems**:
   - Adjust `offset` values in `Config.WeaponPositions`
   - Test with different bone indices
   - Use debug mode to see attachment points

### Debug Mode

Enable debug mode for troubleshooting:
```lua
Config.Debug = true
```

This will print detailed information to console about:
- Weapon attachment/detachment
- Player state changes
- Validation failures
- Performance metrics

## 📊 Performance

### Optimization Features

- **Distance Culling**: Automatically hides weapons beyond specified distance
- **Efficient Updates**: Configurable update intervals
- **Memory Management**: Automatic cleanup of unused objects
- **State Caching**: Reduces redundant calculations
- **Validation Checks**: Prevents invalid weapon states

### Recommended Settings

For **High Population** servers (100+ players):
```lua
Config.RefreshRate = 1500
Config.Performance.cullDistance = 75.0
Config.Performance.updateInterval = 3000
```

For **Low Population** servers (<50 players):
```lua
Config.RefreshRate = 500
Config.Performance.cullDistance = 150.0
Config.Performance.updateInterval = 1000
```

## 🤝 Support

- **Issues**: Report bugs on GitHub Issues
- **Feature Requests**: Submit via GitHub Issues with "enhancement" label
- **Documentation**: Check this README and in-code comments

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Credits

- **Author**: HeisenbergJr49
- **Framework**: ESX Framework Team
- **Community**: FiveM Development Community

## 📚 Changelog

### Version 1.0.0
- Initial release
- Complete weapon back system implementation
- Multi-language support (EN/DE)
- Performance optimization features
- Admin commands and debugging tools
- Comprehensive configuration options

---

**Made with ❤️ for the FiveM ESX Community**
