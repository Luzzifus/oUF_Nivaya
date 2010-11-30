local RefreshAnchoring = function()
    oUF_pet:ClearAllPoints()
    oUF_pet:SetPoint('TOPRIGHT', oUF_player, 'BOTTOMRIGHT', nivcfgDB.petX, nivcfgDB.petY)

    oUF_target:ClearAllPoints()
    if nivcfgDB.targetSym then
        oUF_target:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -nivcfgDB.playerX, nivcfgDB.playerY)
    else
        oUF_target:SetPoint('BOTTOMLEFT', oUF_player, 'BOTTOMRIGHT', nivcfgDB.targetX, nivcfgDB.targetY)
    end

    oUF_tot:ClearAllPoints()
    oUF_tot:SetPoint('BOTTOMLEFT', oUF_target, 'TOPRIGHT', nivcfgDB.totX, nivcfgDB.totY)

    oUF_focus:ClearAllPoints()
    oUF_focus:SetPoint('BOTTOMRIGHT', oUF_player, 'TOPLEFT', nivcfgDB.focusX, nivcfgDB.focusY)

    if oUF_ttt then
        oUF_ttt:ClearAllPoints()
        oUF_ttt:SetPoint('TOPLEFT', oUF_tot, 'TOPRIGHT', nivcfgDB.tttX, nivcfgDB.tttY)
    end

    if oUF_ft then
        oUF_ft:ClearAllPoints()
        oUF_ft:SetPoint('TOPRIGHT', oUF_focus, 'TOPLEFT', nivcfgDB.ftX, nivcfgDB.ftY)
    end

    local vg = nivDB.vg

    if prh then
        local offs = nivDB.healerMode and nivcfgDB.hmraidOffset or nivcfgDB.raidOffset
        local tOffs = 0
        if (offs > 0) then 
            tOffs = 2*(vg and nivDB.prx or nivDB.pry)
            local t = _G['oUF_Raid1']
            t:ClearAllPoints()
            oUF_Party:ClearAllPoints()
            if vg then 
                t:SetPoint('TOPLEFT', prh, 'TOPLEFT') 
                oUF_Party:SetPoint('TOPLEFT', prh, 'TOPLEFT') 
            else 
                t:SetPoint('BOTTOMLEFT', prh, 'BOTTOMLEFT')
                oUF_Party:SetPoint('BOTTOMLEFT', prh, 'BOTTOMLEFT') 
            end
        else
            local t = _G['oUF_Raid1']
            t:ClearAllPoints()
            oUF_Party:ClearAllPoints()
            if vg then
                t:SetPoint('TOPRIGHT', prh, 'TOPRIGHT')
                oUF_Party:SetPoint('TOPRIGHT', prh, 'TOPRIGHT')
            else
                t:SetPoint('TOPLEFT', prh, 'TOPLEFT')
                oUF_Party:SetPoint('TOPLEFT', prh, 'TOPLEFT')
            end
        end

        for i = 2, nivDB.maxRaidGroups do
            local t = _G['oUF_Raid'..i]
            t:ClearAllPoints()
            if vg then
                t:SetPoint('TOPRIGHT', _G['oUF_Raid'..(i-1)], 'TOPLEFT', offs+tOffs, 0)
            else
                t:SetPoint('TOPLEFT', _G['oUF_Raid'..(i-1)], 'BOTTOMLEFT', 0, offs+tOffs)
            end
        end
    end

    oUF_player.Castbar:ClearAllPoints()
    oUF_target.Castbar:ClearAllPoints()
    oUF_player.Castbar:SetPoint("CENTER", UIParent, "CENTER", nivcfgDB.castbarX, nivcfgDB.castbarY)
    oUF_target.Castbar:SetPoint("CENTER", UIParent, "CENTER", nivcfgDB.castbarX, nivcfgDB.castbarY - 17)
end

local RefreshTextures = function()
    oUF_Nivaya:InitSMVars()

    for i,v in pairs(oUF.objects) do
        if (v.unit ~= nil) then
            if (v.Health) then
                v.Health:SetStatusBarTexture(nivDB.texStrHealth)
                v.Health.bg:SetTexture(nivDB.texStrHealth)
                v.Power:SetStatusBarTexture(nivDB.texStrMana)
                v.Power.bg:SetTexture(nivDB.texStrMana)
                if v.HealPrediction then
                    v.ohpb:SetStatusBarTexture(nivDB.texStrHealth)
                    v.mhpb:SetStatusBarTexture(nivDB.texStrHealth)
                end
            end
        end
    end

    oUF_player.Castbar:SetStatusBarTexture(nivDB.texStrHealth)
    oUF_player.Castbar.SafeZone:SetTexture(nivDB.texStrHealth)
    oUF_target.Castbar:SetStatusBarTexture(nivDB.texStrHealth)
    oUF_target.Castbar.SafeZone:SetTexture(nivDB.texStrHealth)

    if (oUF_player.DruidMana) then oUF_player.DruidMana:SetStatusBarTexture(nivDB.texStrMana) end

    if (oUF_player.Experience) then
        oUF_player.Experience:SetStatusBarTexture(nivDB.texStrHealth)
        oUF_player.Experience.bg:SetTexture(nivDB.texStrHealth)
    end

    if (oUF_player.Reputation) then
        oUF_player.Reputation:SetStatusBarTexture(nivDB.texStrHealth)
        oUF_player.Reputation.bg:SetTexture(nivDB.texStrHealth)
    end
end

local RefreshFonts = function()
    oUF_Nivaya:InitSMVars()

    for i,v in pairs(oUF.objects) do
        if (v.unit ~= nil) then
            if (v.Name) then v.Name:SetFont(nivDB.fontStrNames, nivcfgDB.fontHeightN) end
            if (v.Health) then v.Health.value:SetFont(nivDB.fontStrValues, nivcfgDB.fontHeightV) end 
            if (v.Power) then v.Power.value:SetFont(nivDB.fontStrValues, nivcfgDB.fontHeightV) end
        end
    end

    oUF_player.CombatFeedbackText:SetFont(nivDB.fontStrValues, 18)
    oUF_player.Castbar.Time:SetFont(nivDB.fontStrValues, nivcfgDB.fontHeightV+2)
    oUF_player.Castbar.Text:SetFont(nivDB.fontStrNames, nivcfgDB.fontHeightN+2)
    if (oUF_player.Experience) then oUF_player.Experience.Text:SetFont(nivDB.fontStrValues, nivcfgDB.fontHeightV) end
    if (oUF_player.Reputation) then oUF_player.Reputation.Text:SetFont(nivDB.fontStrValues, nivcfgDB.fontHeightV) end
    if (oUF_player.DruidManaText) then oUF_player.DruidManaText:SetFont(nivDB.fontStrValues, nivcfgDB.fontHeightV) end

    oUF_target.CombatFeedbackText:SetFont(nivDB.fontStrValues, 18)
    oUF_target.Castbar.Time:SetFont(nivDB.fontStrValues, nivcfgDB.fontHeightV)
    oUF_target.Castbar.Text:SetFont(nivDB.fontStrNames, nivcfgDB.fontHeightN)
end

local UpdatePRpos = function()
    if not prh then return end
    local tX, tY
    local offs = nivDB.healerMode and nivcfgDB.hmraidOffset or nivcfgDB.raidOffset
    if nivDB.vg then 
        if (offs > 0) then tX = prh:GetLeft() else tX = prh:GetRight() end
        tY = prh:GetTop()
    else
        tX = prh:GetLeft()
        if (offs > 0) then tY = prh:GetBottom() else tY = prh:GetTop() end
    end

    if nivDB.healerMode then
        nivcfgDB.hmpartyX = tX
        nivcfgDB.hmpartyY = tY
    else
        nivcfgDB.partyX = tX
        nivcfgDB.partyY = tY
    end
end

