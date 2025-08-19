fx_version 'cerulean'
game 'gta5'

author 'Life4Tune'
description 'Live Player Blips for admin jobs with ESX Legacy compatibility'
version '1.3.0'

-- ESX Legacy import (no old shared object event)
shared_scripts {
    '@es_extended/imports.lua',
    'config.lua'
}

client_script 'client.lua'
server_script 'server.lua'
