nameplayer = "trickysave"
Current_x = 19
bot_index = 8
--========================
pnbworld ="ariopnb2" 
pnbid ="vri877ze21"
--========================
storage ="lohiyoblocks"
storageid ="vri877ze21"
--========================
dropseed ="lohiyoseed"
dropseedid ="vri877ze21"
iddropseed = 596
--========================
droppack ="lohiyoseed"
droppackid ="vri877ze21"
iddroppack = 1422
--========================
packname = "geiger"
packid = {2204}
pricepack = 25000
packlimit = 1
--========================
idblock = 4584
idseed = idblock + 1
--========================
delayput = 120
delaypun = 180
--========================
trashitem = {5024, 5026, 5028, 5030, 5030, 5032, 5034, 5036, 5038, 5040, 5042, 5044, 7164, 7162} --trash list
webhookblock = "https://discord.com/api/webhooks/1168111309276053544/RZSyQf1oBtlJs9Wou4xRuUv0Po2SwYekT2JQIXEW0josEAHNySJPTtds8yGwDSF76Zts"
Webhookseed = "https://discord.com/api/webhooks/1168138169607278653/l8z2qQbPMx4b6jHnG9nGYqLd_k3osFMiA8kXXANxXQdPS6cdGiK0KxfGyWg3XNVEBK_e"
bot = getBot()
modjoin = false
guardianjoin = false
maxSpot  = false
seed_x = 0
bot_collect = false
--=========PICKAXE============
function collectSpek()
    if bot:inWorld() then
        for _, object in pairs(bot:getObjects()) do
            local posX = math.floor(object.pos.x / 32)
            local posY = math.floor(object.pos.y / 32)
            if bot:isInside(posX, posY, 3) then
                if object.id == 98 then
                    bot:collectObject(object.uid)
                end
            end
        end
    end
end
function Itemdrop(itemID, count)
    if bot:getItemCount(itemID)>=count then
        bot:sendPacket("action|drop\nitemID|" .. itemID, 2)
        sleep(1000)
        bot:sendPacket("action|dialog_return\ndialog_name|drop_item\nitemID|" .. itemID .. "|\ncount|" .. count,2)
        sleep(3000)
    end
end
function scanFloat(id)
    local count = 0
    for _, obj in pairs(bot:getObjects()) do
        if obj.id == id then
            count = count + obj.count
        end
    end
    return count
end
function takefind(id)
    for _, obj in pairs(bot:getObjects()) do
        if obj.id == id then
            local x = math.floor(obj.pos.x/32)
            local y = math.floor(obj.pos.y/32)
            bot:findPath(x, y)
            sleep(1500)
            collectSpek()
            sleep(3000)
        end
        if bot:getItemCount(id) > 0 then
            break
        end
    end
end
function pickaxe()
    while true do
        if scanFloat(98) > 0 then
            if bot:getItemCount(98) == 0 then
                takefind(98)
                sleep(100)
                if bot:getItemCount(98) > 0 then
                    Itemdrop(98,bot:getItemCount(98) - 1)
                    sleep(5000)
                    break
                end
            end
        end
        sleep(2000)
    end
end
function wear(id)
    pkt = {}
    pkt.type = 10
    pkt.int_data = id
    bot:sendPacketRaw(pkt)
end
--========================
for _,bot in pairs(getBots()) do
    total = bot:getIndex() + 1
end
function iniCollect()
    if bot:inWorld() then
        for __,tile in ipairs(bot:getTiles()) do
            if tile.fg == 20 or tile.bg == 20 then
                pnbx = tile.x + 10
                pnby = tile.y - 3
            end
        end
        bot:findPath(pnbx,pnby)
        sleep(500)
    end
end
function collectAllIgnoreGems()
    if bot:inWorld() or (bot:getItemCount(idseed)~=200 and bot:getItemCount(idblock)~=200) then
        for _, object in pairs(bot:getObjects()) do
            local posX = math.floor(object.pos.x / 32)
            local posY = math.floor(object.pos.y / 32)
            if bot:isInside(posX, posY, 3) then
                if 112 == nil or object.id ~= 112 then
                    bot:collectObject(object.uid)
                end
            end
        end
    end