SetFrameMovable = function(frame, value)
    if (frame ~= nil) then 
        if (value) then
            frame:SetMovable(true)
            frame:RegisterForDrag("LeftButton");
            frame:SetScript('OnDragStart', function(self) 
                RefreshAnchoring(); 
                self:StartMoving() 
            end)
            frame:SetScript('OnDragStop', function(self) 
                self:StopMovingOrSizing() 
                nivcfgDB.playerX = oUF_player:GetLeft()
                nivcfgDB.playerY = oUF_player:GetBottom()
                UpdatePRpos()
                RefreshAnchoring()
            end)
        else
            frame:SetMovable(false)
            frame:RegisterForDrag();
            frame:SetScript('OnDragStart', nil)
            frame:SetScript('OnDragStop', nil)
        end
    end
end

local UpdatePTframes = function()
    oUF_player:SetHeight(nivcfgDB.ptHeight)
    oUF_player:SetWidth(nivcfgDB.ptWidth)
    oUF_player.Health:SetHeight(nivcfgDB.ptHealthHeight)
    oUF_player.Power:SetHeight(nivcfgDB.ptManaHeight)
    oUF_player.Spark:SetHeight(nivcfgDB.ptManaHeight * 2)
    oUF_player.Spark:SetWidth(nivcfgDB.ptManaHeight * 2)
    if IsAddOnLoaded('oUF_PowerSpark') then	oUF_PowerSpark_ReapplySettings(oUF_player) end

    oUF_target:SetHeight(nivcfgDB.ptHeight)
    oUF_target:SetWidth(nivcfgDB.ptWidth)
    oUF_target.Health:SetHeight(nivcfgDB.ptHealthHeight)
    oUF_target.Power:SetHeight(nivcfgDB.ptManaHeight)

    oUF_player.Debuffs:SetWidth(nivcfgDB.ptWidth)
    oUF_target.Buffs:SetWidth(nivcfgDB.ptWidth)
    oUF_target.Debuffs:SetWidth(nivcfgDB.ptWidth)

    oUF_Nivaya:UpdatePortrait(oUF_player, 'player')
    oUF_Nivaya:UpdatePortrait(oUF_target, 'target')	
end

local UpdateTFframes = function()
    oUF_tot:SetHeight(nivcfgDB.tfHeight)
    oUF_tot:SetWidth(nivcfgDB.tfWidth)
    oUF_tot.Health:SetHeight(nivcfgDB.tfHealthHeight)
    oUF_tot.Power:SetHeight(nivcfgDB.tfManaHeight)

    if oUF_ttt then
        oUF_ttt:SetHeight(nivcfgDB.tfHeight)
        oUF_ttt:SetWidth(nivcfgDB.tfWidth)
        oUF_ttt.Health:SetHeight(nivcfgDB.tfHealthHeight)
        oUF_ttt.Power:SetHeight(nivcfgDB.tfManaHeight)
    end

    oUF_focus:SetHeight(nivcfgDB.tfHeight)
    oUF_focus:SetWidth(nivcfgDB.tfWidth)
    oUF_focus.Health:SetHeight(nivcfgDB.tfHealthHeight)
    oUF_focus.Power:SetHeight(nivcfgDB.tfManaHeight)

    if oUF_ft then
        oUF_ft:SetHeight(nivcfgDB.tfHeight)
        oUF_ft:SetWidth(nivcfgDB.tfWidth)
        oUF_ft.Health:SetHeight(nivcfgDB.tfHealthHeight)
        oUF_ft.Power:SetHeight(nivcfgDB.tfManaHeight)
    end
end

local UpdatePetFrame = function()
    oUF_pet:SetHeight(nivcfgDB.petHeight)
    oUF_pet:SetWidth(nivcfgDB.petWidth)
    oUF_pet.Health:SetHeight(nivcfgDB.petHealthHeight)
    oUF_pet.Power:SetHeight(nivcfgDB.petManaHeight)
end

local ResizePRframes = function()
    for i = 1, nivDB.maxRaidGroups do 
        local t = _G['oUF_Raid'..i]
        if (t) then t:SetWidth(nivDB.prx) end
        for j=1,5 do
            local t = _G['oUF_Raid'..i..'UnitButton'..j]
            if (t) then
                t:SetWidth(nivDB.prx)
                t:SetHeight(nivDB.pry)
                t.Health:SetHeight(nivDB.pr_hp)
                t.Power:SetHeight(nivDB.pr_pw)
            end
        end
    end
    oUF_Nivaya:UpdatePrh()
end

local UpdateIconSize = function(type)
    for i,v in pairs(oUF.objects) do
        if (v.unit ~= nil) then
            if ((nivcfgDB.buffs[v.unit]) and (type == 'buff') and v.Buffs) then
                v.Buffs.size = nivcfgDB.buffSize
                local icons = v.Buffs
                for k, icon in ipairs(icons) do
                    icon:SetHeight(icons.size)
                    icon:SetWidth(icons.size)
                end
            end

            if ((nivcfgDB.debuffs[v.unit]) and (type == 'debuff') and v.Debuffs) then
                v.Debuffs.size = nivcfgDB.debuffSize
                local icons = v.Debuffs
                for k, icon in ipairs(icons) do
                    icon:SetHeight(icons.size)
                    icon:SetWidth(icons.size)
                end
            end
        end
    end
end

local UpdateAuras = function()
    oUF_Nivaya:UpdateAuraPos(oUF_player, 'player', "buff", false)
    oUF_Nivaya:UpdateAuraPos(oUF_player, 'player', "debuff", false)
    oUF_Nivaya:UpdateAuraPos(oUF_target, 'target', "buff", false)
    oUF_Nivaya:UpdateAuraPos(oUF_target, 'target', "debuff", false)
    oUF_Nivaya:UpdateAuraPos(oUF_pet, 'pet', "buff", false)
    oUF_Nivaya:UpdateAuraPos(oUF_pet, 'pet', "debuff", false)
    oUF_Nivaya:UpdateAuraPos(oUF_tot, 'targettarget', "buff", false)
    oUF_Nivaya:UpdateAuraPos(oUF_tot, 'targettarget', "debuff", false)
    oUF_Nivaya:UpdateAuraPos(oUF_focus, 'focus', "buff", false)
    oUF_Nivaya:UpdateAuraPos(oUF_focus, 'focus', "debuff", false)
end

local ToggleBlizzAuraFrame = function(invisible)
    if invisible then
        BuffFrame:Hide()
        TemporaryEnchantFrame:Hide()
    else
        BuffFrame:Show()
        TemporaryEnchantFrame:Show()
    end
end

local UpdateCBpos = function()
    oUF_tot.Castbar:ClearAllPoints()
    oUF_focus.Castbar:ClearAllPoints()
    if nivcfgDB.cbPosTF=="Bottom" then
        oUF_tot.Castbar:SetPoint("TOPLEFT", oUF_tot, "BOTTOMLEFT", 0, -1)
        oUF_tot.Castbar:SetPoint("TOPRIGHT", oUF_tot, "BOTTOMRIGHT", 0, -1)
        oUF_focus.Castbar:SetPoint("TOPLEFT", oUF_focus, "BOTTOMLEFT", 0, -1)
        oUF_focus.Castbar:SetPoint("TOPRIGHT", oUF_focus, "BOTTOMRIGHT", 0, -1)
    else
        oUF_tot.Castbar:SetPoint("BOTTOMLEFT", oUF_tot, "TOPLEFT", 0, 1)
        oUF_tot.Castbar:SetPoint("BOTTOMRIGHT", oUF_tot, "TOPRIGHT", 0, 1)
        oUF_focus.Castbar:SetPoint("BOTTOMLEFT", oUF_focus, "TOPLEFT", 0, 1)
        oUF_focus.Castbar:SetPoint("BOTTOMRIGHT", oUF_focus, "TOPRIGHT", 0, 1)
    end
