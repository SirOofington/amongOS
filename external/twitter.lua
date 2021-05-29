twt_theme = {
    head_txt = colors.white,
    head_bck = colors.cyan,
    ui_txt = colors.black,
    ui_bck = colors.white,
    sel_txt = colors.white,
    sel_bck = colors.lightBlue,
    title_txt = colors.white,
    title_bck = colors.blue
}

selected = 1

buttons = {"Timeline", "Send Tweet", "Edit Profile", "Exit"}

function draw_main_menu()
    aOSutils.set_colors("title")
    paintutils.drawLine(2,6,25,6)
    aOSutils.draw_text(7,6,"T W I T T E R")

    for i=1,#buttons do
        
        local bx
        
        if i % 2 == 1 then bx = 2 else bx = aOSutils.w - #buttons[i] end

        local by = 13 + 2 * math.floor((i-1)/2)

        aOSutils.set_colors("ui")
        if i == selected then aOSutils.set_colors("sel") end

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