end
function CollectAll(range)
    if bot:inWorld() then
        for _, obj in pairs(bot:getObjects()) do
            local posx = math.abs(bot:getLocal().pos.x - obj.pos.x)
            local posy = math.abs(bot:getLocal().pos.y - obj.pos.y)
            if posx < range * 36 and posy < range * 36 then
                pkt = {}
                pkt.type = 11
                pkt.int_data = obj.uid
                pkt.pos_x = obj.pos.x
                pkt.pos_y = obj.pos.y
                bot:sendPacketRaw(pkt)
                sleep(10)
            end
        end
    end
end
function warps(B,P)
    if bot:getEnetStatus()==Connected then
        while bot:getCurrentWorld():upper()~=B:upper() or bot:getTile(math.floor(bot:getLocal().pos.x/32),math.floor(bot:getLocal().pos.y/32)).fg==6 do
            sleep(500)
            bot:sendPacket("action|join_request\nname|"..B.."|"..P.."\ninvitedWorld|0",3)       
            sleep(5000)
        end
    end
end
function baris()
    if bot:inWorld() then
        for __,tile in ipairs(bot:getTiles()) do
            if tile.fg == 20 or tile.bg == 20 then
                pnbx = tile.x + bot:getIndex() + 2
                pnby = tile.y
            end
        end
        if (pnbx % 2 == 0) then
            pnbx = pnbx + total + 2
        else
            pnbx = pnbx + 1
        end
    end
    return
end
function joinpnb()
    while bot:getTile(math.floor(bot:getLocal().pos.x / 32), math.floor(bot:getLocal().pos.y / 32)).fg == 6 or bot:getWorld().name ~= pnbworld:lower() or bot:getWorld().name == "exit" or bot:getTile(math.floor(bot:getLocal().pos.x / 32), math.floor(bot:getLocal().pos.y / 32)).fg == 12 do
        warps(pnbworld,pnbid)
        while bot:getWorld().name ~= pnbworld:lower() do
            sleep(1000)
        end
        bot:findPath(pnbx,pnby)
        sleep(500)
    end
    return false
end
function joindrop()
    while bot:getTile(math.floor(bot:getLocal().pos.x / 32), math.floor(bot:getLocal().pos.y / 32)).fg == 6 or bot:getWorld().name ~= dropseed:lower() or bot:getWorld().name == "exit" do
        warps(pnbworld,droppackid)
        while bot:getWorld().name ~= dropseed:lower() do
            sleep(1000)
        end
    end
    return false
end
function recon1()
    if bot:getEnetStatus()~=Connected then recon2() end
    if bot:getEnetStatus()==Connected and bot:getTile(math.floor(bot:getLocal().pos.x/32),math.floor(bot:getLocal().pos.y/32)).fg==6 then
        while bot:getTile(math.floor(bot:getLocal().pos.x/32),math.floor(bot:getLocal().pos.y/32)).fg==6 do
            if bot:getCurrentWorld():upper()==pnbworld:upper() then
                warps(pnbworld,pnbid)
            elseif bot:getCurrentWorld():upper()==droppack:upper() then
                warps(droppack,droppackid)
            elseif bot:getCurrentWorld():upper()==dropseed:upper() then
                warps(dropseed,dropseedid)
            end
        end
        bot:findPath(pnbx,pnby)
        sleep(500)
    end
    if modjoin then
        if bot:getEnetStatus()==Connected then
            bot:setBool("autoReconnect", false)
            bot:disconnect()
            sleep(10000)
            while bot:getEnetStatus()==Connected do
                bot:setBool("autoReconnect", false)
                bot:disconnect()
                sleep(30000)
            end
        end
        sleep(1000)
        log("Mods join the world. Bot auto dc.")
        sleep(1000)
        modjoin=false
    end
    if guardianjoin then
        if bot:getEnetStatus()==Connected then
            bot:setBool("autoReconnect", false)
            bot:disconnect()
            sleep(10000)
            while bot:getEnetStatus()==Connected do
                bot:setBool("autoReconnect", false)
                bot:disconnect()
                sleep(30000)
            end
        end
        sleep(1000)
        log("Guardian join the world. Bot auto dc.")
        sleep(1000)
    end
