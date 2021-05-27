twt_theme = {
    head_txt = colors.white,
    head_bck = colors.cyan,
    ui_txt = colors.black,
    ui_bck = colors.white,
    sel_txt = colors.white,
    sel_bck = colors.lightBlue
}

selected = 1

buttons = {"Timeline", "Send Tweet", "Edit Profile", "Exit"}

function draw_main_menu()
    aOSutils.set_sel_colors()
    aOSutils.draw_text(2,3,"Twitter")

    for i=1,#buttons do
        
        local bx
        
        if i % 2 == 1 then bx = 2 else bx = aOSutils.w - #buttons[i] end

        local by = 5 + 2 * math.floor((i-1)/2)

        aOSutils.set_ui_colors()
        if i == selected then aOSutils.set_sel_colors() end

        aOSutils.draw_text(bx,by,buttons[i])
    end
end

while true do
    aOSutils.set_theme(twt_theme)
    aOSutils.draw_header()
    draw_main_menu()
    os.sleep(5)
    break
end