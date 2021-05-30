twt_theme = {
    head_txt = colors.white,
    head_bck = colors.blue,
    ui_txt = colors.black,
    ui_bck = colors.white,
    sel_txt = colors.lightBlue,
    sel_bck = colors.white,
    title_txt = colors.white,
    title_bck = colors.blue
}

selected = 1
input_text = ""

buttons = {
    main_menu = {
        {name="Timeline",func=nil},
        {name="Send Tweet",func=send_tweet_menu},
        {name="Profile",func=nil},
        {name="Exit",func=nil}
    },
    send_tweet = {
        {name="Send",func=nil},
        {name="Exit",func=nil}
    }
}

username = "SirOofington"

function input_send_tweet_menu()
    aOSutils.pull_event()
    if selected ~= 1 then
        if aOSutils.event_key_held(keys.left) or aOSutils.event_key_held(keys.right) then
            selected = 5 - selected
        end
        if aOSutils.event_key_held(keys.up) or aOSutils.event_key_held(keys.down) then
            selected = 1
        end
    end

    while selected == 1 do
        aOSutils.pull_event()
        input_text = aOSutils.event_character_input(input_text)
        if #input_text > 80 then
            input_text = string.sub(input_text,1,-2)
        end
        if aOSutils.event_key_held(keys.up) or aOSutils.event_key_held(keys.down) then
            selected = 2
        end
    end

    if (aOSutils.event_key_press(keys.enter) or aOSutils.event_key_press(keys.space)) and selected > 1 then
        if buttons["main_menu"][selected - 1]["func"] ~= nil then
            buttons["main_menu"][selected - 1]["func"]()
        else
            return true
        end
    end
    return false
end

function draw_send_tweet_menu()
    aOSutils.set_colors("ui")
    aOSutils.draw_text(2,4,"Send Tweet")

    aOSutils.set_colors("sel")
    aOSutils.draw_text(2,7,"@"..username.."#"..string.format("%05d",os.getComputerID()))

    aOSutils.set_colors("ui")
    if selected == 1 then aOSutils.set_colors("sel") end
    aOSutils.draw_text_box(2,8,25,13)
    aOSutils.draw_text(19,15,tostring(#input_text).." / 80")

    aOSutils.set_colors("ui")
    aOSutils.draw_wrapped_text(3,9,22,input_text)
    
    if selected == 2 then aOSutils.set_colors("sel") end
    aOSutils.draw_text(2,18,buttons["send_tweet"][2])

    aOSutils.set_colors("ui")
    if selected == 3 then aOSutils.set_colors("sel") end
    aOSutils.draw_text(aOSutils.w - #buttons["send_tweet"][3] - 1,18,buttons["send_tweet"][3])
end

function send_tweet_menu()
    selected = 1
    input_txt = ""
    while true do
        aOSutils.draw_header()
        draw_send_tweet_menu()
        if input_send_tweet_menu() then
            selected = 1
            input_txt = ""
            break
        end
    end
end

function input_main_menu()
    aOSutils.pull_event()
    if aOSutils.event_key_held(keys.left) or aOSutils.event_key_held(keys.right) then
        if selected % 2 == 0 then
            selected = selected - 1
        else
            selected = selected + 1
        end
    end
    if aOSutils.event_key_held(keys.up) then
        selected = selected - 2
    end
    if aOSutils.event_key_held(keys.down) then
        selected = selected + 2
    end
    selected = ((selected - 1) % #buttons["main_menu"]) + 1
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
    aOSutils.draw_text(7,6,"T W I T T E R "..string.char(169))

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

buttons = {
    main_menu = {
        {name="Timeline",func=nil},
        {name="Send Tweet",func=send_tweet_menu},
        {name="Profile",func=nil},
        {name="Exit",func=nil}
    },
    send_tweet = {
        {name="Send",func=nil},
        {name="Exit",func=nil}
    }
}

while true do
    aOSutils.set_theme(twt_theme)
    aOSutils.draw_header()
    draw_main_menu()
    if input_main_menu() then
        break
    end
end