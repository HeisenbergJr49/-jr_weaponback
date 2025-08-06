fx_version 'cerulean'
game 'gta5'

name 'jr_weaponback'
description 'ESX Weapon on Back System - Advanced weapon display system for ESX framework'
author 'HeisenbergJr49'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'es_extended'
}