end

local optGeneral = function(order)
    return {
        type = 'group', name = "General Settings", order = order, dialogHidden = true, dialogInline = true, 
        args = {
            desc1       = { type = 'description', order = 0, name = "The following changes take effect immediately.", },
            desc2       = { type = 'description', order = 1, name = "However, it is advised to /reloadui after repositioning party- or raidframes.", },

            unlocked    = { type = 'toggle', 
                            order = 2, 
                            name = "Unlocked", 
                            desc = "Unlock the player frame, party frame and raidframes to be movable. All other units can be repositioned from the 'Positions' tab. This option can also be toggled by using one of the chat commands '/ouf lock' or '/ouf unlock'.", 
                            get = function(info) return nivcfgDB.unlocked end, 
                            set = function(info, value)
                                nivcfgDB.unlocked = value
                                SetFrameMovable(oUF_player, value)
                                if prh then
                                    oUF_Nivaya:SetPRvisible(value)
                                    SetFrameMovable(prh, value)
                                end
                            end, },

            castBar     = { type = 'toggle', 
                            order = 4, 
                            width = 'full',
                            name = "Show Castbar (Player and Target)", 
                            desc = "Toggle Castbar display for player and target frames.", 
                            get = function(info) return nivcfgDB.castBar end, 
                            set = function(info, value)
                                nivcfgDB.castBar = value
                                oUF_player.Castbar:SetAlpha(value and 1 or 0)
                                oUF_target.Castbar:SetAlpha(value and 1 or 0)
                            end, },

            castBarTTF  = { type = 'toggle', 
                            order = 5, 
                            width = 'full',
                            name = "Show Castbar (ToT and Focus)", 
                            desc = "Toggle Castbar display for target of target and focus frames.", 
                            get = function(info) return nivcfgDB.castBarTTF end, 
                            set = function(info, value)
                                nivcfgDB.castBarTTF = value
                                oUF_tot.Castbar:SetAlpha(value and 1 or 0)
                                oUF_focus.Castbar:SetAlpha(value and 1 or 0)
                            end, },

            dbHlFilter  = { type = 'toggle', 
                            order = 7, 
                            width = 'full',
                            name = "Filter Debuff Highlighting", 
                            desc = "When this is active, debuff highlighting will only be active for debuffs you can cure.", 
                            get = function(info) return nivcfgDB.dbHighlightFilter end, 
                            set = function(info, value)
                                nivcfgDB.dbHighlightFilter = value
                                for i,v in pairs(oUF.objects) do
                                    if (v.unit ~= nil) then
                                        v.DebuffHighlightFilter = value
                                    end
                                end
                            end, },
            
            hideBlzAuras = { type = 'toggle', 
                            order = 8, 
                            width = 'full',
                            name = "Hide default Buff Frame", 
                            desc = "When this is active, Blizzards default buff frame will be hidden. When other addons also can do that, this setting is likely to be overwritten.", 
                            get = function(info) return nivcfgDB.hideBlizzAuras end, 
                            set = function(info, value)
                                nivcfgDB.hideBlizzAuras = value
                                ToggleBlizzAuraFrame(value)
                            end, },

            showPR      = { type = 'toggle', 
                            order = 9, 
                            width = 'full',
                            name = "Show Party/Raid (requires /reloadui)", 
                            desc = "Show or hide Party- and Raidframes. Disabling this allows you to use the default Blizzard frames or any other replacement addon.", 
                            get = function(info) return nivcfgDB.enablePR end, 
                            set = function(info, value)
                                nivcfgDB.enablePR = value
                            end, },

            showIcons   = { type = 'toggle', 
                            order = 10,
                            width = 'full',
                            name = "Show Status Icons", 
                            desc = "Show or hide the Resting Icon, PvP Icon and Leader Icon.", 
                            get = function(info) return nivcfgDB.showIcons end, 
                            set = function(info, value)
                                nivcfgDB.showIcons = value
                                oUF_player.Leader:SetAlpha(value and 1 or 0)
                                oUF_player.PvP:SetAlpha(value and 1 or 0)
                                oUF_player.Resting:SetAlpha(value and 1 or 0)
                            end, },

            desc3       = { type = 'description', order = 11, name = "The following changes require /reloadui to take effect.", },

            TTT         = { type = 'toggle', 
                            order = 12, 
                            width = 'full',
                            name = "Enable Target of Target of Target", 
                            get = function(info) return nivcfgDB.enableTTT end, 
                            set = function(info, value)
                                nivcfgDB.enableTTT = value
                            end, },

            FT          = { type = 'toggle', 
                            order = 13, 
                            width = 'full',
                            name = "Enable Focus Target", 
                            get = function(info) return nivcfgDB.enableFT end, 
                            set = function(info, value)
                                nivcfgDB.enableFT = value
                            end, },

            banzai      = { type = 'toggle', 
                            order = 14, 
                            width = 'full',
                            name = "Enable Aggro Coloring (Banzai)", 
                            desc = "When this is active, units who have aggro are colored red (Player, Party, Raid).", 
                            get = function(info) return nivcfgDB.enableBanzai end, 
                            set = function(info, value)
                                nivcfgDB.enableBanzai = value
                            end, },

            cpText      = { type = 'toggle', 
                            order = 15, 
                            width = 'full',
                            name = "Display ComboPoints as text value", 
                            desc = "When this is active, combo points will be displayed as text value instead of bubbles.", 
                            get = function(info) return nivcfgDB.cpText end, 
                            set = function(info, value)
                                nivcfgDB.cpText = value
                            end, },

            healpred    = { type = 'toggle', 
                            order = 16, 
                            width = 'full',
                            name = "Enable Heal Prediction", 
                            desc = "When this is active, incoming heals for all units will be displayed.", 
                            get = function(info) return nivcfgDB.enableHealPred end, 
                            set = function(info, value)
                                nivcfgDB.enableHealPred = value
                            end, },
        },
    }
end