end
function recon2()
    if bot:getEnetStatus()==Disconnected then
        sleep(10000)
        while bot:getEnetStatus()==Disconnected do
            bot:reConnect()
            sleep(20000)
            if bot:getBotStatus()==OnSendToServer then
                sleep(20000)
            elseif bot:getBotStatus()==Banned then
                log(bot:getLocal().name .. "IS BANNED")
                bot:remove()
                sleep(10000)
                log("Banned")
            elseif bot:getBotStatus()==Suspended then
                log(bot:getLocal().name .. "IS BANNED")
                bot:remove()
                sleep(10000)
                log("Suspended")
            elseif bot:getBotStatus()==SERVER_OVERLOADED then
                sleep(300000)
                log("Server Overload")
            elseif bot:getBotStatus()==LogonATTEMPTS then
                sleep(30000)
            elseif bot:getBotStatus()==Maintenance then
                log("Server Maintenance Delay 30 Minutes")
                sleep(1800000)
            elseif bot:getBotStatus()==Update_Required then
                sleep(600000)
                log("Update Required.")
            end
        end
        log("Bot Reconnected.")
        sleep(500)
    elseif bot:getEnetStatus()==ShadowBan then
        log("Bot Got Error Connecting. Bot Try Reconnect 3 Times")
        for m=1,3,1 do
            sleep(5000)
            bot:reConnect()
            sleep(30000)
            if bot:getEnetStatus()==Connected then
                goto C 
            end
        end
        sleep(10000)
        ::C::
        if bot:getEnetStatus()==Connected then
            log("Bot Reconnected.")
        else
            log("Bot Removed Got Ercon.")
        end
    end
end
function modjoined(guardian)
    if guardian then
        
        guardianjoin=true
    else
        
        modjoin=true
    end
end
function take()
    if bot:inWorld() then
        for i, object in pairs(bot:getObjects()) do
            if object.id == idblock then
                local posX = math.floor(object.pos.x / 32)
                local posY = math.floor(object.pos.y / 32)
                if bot:findPath(posX, posY) then
                    sleep(500)
                    CollectAll(3)
                    sleep(500)
                    if bot:getItemCount(idblock) ~= 0 then 
                        -- local totalblocks = bot:getItemCount(idblock)
                        -- if totalblocks > 100 then
                        --     bot:drop(idblock, totalblocks - 100)
                        --     sleep(500)
                        -- end
                        sleep(1000)
                        return true 
                    end
                end
                sleep(50)
            end
        end
        return false
    end
end
function droppp(B)
local counts=bot:getItemCount(B)
    if bot:inWorld() then
        bot:sendPacket("action|drop\n|itemID|"..B,2)
    	sleep(1500)
        bot:sendPacket("action|dialog_return\ndialog_name|drop_item\nitemID|"..B.."|\ncount|"..counts,2)
        sleep(5000)
    end
end
function HookSeed(varlist)
    if varlist[0] == "OnTextOverlay" then
        if varlist[1]:find("You can't drop") then
            maxSpot = true
        end
    end
end

bot:addHook(HookSeed,varlist)
function dropbijilu(B)
    if bot:getCurrentWorld():upper()~=dropseed:upper() then
        warps(dropseed,dropseedid)
        joindrop()
        recon1()
    end
    if bot:inWorld() and bot:getCurrentWorld():upper()==dropseed:upper() and bot:getEnetStatus()==Connected then
        joindrop()
        recon1()
        for V,c in pairs(bot:getTiles()) do
            if c.fg==iddropseed or c.bg==iddropseed then
                bot:findPath(c.x-bot:getIndex(),c.y)
                sleep(500)
                while bot:getItemCount(B)>0 do
                    sleep(1500)
                    bot:sendPacket("action|drop\n|itemID|"..idseed,2)
                    sleep(1500)
                    bot:addHook(HookSeed,varlist)
                    sleep(500)
                    if not maxSpot then
                        joindrop()
                        recon1()
                        bot:drop(idseed, bot:getItemCount(idseed)) 
                        sleep(1000)
                        joindrop()
                        recon1()
                        if bot:getItemCount(idseed) ~=0 then
                            joindrop()
                            recon1()
                            maxSpot = true
                        end
                    end
                    if maxSpot then
                        joindrop()
                        recon1()
                        maxSpot = false
                        bot:move(LEFT, 1) 
                        sleep(1000)
                        seed_x = seed_x + 1
                    end
                    if not maxSpot and bot:getItemCount(idseed)==0 then sleep(5000) goto C end
                end
            end
        end
        ::C::
    end
