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

buttons = {
    main_menu = {
        {name="Timeline",func=nil},
        {name="Send Tweet",func=nil},
        {name="Edit Profile",func=nil},
        {name="Exit",func=nil}
    }
}

function input_main_menu()
    aOSutils.pull_event()
    if aOSutils.event_key_held(keys.left) or aOSutils.event_key_held(keys.right) then
        if selected % 2 == 0 then
            selected = selected - 1
        else
            selected = selected + 1
        end
    end
    if aOSutils.event_key_held(keys.down) then
        selected = ((selected + 1) % #buttons["main_menu"]) + 1
    end
    if aOSutils.event_key_held(keys.down) then
        selected = ((selected + 3) % #buttons["main_menu"]) + 1
    end
    if aOSutils.event_key_press(keys.enter) or aOSutils.event_key_press(keys.space) then
        if buttons["main_menu"][selected]["func"] ~= nil then
            buttons["main_menu"][selected]["func"]()
        else
            return true
        end
    end
    return false
end

function draw_main_menu()
    aOSutils.set_colors("title")
    paintutils.drawFilledBox(2,5,25,7)
    aOSutils.draw_text(7,6,"T W I T T E R")

    for i=1,#buttons["main_menu"] do
        
        local bx
        
        if i % 2 == 1 then 
            bx = 2 
        else 
            bx = aOSutils.w - #buttons["main_menu"][i]["name"]
        end

        local by = 13 + 2 * math.floor((i-1)/2)

        aOSutils.set_colors("ui")
        if i == selected then aOSutils.set_colors("sel") end

        aOSutils.draw_text(bx,by,buttons["main_menu"][i]["name"])
    end
end

while true do
    aOSutils.set_theme(twt_theme)
    aOSutils.draw_header()
    draw_main_menu()
    if input_main_menu() then
        break
    end
end