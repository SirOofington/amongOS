os.pullEvent = os.pullEventRaw

version = "v1.0"
w, h = term.getSize()
selected_app = 1
apps = {}

function draw_header()
    paintutils.drawFilledBox(1,1,w,h,colors.black)
    for i=1,w do
        paintutils.drawPixel(i,1,colors.gray)
        paintutils.drawPixel(i,h,colors.gray)
    end
    
    term.setTextColor(colors.yellow)
    term.setCursorPos(1,1)
    term.write(string.format("pogOS %s",version))

    term.setCursorPos(w - string.len("ID: *****") + 1,1)
    term.write(string.format("ID: %5d",os.getComputerID()))

    term.setBackgroundColor(colors.black)
    term.setCursorPos(0,0)
end

function draw_apps()
    for i=1,#apps do
        term.setTextColor(colors.white)
        term.setBackgroundColor(colors.black)
        if i == selected_app then
            term.setTextColor(colors.black)
            term.setBackgroundColor(colors.white)
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
        selected_app = selected_app - 1
        selected_app = (selected_app + 1) % #apps
        selected_app = selected_app + 1
    end
    if key == keys.up then
        selected_app = selected_app - 1
        selected_app = (selected_app - 1) % #apps
        selected_app = selected_app + 1
    end
    if key == keys.enter or key == keys.space then
        apps[selected_app]["func"]()
    end
end

function app_exit()
    term.clear()
    draw_header()
    term.setCursorPos(1,3)
    term.setTextColor(colors.white)
    term.setCursorBlink(false)
    term.write("Shutting down")
    for i=1,3 do
        os.sleep(0.5)
        term.write(".")
    end
    os.sleep(0.5)
    os.shutdown()
end

function app_snake()
    shell.run("worm")
end

function app_info_draw_interface()
    term.setCursorPos(1,3)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.write(string.format("Phone ID: %05d",os.getComputerID()))
    term.setCursorPos(1,4)
    term.write("Owner: ")
    term.setCursorPos(1,5)
    term.write(string.format("Firmware Version: %s",version))
    term.setCursorPos(1,7)
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.black)
    term.write("Back")
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
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
    local website = http.get("https://raw.githubusercontent.com/SirOofington/pogOS/test/pogOS.lua")
    if website then
        term.setBackgroundColor(colors.black)
        term.clear()
        draw_header()
        
        local txt = website.readAll()
        website.close()

        local file = fs.open("pogOS.lua","w")
        file.write(txt)
        file.close()

        term.setCursorPos(1,3)
        term.setTextColor(colors.white)
        term.setCursorBlink(false)
        term.write("Updating")
        for i=1,3 do
            os.sleep(0.5)
            term.write(".")
        end
        os.sleep(0.5)

        shell.run("delete startup")
        shell.run("copy pogOS.lua startup")
        os.reboot()
    end
end

apps = {
    {name="Twitter",func=nil,ico=colors.lightBlue},
    {name="Info",func=app_info,ico=colors.gray},
    {name="Update",func=app_update,ico=colors.green},
    {name="Shut Down",func=app_exit,ico=colors.red}
}

while true do
    term.clear()
    draw_header()
    draw_apps()
    cycle_apps()
end