os.loadAPI("aOSutils.lua")
os.loadAPI("twitter.lua")

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
    aOSutils.set_ui_colors()
    term.clear()
    aOSutils.draw_header()
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
    _,key = os.pullEvent("key")
    os.sleep(0.05)
    return key == keys.enter or key == keys.space
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
    {name="Twitter",func=twitter.run,ico=colors.lightBlue},
    {name="",func=nil,ico=colors.black},
    {name="Info",func=app_info,ico=colors.gray},
    {name="Update",func=app_update,ico=colors.green},
    {name="Shut Down",func=app_exit,ico=colors.red}
}

while true do
    term.clear()
    aOSutils.set_home_theme()
    aOSutils.draw_header()
    draw_apps()
    cycle_apps()
end