local optFontsTextures = function(order)
    return {
        type = 'group', name = "Fonts & Textures", order = order, dialogHidden = true, dialogInline = true, 
        args = {
            desc1       = { type = 'description', order = 0, name = "In order to use most of the settings below, the AddOn |cFFFF0000SharedMedia|r is required. Otherwise you won't be able pick custom textures or fonts.", },
            header1     = { type = "header", order = 1, name = "Texture Options", },

            healthTex   = {
                            type = 'select',
                            dialogControl = 'LSM30_Statusbar',
                            order = 2,
                            name = 'Health Bar Texture',
                            disabled = not nivDB.SMactive,
                            values = AceGUIWidgetLSMlists.statusbar,
                            get = function() return nivcfgDB.texHealth end,
                            set = function(info, value)
                                nivcfgDB.texHealth = value
                                RefreshTextures()
                            end, },

            manaTex     = {
                            type = 'select',
                            dialogControl = 'LSM30_Statusbar',
                            order = 3,
                            name = 'Mana Bar Texture',
                            disabled = not nivDB.SMactive,
                            values = AceGUIWidgetLSMlists.statusbar,
                            get = function() return nivcfgDB.texMana end,
                            set = function(info, value)
                                nivcfgDB.texMana = value
                                RefreshTextures()
                            end, },

            healthCol   = {
                            type = 'color',
                            order = 4,
                            name = "Custom Bar Color",
                            hasAlpha = true,
                            get = function(info)
                                local t = nivcfgDB.colorHealth
                                return t.r, t.g, t.b, t.a
                            end,
                            set = function(info, r, g, b, a)
                                nivcfgDB.colorHealth.r, nivcfgDB.colorHealth.g, nivcfgDB.colorHealth.b, nivcfgDB.colorHealth.a = r, g, b, a

                                for i,v in pairs(oUF.objects) do
                                    if (v.unit ~= nil) then
                                        if (v.Health) then v.Health:SetStatusBarColor(r, g, b, a) end
                                    end
                                end

                                oUF_player.Castbar:SetStatusBarColor(r, g, b, a)
                                oUF_target.Castbar:SetStatusBarColor(r, g, b, a)
                                if (oUF_player.Experience) then oUF_player.Experience:SetStatusBarColor(r, g, b, a) end
                                if (oUF_player.Reputation) then oUF_player.Reputation:SetStatusBarColor(r, g, b, a) end
                            end, },

            bgCol       = {
                            type = 'color',
                            order = 5,
                            name = "Custom Background Color",
                            hasAlpha = true,
                            get = function(info)
                                local t = nivcfgDB.colorBg
                                return t.r, t.g, t.b, t.a
                            end,
                            set = function(info, r, g, b, a)
                                nivcfgDB.colorBg.r, nivcfgDB.colorBg.g, nivcfgDB.colorBg.b, nivcfgDB.colorBg.a = r, g, b, a

                                for i,v in pairs(oUF.objects) do
                                    if (v.unit ~= nil) then
                                        if (v.Health) then v.Health.bg:SetVertexColor(r, g, b, a) end
                                    end
                                end

                                oUF_player.Castbar.SafeZone:SetVertexColor(r, g, b, a)
                                oUF_target.Castbar.SafeZone:SetVertexColor(r, g, b, a)
                                if (oUF_player.Experience) then oUF_player.Experience.bg:SetVertexColor(r, g, b, a) end
                                if (oUF_player.Reputation) then oUF_player.Reputation.bg:SetVertexColor(r, g, b, a) end
                            end, },

            desc2       = { type = 'description', order = 6, name = "The following bar coloring options require reloading your UI if changed. Note that if you are using class colors for one type of bars, you usually might want to use reaction colors (by mobtype) for them too. This is because class information is not available for every NPC.", },

            ccHealth    = { type = 'toggle', 
                            order = 7, 
                            name = "Color health by class",
                            get = function(info) return nivcfgDB.colorClassHealth end, 
                            set = function(info, value)
                                nivcfgDB.colorClassHealth = value
                            end, },

            ccMana      = { type = 'toggle', 
                            order = 8, 
                            name = "Color mana by class",
                            get = function(info) return nivcfgDB.colorClassMana end, 
                            set = function(info, value)
                                nivcfgDB.colorClassMana = value
                            end, },

            crHealth    = { type = 'toggle', 
                            order = 9, 
                            name = "Color health by mobtype",
                            get = function(info) return nivcfgDB.colorReactHealth end, 
                            set = function(info, value)
                                nivcfgDB.colorReactHealth = value
                            end, },

            crMana      = { type = 'toggle',
                            order = 10, 
                            name = "Color mana by mobtype",
                            get = function(info) return nivcfgDB.colorReactMana end, 
                            set = function(info, value)
                                nivcfgDB.colorReactMana = value
                            end, },

            header2     = { type = "header", order = 11, name = "Font Options", },

            nameFont    = { type = 'select',
                            dialogControl = 'LSM30_Font',
                            order = 12,
                            name = 'Unit Name Font',
                            disabled = not nivDB.SMactive,
                            values = AceGUIWidgetLSMlists.font,
                            get = function() return nivcfgDB.fontNames end,
                            set = function(info, value)
                                nivcfgDB.fontNames = value
                                RefreshFonts()
                            end, },

            valueFont   = { type = 'select',
                            dialogControl = 'LSM30_Font',
                            order = 13,
                            name = 'Health / Mana Value Font',
                            disabled = not nivDB.SMactive,
                            values = AceGUIWidgetLSMlists.font,
                            get = function() return nivcfgDB.fontValues end,
                            set = function(info, value)
                                nivcfgDB.fontValues = value
                                RefreshFonts()
                            end, },

            fHeightN    = { type = 'range', 
                            order = 14, 
                            name = "Unit Name Font Size", 
                            min = 5, 
                            max = 18,
                            step = 1, 
                            get = function(info) return nivcfgDB.fontHeightN end, 
                            set = function(info, value)
                                nivcfgDB.fontHeightN = value
                                RefreshFonts()
                            end, },

            fHeightV    = { type = 'range', 
                            order = 15, 
                            name = "Health / Mana Value Size", 
                            min = 5, 
                            max = 18,
                            step = 1, 
                            get = function(info) return nivcfgDB.fontHeightV end, 
                            set = function(info, value)
                                nivcfgDB.fontHeightV = value
                                RefreshFonts()
                            end, },
        },
    }
end

