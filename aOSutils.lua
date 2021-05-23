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

head_txt = nil
head_bck = nil
ui_txt = nil
ui_bck = nil
sel_txt = nil
sel_bck = nil

function set_home_theme()
    head_txt = home_theme["head_txt"]
    head_bck = home_theme["head_bck"]
    ui_txt = home_theme["ui_txt"]
    ui_bck = home_theme["ui_bck"]
    sel_txt = home_theme["sel_txt"]
    sel_bck = home_theme["sel_bck"]
end

function set_twt_theme()
    head_txt = twt_theme["head_txt"]
    head_bck = twt_theme["head_bck"]
    ui_txt = twt_theme["ui_txt"]
    ui_bck = twt_theme["ui_bck"]
    sel_txt = twt_theme["sel_txt"]
    sel_bck = twt_theme["sel_bck"]
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

function draw_text(x,y,str)
    term.setCursorPos(x,y)
    term.write(str)
    term.setCursorPos(0,0)
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