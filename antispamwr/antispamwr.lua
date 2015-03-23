local firsttab = true
local result = false
local version = GetAddOnMetadata("antispamwr", "Version")
local autoban = 100

function antispamwr_postFilter(...)
    firsttab = true
end

function antispamwr_SlashHandler(msg, box)
    msg = string.lower(msg)

    if( msg == "purge all" ) then
        antispamwr_magics["phrases"] = {}
        antispamwr_magics["nicknames"] = {}
        antispamwr_magics["wphrases"] = {}
        antispamwr_magics["manually"] = {}
        antispamwr_magics["catches"] = {}
        print ("Все словари очищены");
    elseif( msg == "purge black" ) then
        antispamwr_magics["phrases"] = {}
        antispamwr_magics["nicknames"] = {}
        print ("Очищены словари черного списка");
    elseif( msg == "purge white" ) then
        antispamwr_magics["wphrases"] = {}
        print ("Очищены словари белого списка");
    elseif( msg == "stat" ) then
        print ("Жалоб в эту сессию: "..antispamwr_magics["statistic"]["session"]);
        print ("Жалоб всего: "..antispamwr_magics["statistic"]["total"]);
    else
        print ("Антиспам аддон от WowRaider.Ru версия "..version)
        print ("Список команд:")
        print ("  /aswr help - показывает подсказку")
        print ("  /aswr stat - показывает статистику")
        print ("  /aswr purge all - очищает все словари, обнуляет обучение")
        print ("  /aswr purge black - очищает словари заблокированных сообщений и имен")
        print ("  /aswr purge white - очищает словари сообщений белого списка")
    end

end

function antispamwr_Filter(...)
    local self, event, msg, user,  language, channelString, target, flags, unknown1, channelNumber, channelName, unknown2, msgcounter, guid= ...
    result = false
    
    if( not(firsttab) ) then
        return result
    end
    firsttab = false
    
    local lmsg = string.lower(msg)

    local weight = 0;
    for word, val in pairs(antispamwr_magics["templates"]) do
        word = string.lower(word)
        if( string.find(lmsg, word, 1, true)) then
            weight = weight + val
        end
    end

    if( weight > 0 and not(antispamwr_magics["wphrases"][lmsg]) ) then 
        if( weight >= autoban or antispamwr_magics["phrases"][lmsg] or antispamwr_magics["phrases"][user] ) then
            result = antispamwr_Report(msgcounter, user, lmsg)
        else
            antispamwr_magics["catches"][lmsg] = 1;
            local msg_protected = string.gsub(msg, '%%', '%%%%');
            result = true;
            StaticPopupDialogs["ANTISPAMWR_CONFIRM"] = {
                text = "Хотите ли вы пожаловаться на сообщение: \n"..msg_protected.."?",
                button1 = "Да",
                button2 = "Нет",
                OnAccept = function(self, unk1, reason)
                    antispamwr_magics["manually"][lmsg] = 1;
                    result = antispamwr_Report(msgcounter, user, lmsg)
                end,
                OnCancel = function(self, unk1, reason)
                    if( reason == 'clicked') then
                        antispamwr_magics["wphrases"][lmsg] = 1;
                    end
                end,
                timeout = 0,
                whileDead = true,
                hideOnEscape = true
                }
            StaticPopup_Show("ANTISPAMWR_CONFIRM");
        end
    end
    return result
end

function antispamwr_Report(msgcounter, user, lmsg)
    ReportPlayer(PLAYER_REPORT_TYPE_SPAM, msgcounter);
--  ComplainChat(msgcounter)
    antispamwr_magics["nicknames"][user] = 1;
    antispamwr_magics["phrases"][lmsg] = 1;
    antispamwr_magics["statistic"]["session"] = antispamwr_magics["statistic"]["session"]+1;
    antispamwr_magics["statistic"]["total"] = antispamwr_magics["statistic"]["total"]+1;
    return true
end

