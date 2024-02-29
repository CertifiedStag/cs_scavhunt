fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'CertifiedStag'
name 'Scavenger Hunt'
description 'Happy Hunting'
version '1.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared.lua',
}

client_scripts {
    'client.lua',
}

server_scripts {
    'sv_config.lua',
    'server.lua',
}