fx_version 'cerulean'
game 'gta5'
lua54 'yes'

server_scripts {
    "server/*.lua"
}

client_scripts {
    '@meta_target/lib/target.lua',
    'client/*.lua'
}

shared_scripts {
    '@pmc-callbacks/import.lua',
    '@ox_lib/init.lua',
    "shared/*.lua"
}