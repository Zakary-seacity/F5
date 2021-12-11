fx_version('cerulean')
game('gta5')

client_scripts({
    -- Src
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua",

    -- Main
    "modules/cl_shared.lua",
    "modules/cl_inventory.lua",
    "other/*.lua",
})

server_scripts({
    "@mysql-async/lib/MySQL.lua",
    "modules/sv_main.lua",
    "modules/sv_piggyback.lua",
})

ui_page("html/index.html")
files({
    "html/index.html",
    "html/css/style.css",
    "html/js/*.js",
    "images/*",
})