local args = {...}
local branch, dir

print("--amongOS installer--")

if not (args[1] == nil) then
    branch = tostring(args[1])
else
    branch = "main"
end
print("Pulling files from "..branch.." branch")

if args[2] == nil then
    dir = "disk/"
elseif args[2] == "none" then
    dir = ""
else
    dir = tostring(args[2]).."/"
end
print("Installing to directory \""..dir.."\"")

local website = http.get("https://raw.githubusercontent.com/SirOofington/amongOS/"..branch.."/filelist.txt")

local file_list = {}

if website then
        while true do
            local file = website.readLine()
            if file == nil then
                break
            end
            table.insert(file_list,file)
        end
    website.close()
else
    return nil
end

for i=1,#file_list do
    local filename = file_list[i]
    local website = http.get("https://raw.githubusercontent.com/SirOofington/amongOS/"..branch.."/"..filename)
    if website then
        local txt = website.readAll()
        website.close()

        local file = fs.open(dir..filename,"w")
        file.write(txt)
        file.close()
    end
end
