os_name = "amongOS"
version = "v1.0"
w, h = term.getSize()
event = {}

home_theme = {
    head_txt = colors.yellow,
    head_bck = colors.gray,
    ui_txt = colors.white,
    ui_bck = colors.black,
    sel_txt = colors.black,
    sel_bck = colors.white
}

twt_theme = {
    head_txt = colors.white,
    head_bck = colors.cyan,
    ui_txt = colors.black,
    ui_bck = colors.white,
    sel_txt = colors.cyan,
    sel_bck = colors.white
}

head_txt = home_theme.head_txt
head_bck = home_theme.head_bck
ui_txt = home_theme.ui_txt
ui_bck = home_theme.ui_bck
sel_txt = home_theme.sel_txt
sel_bck = home_theme.sel_bck

function draw_text(x,y,str)
    term.setCursorPos(x,y)
    term.write(str)
    term.setCursorPos(0,0)
end

function set_theme(theme)
    head_txt = theme.head_txt
    head_bck = theme.head_bck
    ui_txt = theme.ui_txt
    ui_bck = theme.ui_bck
    sel_txt = theme.sel_txt
    sel_bck = theme.sel_bck
end

function set_head_colors()
    term.setBackgroundColor(head_bck)
    term.setTextColor(head_txt)
end

function set_ui_colors()
    term.setBackgroundColor(ui_bck)
    term.setTextColor(ui_txt)
end

function set_sel_colors()
    term.setBackgroundColor(sel_bck)
    term.setTextColor(sel_txt)
end

function draw_header()
    paintutils.drawFilledBox(1,1,w,h,ui_bck)
    for i=1,w do
        paintutils.drawPixel(i,1,head_bck)
        paintutils.drawPixel(i,h,head_bck)
    end
    
    set_head_colors()
    term.setCursorPos(1,1)
    term.write(string.format("%s %s",os_name,version))

    term.setCursorPos(w - string.len("ID: *****") + 1,1)
    term.write(string.format("ID: %5d",os.getComputerID()))

    term.setCursorPos(0,0)
end

function pull_event()
    event = {os.pullEvent()}
    os.sleep(0.05)
end

function event_key_press(key_value)
    if event[1] == "key" and event[2] == key_value and event[3] == false then
        return true
    end
    return false
end

function event_key_held(key_value)
    if event[1] == "key" and event[2] == key_value then
        return true
    end
    return false
end

function event_key_released(key_value)
    if event[1] == "key_up" and event[2] == key_value then
        return true
    end
    return false
end

function event_mouse_click(x,y,right_click)

    right_click = right_click or false
    if right_click then
        right_click = 1
    else
        right_click = 0
    end

    if event[1] == "mouse_click" and event[2] == right_click and event[3] == x and event[4] == y then
        return true
    end
    return false
end

function event_mouse_drag(x,y,right_click)

    right_click = right_click or false
    if right_click then
        right_click = 1
    else
        right_click = 0
    end

    if event[1] == "mouse_drag" and event[2] == right_click and event[3] == x and event[4] == y then
        return true
    end
    return false
end

function event_mouse_released(x,y,right_click)

    right_click = right_click or false
    if right_click then
        right_click = 1
    else
        right_click = 0
    end

    if event[1] == "mouse_up" and event[2] == right_click and event[3] == x and event[4] == y then
        return true
    end
    return false
end

function event_mouse_scroll_up()
    if event[1] = "mouse_scroll" and event[2] = -1 then
        return true
    end
    return false
end

function event_mouse_scroll_down()
    if event[1] == "mouse_scroll" and event[2] == 1 then
        return true
    end
    return false
end