fx_version 'cerulean'
game "gta5"
lua54 'yes'

author "Project Sloth & OK1ez"
version '2.2.0'

ui_page 'html/index.html'
-- ui_page 'http://localhost:5173/' --for dev

client_script {
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
}

ox_lib 'locale' -- v3.8.0 or above
