local tArgs = {...}
local branch, dir, verbose, author

-- Arguments and Usage function
local function printUsage()
    local programName = arg[0] or fs.getName(shell.getRunningProgram())
    print("Usage:")
    print(programName .. " <branch> <directory> <verbose> <author>\n")
    print("Defaults:\n - branch = main\n - directory = disk\n - verbose = true\n - author = SirOofington")
end

if tArgs[1] == "help" then
    printUsage()
    return
elseif not (tArgs[1] == nil) then
    branch = tostring(tArgs[1])
else
    branch = "main"
end

if tArgs[2] == nil then
    dir = "disk/"
elseif tArgs[2] == "none" then
    dir = ""
else
    dir = tostring(tArgs[2]).."/"
end

if not (tArgs[3] == nil) and (tArgs[3] == "false") then
  verbose = false
else
  verbose = true
end

if not (tArgs[4] == nil) then
  author = tostring(tArgs[4])
else
  author = "SirOofington"
end

if verbose then
  print("--amongOS installer--")
  print("Pulling files from "..author.."/"..branch.." branch")
  print("Installing to directory \""..dir.."\"")
end

-- The actual installation part
local website = http.get("https://raw.githubusercontent.com/"..author.."/amongOS/"..branch.."/filelist.txt")

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
    local website = http.get("https://raw.githubusercontent.com/"..author.."/amongOS/"..branch.."/"..filename)
    if website then
        local txt = website.readAll()
        website.close()

        local file = fs.open(dir..filename,"w")
        file.write(txt)
        file.close()
    end
end
