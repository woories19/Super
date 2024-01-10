fx_version 'cerulean'
games { 'gta5' };

name 'super';
description 'fiverr.com/paper_ashes'

shared_scripts {
    'config.lua',
}

client_scripts {
    'bin/client.lua',
    'bin/powers.lua',
    'bin/ui.lua',
    'bin/base.lua'
}

server_scripts {
    'bin/server.lua',
}

files {
    'bin/html/index.html',
    'bin/html/style.css',
    'bin/html/script.js',
}

ui_page 'bin/html/index.html'