--[[ FX Information ]]
fx_version 'adamant'
game 'gta5'
lua54 'yes'
--[[ Resource Information ]]
name 'noa_paynspray'
author 'Opal'
version '1.0.0'
description 'A simple Pay & Spray mechanic for allowing players to customize their vehicles similar to the Pay & Spray in GTA: San Andreas.'

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    'compat/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'sources/**/server.lua',
}

escrow_ignore {
    'compat/*.lua',
}

client_scripts {
    'sources/**/client.lua',
}

files {
    'locales/*.json',
}