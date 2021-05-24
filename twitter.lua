os.loadAPI("aOSutils.lua")

function draw_main_menu()
    aOSutils.set_ui_colors()
    aOSutils.draw_text(2,2,"TEST")
end

function run()
    while true do
        aOSutils.set_twt_theme()
        aOSutils.draw_header()
        draw_main_menu()
        os.sleep(5)
        break
    end
end