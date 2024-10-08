bot = getBot()
storage = "TPARIO1|VRI877ZE21"
rotation = bot.rotation
bot.wear_storage = storage
bot.custom_status = "WAIT UNTIL LEVEL 6"
function startings()
    bot.custom_status = "Starting"
    bot:sendPacket(3,"action|gohomeworld")
    sleep(13000)
    while bot:getWorld().name:lower() == "exit" do
        bot:sendPacket(3,"action|gohomeworld")
        sleep(13000)
    end
    function isOwnerLock()
        for _, tile in pairs(getTiles()) do
            if tile.fg == 242 or tile.fg == 9640 then
                if tile:getExtra().uid == getLocal().userid then
                    return true
                end
            end
        end
        return false
    end
    while not isOwnerLock() do
        while bot:getWorld().name:lower() == "exit" do
            bot:sendPacket(3,"action|gohomeworld")
            sleep(13000)
        end
    end
    world_home = bot:getWorld().name:lower()
end
function baris_randomen()
    local iii = 1
    for __, player in pairs(getBots()) do
        if player.name == getBot().name then
            break
        else
            iii = iii + 1
        end
    end
    return iii
end

-- Function to generate a random text
function generateRandomText(length, letters, botId)
    local text = ""
    for i = 1, length do
        local randomValue = math.random()
        local randomIndex = math.floor(randomValue * #letters) + 1
        local adjustedIndex = (randomIndex + botId - 1) % #letters + 1
        local randomChar = letters:sub(adjustedIndex, adjustedIndex)
        text = text .. randomChar
    end
    return text
end

-- Function to get random text with bot-specific adjustments
function getRandom()
    local letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local countNumber = 13  -- Example length, adjust as needed
    local botId = baris_randomen()  -- Get bot index
    local hasil = generateRandomText(countNumber, letters, botId)
    return hasil
end

-- Seed random number generator once
math.randomseed(os.time())

function split(abc, def)
    if def==nil then
        def="%s"
    end
    local t={}
    for str in string.gmatch(abc,"([^"..def.."]+)") do
        table.insert(t,str)
    end
    return t
end
function warps(x)
    while bot.status ~= BotStatus.online do sleep(13000) end
    if bot.status == BotStatus.online then
        while bot:getWorld().name:lower() ~= split(x,"|")[1]:lower() or getTile(bot.x, bot.y).fg == 6 do
            bot:warp(x)
            -- bot:sendPacket(3,"action|join_request\nname|"..x.."\ninvitedWorld|0")
            sleep(13000)  
        end
    end
end
function home()
    while bot.status ~= BotStatus.online do sleep(13000) end
    if bot.status == BotStatus.online then
        while bot:getWorld().name:lower() ~= world_home:lower() do
            bot:warp(world_home)
            sleep(13000)  
        end
    end
end
function clearConsole()
    local console = getBot():getConsole()
    for i = 0, 50 do
        console:append("")
    end
end
function template_rotasi()
    bot.move_x = 3
    bot.move_y = 1
    bot.reconnect_interval = 20
    bot.collect_interval = 25
    bot.object_collect_delay = 0
    bot.collect_range = 10
    bot.collect_path_check = false
    rotation.break_x = 3
    rotation.break_y = 1
    rotation.custom_position = true
    rotation.auto_jammer = false
    rotation.dynamic_delay = true
    rotation.pnb_in_home = false
    rotation.ignore_plant = false
    rotation.auto_fill = true
    bot.anti_toxic = false
    bot.auto_ban = false
    bot.rest_interval = 1800
    bot.rest_time = 300
    bot.auto_rest_mode = true
    rotation.break_interval = 0.17
    rotation.plant_interval = 0.16
    rotation.harvest_interval = 0.16
    rotation.warp_interval = 16
    rotation.one_by_one = true
    --bot.custom_status = ""
end
function rotasi_down()
    if rotation.clear_objects then
        rotation.clear_objects = false
    end
    if not rotation.harvest_until_level then
        rotation.harvest_until_level = true
    end
    if rotation.auto_fill then
        rotation.auto_fill = false
    end
    while true do
        if bot.gem_count >= 5200 then
            rotation.enabled = false
            -- bot.auto_reconnect  = false
            if bot:getInventory().slotcount == 16 then
                bot:sendPacket(2,"action|buy\nitem|upgrade_backpack")
                sleep(2000)
            end
            bot.custom_status = "done gems"
            break
        end
        rotation.enabled = true
        bot.custom_status = "Get Gems"
        sleep(5000)
    end
end
function rotasi_up()
    if not rotation.clear_objects then
        rotation.clear_objects = true
    end
    if rotation.harvest_until_level then
        rotation.harvest_until_level = false
    end
    if not rotation.auto_fill then
        rotation.auto_fill = true
    end
end
function quest1(variant, netid)
    if variant:get(0):getString() == "OnFtueButtonDataSet" and variant:get(4):getString():find("Splice Lava and Sign Seeds") then
        bot.custom_status = "quest 1"
    elseif variant:get(0):getString() == "OnDialogRequest" and variant:get(1):getString():find("Malpractice") then
           bot.custom_status = "Malpractice"
    elseif variant:get(0):getString() == "OnFtueButtonDataSet" and variant:get(4):getString():find("Place a Torch in the World") then
        bot.custom_status = "quest1-done splice"
    elseif variant:get(0):getString() == "OnFtueButtonDataSet" and variant:get(4):getString():find("Wrench yourself to see Growmojis") then
        bot.custom_status = "quest1-done wrench torch"
    elseif variant:get(0):getString() == "OnFtueButtonDataSet" and variant:get(4):getString():find("Use one of the Growmoji") then
        bot.custom_status = "quest1-done growmoji"
    elseif variant:get(0):getString() == "OnFtueButtonDataSet" and variant:get(4):getString():find("Wrench a Torch to silence it") then
        bot.custom_status = "quest1-done torch"
    elseif variant:get(0):getString() == "OnFtueButtonDataSet" and variant:get(4):getString():find("Set your World Lock as a Home") then
        bot.custom_status = "quest 2"
    elseif variant:get(0):getString() == "OnFtueButtonDataSet" and variant:get(4):getString():find("Collect 5000 Gems") then
        bot.custom_status = "quest3-5000 gems"
    elseif variant:get(0):getString() == "OnFtueButtonDataSet" and variant:get(4):getString():find("Buy a Surgery") then
        bot.custom_status = "buy surgery"
    elseif variant:get(0):getString() == "OnFtueButtonDataSet" and variant:get(4):getString():find("Place a Train") then
        bot.custom_status = "place train"
    elseif variant:get(0):getString() == "OnFtueButtonDataSet" and variant:get(4):getString():find("Perform Nose Job") then
        -- bot.custom_status = "Perform Nose Job"
        bot.custom_status = "DONE INJECT"
    elseif variant:get(0):getString() == "OnFtueButtonDataSet" and variant:get(4):getString():find("Perform Bird Flu surgery") then
        -- bot.custom_status = "Perform Bird Flu surgery"
        bot.custom_status = "DONE INJECT"
    elseif variant:get(0):getString() == "OnFtueButtonDataSet" and variant:get(4):getString():find("Perform Broken Leg surgery") then
            -- bot.custom_status = "Perform Broken Leg surgery"
            bot.custom_status = "DONE INJECT"
    elseif variant:get(0):getString() == "OnFtueButtonDataSet" and variant:get(4):getString():find("Check out the Role") then
            bot.custom_status = "Check out the Role"
    elseif variant:get(0):getString() == "OnFtueButtonDataSet" and variant:get(4):getString():find("Buy a Small Lock from the Store") then
        bot.custom_status = "creating world and place sl"
    elseif variant:get(0):getString() == "OnFtueButtonDataSet" and variant:get(4):getString():find("Place a Small Lock in the World") then
        bot.custom_status = "creating world and place sl"
    elseif variant:get(0):getString() == "OnFtueButtonDataSet" and variant:get(4):getString():find("Visit the START World") then
        bot.custom_status = "warp start"
    elseif variant:get(0):getString() == "OnFtueButtonDataSet" and variant:get(4):getString():find("Buy a Small Lock from the Store") then
        bot.custom_status = "buy sl"
    elseif variant:get(0):getString() == "OnFtueButtonDataSet" and variant:get(4):getString():find("Go create a new World") then
        bot.custom_status = "creating world and place sl"
    elseif variant:get(0):getString() == "OnFtueButtonDataSet" and variant:get(4):getString():find("Use the page icon to continue learning") then
        bot.custom_status = "DONE INJECT"
    elseif variant:get(0):getString() == "OnFtueButtonDataSet" and variant:get(4):getString():find("Congratulations!") then
        bot.custom_status = "DONE INJECT"
    end
end
addEvent(Event.variantlist, quest1)
function auto_surg()
    local packetSent = false
    loop_surg = true

    addEvent(Event.variantlist, function(variant, netid)
        bot = getBot()
        local dialog = variant:get(1):getString()

        -- Debug: Print dialog yang diterima
        print("Received dialog:", dialog)

        if packetSent then
                -- Debug: Print dialog setelah OnDialogRequest
                print("Dialog after OnDialogRequest:", dialog)

                -- Ekstrak teks setelah embed_data|itemSuggestionsForTrainee|
                local itemsString = dialog:match("embed_data|itemSuggestionsForTrainee|(.+)")

                -- Jika ada teks yang ditemukan
                if itemsString then
                    -- Debug: Print teks yang diekstrak
                    print("Extracted items string:", itemsString)

                    -- Pisahkan item berdasarkan koma
                    local items = {}
                    for item in itemsString:gmatch("(%d+),") do
                        table.insert(items, item)
                    end

                    -- Debug: Print semua item yang diekstraksi
                    print("Extracted items:", table.concat(items, ", "))

                    -- Buat format string itemSuggestionsForTrainee
                    local suggestions = table.concat(items, ",") .. ","
                    
                    -- Debug: Print hasil akhir dari itemSuggestionsForTrainee
                    print("Formatted itemSuggestionsForTrainee:", suggestions)

                    -- Ambil item pertama untuk buttonClicked
                    local firstSuggestion = items[1] or ""

                    -- Debug: Print item pertama untuk buttonClicked
                    print("First suggestion:", firstSuggestion)

                    if dialog:find("embed_data|itemSuggestionsForTrainee") then
                        bot:sendPacket(2, "action|dialog_return\ndialog_name|surgery\nbuttonClicked|tool"..firstSuggestion.."\n\nitemSuggestionsForTrainee|"..itemsString:gsub("\n", "").."|\n")
                        sleep(2000)
                        itemsString = false
                        items = {}
                        suggestions = false
                        firstSuggestion = false
                        return true
                    end
                else
                    -- Jika tidak ditemukan string yang sesuai
                    print("No items found after 'embed_data|itemSuggestionsForTrainee|'")
                    itemsString = false
                    items = {}
                    suggestions = false
                    firstSuggestion = false
                end
        else
            -- Jika dialog adalah "end_dialog|surge|Cancel|Okay!|", kirim paket
            if dialog:find("end_dialog|surge|Cancel|Okay!|") then
                bot:sendPacket(2, "action|dialog_return\ndialog_name|surge\ntilex|"..bot.x.."|\ntiley|"..bot.y.."|\n")
                sleep(2000)
                bot.custom_status = "starting surg"
                packetSent = true
                loop_surg = true
                return true
            end
        end
        loop_surg = false

        return false
    end)

    bot = getBot()
    sleep(2000)
    bot:wrench(bot.x, bot.y)
    listenEvents(30) -- Panggil listenEvents sebelum memulai loop
    while loop_surg do
        listenEvents(5)
        sleep(200)
    end
end
function check_profile()
    addEvent(Event.variantlist, quest1)
    bot:sendPacket(2,"action|wrench\n|netid|1")
    listenEvents(4)
    unlistenEvents()
end
function take_quest1()
    addEvent(Event.variantlist, quest1)
    bot:sendPacket(2,"action|tutorialTaskQuestClicked")
    sleep(2000)
    bot:sendPacket(2,"action|dialog_return\ndialog_name|tutorialEventUI\nbuttonClicked|ftue_select_questline_2")
    listenEvents(4)
    sleep(500)
    unlistenEvents()
end
function take_quest2()
    addEvent(Event.variantlist, quest1)
    bot:sendPacket(2,"action|tutorialTaskQuestClicked")
    sleep(2000)
    bot:sendPacket(2,"action|dialog_return\ndialog_name|tutorialEventUI\nbuttonClicked|ftue_select_questline_3")
end
function take_quest3()
    addEvent(Event.variantlist, quest1)
    bot:sendPacket(2,"action|tutorialTaskQuestClicked")
    sleep(2000)
    bot:sendPacket(2,"action|dialog_return\ndialog_name|tutorialEventUI\nbuttonClicked|ftue_select_questline_4")
end
--==========TAKE ITEM============
function Itemdrop(itemID, count)
    if bot:getInventory():getItemCount(itemID)>=count then
        bot:sendPacket(2,"action|drop\nitemID|" .. itemID)
        sleep(500)
        bot:sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|" .. itemID .. "|\ncount|" .. count)
        sleep(500)
    end
end
function scanFloat(id)
    local count = 0
    for _, obj in pairs(getObjects()) do
        if obj.id == id then
            count = count + obj.count
        end
    end
    return count
end
function takefind(id)
    for _, obj in pairs(getObjects()) do
        if obj.id == id then
            local x = math.floor(obj.x//32)
            local y = math.floor(obj.y//32)
            if obj.id == id then
                if bot:findPath(x, y) then
                    sleep(500)
                    bot:collectObject(obj.oid, 3)
                    sleep(500)
                end
                if bot:getInventory():getItemCount(id) ~= 0 then 
                    break 
                end
            end
        end
    end
end
function lava()
    while true do
        warps(storage)
        if scanFloat(5) > 0 then
            if bot:getInventory():getItemCount(5) == 0 then
                takefind(5)
                sleep(500)
                if bot:getInventory():getItemCount(5) > 0 then
                    bot:moveRight(2) 
                    sleep(500)
                    bot:moveLeft(1)
                    sleep(500)
                    Itemdrop(5,bot:getInventory():getItemCount(5) - 1)
                    sleep(500)
                    break
                end
            end
        else
            bot.custom_status = "lava zero"
        end
        sleep(1000)
    end
end
function sign()
    while true do
        warps(storage)
        if scanFloat(21) > 0 then
            if bot:getInventory():getItemCount(21) == 0 then
                takefind(21)
                sleep(500)
                if bot:getInventory():getItemCount(21) > 0 then
                    bot:moveRight(2) 
                    sleep(500)
                    bot:moveLeft(1)
                    sleep(500)
                    Itemdrop(21,bot:getInventory():getItemCount(21) - 1)
                    sleep(500)
                    break
                end
            end
        else
            bot.custom_status = "sign zero"
        end
        sleep(1000)
    end
end
function torch()
    while true do
        warps(storage)
        if scanFloat(696) > 0 then
            if bot:getInventory():getItemCount(696) == 0 then
                takefind(696)
                sleep(500)
                if bot:getInventory():getItemCount(696) > 0 then
                    bot:moveRight(2) 
                    sleep(500)
                    bot:moveLeft(1)
                    sleep(500)
                    Itemdrop(696,bot:getInventory():getItemCount(696) - 1)
                    sleep(500)
                    break
                end
            end
        else
            bot.custom_status = "torch zero"
        end
        sleep(1000)
    end
end
--=========END TAKE ITEM=========
function splice()
    for i, tile in ipairs(bot:getWorld():getTiles()) do
        if (tile.fg ~= 0 and tile.fg ~= 202 and getTile(tile.x,tile.y-1).fg == 0 and bot:getInventory():getItemCount(21) ~= 0 and bot:getInventory():getItemCount(5) ~= 0) then
            bot:findPath(tile.x, tile.y-1)
            sleep(200)
            bot:place(tile.x,tile.y-1,21)
            sleep(200)
            bot:place(tile.x,tile.y-1,5)
            sleep(80)
        end
    end
end
function wearing()
    item_ids = {1242, 1244, 1248, 1246}
    for _, item_id in ipairs(item_ids) do
        if bot:getInventory():getItemCount(5) ~= 0 then
            bot:wear(item_id)
            sleep(1000)
        end
    end
end
function quest_pertama()
    take_quest1()
    if bot.custom_status == "quest 1" then
        rotasi_down()
        if bot.custom_status == "done gems" then
            warps(storage)
        end
        while true do
            if bot:getInventory():getItemCount(5) == 0 then
                bot.custom_status = "Lava"
                lava()
            end
            if bot:getInventory():getItemCount(21) == 0 then
                bot.custom_status = "Sign"
                sign()
            end
            if bot:getInventory():getItemCount(696) == 0 then
                bot.custom_status = "Torch"
                torch()
            end
            if bot:getInventory():getItemCount(98) == 0 then
                bot.custom_status ="Pickaxe"
                bot.auto_wear = true
                sleep(10000)
            end
            if bot:getInventory():getItemCount(5) ~= 0 and bot:getInventory():getItemCount(21) ~= 0 and bot:getInventory():getItemCount(696) ~= 0 and bot:getInventory():getItemCount(98) ~= 0 then
                bot.custom_status = "quest1-done take"
            end
            if bot.custom_status == "quest1-done take" then
                home()
                splice()
                sleep(1000)
                bot.custom_status = "quest1-done splice"
                break
            end
            sleep(3000)
        end
    end
    if bot.custom_status == "quest1-done splice" then
        bot.custom_status = "quest1-place Torch"
        home()
        bot:findPath(54,20)
        sleep(2000)
        while bot:getInventory():getItemCount(696) ~= 0 do
            bot:place(bot.x - 1, bot.y - 1, 696)
            sleep(1000)
            bot:moveRight(2)
        end
        bot.custom_status = "quest1-done torch"
    end
    if bot.custom_status == "quest1-done torch" then
        bot.custom_status = "quest1-wrench torch"
        home()
        bot:findPath(45,23)
        sleep(2000)
        bot:wrench(bot.x - 1, bot.y)
        sleep(1000)
        bot:sendPacket(2,"action|dialog_return\ndialog_name|boombox_edit\ncheckbox_public|0\ncheckbox_silence|1\ntilex|44|\ntiley|23|")
        sleep(1000)
        bot.custom_status = "quest1-done wrench torch"
    end
    if bot.custom_status == "quest1-done wrench torch" then
        bot.custom_status = "quest1-open growmoji"
        home()
        bot:sendPacket(2,"action|wrench\n|netid|1")
        sleep(2000)
        bot:sendPacket(2,"action|dialog_return\ndialog_name|popup\nnetID|1|\nbuttonClicked|emojis")
        sleep(1000)
        bot.custom_status = "quest1-done growmoji"
    end
    if bot.custom_status == "quest1-done growmoji" then
        home()
        bot:say("(wow)")
        sleep(1000)
        bot.custom_status = "quest1-DONE ALL"
        sleep(5000)
    end
end

function quest_kedua()
    unlistenEvents()
    bot.custom_status ="quest1-DONE ALL"
    if bot.custom_status == "quest1-DONE ALL" then
        take_quest2()
        listenEvents(4)
        sleep(500)
        unlistenEvents()
    end
    if bot.custom_status == "quest 2" then
        bot.custom_status = "quest2-wrench world"
        home()
        bot:wrench(bot.x,bot.y-1)
        sleep(1000)
        bot:sendPacket(2,"action|dialog_return\ndialog_name|lock_edit\ntilex|45\ntiley|22\ncheckbox_public|0\ncheckbox_disable_music|0\ntempo|100\ncheckbox_disable_music_render|0\ncheckbox_set_as_home_world|1\nminimum_entry_level|124")
        sleep(1000)
        bot.custom_status = "creating world and place sl"
    end
    if bot.custom_status == "creating world and place sl" then
        new_world = getRandom()
        while bot.status ~= BotStatus.online do sleep(13000) end
        if bot.status == BotStatus.online then
            while bot:getWorld().name:lower() ~= new_world:lower() do
                bot:warp(new_world)
                sleep(13000)  
            end
        end
        bot.custom_status = "buy sl"
    end
    if bot.custom_status == "buy sl" then
        bot.custom_status = "lock SL"
        bot:sendPacket(2,"action|buy\nitem|small_lock")
        sleep(1000)
        -- while bot:getInventory():getItemCount(202) ~= 0 do
            bot:place(bot.x,bot.y-1,202)
            sleep(700)
        --     break
        -- end
        -- if bot:getInventory():getItemCount(202) == 0 then
            bot:wrench(bot.x,bot.y-1)
            sleep(500)
            yox = bot.x
            yoy = bot.y - 1
            bot:sendPacket(2,"action|dialog_return\ndialog_name|lock_edit\ntilex|"..yox.."|\ntiley|"..yoy.."|\ncheckbox_public|1\ncheckbox_ignore|0")
            sleep(500)
            bot:wrench(bot.x,bot.y-1)
            sleep(500)
            yox = bot.x
            yoy = bot.y - 1
            bot:sendPacket(2,"action|dialog_return\ndialog_name|lock_edit\ntilex|"..yox.."|\ntiley|"..yoy.."|\ncheckbox_public|0\ncheckbox_ignore|0")
            sleep(500)
            bot.custom_status = "warp start"
        -- end
    end
    if bot.custom_status == "warp start" then
        while bot.status ~= BotStatus.online do sleep(13000) end
        if bot.status == BotStatus.online then
            local validWorlds = { "start", "start1", "start2", "start3" }

            local function isValidWorld(name)
                for _, v in ipairs(validWorlds) do
                    if name:lower() == v then
                        return true
                    end
                end
                return false
            end

            while not isValidWorld(bot:getWorld().name) do
                bot:sendPacket(3, "action|join_request\nname|\ninvitedWorld|0")
                sleep(13000)
            end
            home()
            bot.custom_status = "quest2-DONE ALL"
        end
    end
end

function quest_ketiga()
    check_profile()
    sleep(500)
    if bot.custom_status == "Malpractice" then
        goto DONE
    else
        bot.custom_status = "No Malpractice"
    end
    addEvent(Event.variantlist, quest1)
    unlistenEvents()
    bot.custom_status ="quest2-DONE ALL"
    if bot.custom_status == "quest2-DONE ALL" then
        take_quest3()
        listenEvents(4)
        sleep(500)
        unlistenEvents()
    end
    if bot.custom_status == "quest3-5000 gems" then
        gems_now = bot.gem_count
        rotation.enabled = true
        while bot.gem_count <= gems_now do
            sleep(1000)
        end
        rotation.enabled = false
        bot.custom_status = "buy surgery"
    end
    if bot.custom_status == "buy surgery" then
        while true do
            if bot.gem_count >= 5000 then
                bot:sendPacket(2,"action|buy\nitem|surg_starter_pack")
                sleep(500)
                rotation.enabled = false
                bot.custom_status = "buy done"
                break
            else
                rotation.enabled = true
            end
        end
        bot.custom_status = "place train"
    end
    if bot.custom_status == "place train"then
        home()
        bot:findPath(44,15)
        sleep(2000)
        while getTile(bot.x,bot.y-1).fg==0 and bot:getInventory():getItemCount(8558) ~= 0 do
            bot:place(bot.x, bot.y - 1, 8558)
            sleep(1000)
        end
        -- bot.custom_status = "Perform Nose Job"
        bot.custom_status = "DONE INJECT"
    end
    if bot.custom_status == "Perform Nose Job" or bot.custom_status == "Perform Bird Flu surgery" or bot.custom_status == "Perform Broken Leg surgery" then
        while true do
            unlistenEvents()
            check_profile()
            sleep(500)
            if bot.custom_status == "Malpractice" then
                break
            end
            addEvent(Event.variantlist, quest1)
            take_quest3()
            listenEvents(4)
            sleep(500)
            unlistenEvents()
            if bot.custom_status == "Perform Nose Job" or bot.custom_status == "Perform Bird Flu surgery" or bot.custom_status == "Perform Broken Leg surgery" then
                home()
                on_going = false
                while true do
                    for __, tile in ipairs(getTiles()) do
                        tilew = getTile(tile.x, tile.y)
                        if tile.fg == 8558 then 
                            bot:findPath(tile.x, tile.y)
                            sleep(500) 
                            on_going = true
                        end
                    end
                    if on_going then
                        unlistenEvents()
                        auto_surg()
                        on_going = false
                        sleep(2000)
                        break
                    else
                        home()
                        bot:findPath(44,15)
                        sleep(2000)
                        while getTile(bot.x,bot.y-1).fg==0 and bot:getInventory():getItemCount(8558) ~= 0 do
                            bot:place(bot.x, bot.y - 1, 8558)
                            sleep(1000)
                            break
                        end
                    end
                end
            else
                break
            end
            sleep(5000)
        end
        bot.custom_status = "Check out the Role"
    end
    if bot.custom_status == "Check out the Role" then
        bot:sendPacket(2,"action|input\n|text|/roles")
        sleep(500)
    end
    bot.custom_status = "quest3-DONE ALL"
    ::DONE::

end

function finish()
    rotation.enabled = true
    while bot.level < 12 do
        sleep(5000)
    end
    rotasi_up()
end
while true do
    if bot.custom_status == "ALL INJECT" then
        break
    end
    if bot.level >= 6 then
        startings()
        template_rotasi()
        unlistenEvents()
        addEvent(Event.variantlist, quest1)
        tutorial = bot.auto_tutorial
        tutorial.enabled = false
        tutorial.auto_quest = false
        tutorial.set_as_home = false
        tutorial.set_high_level = false
        tutorial.set_random_skin = false
        tutorial.set_random_profile = false
        quest_pertama()
        quest_kedua()
        quest_ketiga()
        unlistenEvents()
        check_profile()
        if bot.custom_status == "Malpractice" then
            bot.custom_status = "ALL INJECT(Malpractice)"
            finish()
            if bot.level >= 12 then
                wearing()
                break
            end
        end
        sleep(500)
        addEvent(Event.variantlist, quest1)
        take_quest1()
        listenEvents(2)
        sleep(500)
        unlistenEvents()
        if bot.custom_status == "DONE INJECT" then
            take_quest2()
            listenEvents(2)
            sleep(500)
            unlistenEvents()
            if bot.custom_status == "DONE INJECT" then
                take_quest3()
                listenEvents(2)
                sleep(500)
                unlistenEvents()
                if bot.custom_status == "DONE INJECT" then
                    bot.custom_status = "ALL INJECT"
                   finish()
                else
                    quest_ketiga()
                    if bot.custom_status == "Malpractice" then
                        bot.custom_status = "ALL INJECT(Malpractice)"
                        finish()
                    end
                end
            else
                quest_kedua()
            end
        else
            quest_pertama()
        end
    end
    if bot.level >= 12 then
        wearing()
        break
    end
    sleep(5000)
end
