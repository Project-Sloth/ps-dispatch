fx_version 'cerulean'
game 'gta5'

version '2.7.1'
description 'https://github.com/thelindat/linden_outlawalert'
versioncheck 'https://raw.githubusercontent.com/thelindat/linden_outlawalert/master/fxmanifest.lua'

shared_scripts {
    'config.lua',
    'locales/locales.lua',
}

client_scripts{
    'client/cl_main.lua',
    'client/cl_events.lua',
    'client/cl_loops.lua',
} 
server_script {
    'server/sv_dispatchcodes.lua',
    'server/sv_main.lua'
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/app.js',
    'ui/style.css',
}