end
function buypack()
    if bot:getCurrentWorld():upper()~=droppack:upper() then
        warps(droppack,droppackid)
        sleep(1000)
        joindrop()
        recon1()
    end
    if bot:getCurrentWorld():upper()==droppack:upper() then
        if bot:inWorld() then
            joindrop()
            recon1()
            while bot:getLocal().gems>=pricepack do
                sleep(500)
                if bot:getItemCount(packid[1])~=200 then
                    bot:sendPacket("action|buy\nitem|"..packname,2)
                    sleep(1000)
                    joindrop()
                    recon1()
                end
                if bot:getItemCount(packid[1])==200 then
                    break
                end
                joindrop()
                recon1()
                if bot:getItemCount(packid[1])==0 then
                    bot:sendPacket("action|buy\nitem|upgrade_backpack",2)
                    sleep(1000)
                    log("Bot Buy BP")
                end
                joindrop()
                recon1()
                if bot:getLocal().gems<pricepack then
                    sleep(100)
                    break
                end
            end
            for E,V in pairs(bot:getTiles()) do
                if V.fg==iddroppack or V.bg==iddroppack then
                    bot:findPath(V.x,V.y)
                    sleep(1000)
                    for B,E in pairs(packid) do
                        while bot:getItemCount(E)>0 do
                            sleep(1500)
							bot:move(LEFT,1)
							sleep(1000)
                            droppp(E)
                            sleep(1000)
                            joindrop()
                            recon1()
                        end
                    end
                end
            end
            joindrop()
            recon1()
        end
    end
end
function trashkontol(B)
    if bot:inWorld() then
        sleep(500)
        bot:sendPacket("action|trash\n|itemID|"..B,2)
        sleep(1000)
        bot:sendPacket("action|dialog_return\ndialog_name|trash_item\nitemID|"..B.."|\ncount|"..bot:getItemCount(B),2)
        sleep(1000)
    end
end
function Scan()
scankntl = 0
    if bot:inWorld() then
        for _, object in pairs(bot:getObjects()) do
            if object.id == idblock then
                scankntl = scankntl + object.count
            end
        end
        return scankntl
    end
end
function ScanSeed()
scankntl_seed = 0
    if bot:inWorld() then
        for _, object in pairs(bot:getObjects()) do
            if object.id == idseed then
                scankntl_seed = scankntl_seed + object.count
            end
        end
        return scankntl_seed
    end
end
function ScanPack()
scan_pack = 0
    if bot:inWorld() then
        for _, object in pairs(bot:getObjects()) do
            if object.id == packid[1] then
                scan_pack = scan_pack + object.count
            end
        end
        return scan_pack
    end
end
function mf(xy)
    return math.floor(xy / 32)
end
function punch(x,y)
    if bot:inWorld() then
        bot:hitTile(mf(bot:getLocal().pos.x) + x,mf(bot:getLocal().pos.y) + y)
    end
end
function place(id,x,y)
    if bot:inWorld() then
        bot:placeTile(mf(bot:getLocal().pos.x) + x,mf(bot:getLocal().pos.y) + y,id)
    end