function antispamwr_Init()
    if( not antispamwr_magics) then
        antispamwr_magics = {
            ["templates"] = {},
            ["nicknames"] = {},
            ["phrases"] = {},
            ["catches"] = {},
            };
    end
    
    if( not antispamwr_magics["catches"] ) then
        antispamwr_magics["catches"] = {}
    end
    
    antispamwr_magics["templates"] = {
            ["trоllmоnеy"] = 100,
            ["wowmoney"] = 100,
            ["wowmoney"] = 100,
            ["wowмоneу"] = 100,
            ["a.sworm"] = 100,
            ["tpalala_"] = 100,
            ["вовголд"] = 100,
            ["wow_gold"] = 100,
            ["тrоllмоnеy"] = 100,
            ["wowgoldsale"] = 100,
            ["gold_money_now"] = 100,
            ["souliceman"] = 100,
            ["тrоllмоnеy"] = 100,
            ["gnomoptovik"] = 100,
            ["wow-g-online"] = 100,
            ["З0Л0ТО"] = 100,
            ["INGMONEY"] = 100,
            ["gamersgold"] = 100,
            ["KingPeon"] = 100,

            ["тrоllмоnеy"] = 100,
            ["mmo-shop"] = 100,
            ["ggrpg"] = 100,
            ["moneybooker"] = 100,
            ["duckgold"] = 100,
            
            ["г0"] = 100,
            ["р0"] = 100,
            ["д0"] = 100,
            ["аттестат"] = 100,
            ["30л0"] = 100,
            ["г0лд"] = 100,
            ["gо1d"] = 100,         
            ["30ло"] = 100,         
            ["м0"] = 100,           
            ["неt"] = 100,          
            ["kи"] = 100,           
            ["balalayka92"] = 100,          
            ["rpgbox"] = 100,           
            ["wowgoldbest"] = 100,          
            ["монетныидвор"] = 100,         
            ["wow4real"] = 100,         
            ["mmoney"] = 100,           
            ["вовсчастье"] = 100,           
            
            ["onlinemagazine"] = 100,           
            ["блестяшк"] = 100,
            ["блестях"] = 100,
            ["6лестяшк"] = 100,
            ["6лестях"] = 100,
            ["лотишко"] = 100,

            ["овощевик"] = 100,
            ["0вощевик"] = 100,
            ["oвощевик"] = 100,
            ["ов0щевик"] = 100,
            ["овoщевик"] = 100,
            
            ["golg_money_now"] = 100,
            ["cosmos1140"] = 100,
            ["rpg-shop"] = 100,
            ["мoнeткu"] = 100,
            ["Mywowgold"] = 100,
            ["mуwоwgold"] = 100,
            ["mуwowgоld"] = 100,
            ["rpgdealer"] = 100,
            ["trolmoney"] = 100,
            ["mуwowgold"] = 100,
            ["GGSHOP"] = 100,
            ["mywоwgоld"] = 100,
            ["zолoт0"] = 100,
            ["mywоwgold"] = 100,
            ["monetasrazu"] = 100,
            ["RPGSHOP"] = 100,
            ["Nigmаz"] = 100,
            ["GAMECARDS"] = 100,
            ["wowskill"] = 100,
            ["печеньки"] = 100,
            ["картошку"] = 100,
            ["night-money"] = 100,
            ["elfmoney"] = 100,
            ["rpgcash"] = 100,
            ["oвoщевик"] = 100,
            ["dостaвka"] = 100,
            ["mywowgоld"] = 100,
            ["фани-мани"] = 100,
            ["продам {круг}"] = 100,
            ["продам  {круг}"] = 100,
            ["продаю {круг}"] = 100,
            ["продам картофан"] = 100,
            ["л0t0"] = 100,
            ["л0то"] = 100,
            ["3oл"] = 100,
            ["goldec"] = 100,
            ["thedrot.net"] = 100,
            ["golderman"] = 100,
            ["goldwow"] = 100,
            ["elitno"] = 100,
            ["goldneedgold"] = 100,
            ["nightorc"] = 100,
            ["prodamgold"] = 100,
            ["miratexru"] = 100,
            ["fugasok"] = 100,
            ["offadena"] = 100,
            ["o f f r p g"] = 100,
            ["offrpg"] = 100,
            ["куплю оплату"] = 100,
            ["куплю проплату"] = 100,
            ["прокачка песонажей"] = 100,
            ["kekcique"] = 100,

            ["wówмónèÿ"] = 100,
            ["гöлд"] = 100,
            ["wówмónèÿ"] = 100,
            ["картошка"] = 100,
            ["wowelfgold"] = 100,
            ["g0л"] = 100,
            ["wowмoney"] = 100,
            ["getmoneywow"] = 100,
            ["щебён"] = 100,
            ["игровое время"] = 100,
            ["анус"] = 100,
            ["ануса"] = 100,
            ["куплю монетки"] = 100,
            ["куплю {круг}"] = 100,
            
            ["achieveshop"] = 1000,
            ["mmozoloto"] = 1000,
            ["coins-wow"] = 1000,
            ["maxlvl"] = 1000,
            ["bllizzik"] = 1000,
            ["golddeal.ru"] = 1000,
            ["Arenamasters"] = 1000,
            ["фaни-мaни"] = 1000,
            ["own-market"] = 1000,
            ["idwm"] = 1000,
            ["kupioplatu"] = 1000,
            ["twistedmoney"] = 1000,
            ["whispers ru"] = 1000,
            ["whispers.ru"] = 1000,
            ["korobeinik.me"] = 1000,
            ["wowhere.ru"] = 1000,
            ["mmo-market.ru"] = 1000,
            ["buyboost.ru"] = 1000,
            ["dving.ru"] = 1000,
            ["fastwow.ru"] = 1000,
            ["winigold.ru"] = 1000,
            ["wowmart.ru"] = 1000,
            ["my24gold.ru"] = 1000,
            ["mmo-cash.ru"] = 1000,
            ["crabbs-level"] = 1000,
            ["golddeal.ru"] = 1000,
            ["boomkin.ru"] = 1000,
            ["vip-wow.ru"] = 1000,
            ["rpg-sale.ru"] = 1000,
            ["vendor-money.ru"] = 1000,
            ["pve-helper.com"] = 1000,
            ["wowmoney.ru"] = 1000,
            ["mmopeon.ru"] = 1000,
            ["paywow.ru"] = 1000,
            ["кorobeinik"] = 1000,
            ["wow-store"] = 1000,
            ["draenorgold.ru"] = 1000,
            ["lvl-money.ru"] = 1000,
            ["9peso.ru"] = 1000,
            ["archemoney.ru"] = 1000,

            ["bornboost"] = 1000,
            ["draeneigold.ru"] = 1000,
            ["oldschool-gaming"] = 1000,
            ["leeeroy.com"] = 1000,
            ["sellpaywow"] = 1000,
            ["boostingshop"] = 1000,
            
            ["druidshop.ru"] = 1000,
            ["продам аккаунт"] = 1000,
            ["куплю аккаунт"] = 1000,

            ["продам золото"] = 100,
            ["куплю золото"] = 100,
            ["куплю ваше золото"] = 1000,

            ["freewowgold"] = 1000,
            ["rpgtorg"] = 1000,
            ["djuancheg"] = 1000,
            ["chupboost"] = 1000,
            ["motore82"] = 1000,
            ["leeeroy.com"] = 1000,
            ["rpg-sale"] = 1000,
            ["wowersy"] = 1000,
            ["selfwow"] = 1000,
            ["self-wow"] = 1000,
            ["lexberk"] = 1000,
            ["mmo-market"] = 1000,
            ["oldschool-gaming"] = 1000,
            ["draeneigold"] = 1000,
            ["corvano"] = 1000,
            ["wowgydrasale"] = 1000,
            ["paywow"] = 1000,
            ["white-tavern"] = 1000,
            ["wow-nexus.ru"] = 1000, 
            ["saledraenor"] = 1000, 
            ["wow-golda"] = 1000, 
            
            ["продам голд"] = 1000,
            ["куплю голд"] = 1000,
            ["продам монет"] = 1000,
            ["куплю монет"] = 1000,
            ["продам печеньки"] = 1000,
            ["куплю печеньки"] = 1000,
            ["продам блестяшки"] = 1000,
            ["куплю блестяшки"] = 1000,
            ["куплю картоф"] = 1000,
            ["продам картоф"] = 1000,
            ["куплю картаф"] = 1000,
            ["продам картаф"] = 1000,
            
            ["золото 11"] = 1000,
            ["золото 10"] = 1000,
            ["золото 12"] = 1000,
            ["золот{rt2}"] = 1000,
            
            ["скайп"] = 25,
            ["skype"] = 25,
            ["ІCQ"] = 25,
            ["ІСQ"] = 25,
            ["icq"] = 25,
            ["iсq"] = 50,

            ["аккаунт"] = 50,
            ["акаунт"] = 50,
            ["нефт"] = 50,
            ["wmr"] = 50,
            ["протекц"] = 50,
            ["вмр"] = 50,
            ["виза"] = 50,
            ["visa"] = 50,
            ["киви"] = 50,
            ["qiwi"] = 50,
            ["монеты"] = 50,
            ["золот"] = 50,
            ["печенье"] = 50,
            
            ["золото]|h|r"] = -100,
            ["0|h[золот"] = -100,
            
            ["wowgydrasale"] = 100,
            
            ["истинное золот"] = -500,
            ["золотой лотос"] = -500,
            ["корвалийское золот"] = -500,
            }
    if( not antispamwr_magics["wphrases"] ) then
        antispamwr_magics["wphrases"] = {}
    end
    if( not antispamwr_magics["manually"] ) then
        antispamwr_magics["manually"] = {}
    end

    if( not antispamwr_magics["statistic"] ) then
        antispamwr_magics["statistic"] = {
            ["total"] = 0,
            }
    end

    if( not antispamwr_magics["statistic"]["total"] ) then
        antispamwr_magics["statistic"]["total"] = 0;
    end

    antispamwr_magics["statistic"]["session"] = 0;
    
    SLASH_ASWR1 = '/aswr';
    SlashCmdList["ASWR"] = antispamwr_SlashHandler  

    antispamwr_Frame:RegisterEvent("CHAT_MSG_CHANNEL")
    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL",antispamwr_Filter)
    print("Анти-спаммер от WowRaider.Ru. Версия "..version.." Управление /aswr")
end

