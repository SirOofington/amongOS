os.loadAPI("aOSutils.lua")

function draw_main_menu()
    aOSutils.set_sel_colors()
    aOSutils.draw_text(2,3,"Twitter")
end

function run()
    aOSutils.set_theme(aOSutils.twt_theme)
    aOSutils.draw_header()
    draw_main_menu()
    os.sleep(5)
    break
end

while true do
    run()
end