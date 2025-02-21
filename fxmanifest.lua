fx_version 'cerulean'

game "gta5"

author "Project Sloth & OK1ez"
version '2.2.1'

lua54 'yes'

ui_page 'html/index.html'
-- ui_page 'http://localhost:5173/' --for dev

client_script {
  '@PolyZone/client.lua',
  '@PolyZone/CircleZone.lua',
  '@PolyZone/BoxZone.lua',
  'client/**',
}
server_script {
  "server/**",
}
shared_script {
  "shared/**",
  '@ox_lib/init.lua',
}

files {
  'html/**',
  'locales/*.json',
  'data/audioexample_sounds.dat54.rel',
  'audiodirectory/dispatch.awc'
}

ox_lib 'locale' -- v3.8.0 or above

data_file 'AUDIO_WAVEPACK'  'audiodirectory'
data_file 'AUDIO_SOUNDDATA' 'data/audioexample_sounds.dat'