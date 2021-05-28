calendar_theme = {
    head_txt = colors.yellow,
    head_bck = colors.gray,
    ui_txt = colors.white,
    ui_bck = colors.black,
    sel_txt = colors.black,
    sel_bck = colors.white,
    day_txt = colors.red,
    day_bck = colors.black
}

function draw_calendar()
    local title = "Calendar"
    aOSutils.draw_text(3,aOSutils.w - math.floor(#title/2))

    local days = {"Su","Mo","Tu","We","Th","Fr","Sa"}
    local seasons = {"Spring","Summer","Fall","Winter"}
    local raw_day = os.day()
    local day = ((raw_day - 1) % 28) + 1
    local season = ((math.floor((raw_day-1)/28)) % 4) + 1
    local year = math.floor((raw_day-1)/112) + 1

    aOSutils.draw_text(4,5,seasons[season])
    aOSutils.draw_text(15,5,string.format("Year %4d",year))

    local ox
    local oy

    for i=1,7 do
        ox = 4 + 3 * i
        oy = 7
        aOSutils.set_colors("ui")
        aOSutils.draw_text(ox,oy,days[i])
    end

    for i=1,28 do
        ox = ((i - 1) % 7) + 1
        ox = 4 + 3 * ox
        oy = 9 + 2 * math.floor(i/7)
        aOSutils.set_colors("ui")
        if day == i then aOSutils.set_colors("day") end
        aOSutils.draw_text(ox,oy,string.format("%2d",i))
    end

end

while true do
    aOSutils.set_theme(calendar_theme)
    aOSutils.draw_header()
    draw_calendar()
    os.sleep(5)
    break
end