local optPositions = function(order)
    return {
        type = 'group', name = "Positions and Anchoring", order = order, dialogHidden = true, dialogInline = true, 
        args = {
            desc1       = { type = 'description', order = 0, name = "Adjust the positions of most units and frames.", },

            header1     = { type = "header", order = 1, name = "Target Frame Settings",},

            targetSym   = { type = 'toggle', 
                            order = 2, 
                            name = "Symmetric", 
                            desc = "When this is enabled, the player and target frames are always kept to have horizontally symmetric positions in respect to the screen center.", 
                            get = function(info) return nivcfgDB.targetSym end, 
                            set = function(info, value)
                                nivcfgDB.targetSym = value
                                RefreshAnchoring()
                            end, },

            targetX     = { type = 'input',
                            order = 3,
                            name = "Target X-Offset",
                            desc = "Horizontal offset for Target frame. Only takes effect when symmetrical lineup is disabled.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.targetX) end,
                            set = function(info, value)
                                nivcfgDB.targetX = tonumber(value)
                                RefreshAnchoring()
                            end, },

            targetY     = { type = 'input',
                            order = 4,
                            name = "Target Y-Offset",
                            desc = "Vertical offset for Target frame. Only takes effect when symmetrical lineup is disabled.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.targetY) end,
                            set = function(info, value)
                                nivcfgDB.targetY = tonumber(value)
                                RefreshAnchoring()
                            end, },

            header2     = { type = "header", order = 5, name = "ToT, Focus and Pet",},

            totX        = { type = 'input',
                            order = 6,
                            name = "ToT X-Offset",
                            desc = "Horizontal offset for Target of Target frame.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.totX) end,
                            set = function(info, value)
                                nivcfgDB.totX = tonumber(value)
                                RefreshAnchoring()
                            end, },

            totY        = { type = 'input',
                            order = 7,
                            name = "ToT Y-Offset",
                            desc = "Vertical offset for Target of Target frame.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.totY) end,
                            set = function(info, value)
                                nivcfgDB.totY = tonumber(value)
                                RefreshAnchoring()
                            end, },

            focusX      = { type = 'input',
                            order = 8,
                            name = "Focus X-Offset",
                            desc = "Horizontal offset for Focus frame.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.focusX) end,
                            set = function(info, value)
                                nivcfgDB.focusX = tonumber(value)
                                RefreshAnchoring()
                            end, },

            focusY      = { type = 'input',
                            order = 9,
                            name = "Focus Y-Offset",
                            desc = "Vertical offset for Focus frame.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.focusY) end,
                            set = function(info, value)
                                nivcfgDB.focusY = tonumber(value)
                                RefreshAnchoring()
                            end, },

            petX        = { type = 'input',
                            order = 10,
                            name = "Pet X-Offset",
                            desc = "Horizontal offset for Pet frame.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.petX) end,
                            set = function(info, value)
                                nivcfgDB.petX = tonumber(value)
                                RefreshAnchoring()
                            end, },

            petY        = { type = 'input',
                            order = 11,
                            name = "Pet Y-Offset",
                            desc = "Vertical offset for Pet frame.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.petY) end,
                            set = function(info, value)
                                nivcfgDB.petY = tonumber(value)
                                RefreshAnchoring()
                            end, },

            header3     = { type = "header", order = 12, name = "ToToT and Focus Target",},

            tttX        = { type = 'input',
                            order = 13,
                            name = "TTT X-Offset",
                            desc = "Horizontal offset for Target of Target of Target frame.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.tttX) end,
                            set = function(info, value)
                                nivcfgDB.tttX = tonumber(value)
                                RefreshAnchoring()
                            end, },

            tttY        = { type = 'input',
                            order = 14,
                            name = "TTT Y-Offset",
                            desc = "Vertical offset for Target of Target of Target frame.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.tttY) end,
                            set = function(info, value)
                                nivcfgDB.tttY = tonumber(value)
                                RefreshAnchoring()
                            end, },

            ftX         = { type = 'input',
                            order = 15,
                            name = "FT X-Offset",
                            desc = "Horizontal offset for Focus Target frame.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.ftX) end,
                            set = function(info, value)
                                nivcfgDB.ftX = tonumber(value)
                                RefreshAnchoring()
                            end, },

            ftY         = { type = 'input',
                            order = 16,
                            name = "FT Y-Offset",
                            desc = "Vertical offset for Focus Target frame.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.ftY) end,
                            set = function(info, value)
                                nivcfgDB.ftY = tonumber(value)
                                RefreshAnchoring()
                            end, },

            header4     = { type = "header", order = 17, name = "Castbar Settings (Player and Target)", },

            castBarX    = { type = 'input',
                            order = 18,
                            name = "X-Offset",
                            desc = "Horizontal offset for the Castbars.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.castbarX) end,
                            set = function(info, value)
                                nivcfgDB.castbarX = tonumber(value)
                                RefreshAnchoring()
                            end, },

            castBarY    = { type = 'input',
                            order = 19,
                            name = "Y-Offset",
                            desc = "Vertical offset for the Castbars.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.castbarY) end,
                            set = function(info, value)
                                nivcfgDB.castbarY = tonumber(value)
                                RefreshAnchoring()
                            end, },

            castBarW    = { type = 'input',
                            order = 20,
                            name = "Castbar Width",
                            desc = "Width of the Castbars.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.castbarWidth) end,
                            set = function(info, value)
                                local t = tonumber(value)
                                nivcfgDB.castbarWidth = t
                                oUF_player.Castbar:SetWidth(t)
                                oUF_target.Castbar:SetWidth(t)
                                local sw = oUF_player.Swing
                                if sw then sw:SetWidth(t) end
                            end, },

            cbTextLen   = { type = 'input',
                            order = 21,
                            name = "Name Length",
                            desc = "Maximum number of letters for the spell name text.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.cbTextLen) end,
                            set = function(info, value)
                                local t = tonumber(value)
                                nivcfgDB.cbTextLen = t
                            end, },

            header5     = { type = "header", order = 22, name = "Castbar Settings (ToT and Focus)", },

            cbPosTF     = { type = 'select',
                            order = 23,
                            name = "Position",
                            desc = 'Position of the castbar (ToT and Focus).',
                            width = "half",
                            values = { ["Top"] = "Top", ["Bottom"] = "Bottom", },
                            get = function(info) return nivcfgDB.cbPosTF end,
                            set = function(info, value)	
                                nivcfgDB.cbPosTF = value 
                                UpdateCBpos()
                            end, },

            cbTextLenTF = { type = 'input',
                            order = 24,
                            name = "Name Length",
                            desc = "Maximum number of letters for the spell name text (ToT and Focus).",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.cbTextLenTF) end,
                            set = function(info, value)
                                local t = tonumber(value)
                                nivcfgDB.cbTextLenTF = t
                            end, },
            
            header6     = { type = "header", order = 25, name = "Class Specific", },

            desc1       = { type = 'description', order = 26, name = "Here you can change the position of class specific elements. This currently includes SoulShards, HolyPower, Rune bars and Totem bars.", },

            cdPos       = { type = 'select',
                            order = 27,
                            name = "Position",
                            values = { ["TopLeft"] = "Top (Left)", ["TopRight"] = "Top (Right)", ["BottomLeft"] = "Bottom (Left)", ["BottomRight"] = "Bottom (Right)", },
                            get = function(info) return nivcfgDB.cdPos end,
                            set = function(info, value)
                                nivcfgDB.cdPos = value 
                                oUF_Nivaya:UpdateClassDisplayPos()
                            end, },
        },
    }
end

