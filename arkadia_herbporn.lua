arkadia_herbporn = arkadia_herbporn or {
    state = false,
    items = {},
    panel = "",
    bufflabel = nil,
    fontsize = 14
}
-- ✊
-- 🍄

arkadia_herbporn.herbs = {
    ["deliona"] = {
        cooldown = 600,
        effect = 15,
        effect_type = "sta",
        stacks = true,
        diminish = true,
        diminish_ratio = 3,
        --symbol = "🌼"
        symbol = "🌼"
    },
    ["mandragora"] = {
        cooldown = 600,
        effect = 1,
        stacks = false,
        diminish = true,
        diminish_ratio = 3,
        symbol = "💧"
    },
    ["bielun"] = {
        cooldown = 0,
        effect = 600,
        effect_type = "str",
        stacks = true,
        dimisnih = true,
        diminish_ratio = 3,
        --symbol = "🌿"
        symbol = "🏋 <font color='magenta'>B"
    }
}

--Powoli opuszczaja cie wszelkie emocje. Zadne odczucia nie zaklocaja twoich mysli. Bardziej opanowany juz chyba byc nie mozesz.

function arkadia_herbporn:add_buff(bufftype)
    local itemcount = table.size(arkadia_herbporn.items)
    itemcount = itemcount + 1
    arkadia_herbporn.items[itemcount] = {}
    arkadia_herbporn.items[itemcount].type = bufftype
    arkadia_herbporn.items[itemcount].cooldown = arkadia_herbporn.herbs[bufftype].cooldown
    arkadia_herbporn.items[itemcount].effect = arkadia_herbporn.herbs[bufftype].effect
    cecho("<green>(buffs) <reset>" .. os.date("%H:%m:%S") .. " Added <blue>" .. bufftype .. "<reset> to the stack.\n")
end


function arkadia_herbporn:label_setup()
    local evenBiggerFont = scripts.ui.multibinds.font_size + 4
    local css = CSSMan.new([[
    padding-left: 5px;
    border-bottom: 1px solid black;
    margin-bottom: 3px;
    font-family:]].. getFont() ..[[,Consolas,Monaco,Lucida Console,Liberation Mono,DejaVu Sans Mono,Bitstream Vera Sans Mono,Courier New, monospace;
  ]] .. amap.ui.normal_button)

    arkadia_herbporn.bufflabel = Geyser.Label:new({
        name = "arkadia_herbporn.bufflabel",
        height = "100%",
        width = "50%",
        fontSize = arkadia_herbporn.fontsize
    }, scripts.ui.actions_container)

    arkadia_herbporn.bufflabel:setStyleSheet(css:getCSS())
    arkadia_herbporn.bufflabel:echo("<font color='lawn green'>Init...")
end

function arkadia_herbporn:nice_minutes(seconds)
    if seconds > 600 then return "10m" end
    if seconds > 540 then return "9m" end
    if seconds > 480 then return "8m" end
    if seconds > 420 then return "7m" end
    if seconds > 360 then return "6m" end
    if seconds > 300 then return "5m" end
    if seconds > 240 then return "4m" end
    if seconds > 180 then return "3m" end
    if seconds > 120 then return "2m" end
    if seconds > 60 then return "1m" end
    return seconds
end

function arkadia_herbporn:loop()
    arkadia_herbporn.panel = ""
    local itemcount = table.size(arkadia_herbporn.items)
    if itemcount == 0 then
        if self.bufflabel then
            self.bufflabel:hide()
        end
        tempTimer(1, [[arkadia_herbporn:loop()]])
        return
    end

    if not self.bufflabel then
        self.label_setup()
    end

    self.bufflabel:show()

    for i=1, itemcount, 1 do
        if arkadia_herbporn.items[i].cooldown > 0 then
            arkadia_herbporn.items[i].cooldown = arkadia_herbporn.items[i].cooldown - 1
            if arkadia_herbporn.items[i].cooldown == 0 then
                cecho("<green>(buffs) <reset>" .. os.date("%H:%m:%S") .. " The cooldown of <yellow>" .. arkadia_herbporn.items[i].type .. "<reset> faded...\n")
                arkadia_herbporn.items[i].cooldown = -1
            else
                arkadia_herbporn.panel = arkadia_herbporn.panel .. "<font color='black'>|" .. arkadia_herbporn.herbs[arkadia_herbporn.items[i].type].symbol .. "<font color='red'>" .. self:nice_minutes(arkadia_herbporn.items[i].cooldown)
            end
        end
        if arkadia_herbporn.items[i].effect > 0 then
            arkadia_herbporn.items[i].effect = arkadia_herbporn.items[i].effect - 1
            if arkadia_herbporn.items[i].effect == 0 then
                cecho("<green>(buffs) <reset>" .. os.date("%H:%m:%S") .. " The effect of <yellow>" .. arkadia_herbporn.items[i].type .. "<reset> faded...\n")
                arkadia_herbporn.items[i].effect = -1
            else
                arkadia_herbporn.panel = arkadia_herbporn.panel .. "<font color='black'>|" .. arkadia_herbporn.herbs[arkadia_herbporn.items[i].type].symbol .. "<font color='lawn green'>" .. self:nice_minutes(arkadia_herbporn.items[i].effect)
            end
        end
    end
    arkadia_herbporn.bufflabel:echo(arkadia_herbporn.panel)
    tempTimer(1, [[arkadia_herbporn:loop()]])
end


function arkadia_herbporn:init()
    self.fontsize = scripts.ui.multibinds.font_size + 2
    arkadia_herbporn.items = {}
    arkadia_herbporn:loop()
end

arkadia_herbporn:init()


