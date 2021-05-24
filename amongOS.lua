success = os.loadAPI("aOSutils.lua")

if not success then
    print("Problem loading aOSutils.lua, exiting...")
    
end

os.pullEvent = os.pullEventRaw

selected_app = 1
apps = {}

function draw_apps()
    for i=1,#apps do
        aOSutils.set_ui_colors()
        if i == selected_app then aOSutils.set_sel_colors() end
        aOSutils.draw_text(3,i + 2,apps[i]["name"])
        paintutils.drawPixel(1,i+2,apps[i]["ico"])
    end
    aOSutils.set_ui_colors()
    term.setCursorPos(0,0)
end

function cycle_apps()
    aOSutils.pull_event()
    if aOSutils.event_key_held(keys.down) or aOSutils.event_mouse_scroll_down() then
        repeat
            selected_app = selected_app - 1
            selected_app = (selected_app + 1) % #apps
            selected_app = selected_app + 1
        until apps[selected_app]["name"] ~= ""
    end
    if aOSutils.event_key_held(keys.up) or aOSutils.event_mouse_scroll_up() then
        repeat
            selected_app = selected_app - 1
            selected_app = (selected_app - 1) % #apps
            selected_app = selected_app + 1
        until apps[selected_app]["name"] ~= ""
    end
    if aOSutils.event_key_press(keys.enter) or key == aOSutils.event_key_press(keys.space) then
        if apps[selected_app]["func"] ~= nil then
            apps[selected_app]["func"]()
        elseif apps[selected_app]["shell"] ~= nil then
            shell.run(apps[selected_app]["shell"])
        end
    end
end

function app_exit()
    term.clear()
    aOSutils.draw_header()
    aOSutils.set_ui_colors()
    aOSutils.draw_text(1,3,"Shutting down")
    for i=1,3 do
        os.sleep(0.5)
        aOSutils.draw_text(string.len("Shutting down") + i,3,".")
    end
    os.sleep(0.5)
    os.shutdown()
end

function app_info_draw_interface()
    aOSutils.set_ui_colors()
    aOSutils.draw_text(1,3,string.format("Phone ID: %05d",os.getComputerID()))
    aOSutils.draw_text(1,4,"Owner: ")
    aOSutils.draw_text(1,5,string.format("Firmware Version: %s",aOSutils.version))
    aOSutils.set_sel_colors()
    aOSutils.draw_text(1,7,"Back")
end

function app_info_exit()
    aOSutils.pull_event()
    return aOSutils.event_key_press(keys.enter) or aOSutils.event_key_press(keys.space)
end

function app_info()
    while true do
        term.clear()
        aOSutils.draw_header()
        app_info_draw_interface()
        if app_info_exit() then
            break
        end
    end
end

function app_update()
    
    local file = fs.open("filelist.txt","r")
    local file_list = {}

    while true do
        local temp = file.readLine()
        if temp == nil then
            break
        end
        table.insert(file_list,temp)
    end

    file.close()

    for i=1,#file_list do
        local filename = file_list[i]
        local website = http.get("https://raw.githubusercontent.com/SirOofington/amongOS/test/"..filename)
        if website then
            local txt = website.readAll()
            website.close()

            local file = fs.open(filename,"w")
            file.write(txt)
            file.close()
        end
    end
    term.clear()
    aOSutils.draw_header()
    aOSutils.set_ui_colors()
    aOSutils.draw_text(1,3,"Updating")
    for i=1,3 do
        os.sleep(0.5)
        aOSutils.draw_text(string.len("Updating") + i,3,".")
    end
    os.sleep(0.5)

    shell.run("delete startup")
    shell.run("copy "..aOSutils.os_name..".lua startup")
    os.reboot()
end

apps = {
    {name="Twitter",func=nil,shell="twitter.lua",ico=colors.lightBlue},
    {name="",func=nil,shell=nil,ico=colors.black},
    {name="Info",func=app_info,ico=colors.gray},
    {name="Update",func=app_update,ico=colors.green},
    {name="Shut Down",func=app_exit,ico=colors.red}
}

while true do
    term.clear()
    aOSutils.set_theme(aOSutils.home_theme)
    aOSutils.draw_header()
    draw_apps()
    cycle_apps()
end