local w, h = term.getSize()
local selected_app = 1

function draw_header()
    paintutils.drawFilledBox(1,1,w,h,colors.lightBlue)
    for i=1,w do
        paintutils.drawPixel(i,1,colors.black)
    end

    term.setTextColor(colors.white)
    term.setCursorPos(1,1)
    term.write("pogOS")

    term.setCursorPos(w - string.len("ID: *****") + 2,1)
    term.write(string.format("ID: %5d",os.getComputerID()))

    term.setBackgroundColor(colors.black)
    term.setCursorPos(0,0)
end

function draw_apps(app_list,selected_app)
    term.setTextColor(colors.white)
    for i=1,#app_list do
        term.setCursorPos(1,i + 1)
        term.write(app_list[i]["name"])
    end
    term.setCursorPos(0,0)
end

function app_exit()
    term.clear()
    draw_header()
    term.setCursorPos(1,2)
    term.setTextColor(colors.white)
    term.write("Shutting down...")
    term.setCursorBlink(false)
    os.sleep(5)
    os.shutdown()
end

local apps = {
    {name="Snake",func=function() shell.run("worm") end},
    {name="Exit",func=app_exit}
}

while true do
    term.clear()
    draw_header()
    draw_apps(apps,selected_app)
    
end