end
function pnb()
    joinpnb()
    bot:findPath(pnbx,pnby)
    sleep(1000)
    while bot:getItemCount(idblock)~=0 and bot:inWorld() and bot:getEnetStatus()==Connected do
        joinpnb()
        recon1()
        if bot_collect then
            while(getBot(bot_index):getCurrentWorld():upper()~=pnbworld:upper() and getBot(bot_index):getEnetStatus()~=Connected) do 
                sleep(3000)
            end
            while (getBot(bot_index):getLocal().pos.y / 32 ~= Current_x) do
                sleep(3000)
            end
        end
        if bot:getTile(pnbx,pnby-2).fg~=0 and bot:getEnetStatus()==Connected then
            punch(0,-2)
            sleep(delaypun)
        end
        if bot:getTile(pnbx,pnby-1).fg~=0 and bot:getEnetStatus()==Connected then
            punch(0,-1)
            sleep(delaypun)
        end
        if bot:getItemCount(idseed)==200 then goto A end
        if bot:getTile(pnbx,pnby-2).fg==0 and bot:getItemCount(idblock) ~= 0 and bot:getEnetStatus()==Connected then
            CollectAll(2)
            sleep(50)
            place(idblock,0,-2)
            sleep(delayput)
        end
        if bot:getTile(pnbx,pnby-1).fg==0 and bot:getItemCount(idblock) ~= 0 and bot:getEnetStatus()==Connected then
            CollectAll(2)
            sleep(50)
            place(idblock,0,-1)
            sleep(delayput)
        end
        joinpnb()
        recon1()
    end
    ::A::
    for d,T in pairs(trashitem) do
        if bot:getItemCount(T)>5 then
            trashkontol(T)
            sleep(500)
        end
    end
end
function sendWebhookSeed(text,WH)
    RequestINFO={}
    RequestINFO.json = true
    RequestINFO.url=WH
    RequestINFO.method=POST
    RequestINFO.postData = 
    [[
        {
            "content" : "SEED LEFT : ]]..scankntl_seed..[[\n\nPACK LEFT : ]]..scan_pack..[[",
          "embeds": [
            {   
                "title": "Made by Do's",
                "description": "]]..text..[[\n\nSEED LEFT : ]]..scankntl_seed..[[\n\nPACK LEFT : ]]..scan_pack..[[",
              "color": "]] .. math.random(0, 16777215) .. [[",
              "footer": {
                "text": "Webhook made With <3 \n]]..(os.date("!%a %b %d, %Y at %I:%M %p", os.time() + 7 * 60 * 60))..[[",
                "icon_url": "https://media.tenor.com/-dW_a5gQvEwAAAAC/gaming-imposter.gif"
              }
            }
          ]
        }
    ]]
    x = httpReq(RequestINFO)
    if x.success then
        suksessss = yeyay
    else
        log("Request WH Failed Error Msg : ",x.failInfo)
    end
end
function sendWebhookBlock(text,WH)
    RequestINFO={}
    RequestINFO.json = true
    RequestINFO.url=WH
    RequestINFO.method=POST
    RequestINFO.postData = 
    [[
        {
            "content" : "Info",
          "embeds": [
            {   
                "title": "Made by Do's",
                "description": "]]..text..[[\n\nBLOCK LEFT : ]]..scankntl..[[",
              "color": "]] .. math.random(0, 16777215) .. [[",
              "footer": {
                "text": "Webhook made With <3 \n]]..(os.date("!%a %b %d, %Y at %I:%M %p", os.time() + 7 * 60 * 60))..[[",
                "icon_url": "https://media.tenor.com/-dW_a5gQvEwAAAAC/gaming-imposter.gif"
              }
            }
          ]
        }
    ]]
    x = httpReq(RequestINFO)
    if x.success then
        suksessss = yeyay
    else
        log("Request WH Failed Error Msg : ",x.failInfo)
    end
end
bot:addHook(modjoined,moderatorJoined)
if bot:getLocal().name == nameplayer then
    warps(pnbworld,pnbid)
    iniCollect()
    goto ENDD
end
warps(pnbworld,pnbid)
sleep(1000)
if bot:getItemCount(98) == 0 then
    warps(pnbworld,pnbid)
    sleep(500)
    pickaxe()
    sleep(1000)
    wear(98)
    sleep(3000)
end
baris()
pnb()
while true do
    if bot:getItemCount(idseed) >= 20 then
        dropbijilu(idseed)
        if bot:getLocal().gems>pricepack then
            buypack()
        end
        ScanSeed()
        ScanPack()
        sendWebhookSeed("Dropp Seed ...",Webhookseed)
        -- warps(pnbworld,pnbid)
        -- pnb()
    end
    warps(storage,storageid)
    if not take() then
        warps(pnbworld,pnbid)
        pnb()
        log("DONE ...")
        goto ZERO
    end
    Scan()
    sendWebhookBlock("Take Block ...",webhookblock)
    warps(pnbworld,pnbid)
    pnb()