local optSizePort = function(order)
    return {
        type = 'group', name = "Sizes & Portraits", order = order, dialogHidden = true, dialogInline = true, 
        args = {
            desc1       = { type = 'description', order = 0, name = "Change the size and appearance of the unit frames.", },

            header1     = { type = "header", order = 1, name = "Player & Target Settings", },

            frameWidth  = { type = 'input',
                            order = 2,
                            name = "Frame Width",
                            desc = "Overall width of the frame, including its background.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.ptWidth) end,
                            set = function(info, value)
                                nivcfgDB.ptWidth = tonumber(value)
                                UpdatePTframes()
                            end, },

            frameHeight = { type = 'input',
                            order = 3,
                            name = "Frame Height",
                            desc = "Overall height of the frame, including its background.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.ptHeight) end,
                            set = function(info, value)
                                nivcfgDB.ptHeight = tonumber(value)
                                UpdatePTframes()
                            end, },

            hpHeight    = { type = 'input',
                            order = 4,
                            name = "Health Height",
                            desc = "Height of the Health bar inside the frame.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.ptHealthHeight) end,
                            set = function(info, value)
                                nivcfgDB.ptHealthHeight = tonumber(value)
                                UpdatePTframes()
                            end, },

            manaHeight  = { type = 'input',
                            order = 5,
                            name = "Mana Height",
                            desc = "Height of the Mana bar inside the frame.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.ptManaHeight) end,
                            set = function(info, value)
                                nivcfgDB.ptManaHeight = tonumber(value)
                                UpdatePTframes()
                            end, },

            header2     = { type = "header", order = 6, name = "Portrait Settings", },

            optPortrait = { type = 'toggle', 
                            order = 7,
                            name = "Portrait Enabled",
                            get = function(info) return nivcfgDB.ptShowPortrait end,
                            set = function(info, value) 
                                nivcfgDB.ptShowPortrait = value
                                oUF_Nivaya:UpdatePortrait(oUF_player, 'player')
                                oUF_Nivaya:UpdatePortrait(oUF_target, 'target')
                            end, },

            optPortSym  = { type = 'toggle', 
                            order = 8,
                            name = "Symmetric",
                            desc = "When this is enabled, the portrait positions are set symmetrical, e.g. for the player frame it is at the left side, and for the target frame at the right side.",
                            get = function(info) return nivcfgDB.ptPortraitSym end,
                            set = function(info, value) 
                                nivcfgDB.ptPortraitSym = value
                                oUF_Nivaya:UpdatePortrait(oUF_player, 'player')
                                oUF_Nivaya:UpdatePortrait(oUF_target, 'target')
                            end, },

            portPos     = { type = 'select',
                            order = 9,
                            name = "Portrait Position",
                            values = { ["Left"] = "Left", ["Right"] = "Right", ["Top"] = "Top", ["Bottom"] = "Bottom", ["Middle"] = "Middle", },
                            get = function(info) return nivcfgDB.ptPortraitPos end,
                            set = function(info, value)
                                nivcfgDB.ptPortraitPos = value
                                oUF_Nivaya:UpdatePortrait(oUF_player, 'player')
                                oUF_Nivaya:UpdatePortrait(oUF_target, 'target')
                            end, },

            portWidth   = { type = 'input',
                            order = 10,
                            name = "Portrait Width",
                            width = 'half',
                            desc = 'Width of the Portrait. This only takes effect when its position is "Left" or "Right".',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.ptPortraitWidth) end,
                            set = function(info, value)
                                nivcfgDB.ptPortraitWidth = tonumber(value)
                                oUF_Nivaya:UpdatePortrait(oUF_player, 'player')
                                oUF_Nivaya:UpdatePortrait(oUF_target, 'target')
                            end, },

            portHeight  = { type = 'input',
                            order = 11,
                            name = "Portrait Height",
                            width = 'half',
                            desc = 'Height of the Portrait. This only takes effect when its position is "Top", "Middle" or "Bottom".',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.ptPortraitHeight) end,
                            set = function(info, value)
                                nivcfgDB.ptPortraitHeight = tonumber(value)
                                oUF_Nivaya:UpdatePortrait(oUF_player, 'player')
                                oUF_Nivaya:UpdatePortrait(oUF_target, 'target')
                            end, },

            header3     = { type = "header", order = 12, name = "ToT & Focus Settings", },

            totfocW     = { type = 'input',
                            order = 13,
                            name = "Frame Width",
                            desc = "Overall width of the frame, including its background.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.tfWidth) end,
                            set = function(info, value)
                                nivcfgDB.tfWidth = tonumber(value)
                                UpdateTFframes()
                            end, },

            totfocH     = { type = 'input',
                            order = 14,
                            name = "Frame Height",
                            desc = "Overall height of the frame, including its background.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.tfHeight) end,
                            set = function(info, value)
                                nivcfgDB.tfHeight = tonumber(value)
                                UpdateTFframes()
                            end, },

            totfochpH   = { type = 'input',
                            order = 15,
                            name = "Health Height",
                            desc = "Height of the Health bar inside the frame.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.tfHealthHeight) end,
                            set = function(info, value)
                                nivcfgDB.tfHealthHeight = tonumber(value)
                                UpdateTFframes()
                            end, },

            totfocmanaH = { type = 'input',
                            order = 16,
                            name = "Mana Height",
                            desc = "Height of the Mana bar inside the frame.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.tfManaHeight) end,
                            set = function(info, value)
                                nivcfgDB.tfManaHeight = tonumber(value)
                                UpdateTFframes()
                            end, },

            header4     = { type = "header", order = 17, name = "Pet Frame Settings", },

            petW        = { type = 'input',
                            order = 18,
                            name = "Frame Width",
                            desc = "Overall width of the frame, including its background.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.petWidth) end,
                            set = function(info, value)
                                nivcfgDB.petWidth = tonumber(value)
                                UpdatePetFrame()
                            end, },

            petH        = { type = 'input',
                            order = 19,
                            name = "Frame Height",
                            desc = "Overall height of the frame, including its background.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.petHeight) end,
                            set = function(info, value)
                                nivcfgDB.petHeight = tonumber(value)
                                UpdatePetFrame()
                            end, },

            pethpH      = { type = 'input',
                            order = 20,
                            name = "Health Height",
                            desc = "Height of the Health bar inside the frame.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.petHealthHeight) end,
                            set = function(info, value)
                                nivcfgDB.petHealthHeight = tonumber(value)
                                UpdatePetFrame()
                            end, },

            petmanaH    = { type = 'input',
                            order = 21,
                            name = "Mana Height",
                            desc = "Height of the Mana bar inside the frame.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.petManaHeight) end,
                            set = function(info, value)
                                nivcfgDB.petManaHeight = tonumber(value)
                                UpdatePetFrame()
                            end, },

            header5     = { type = "header", order = 22, name = "Miscellaneous", },

            hpOverflow  = { type = 'range', 
                            order = 23, 
                            name = "Maximum Heal Prediction Overflow", 
                            desc = "Defines the maximum heal prediction overflow to be shown. At 1.0 the heal prediction bar will never exceed your max health, at 2.0 it will be capped at twice the width of the health bar. Requires reloading the UI to take effect.",
                            width = "full",
                            min = 1.0, 
                            max = 2.0,
                            step = 0.05, 
                            get = function(info) return nivcfgDB.hpOverflow end, 
                            set = function(info, value)
                                nivcfgDB.hpOverflow = value
                            end, },
        },
    }
end

local optHealerMode = function(order)
    return {
        type = 'group', name = "Healer Mode Settings", order = order, dialogHidden = true, dialogInline = true, 
        args = {
            desc1       = { type = 'description', order = 0, name = "Changes to Healer Mode settings require /reloadui to take effect!", },

            optHM       = { type = 'toggle', order = 1, name = "Activate Healer Mode", desc = "Generally toggle Healer Mode on or off.", width = 'full', get = function(info) return nivcfgDB.healerMode end, set = function(info, value) nivcfgDB.healerMode = value end, },
            optAutoHM   = { type = 'toggle', order = 2, name = "Automatically toggle Healer Mode", desc = "Automatically toggle Healer Mode based on the conditions defined below. This overrides the manually set Healer Mode.", width = 'full', get = function(info) return nivcfgDB.autoHMtoggle end, set = function(info, value) nivcfgDB.autoHMtoggle = value end, },

            desc2       = { type = 'header', order = 3, name = "Class Conditions", },

            optDK       = { type = 'toggle', order = 4,     name = "Death Knight",  get = function(info) return nivcfgDB.hmDK end,      set = function(info, value) nivcfgDB.hmDK = value end, },
            optDRUID    = { type = 'toggle', order = 5,     name = "Druid",         get = function(info) return nivcfgDB.hmDRUID end,   set = function(info, value) nivcfgDB.hmDRUID = value end, },
            optHUNTER   = { type = 'toggle', order = 6,     name = "Hunter",        get = function(info) return nivcfgDB.hmHUNTER end,  set = function(info, value) nivcfgDB.hmHUNTER = value end, },
            optMAGE     = { type = 'toggle', order = 7,     name = "Mage",          get = function(info) return nivcfgDB.hmMAGE end,    set = function(info, value) nivcfgDB.hmMAGE = value end, },
            optPALA     = { type = 'toggle', order = 8,     name = "Paladin",       get = function(info) return nivcfgDB.hmPALA end,    set = function(info, value) nivcfgDB.hmPALA = value end, },
            optPRIEST   = { type = 'toggle', order = 9,     name = "Priest",        get = function(info) return nivcfgDB.hmPRIEST end,  set = function(info, value) nivcfgDB.hmPRIEST = value end, },
            optROGUE    = { type = 'toggle', order = 10,    name = "Rogue",         get = function(info) return nivcfgDB.hmROGUE end,   set = function(info, value) nivcfgDB.hmROGUE = value end, },
            optSHAM     = { type = 'toggle', order = 11,    name = "Shaman",        get = function(info) return nivcfgDB.hmSHAM end,    set = function(info, value) nivcfgDB.hmSHAM = value end, },
            optWL       = { type = 'toggle', order = 12,    name = "Warlock",       get = function(info) return nivcfgDB.hmWL end,      set = function(info, value) nivcfgDB.hmWL = value end, },
            optWARR     = { type = 'toggle', order = 13,    name = "Warrior",       get = function(info) return nivcfgDB.hmWARR end,    set = function(info, value) nivcfgDB.hmWARR = value end, },
        },
    }
end

