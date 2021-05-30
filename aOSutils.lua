os_name = "amongOS"
version = "v1.0"
dev_mode = false
w, h = term.getSize()
event = {}
theme = {}

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

function set_theme(new_theme)
    theme = new_theme
end

function set_colors(type)
    term.setBackgroundColor(theme[type.."_bck"])
    term.setTextColor(theme[type.."_txt"])
end

function draw_header()
    set_colors("ui")
    term.clear()
    set_colors("head")
    for i=1,w do
        paintutils.drawPixel(i,1,term.getBackgroundColor())
        paintutils.drawPixel(i,h,term.getBackgroundColor())
    end
    
    set_colors("head")
    draw_text(1,1,string.format("%s %s",os_name,version))

    local id_txt = string.format("ID: %5d",os.getComputerID())

    draw_text(w - #id_txt + 1,1,id_txt)
    if get_dev_mode() then
        draw_text(1,h,"Dev")
    end

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
    if event[1] == "key" and key_value == nil and event[3] == false then
        return event[2]
    end
    if event[1] == "key" and event[2] == key_value and event[3] == false then
        return true
    end
    return false
end

function event_key_held(key_value)
    if event[1] == "key" and key_value == nil then
        return event[2]
    end
    if event[1] == "key" and event[2] == key_value then
        return true
    end
    return false
end

function event_key_released(key_value)
    if event[1] == "key" and key_value == nil then
        return event[2]
    end
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

function event_character_input(str)
    if event[1] == "char" then
        str = str..event[2]
    end
    if event[1] == "key" and event[2] == "backspace" then
        str = string.sub(str,1,-2)
    end
    return str
end

function draw_text_box(x1,y1,x2,y2)
    local txt_map = {
        top_left = 156
        top_right = 148
        bottom_left = 141
        bottom_right = 133
        horizontal = 140
        vertical = 149
    }
    term.setCursorPos(x1,y1)
    term.write(string.char(txt_map["top_left"]))
    term.setCursorPos(x2,y1)
    term.write(string.char(txt_map["top_right"]))
    term.setCursorPos(x1,y2)
    term.write(string.char(txt_map["bottom_left"]))
    term.setCursorPos(x2,y2)
    term.write(string.char(txt_map["bottom_right"]))
    for i=x1+1,x2-1 do
        term.setCursorPos(i,y1)
        term.write(string.char(txt_map["horizontal"]))
        term.setCursorPos(i,y2)
        term.write(string.char(txt_map["horizontal"]))
    end
    for i=y1+1,y2-1 do
        term.setCursorPos(x1,i)
        term.write(string.char(txt_map["vertical"]))
        term.setCursorPos(x2,i)
        term.write(string.char(txt_map["vertical"]))
    end
end

function draw_debug_text(str)
    set_colors("head")
    draw_text(1,h,str)
end