fx_version 'cerulean'
game 'gta5'

author 'trxentster'
description 'Workbecnh for PD'
version '1.0.0'

shared_script 'locales/en.lua'

client_scripts {
    'client.lua',
    'config.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'ox_target',
    'ox_lib'
}
