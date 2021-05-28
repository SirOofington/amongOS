os_name = "amongOS"
version = "v1.0"
dev_mode = false
w, h = term.getSize()
event = {}

head_txt = colors.black
head_bck = colors.black
ui_txt = colors.black
ui_bck = colors.black
sel_txt = colors.black
sel_bck = colors.black

function toggle_dev_mode()
    dev_mode = not dev_mode
end

function get_dev_mode()
    return dev_mode
end

function draw_text(x,y,str)
    term.setCursorPos(x,y)
    term.write(str)
    term.setCursorPos(0,0)
end

function set_theme(theme)
    head_txt = theme["head_txt"]
    head_bck = theme["head_bck"]
    ui_txt = theme["ui_txt"]
    ui_bck = theme["ui_bck"]
    sel_txt = theme["sel_txt"]
    sel_bck = theme["sel_bck"]
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
    draw_text(1,1,string.format("%s %s",os_name,version))

    local id_txt = string.format("ID: %5d",os.getComputerID())

    draw_text(w - #id_txt + 1,1,id_txt)
    if get_dev_mode() then
        draw_text(1,h,"Dev")
    end
    
    pull_event("timer")

    local time_txt = textutils.formatTime(os.time(),false)

    draw_text(w - #time_txt + 1,h,time_txt)

    term.setCursorPos(0,0)
end

function pull_event(check_event)
    local timer = os.startTimer(0.05)
    event = {os.pullEvent(check_event)}
    if event[1] ~= "timer" then
        os.sleep(0.05)
        os.cancelTimer(timer)
    end
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
        right_click = 2
    else
        right_click = 1
    end

    if event[1] == "mouse_click" and event[2] == right_click and event[3] == x and event[4] == y then
        return true
    end
    return false
end

function event_mouse_drag(x,y,right_click)

    right_click = right_click or false
    if right_click then
        right_click = 2
    else
        right_click = 1
    end

    if event[1] == "mouse_drag" and event[2] == right_click and event[3] == x and event[4] == y then
        return true
    end
    return false
end

function event_mouse_released(x,y,right_click)

    right_click = right_click or false
    if right_click then
        right_click = 2
    else
        right_click = 1
    end

    if event[1] == "mouse_up" and event[2] == right_click and event[3] == x and event[4] == y then
        return true
    end
    return false
end

function event_mouse_scroll_up()
    if event[1] == "mouse_scroll" and event[2] == -1 then
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

function event_mouse_click_region(x1,y1,x2,y2,right_click)
    right_click = right_click or false

    if right_click then
        right_click = 2
    else
        right_click = 1
    end

    if event[1] == "mouse_click" and event[2] == right_click then
        if x1 <= event[3] and event[3] <= x2 and y1 <= event[4] and event[4] <= y2 then
            return true
        end
    end
    return false
end

function event_mouse_released_region(x1,y1,x2,y2,right_click)
    right_click = right_click or false

    if right_click then
        right_click = 2
    else
        right_click = 1
    end

    if event[1] == "mouse_up" and event[2] == right_click then
        if x1 <= event[3] and event[3] <= x2 and y1 <= event[4] and event[4] <= y2 then
            return true
        end
    end
    return false
end

function draw_debug_text(str)
    draw_set_header()
    draw_text(1,h,str)
end