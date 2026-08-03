fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'NexLabs Studios LLC'
description 'AI EMS Civilian Calls - 0.00ms Optimized - Server-sided EMS checks, auto calls only when EMS on duty'
version '2.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'qb-core',
    'ox_lib',
    'ox_target',
    'ox_inventory'
}