end
warps(pnbworld,pnbid)
goto ZERO

---=======BOT COLLECT===============
::ENDD::
function dropGeiger()
    if bot:getCurrentWorld():upper()~=droppack:upper() then
        warps(droppack,droppackid)
        joindrop()
        recon1()
    end
    if bot:getCurrentWorld():upper()==droppack:upper() then
        if bot:inWorld() then
            joindrop()
            recon1()
            for E,V in pairs(bot:getTiles()) do
                if V.fg==iddroppack or V.bg==iddroppack then
                    bot:findPath(V.x,V.y)
                    sleep(500)
                    bot:drop(packid[1], bot:getItemCount(packid[1]))
                    sleep(500)
                end
            end
            joindrop()
            recon1()
        end
    end
end
function warpsSOLO(B,P)
    while bot:getCurrentWorld():upper()~=B:upper() or bot:getTile(math.floor(bot:getLocal().pos.x/32),math.floor(bot:getLocal().pos.y/32)).fg==6 do
        sleep(500)
        bot:sendPacket("action|join_request\nname|"..B.."|"..P.."\ninvitedWorld|0",3)       
        sleep(5000)
    end
end
function joinpnbSOLO()
    while bot:getTile(math.floor(bot:getLocal().pos.x / 32), math.floor(bot:getLocal().pos.y / 32)).fg == 6 or bot:getWorld().name ~= pnbworld:lower() or bot:getWorld().name == "exit" do
        warpsSOLO(pnbworld,pnbid)
        while bot:getWorld().name ~= pnbworld:lower() do
            sleep(1000)
        end
        if bot:inWorld() then
            local ignoreList = {4584, 4585,2204}
            while bot:getTile(math.floor(bot:getLocal().pos.x / 32), math.floor(bot:getLocal().pos.y / 32)).fg == 12 do
                iniCollect()
            end
        end
    end
    return
end
ignoreList = {4584, 4585, 2204}
bot:autoCollect(10, true, ignoreList)
while true do
    joinpnbSOLO()
    if bot:inWorld() then
        bot:autoCollect(10, true, ignoreList)
        if bot:getLocal().gems >= pricepack then
            bot:sendPacket("action|buy\nitem|geiger",2)
            sleep(1000)
        end
        if bot:getItemCount(packid[1]) >= 1 then
            bot:autoCollect(10, false, ignoreList)
            dropGeiger()
            bot:autoCollect(10, true, ignoreList)
        end
    else
        bot:autoCollect(10, false, ignoreList)
    end
    ::JA::
end
---=======END BOT COLLECT===============

::ZERO::
seed_x = seed_x + 1
dropbijilu(idseed)
bot= getBot()
randomworld = {"qwuifbuiqw", "qwifoq", "qwifobfwqib", "qwfiboiwqbf", "qwfiboiwqbfq", "qifwboiwqbf", "oiwqbfiobiouqwe", "qwifbioqbwf", "qfwiboiwqbfiou", "qfwboiwquyoi", "oiwqbfiouwqoie", "oiwqbfoiqbwoiu", "oiwqbfiouwqoieq", "qfwboiwqbfoiu", "fwqboiwqbfie", "fwqbiqwfoiu", "qiwfboiwqfoiuqwe", "qfwboiqbwfoi", "qwifboiuwqe", "qwifobqofiu"}
function warps(B,P)
    if bot:getEnetStatus()==Connected then
        while bot:getCurrentWorld():upper()~=B:upper() or bot:getTile(math.floor(bot:getLocal().pos.x/32),math.floor(bot:getLocal().pos.y/32)).fg==6 do
            sleep(500)
            bot:sendPacket("action|join_request\nname|"..B.."|"..P.."\ninvitedWorld|0",3)       
            sleep(5000)
			break
        end
    end
end
warps(randomworld[bot:getIndex() + 1],"aa")
