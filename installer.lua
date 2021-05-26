local website = http.get("https://raw.githubusercontent.com/SirOofington/amongOS/test/filelist.txt")

if website then
    local txt = website.readAll()
    website.close()

    local file = fs.open("filelist.txt","w")
    file.write(tx)
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

        local file = fs.open("disk/"..filename,"w")
        file.write(txt)
        file.close()
    end
end