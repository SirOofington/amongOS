-- amongOS

os.pullEvent = os.pullEventRaw

os_name = "amongOS"
version = "v1.0"
w, h = term.getSize()
selected_app = 1
apps = {}

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

function set_home_colors()
    head_txt = home_theme.head_txt
    head_bck = home_theme.head_bck
    ui_txt = home_theme.ui_txt
    ui_bck = home_theme.ui_bck
    sel_txt = home_theme.sel_txt
    sel_bck = home_theme.sel_bck
end

function set_twt_colors()
    head_txt = twt_theme.head_txt
    head_bck = twt_theme.head_bck
    ui_txt = twt_theme.ui_txt
    ui_bck = twt_theme.ui_bck
    sel_txt = twt_theme.sel_txt
    sel_bck = twt_theme.sel_bck
end

function draw_header()
    paintutils.drawFilledBox(1,1,w,h,ui_bck)
    for i=1,w do
        paintutils.drawPixel(i,1,head_bck)
        paintutils.drawPixel(i,h,head_bck)
    end
    
    term.setTextColor(head_txt)
    term.setCursorPos(1,1)
    term.write(string.format("%s %s",os_name,version))

    term.setCursorPos(w - string.len("ID: *****") + 1,1)
    term.write(string.format("ID: %5d",os.getComputerID()))

    term.setBackgroundColor(ui_bck)
    term.setCursorPos(0,0)
end

function draw_apps()
    for i=1,#apps do
        term.setTextColor(ui_txt)
        term.setBackgroundColor(ui_bck)
        if i == selected_app then
            term.setTextColor(sel_txt)
            term.setBackgroundColor(sel_bck)
        end
        term.setCursorPos(3,i + 2)
        term.write(apps[i]["name"])
        paintutils.drawPixel(1,i+2,apps[i]["ico"])
    end
    term.setCursorPos(0,0)
end

function cycle_apps()
    local _,key = os.pullEvent("key")
    sleep(0.05)
    if key == keys.down then
        repeat
            selected_app = selected_app - 1
            selected_app = (selected_app + 1) % #apps
            selected_app = selected_app + 1
        until apps[selected_app]["name"] ~= ""
    end
    if key == keys.up then
        repeat
            selected_app = selected_app - 1
            selected_app = (selected_app - 1) % #apps
            selected_app = selected_app + 1
        until apps[selected_app]["name"] ~= ""
    end
    if key == keys.enter or key == keys.space then
        apps[selected_app]["func"]()
    end
end

function app_exit()
    term.setTextColor(ui_txt)
    term.setBackgroundColor(ui_bck)
    term.clear()
    draw_header()
    term.setCursorPos(1,3)
    term.setCursorBlink(false)
    term.write("Shutting down")
    for i=1,3 do
        os.sleep(0.5)
        term.write(".")
    end
    os.sleep(0.5)
    os.shutdown()
end

function app_info_draw_interface()
    term.setCursorPos(1,3)
    term.setBackgroundColor(ui_bck)
    term.setTextColor(ui_txt)
    term.write(string.format("Phone ID: %05d",os.getComputerID()))
    term.setCursorPos(1,4)
    term.write("Owner: ")
    term.setCursorPos(1,5)
    term.write(string.format("Firmware Version: %s",version))
    term.setCursorPos(1,7)
    term.setBackgroundColor(sel_bck)
    term.setTextColor(sel_txt)
    term.write("Back")
    term.setBackgroundColor(ui_bck)
    term.setTextColor(ui_txt)
    term.setCursorPos(0,0)
end

function app_info_exit()
    _,key = os.pullEvent("key")
    os.sleep(0.05)
    return key == keys.enter or key == keys.space
end

function app_info()
    while true do
        term.clear()
        draw_header()
        app_info_draw_interface()
        if app_info_exit() then
            break
        end
    end
end

function app_update()
    local website = http.get("https://raw.githubusercontent.com/SirOofington/amongOS/test/amongOS.lua")
    if website then
        term.setBackgroundColor(ui_bck)
        term.clear()
        draw_header()
        
        local txt = website.readAll()
        website.close()

        local file = fs.open(os_name..".lua","w")
        file.write(txt)
        file.close()

        term.setCursorPos(1,3)
        term.setTextColor(ui_txt)
        term.setCursorBlink(false)
        term.write("Updating")
        for i=1,3 do
            os.sleep(0.5)
            term.write(".")
        end
        os.sleep(0.5)

        shell.run("delete startup")
        shell.run("copy "..os_name..".lua startup")
        os.reboot()
    end
end

function app_twitter()
    while true do
        set_twt_colors()
        draw_header()
        os.sleep(5)
        break
    end
end

apps = {
    {name="Twitter",func=app_twitter,ico=colors.lightBlue},
    {name="",func=nil,ico=colors.black},
    {name="Info",func=app_info,ico=colors.gray},
    {name="Update",func=app_update,ico=colors.green},
    {name="Shut Down",func=app_exit,ico=colors.red}
}

while true do
    set_home_colors()
    term.clear()
    draw_header()
    draw_apps()
    cycle_apps()
end