twt_theme = {
    head_txt = colors.white,
    head_bck = colors.cyan,
    ui_txt = colors.black,
    ui_bck = colors.white,
    sel_txt = colors.cyan,
    sel_bck = colors.white
}

function draw_main_menu()
    aOSutils.set_sel_colors()
    aOSutils.draw_text(2,3,"Twitter")
end

while true do
    aOSutils.set_theme(twt_theme)
    aOSutils.draw_header()
    draw_main_menu()
    os.sleep(5)
    break
end