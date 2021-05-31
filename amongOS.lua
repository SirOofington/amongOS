success = os.loadAPI("aOSutils.lua")
if not success then
    error("Problem loading aOSutils.lua, exiting...")
end

os.pullEvent = os.pullEventRaw

ext_app_dir = "/external/"
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

function display_splash()
    local img = {
        "01111111000",
        "11111111400",
        "11332211400",
        "13222221114",
        "14222241114",
        "11444411114",
        "11111111114",
        "11111111114",
        "11111111114",
        "11111111444",
        "11444411400",
        "11400011400",
        "44400044400"
    }

    local ox = 8
    local oy = 4

    aOSutils.set_theme(home_theme)

    aOSutils.set_colors("ui")
    term.clear()
    aOSutils.draw_text(10,3,aOSutils.os_name)

    rand_color = math.random(1,4)
    primaries = {colors.red,colors.cyan,colors.yellow,colors.lime}
    secondaries = {colors.brown,colors.blue,colors.brown,colors.green}

    for i=1,#img do
        for j=1,#img[i] do
            local color = nil
            local pixel = string.sub(img[i],j,j)

            if pixel == "1" then
                color = primaries[rand_color]
            elseif pixel == "2" then
                color = colors.lightBlue
            elseif pixel == "3" then
                color = colors.white
            elseif pixel == "4" then
                color = secondaries[rand_color]
            else
                color = colors.black
            end

            paintutils.drawPixel(ox + j,oy + i,color)

            if color ~= colors.black then
                os.sleep(0.05)
            end
        end
    end
    os.sleep(1)
end

function load_external_apps()
    if not fs.isDir(ext_app_dir) then
        fs.makeDir(ext_app_dir)
    end

    local ext_apps = fs.list(ext_app_dir)

    for i=1,#ext_apps do
        local current_app = ext_apps[i]

        local ext_index = string.find(current_app,"%.")

        if ext_index ~= nil then
            if string.sub(current_app,ext_index) == ".metadata" then
                local file = fs.open(ext_app_dir..current_app,"r")
                table.insert(apps,textutils.unserialize(file.readAll()))
                file.close()
            end
        end
    end
end

function load_internal_apps()
    if(#apps ~= 0) then
        table.insert(apps,{name="",ico=colors.black})
    end
    table.insert(apps,{name="Info",func=app_info,ico=colors.gray})
    table.insert(apps,{name="Update",func=app_update,ico=colors.green})
    table.insert(apps,{name="Shut Down",func=app_exit,ico=colors.red})
    table.insert(apps,{name="",ico=colors.black,hidden=true})
    table.insert(apps,{name="Terminate",func=app_terminate,ico=colors.orange,hidden=true})
end

function draw_apps()
    while true do
        aOSutils.draw_header()
        for i=1,#apps do
            aOSutils.set_colors("ui")
            if i == selected_app then aOSutils.set_colors("sel") end
            if apps[i]["hidden"] == nil or aOSutils.get_dev_mode() then
                aOSutils.draw_text(3,i + 2,apps[i]["name"])
                paintutils.drawPixel(1,i+2,apps[i]["ico"])
            end
        end
        aOSutils.set_colors("ui")
        os.sleep(0.05)
    end
end

function cycle_apps()
    if apps[selected_app]["name"] == "" then selected_app = selected_app + 1 end
    aOSutils.pull_event()
    
    if aOSutils.event_key_held(keys.down) or aOSutils.event_mouse_scroll_down() then
        repeat
            selected_app = selected_app - 1
            selected_app = (selected_app + 1) % #apps
            selected_app = selected_app + 1
        until apps[selected_app]["name"] ~= "" and (apps[selected_app]["hidden"] == nil or aOSutils.get_dev_mode())
    end
    if aOSutils.event_key_held(keys.up) or aOSutils.event_mouse_scroll_up() then
        repeat
            selected_app = selected_app - 1
            selected_app = (selected_app - 1) % #apps
            selected_app = selected_app + 1
        until apps[selected_app]["name"] ~= "" and (apps[selected_app]["hidden"] == nil or aOSutils.get_dev_mode())
    end
    if aOSutils.event_key_press(keys.enter) or key == aOSutils.event_key_press(keys.space) then
        if apps[selected_app]["func"] ~= nil then
            apps[selected_app]["func"]()
        elseif apps[selected_app]["shell"] ~= nil then
            shell.run(ext_app_dir..apps[selected_app]["shell"])
        end
    end

    for i=1,#apps do
        if aOSutils.event_mouse_click_region(3,i + 2,2 + string.len(apps[i]["name"]),i + 2) then
            selected_app = i
        end
        if aOSutils.event_mouse_released_region(3,i + 2,2 + string.len(apps[i]["name"]),i + 2) and selected_app == i then
            if apps[selected_app]["func"] ~= nil then
                apps[selected_app]["func"]()
            elseif apps[selected_app]["shell"] ~= nil then
                shell.run(ext_app_dir..apps[selected_app]["shell"])
            end
        end
    end
end

function app_exit()
    term.clear()
    aOSutils.draw_header()
    aOSutils.set_colors("ui")
    aOSutils.draw_text(1,3,"Shutting down")
    for i=1,3 do
        os.sleep(0.5)
        aOSutils.draw_text(string.len("Shutting down") + i,3,".")
    end
    os.sleep(0.5)
    os.shutdown()
end

function app_info_draw_interface()
    aOSutils.set_colors("ui")
    aOSutils.draw_text(1,3,string.format("Phone ID: %05d",os.getComputerID()))
    aOSutils.draw_text(1,4,string.format("Firmware Version: %s",aOSutils.version))
    aOSutils.set_colors("sel")
    aOSutils.draw_text(1,6,"Back")
end

function app_info_exit()
    aOSutils.pull_event()
    if aOSutils.event_key_press(keys.home) then
        aOSutils.toggle_dev_mode()
    end
    return aOSutils.event_key_press(keys.enter) or aOSutils.event_key_press(keys.space) or aOSutils.event_mouse_released_region(1,6,#"Back",6)
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
    
    local website = http.get("https://raw.githubusercontent.com/SirOofington/amongOS/test/filelist.txt")

    if website then
        local txt = website.readAll()
        website.close()

        local file = fs.open("filelist.txt","w")
        file.write(txt)
        file.close()
    else
        return nil
    end

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
    aOSutils.set_colors("ui")
    aOSutils.draw_text(1,3,"Updating")
    for i=1,3 do
        os.sleep(0.5)
        aOSutils.draw_text(string.len("Updating") + i,3,".")
    end
    os.sleep(0.5)
    os.reboot()
end

function app_terminate()
    aOSutils.set_colors("ui")
    term.clear()
    term.setCursorPos(1,1)
    error()
end

display_splash()

load_external_apps()
load_internal_apps()

term.clear()
aOSutils.set_theme(home_theme)
parallel.waitForAny(draw_apps,cycle_apps)