local optRaidframes = function(order)
    return {
        type = 'group', name = "Raidframe Settings", order = order, dialogHidden = true, dialogInline = true, 
        args = {
            desc1       = { type = 'description', order = 0, name = "Here you can adjust the appearance of the party- and raidframes. Different settings are being stored for Healer Mode and Non Healer Mode, and you can change these settings only for the mode currently active.", },
            desc2       = { type = 'description', order = 1, name = "Healer Mode is currently ".. (nivDB.healerMode and "|cFF00FF00ACTIVE" or "|cFFFF0000INACTIVE") .."|r.", },

            frameWidth  = { type = 'input',
                            order = 2,
                            name = "Unit Width",
                            desc = "Overall width of each unit frame, including its background.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivDB.prx) end,
                            set = function(info, value)
                                local t = tonumber(value)
                                nivDB.prx = t
                                if nivDB.healerMode then nivcfgDB.prWidthHM = t else nivcfgDB.prWidth = t end
                                ResizePRframes()
                            end, },

            frameHeight = { type = 'input',
                            order = 3,
                            name = "Frame Height",
                            desc = "Overall height of each unit frame, including its background.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivDB.pry) end,
                            set = function(info, value)
                                local t = tonumber(value)
                                nivDB.pry = t
                                if nivDB.healerMode then nivcfgDB.prHeightHM = t else nivcfgDB.prHeight = t end
                                ResizePRframes()
                            end, },

            hpHeight    = { type = 'input',
                            order = 4,
                            name = "Health Height",
                            desc = "Height of the Health bar inside the frame.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivDB.pr_hp) end,
                            set = function(info, value)
                                local t = tonumber(value)
                                nivDB.pr_hp = t
                                if nivDB.healerMode then nivcfgDB.prHealthHeightHM = t else nivcfgDB.prHealthHeight = t end
                                ResizePRframes()
                            end, },

            manaHeight  = { type = 'input',
                            order = 5,
                            name = "Mana Height",
                            desc = "Height of the Mana bar inside the frame.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivDB.pr_pw) end,
                            set = function(info, value)
                                local t = tonumber(value)
                                nivDB.pr_pw = t
                                if nivDB.healerMode then nivcfgDB.prManaHeightHM = t else nivcfgDB.prManaHeight = t end
                                ResizePRframes()
                            end, },

            nameLen     = { type = 'input',
                            order = 6,
                            name = "Name Length",
                            desc = "Maximum number of letters for abbreviated names. This updates on every Raid Roster Update (players joining/leaving, switching groups, ..) and on /reloadui.",
                            width = 'half',
                            pattern = '%d',
                            get = function() return tostring(nivDB.pr_namelen) end,
                            set = function(info, value)
                                local t = tonumber(value)
                                nivDB.pr_namelen = t
                                if nivDB.healerMode then nivcfgDB.prNameLenHM = t else nivcfgDB.prNameLen = t end
                                ResizePRframes()
                            end, },

            desc3       = { type = 'description', order = 7, name = "Switching the alignment stye between vertical and horizontal requires reloading the UI.", },

            vertGroups  = { type = 'toggle', 
                            order = 8,
                            name = "Vertical Raidgroups",
                            width = "full",
                            get = function(info) 
                                if nivDB.healerMode then
                                    return nivcfgDB.hmverticalGroups 
                                else
                                    return nivcfgDB.verticalGroups 
                                end
                            end,
                            set = function(info, value) 
                                if nivDB.healerMode then
                                    nivcfgDB.hmverticalGroups = value
                                else
                                    nivcfgDB.verticalGroups = value
                                end
                            end, },

            raidX       = { type = 'input',
                            order = 9,
                            name = "Spacing between Raidgroups",
                            desc = "Spacing between raidgroups, positive values arranges them left-to-right (bottom-to-top) instead of right-to-left (top-to-bottom).",
                            pattern = '%d',
                            get = function() 
                                if nivDB.healerMode then 
                                    return tostring(nivcfgDB.hmraidOffset) 
                                else 
                                    return tostring(nivcfgDB.raidOffset) 
                                end 
                            end,
                            set = function(info, value)
                                if nivDB.healerMode then
                                    nivcfgDB.hmraidOffset = tonumber(value)
                                else
                                    nivcfgDB.raidOffset = tonumber(value)
                                end
                                UpdatePRpos()
                                RefreshAnchoring()
                                oUF_Nivaya:UpdatePrh()
                            end, },

            maxRGroups  = { type = 'range', 
                            order = 10, 
                            name = "Max raid groups", 
                            desc = "Maximum number of raid groups to be shown at any time. Requires reloading the UI to take effect.",
                            min = 1, 
                            max = 8,
                            step = 1, 
                            get = function(info) return nivcfgDB.maxRaidGroups end, 
                            set = function(info, value)
                                nivcfgDB.maxRaidGroups = value
                            end, },
                            },
    }
end

local optBuffDebuffUnit = function(order, unit)
    return {
        type = 'group', name = unit, order = order, inline = true,
        args = {
            buffToggle  = { type = 'toggle', order = 1, name = "Buffs", width = 'half', get = function(info) return nivcfgDB.buffs[unit].enabled end, set = function(info, value) nivcfgDB.buffs[unit].enabled = value; UpdateAuras() end, },
            dbuffToggle = { type = 'toggle', order = 2, name = "Debuffs", width = 'half', get = function(info) return nivcfgDB.debuffs[unit].enabled end, set = function(info, value) nivcfgDB.debuffs[unit].enabled = value; UpdateAuras() end, },

            buffPos     = { type = 'select',
                            order = 3,
                            name = "Buff Position",
                            values = { ["TopLeft"] = "Top (Left)", ["TopRight"] = "Top (Right)", ["BottomLeft"] = "Bottom (Left)", ["BottomRight"] = "Bottom (Right)", ["LeftTop"] = "Left (Top)", ["LeftBottom"] = "Left (Bottom)", ["RightTop"] = "Right (Top)", ["RightBottom"] = "Right (Bottom)", },
                            get = function(info) return nivcfgDB.buffs[unit].pos end,
                            set = function(info, value)	
                                nivcfgDB.buffs[unit].pos = value 
                                UpdateAuras()
                            end, },

            debuffPos   = { type = 'select',
                            order = 4,
                            name = "Debuff Position",
                            values = { ["TopLeft"] = "Top (Left)", ["TopRight"] = "Top (Right)", ["BottomLeft"] = "Bottom (Left)", ["BottomRight"] = "Bottom (Right)", ["LeftTop"] = "Left (Top)", ["LeftBottom"] = "Left (Bottom)", ["RightTop"] = "Right (Top)", ["RightBottom"] = "Right (Bottom)", },
                            get = function(info) return nivcfgDB.debuffs[unit].pos end,
                            set = function(info, value)	
                                nivcfgDB.debuffs[unit].pos = value 
                                UpdateAuras()
                            end, },

            combine     = { type = 'toggle', order = 5, name = "Combine", get = function(info) return nivcfgDB.debuffs[unit].combine end, set = function(info, value) nivcfgDB.debuffs[unit].combine = value; oUF_Nivaya:UpdateBuffCombine() end, disabled = (unit ~= 'target'), hidden = (unit ~= 'target'), desc = "This shows buffs and debuffs in the same position. Toggle between buffs and debuff by left-clicking on the unit frame. This option can only be activated for the target frame. It also requires identical positions for buffs and debuffs!"},
        },
    }
end

local optBuffDebuff = function(order)
    return {
        type = 'group', name = "Buff and Debuff Settings", order = order, dialogHidden = true, dialogInline = true, 
        args = {
            desc1       = { type = 'description', order = 0, name = "Here you can change buff and debuff settings. |cFFFF0000For the size and position options to fully take effect it is often required to update the buffs / debuffs. This is done by adding or removing a buff or debuff. Sometimes it is enough to switch your target.|r", },

            buffSize    = { type = 'input',
                            order = 1,
                            name = "Buff Size",
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.buffSize) end,
                            set = function(info, value)
                                local t = tonumber(value)
                                nivcfgDB.buffSize = t
                                UpdateIconSize('buff')
                            end, },

            debuffSize  = { type = 'input',
                            order = 2,
                            name = "Debuff Size",
                            pattern = '%d',
                            get = function() return tostring(nivcfgDB.debuffSize) end,
                            set = function(info, value)
                                local t = tonumber(value)
                                nivcfgDB.debuffSize = t
                                UpdateIconSize('debuff')
                            end, },

            dbOnlyYours	= { type = 'toggle', 
                            order = 3,
                            name = "Only show your own debuffs",
                            desc = "Disable this to see all debuffs on a target, enable to see only those debuffs cast by you. Requires /reloadui to take effect.",
                            width = "full",
                            get = function(info) 
                                return nivcfgDB.dbOnlyYours
                            end,
                            set = function(info, value) 
                                nivcfgDB.dbOnlyYours = value
                            end, },

            playerBD    = optBuffDebuffUnit(4, 'player'),
            targetBD    = optBuffDebuffUnit(5, 'target'),
            plpetBD     = optBuffDebuffUnit(6, 'pet'),
            totBD       = optBuffDebuffUnit(7, 'targettarget'),
            focusBD     = optBuffDebuffUnit(8, 'focus'),
        },
    }
