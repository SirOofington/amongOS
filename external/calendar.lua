calendar_theme = {
    head_txt = colors.yellow,
    head_bck = colors.gray,
    ui_txt = colors.white,
    ui_bck = colors.black,
    sel_txt = colors.black,
    sel_bck = colors.white,
    day_txt = colors.red,
    day_bck = colors.white,
    cal_txt = colors.black,
    cal_bck = colors.white
}

function exit_calendar()
    aOSutils.pull_event()
    return aOSutils.event_key_press(keys.enter) or aOSutils.event_key_press(keys.space) or aOSutils.event_mouse_released_region(20,18,20 + #"Exit" - 1,18)
end

function draw_calendar()
    local title = "Calendar"
    aOSutils.set_colors("ui")
    aOSutils.draw_text(3,aOSutils.w - math.floor(#title/2),title)

    local days = {"Su","Mo","Tu","We","Th","Fr","Sa"}
    local seasons = {"Spring","Summer","Fall","Winter"}
    local raw_day = os.day()
    local day = ((raw_day - 1) % 28) + 1
    local season = ((math.floor((raw_day-1)/28)) % 4) + 1
    local year = math.floor((raw_day-1)/112) + 1

    aOSutils.set_colors("cal")
    paintutils.drawFilledBox(3,4,24,16)
    aOSutils.draw_text(4,5,seasons[season])
    aOSutils.draw_text(15,5,string.format("Year %4d",year))

    local ox
    local oy

    for i=1,7 do
        ox = 4 + 3 * (i - 1)
        oy = 7
        aOSutils.set_colors("cal")
        if ((day - 1) % 7) + 1 == i then aOSutils.set_colors("day") end
        aOSutils.draw_text(ox,oy,days[i])
        aOSutils.set_colors("cal")
        if i % 7 ~= 0 then aOSutils.draw_text(ox + 2,oy,"|") end
    end

    for i=1,28 do
        ox = ((i - 1) % 7) + 1
        ox = 4 + 3 * (ox - 1)
        oy = 9 + 2 * math.floor((i - 1)/7)
        aOSutils.set_colors("cal")
        if day == i then aOSutils.set_colors("day") end
        aOSutils.draw_text(ox,oy,string.format("%2d",i))
        aOSutils.set_colors("cal")
        if i % 7 ~= 0 then aOSutils.draw_text(ox + 2,oy,"|") end
        aOSutils.draw_text(4,oy - 1,"--+--+--+--+--+--+--")
    end

    aOSutils.set_colors("sel")
    aOSutils.draw_text(20,18,"Exit")
end

while true do
    aOSutils.set_theme(calendar_theme)
    aOSutils.draw_header()
    draw_calendar()
    if exit_calendar() then
        break
    end
end