end

local optUnitNames = function(order)
    return {
        type = 'group', name = "Unit Name Settings", order = order, dialogHidden = true, dialogInline = true, 
        args = {
            header1     = { type = "header", order = 0, name = "Show Name for..", },

            playerN     = { type = 'toggle', order = 1, name = "Player", width = "half", get = function(info) return nivcfgDB.names['player'].enabled end, set = function(info, value) nivcfgDB.names['player'].enabled = value; oUF_Nivaya:UpdateNamePos(oUF_player, 'player') end, },
            targetN     = { type = 'toggle', order = 2, name = "Target", width = "half", get = function(info) return nivcfgDB.names['target'].enabled end, set = function(info, value) nivcfgDB.names['target'].enabled = value; oUF_Nivaya:UpdateNamePos(oUF_target, 'target') end, },
            totN        = { type = 'toggle', order = 3, name = "ToT", width = "half", get = function(info) return nivcfgDB.names['targettarget'].enabled end, set = function(info, value) nivcfgDB.names['targettarget'].enabled = value; oUF_Nivaya:UpdateNamePos(oUF_tot, 'targettarget') end, },
            focusN      = { type = 'toggle', order = 4, name = "Focus", width = "half", get = function(info) return nivcfgDB.names['focus'].enabled end, set = function(info, value) nivcfgDB.names['focus'].enabled = value; oUF_Nivaya:UpdateNamePos(oUF_focus, 'focus') end, },
            tttN        = { type = 'toggle', order = 5, name = "TTT", desc = 'Target of Target of Target', width = "half", get = function(info) return nivcfgDB.names['targettargettarget'].enabled end, set = function(info, value) nivcfgDB.names['targettargettarget'].enabled = value; oUF_Nivaya:UpdateNamePos(oUF_ttt, 'targettargettarget') end, },
            ftN         = { type = 'toggle', order = 6, name = "FT", desc = 'Focus Target', width = "half", get = function(info) return nivcfgDB.names['focustarget'].enabled end, set = function(info, value) nivcfgDB.names['focustarget'].enabled = value; oUF_Nivaya:UpdateNamePos(oUF_ft, 'focustarget') end, },

            header2     = { type = "header", order = 7, name = "Name Positions", },

            playerPos   = { type = 'select',
                            order = 8,
                            name = "Player",
                            width = "half",
                            values = { ["Top"] = "Top", ["Bottom"] = "Bottom", },
                            get = function(info) return nivcfgDB.names['player'].pos end,
                            set = function(info, value)	
                                nivcfgDB.names['player'].pos = value
                                oUF_Nivaya:UpdateNamePos(oUF_player, 'player')
                            end, },

            targetPos   = { type = 'select',
                            order = 9,
                            name = "Target",
                            width = "half",
                            values = { ["Top"] = "Top", ["Bottom"] = "Bottom", },
                            get = function(info) return nivcfgDB.names['target'].pos end,
                            set = function(info, value)	
                                nivcfgDB.names['target'].pos = value 
                                oUF_Nivaya:UpdateNamePos(oUF_target, 'target')
                            end, },

            totPos      = { type = 'select',
                            order = 10,
                            name = "ToT",
                            width = "half",
                            values = { ["Top"] = "Top", ["Bottom"] = "Bottom", },
                            get = function(info) return nivcfgDB.names['targettarget'].pos end,
                            set = function(info, value)	
                                nivcfgDB.names['targettarget'].pos = value 
                                oUF_Nivaya:UpdateNamePos(oUF_tot, 'targettarget')
                            end, },

            focusPos    = { type = 'select',
                            order = 11,
                            name = "Focus",
                            width = "half",
                            values = { ["Top"] = "Top", ["Bottom"] = "Bottom", },
                            get = function(info) return nivcfgDB.names['focus'].pos end,
                            set = function(info, value)	
                                nivcfgDB.names['focus'].pos = value 
                                oUF_Nivaya:UpdateNamePos(oUF_focus, 'focus')
                            end, },

            tttPos      = { type = 'select',
                            order = 12,
                            name = "TTT",
                            desc = 'Target of Target of Target',
                            width = "half",
                            values = { ["Top"] = "Top", ["Bottom"] = "Bottom", },
                            get = function(info) return nivcfgDB.names['targettargettarget'].pos end,
                            set = function(info, value)	
                                nivcfgDB.names['targettargettarget'].pos = value 
                                oUF_Nivaya:UpdateNamePos(oUF_ttt, 'targettargettarget')
                            end, },

            ftPos       = { type = 'select',
                            order = 13,
                            name = "FT",
                            desc = 'Focus Target',
                            width = "half",
                            values = { ["Top"] = "Top", ["Bottom"] = "Bottom", },
                            get = function(info) return nivcfgDB.names['focustarget'].pos end,
                            set = function(info, value)	
                                nivcfgDB.names['focustarget'].pos = value 
                                oUF_Nivaya:UpdateNamePos(oUF_ft, 'focustarget')
                            end, },
        },
    }
end

local options = {
    type = 'group', name = "oUF Nivaya",
    args = {
        desc1           = { type = 'description', order = 0, name = "Customize this oUF layout.", },

        rlui            = { type = 'execute', order = 1, name = "Reload UI", desc = "Reloads the UI.",  func = function() ReloadUI() end, },
        defaults        = { type = 'execute', order = 2, name = "Restore Defaults", desc = "Restores default settings and reloads the UI.", func = function() nivcfgDB = {}; oUF_Nivaya:LoadDefaults(); ReloadUI() end, },
        GeneralSettings = optGeneral(3),
        FontsTextures   = optFontsTextures(4),
        Positions       = optPositions(5),
        SizePort        = optSizePort(6),
        BuffDebuff      = optBuffDebuff(7),
        UnitNames       = optUnitNames(8),
        Raidframes      = optRaidframes(9),
        HealerMode      = optHealerMode(10),
    },
}

LibStub('AceConfig-3.0'):RegisterOptionsTable('oUF_Nivaya', options)
local ACD = LibStub('AceConfigDialog-3.0')
ACD:AddToBlizOptions('oUF_Nivaya', 'oUF Nivaya')
ACD:AddToBlizOptions('oUF_Nivaya', 'General Settings',  'oUF Nivaya', 'GeneralSettings')
ACD:AddToBlizOptions('oUF_Nivaya', 'Fonts & Textures',  'oUF Nivaya', 'FontsTextures')
ACD:AddToBlizOptions('oUF_Nivaya', 'Positions',         'oUF Nivaya', 'Positions')
ACD:AddToBlizOptions('oUF_Nivaya', 'Sizes & Portraits', 'oUF Nivaya', 'SizePort')
ACD:AddToBlizOptions('oUF_Nivaya', 'Buffs & Debuffs',   'oUF Nivaya', 'BuffDebuff')
ACD:AddToBlizOptions('oUF_Nivaya', 'Unit Names',        'oUF Nivaya', 'UnitNames')
ACD:AddToBlizOptions('oUF_Nivaya', 'Raidframes',        'oUF Nivaya', 'Raidframes')
ACD:AddToBlizOptions('oUF_Nivaya', 'Healer Mode',       'oUF Nivaya', 'HealerMode')