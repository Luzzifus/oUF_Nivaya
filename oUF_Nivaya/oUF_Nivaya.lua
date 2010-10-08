-----------------------------------------------------------------------------------------------
-- oUF_Nivaya
-----------------------------------------------------------------------------------------------
-- Based on oUF_Pazrael.
-- Based on oUF by Haste.
-----------------------------------------------------------------------------------------------

-- ALL OPTIONS THAT USED TO BE HERE ARE NOW TO BE CHANGED INGAME VIA "/ouf".
-- ALSO, IF YOU DON'T WANT TO CHANGE ANYTHING INGAME, YOU CAN CHANGE THE DEFAULTS 
-- AT THE TOP OF "init_and_config.lua".

-- Hide Mouseover-Background of Chatframes:
-- (that has nothing to do with oUF, however I didn't want to make a new addon for this single line)
DEFAULT_CHATFRAME_ALPHA = 0

local classification = {
	["worldboss"] = "%s",
	["rareelite"] = "%s+ Rar",
	["elite"] = " %s+",
	["rare"] = " %s Rar",
	["normal"] = "%s",
	["trivial"] = "%s",
}

-- debuff highlight definitions
local CanDispel = {
	PRIEST = { Magic = true, Disease = true, },
	SHAMAN = { Poison = true, Disease = true, Curse = true, },
	PALADIN = { Magic = true, Poison = true, Disease = true, },
	MAGE = { Curse = true, },
	DRUID = { Curse = true, Poison = true, }
}
local playerClass = select(2, UnitClass("player"))
local dispellist = CanDispel[playerClass] or {}

-- banzai definitions
banzaiIgnoredUnits = {
    target = true,
    targettarget = true,
    targettargettarget = true,
    focus = true,
}

------------------------------------

local function updateColor(self, element, unit, func)
	local color, r, g, b
	local _, class = UnitClass(unit)
	if(UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) or not UnitIsConnected(unit)) then
		color = self.colors.tapped
	elseif(UnitIsPlayer(unit)) then
		color = self.colors.class[class]
	else
		if(UnitIsFriend(unit, "player") or UnitLevel(unit) < 0) then
			color = self.colors.reaction[UnitReaction(unit, 'player')]
		else
			color = GetQuestDifficultyColor(UnitLevel(unit))
			element[func](element, color.r, color.g, color.b)
			return self
		end
	end
	if(color) then
		element[func](element, color[1], color[2], color[3])
	end
end

local menu = function(self)
	if(self.unit:sub(1, -2) == "party" or self.unit:sub(1, -2) == "partypet") then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
	elseif(_G[self.unit:gsub("(.)", string.upper, 1).."FrameDropDown"]) then
		ToggleDropDownMenu(1, nil, _G[self.unit:gsub("(.)", string.upper, 1).."FrameDropDown"], "cursor", 0, 0)
	end
end

local setFontString = function(parent, fontName, fontHeight)
	local fs = parent:CreateFontString(nil, "ARTWORK")
	fs:SetFont(fontName, fontHeight)
	fs:SetShadowColor(0,0,0)
	fs:SetShadowOffset(0.8, -0.8)
	fs:SetTextColor(1,1,1)
	fs:SetJustifyH("LEFT")
	return fs
end

local function OverrideUpdateName(self, event, unit)
	local unitInRaid = self:GetParent():GetName():match"oUF_Raid" 
	local unitInParty = self:GetParent():GetName():match"oUF_Party"
	local unitIsPartyPet = unit and unit:find('partypet%d')
	if unitInRaid or unitInParty or unitIsPartyPet then self.Name:Show() end
	if(self.unit == unit) then
		local name = UnitName(unit)
		local lvl = UnitLevel(unit)
		if lvl < 0 then lvl = "??" end
		if UnitIsDead(unit) or UnitIsGhost(unit) or not UnitIsConnected(unit) then
			if unitInRaid or unitInParty or (unit=="player" and not UnitIsUnit(unit, "player")) then
				self.Name:Show()
				if (not nivDB.healerMode) then self.Name:Hide() end
			end	
		end
		if (unit=="pet") then
			self.Name:SetText('')
		elseif (unit=="target") or (unit=="player") then
			name = oUF_Nivaya:ShortName(name, 25, true)
			updateColor(self, self.Name, unit, 'SetTextColor')
			if unitInRaid or unitInParty or unitIsPartyPet then
				name = oUF_Nivaya:ShortName(name, nivDB.pr_namelen)
				self.Name:SetText(name)
			else
				self.Name:SetText(format(classification[UnitClassification(unit)], lvl) .. ' ' .. '|cffFFFFFF' .. name .. '|r') 
			end
		else
			if unitInRaid or unitInParty or unitIsPartyPet then
				self.Name:Show()
				updateColor(self, self.Name, unit, 'SetTextColor')
				name = oUF_Nivaya:ShortName(name, nivDB.pr_namelen)
				if UnitIsDead(unit) or UnitIsGhost(unit) or not UnitIsConnected(unit) then
					self.Name:Show()
					if (not nivDB.healerMode) then self.Name:Hide() end
				end
			end
			name = oUF_Nivaya:ShortName(name, 25, true)
			self.Name:SetText(name)
		end
	end
end

local number = function(n)
	if n >= 1e7 then
		return ('%.1fm'):format(n / 1e6):gsub('%.?0([km])$', '%1')
	elseif n >= 1e6 then
		return ('%.2fm'):format(n / 1e6):gsub('%.?0+([km])$', '%1')
	elseif n >= 1e5 then
		return ('%.0fk'):format(n / 1e3)
	elseif (n >= 1e3) or (n <= -1e3) then
		return ('%.1fk'):format(n / 1e3):gsub('%.?0([km])$', '%1')
	else
		return n
	end
end

local function GetDebuffType(unit, filter)
    if not UnitCanAssist("player", unit) then return nil end
    for i = 1, 40 do
		local _,_,_,_,dType = UnitAura(unit, i, "HARMFUL")
		if dType and not filter or (filter and dispellist[dType]) then return dType end
	end
    return nil
end

local function UpdateDebuffHighlight(obj, event, unit)
    if obj.unit ~= unit then return nil end
	local dType = GetDebuffType(unit, obj.DebuffHighlightFilter)
	if dType then
		local c = DebuffTypeColor[dType] 
		obj.DebuffHighlight:SetVertexColor(c.r, c.g, c.b, 1)
	else
		obj.DebuffHighlight:SetVertexColor(0, 0, 0, 0)
    end
end

oUF_Nivaya.banzai:RegisterCallback(function(aggro, name, ...)
	for i = 1, select("#", ...) do
		local u = select(i, ...)
		local f = oUF.units[u]
		if f and not banzaiIgnoredUnits[u] and not f.ignoreBanzai then
			if aggro == 1 then
				f.Health:SetStatusBarColor(1, 0, 0)
			else
				f:UNIT_MAXHEALTH("OnBanzaiUpdate", f.unit)
			end
		end
	end
end)

local function PostUpdateHealth(bar, unit, min, max)
    local slf = bar:GetParent()

	if(UnitIsDead(unit)) then
		bar:SetValue(0)
		bar.value:SetText("dead")
	elseif(UnitIsGhost(unit)) then
		bar:SetValue(0)
		bar.value:SetText("dead")
	elseif(not UnitIsConnected(unit)) then
		bar.value:SetText("off")
	else
		if(unit=="player") then
			if (slf:GetName():match"oUF_Raid") or (slf:GetName():match"oUF_Party") or (unit and unit:find('partypet%d')) then
				if nivDB.healerMode then
					if(min~=max) then
						bar.value:SetFormattedText("|cffff8080%s|r", number(min-max))
					else
						bar.value:SetText(number(max))
					end				
				else
					bar.value:SetText()
				end
			else
				if(min~=max) then
					bar.value:SetFormattedText("|cffff8080%s|r |cff0090ff/|r %d%%", number(min-max), floor(min/max*100))
				else
					bar.value:SetText(number(max))
				end
			end
		elseif(unit=="focus" or unit=="focustarget" or unit=="targettarget") then
			if(max==100) then
				if(min~=max) then
					bar.value:SetText(floor(min/max*100).."%")
				else
					bar.value:SetText()
				end
			elseif(min~=max) then
				bar.value:SetFormattedText("%s (%d%%)", number(min), floor(min/max*100))
			else
				bar.value:SetFormattedText("%s", number(max))
			end
		elseif(unit=="pet") then
			if(min~=max) then
				bar.value:SetText(number(min))
			else
				bar.value:SetText(number(max))
			end
		elseif (slf:GetName():sub(1,9)=="oUF_Party") or (slf:GetName():sub(1,8)=="oUF_Raid") or (unit and unit:find('partypet%d')) then
			if nivDB.healerMode then
				if(min~=max) then
					bar.value:SetFormattedText("|cffff8080%s|r", number(min-max))
				else
					bar.value:SetText(number(max))
				end				
			else
				bar.value:SetText()
			end
		else
			if(min~=max) then			
				bar.value:SetFormattedText("%s (%d%%)", number(min), floor(min/max*100))
			else
				bar.value:SetFormattedText("%s", number(min))
			end
		end
	end
    
	if((UnitIsTapped(unit) and not(UnitIsTappedByPlayer(unit))) or not(UnitIsConnected(unit))) then 
		bar:SetStatusBarColor(0.6, 0.6, 0.6)
	else
		if not (nivDB.ccH or nivDB.crH) then
			bar:SetStatusBarColor(nivcfgDB.colorHealth.r, nivcfgDB.colorHealth.g, nivcfgDB.colorHealth.b, nivcfgDB.colorHealth.a)
		end
		bar.bg:SetVertexColor(nivcfgDB.colorBg.r, nivcfgDB.colorBg.g, nivcfgDB.colorBg.b, nivcfgDB.colorBg.a)
	end
    
	slf.UNIT_NAME_UPDATE(slf, event, unit)

    -- banzai
    if not banzaiIgnoredUnits[unit] and not slf.ignoreBanzai and oUF_Nivaya.banzai:GetUnitAggroByUnitId(unit) then
		bar:SetStatusBarColor(1, 0, 0)
	end

end

local LFDRoleUpdate = function(self, event)
	local lfdrole = self.LFDRole
	local isTank, isHealer = UnitGroupRolesAssigned(self.unit)

	if(isTank) then
		lfdrole:SetTexCoord(0, 19/64, 22/64, 41/64)
		lfdrole:Show()
	elseif(isHealer) then
		lfdrole:SetTexCoord(20/64, 39/64, 1/64, 20/64)
		lfdrole:Show()
	else
		lfdrole:Hide()
	end
end

local function DruidManaOnUpdate(self, event, unit)
	if (self ~= oUF_player) then return end
	local _,class = UnitClass('player')
	if (class ~= "DRUID") then return end

	local p = UnitPowerType('player')
	local min,max = UnitPower('player', SPELL_POWER_MANA), UnitPowerMax('player', SPELL_POWER_MANA)
	
	if (min ~= max) then
		self.DruidManaText:SetFormattedText("|cff8080ff%s|r", number(min))
		self.Power.value:SetPoint("LEFT", self.Health, "LEFT", 2, 5)
	else
		self.DruidManaText:SetText()
	end

	self.DruidMana:SetMinMaxValues(0, max)
	self.DruidMana:SetValue(min)
    
	self.DruidMana:SetAlpha((p ~= 0) and 1 or 0)
	self.DruidManaText:SetAlpha((p ~= 0) and 1 or 0)

	if (p==0) then
		self.Power.value:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
	end
end

local function PostUpdatePower(bar, unit, min, max)
    local slf = bar:GetParent()
    
	if (not bar.value) then return end
	if (not UnitIsPlayer(unit)) then
		bar.value:SetText()
	else
		if (min==0) then
			bar.value:SetText()
		elseif (not UnitIsConnected(unit)) or UnitIsDead(unit) or UnitIsGhost(unit) then
			bar.value:SetText()			
		elseif (unit=="player") or (unit=="target") then
			bar.value:SetFormattedText("|cff8080ff%s|r", number(min))
		end
	end
	slf.UNIT_NAME_UPDATE(slf, event, unit)
end

local function PostCreateAuraIcon(self, button)
    button.cd:SetReverse(true)
	button.cd.noOCC = true

	button.icon:SetTexCoord(.07, .93, .07, .93)
	button.icon:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -1)
	button.icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)

	button.overlay:SetTexture("Interface\\Addons\\oUF_Nivaya\\textures\\buttonTex")
	button.overlay:SetTexCoord(0,1,0,1)
	button.overlay.Hide = function(self) self:SetVertexColor(0.4, 0.4, 0.4) end
end

local function RepOverrideText(self, event, unit, bar, min, max, value, name, id)
	self.Reputation.Text:SetFormattedText('Rep: %d / '..number(max - min)..' (%.1f%%)', value - min, (value - min)/(max - min)*100)
end

local function ExpOverrideText(self, event, unit, bar, min, max)
	self.Experience.Text:SetFormattedText('Exp: '..number(min)..' / '..number(max)..' (%.1f%%)', min/max*100)
end

local HidePortrait = function(self, unit)
	if (self.unit == 'target') then
		if (not UnitExists(self.unit) or not UnitIsConnected(self.unit) or not UnitIsVisible(self.unit)) then
			self.Portrait:SetAlpha(0)
		else
			self.Portrait:SetAlpha(1)
			self.Portrait:SetAlpha(1) -- this line appearing twice is intended, so don't change it.
		end
	end
end

local function PostCastStart(self, unit, name)
	if (unit=="player") or (unit=="target") then
		self.Text:SetText(oUF_Nivaya:ShortName(name, nivcfgDB.cbTextLen, true))
	elseif (unit=="targettarget") or (unit=="focus") then
		self.Text:SetText(oUF_Nivaya:ShortName(name, nivcfgDB.cbTextLenTF, true))
	end
end

local function styleFunc(self, unit)
	local _, class = UnitClass('player')

	local unitInRaid = self:GetParent():GetName():match"oUF_Raid" 
	local unitInParty = self:GetParent():GetName():match"oUF_Party"
	local unitIsPartyPet = unit and unit:find('partypet%d')

	self.menu = menu
	self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
	self:RegisterForClicks("anyup")
	self:SetAttribute("*type2", "menu")
	self:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background", insets ={left = -1, right = -1, top = -1, bottom = -1}})				-- backdrop for frame using settings
	self:SetBackdropColor(nivDB.colorBD.r, nivDB.colorBD.g, nivDB.colorBD.b, nivDB.colorBD.a)
	
    self.Health = CreateFrame("StatusBar", nil, self)
	self.Health:SetHeight(22)
	self.Health:SetStatusBarTexture(nivDB.texStrHealth)
    self.Health:GetStatusBarTexture():SetHorizTile(false)
	self.Health:SetFrameLevel(2)
	self.Health:SetPoint("TOPLEFT")
	self.Health:SetPoint("TOPRIGHT") 

	self.Health.bg = self.Health:CreateTexture(nil, "BORDER")
	self.Health.bg:SetAllPoints(self.Health)
	self.Health.bg:SetBlendMode("ADD")
	self.Health.bg:SetVertexColor(nivcfgDB.colorBg.r, nivcfgDB.colorBg.g, nivcfgDB.colorBg.b, nivcfgDB.colorBg.a)
	self.Health.bg:SetTexture(nivDB.texStrHealth)
	
	self.Highlight = self:CreateTexture(nil, 'HIGHLIGHT')
	self.Highlight:SetAllPoints(self.Health)
	self.Highlight:SetBlendMode('ADD')
	self.Highlight:SetTexture('Interface\\AddOns\\oUF_Nivaya\\textures\\mouseoverHighlight')
	
	self.Power = CreateFrame("StatusBar", nil, self)
	self.Power:SetHeight(unit and 5 or 2)
	self.Power:SetStatusBarTexture(nivDB.texStrMana)
    self.Power:GetStatusBarTexture():SetHorizTile(false)
	self.Power:SetPoint("LEFT")
	self.Power:SetPoint("RIGHT")
	self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, -1)
	
	self.Power.bg = self.Power:CreateTexture(nil, "BORDER")
	self.Power.bg:SetAllPoints(self.Power)
	self.Power.bg:SetTexture(nivDB.texStrMana)
	self.Power.bg:SetAlpha(0.3)
	
	self.Health.frequentUpdates = true
	self.Power.frequentUpdates = true
	
	if(IsAddOnLoaded('oUF_Smooth')) then
	  self.Health.Smooth = true
      self.Power.Smooth = true
    end
	
	self.Power.colorTapping = true
	
	self.Health.colorClass = nivDB.ccH and true or false
	self.Health.colorReaction = nivDB.crH and true or false
	if not (unit=="pet") then
	  	self.Power.colorDisconnected = true
		self.Power.colorClass = nivDB.ccM and true or false
		self.Power.colorReaction = nivDB.crM and true or false
		self.Power.colorPower = (not (nivDB.ccM or nivDB.crM)) and true or false
	end
    
    self.HealCommBar = CreateFrame('StatusBar', nil, self.Health)
	self.HealCommBar:SetHeight(0)
	self.HealCommBar:SetWidth(0)
	self.HealCommBar:SetStatusBarTexture(self.Health:GetStatusBarTexture():GetTexture())
    self.HealCommBar:GetStatusBarTexture():SetHorizTile(false)
	self.HealCommBar:SetStatusBarColor(0, 1, 0, 0.25)
	self.HealCommBar:SetPoint('LEFT', self.Health, 'LEFT')
	self.allowHealCommOverflow = true
	
	self.DebuffHighlight = self.Health:CreateTexture(nil, "OVERLAY")
	self.DebuffHighlight:SetAllPoints(self.Health)
	self.DebuffHighlight:SetBlendMode("ADD")
	self.DebuffHighlight:SetVertexColor(0, 0, 0, 0)
	self.DebuffHighlightFilter = nivcfgDB.dbHighlightFilter
	self.DebuffHighlight:SetTexture('Interface\\AddOns\\oUF_Nivaya\\textures\\debuffHighlight')
    if CanDispel[class] then self:RegisterEvent("UNIT_AURA", UpdateDebuffHighlight) end

	self.ignoreHealComm = false
	self.ignoreBanzai = true

	self.Health.value = setFontString(self.Health, nivDB.fontStrValues, nivcfgDB.fontHeightV)
	self.Health.value:SetPoint("RIGHT", -2, 0)
	self.Power.value = setFontString(self.Power, nivDB.fontStrValues, nivcfgDB.fontHeightV)
	self.Power.value:Hide()

	self.Name = setFontString(self.Health, nivDB.fontStrNames, nivcfgDB.fontHeightN)
    self.Range = nil
    
    if unitInParty then
        self.LFDRole = self:CreateTexture(nil, 'OVERLAY')
        self.LFDRole:SetSize(13, 13)
        self.LFDRole:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 2, 2)
        self.LFDRole:SetAlpha(nivcfgDB.showIcons and 1 or 0)
        self.LFDRole.Update = LFDRoleUpdate
    end
    
	if unitInRaid or unitInParty or unitIsPartyPet then
        self.Range = {
            insideAlpha = 1,
            outsideAlpha = .4,
        }
		self.ignoreBanzai = not nivcfgDB.enableBanzai

		if nivDB.healerMode then
			self.Name:SetPoint("TOP", self.Health, "TOP", 0, -1)
			self.Health.value:ClearAllPoints()
			self.Health.value:SetPoint("BOTTOM", self.Health, "BOTTOM", 0, 2)
		else
			self.Name:SetPoint("CENTER", self.Health, "CENTER", 0, 0)
			self.Health.value:ClearAllPoints()
			self.Health.value:SetPoint("RIGHT", -2, 0)
		end
        
   		self.RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
		self.RaidIcon:SetHeight(11)
		self.RaidIcon:SetWidth(11)
		self.RaidIcon:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 3, -8)
		self.RaidIcon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
        
	elseif (unit=="pet") then
	    self.Name:Hide()
	else
		oUF_Nivaya:UpdateNamePos(self, unit)
	end
	
    if not (unit=="player") and not (unitInRaid or unitInParty or unitIsPartyPet) then
		self.RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
		self.RaidIcon:SetHeight(13)
		self.RaidIcon:SetWidth(13)
		self.RaidIcon:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', -1, 2)
		self.RaidIcon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
	end

	if unit then
		self.Buffs = CreateFrame("Frame", nil, self)
        self.Buffs.PostCreateIcon = PostCreateAuraIcon
		self.Buffs.spacing = 1
		self.Buffs:SetHeight(nivcfgDB.buffSize)
		self.Buffs.filter = false
		self.Buffs.size = nivcfgDB.buffSize
		self.Buffs.num = 30	
		oUF_Nivaya:UpdateAuraPos(self, unit, "buff", true)
		
		self.Debuffs = CreateFrame("Frame", nil, self)
        self.Debuffs.PostCreateIcon = PostCreateAuraIcon
		self.Debuffs.spacing = 1
		self.Debuffs:SetHeight(nivcfgDB.debuffSize)
		if (unit == "player") then 
			self.Debuffs.filter = false
		else
			self.Debuffs.filter = "HARMFUL|PLAYER"
		end
		self.Debuffs.showDebuffType = true
		self.Debuffs.size = nivcfgDB.debuffSize
		self.Debuffs.num = 8
		oUF_Nivaya:UpdateAuraPos(self, unit, "debuff", true)
	end

	if(unit=="player") then			
		self.Power.value:Show()
		self.Power.value:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
		
		self.Spark = self.Power:CreateTexture(nil, "OVERLAY")
		self.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
		self.Spark:SetBlendMode("ADD")
		self.Spark:SetHeight(nivcfgDB.ptManaHeight * 2)
		self.Spark:SetWidth(nivcfgDB.ptManaHeight * 2)
		self.Spark.manatick = true
		self.Spark.highAlpha = 1
		self.Spark.highAlpha = 0.65
		self.ignoreBanzai = not nivcfgDB.enableBanzai

		if(IsAddOnLoaded('oUF_GCD')) then
			self.GCD = CreateFrame('Frame', nil, self.Health)
	    	self.GCD:SetPoint('BOTTOMLEFT', self.Health, 'BOTTOMLEFT')
	    	self.GCD:SetPoint('BOTTOMRIGHT', self.Health, 'BOTTOMRIGHT')
	    	self.GCD:SetHeight(3)

	    	self.GCD.Spark = self.GCD:CreateTexture(nil, "OVERLAY")
	    	self.GCD.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	    	self.GCD.Spark:SetBlendMode("ADD")
	    	self.GCD.Spark:SetHeight(10)
	    	self.GCD.Spark:SetWidth(10)
	    	self.GCD.Spark:SetPoint('BOTTOMLEFT', self.Health, 'BOTTOMLEFT', -5, -5)
	    end
		
		if(class == "DRUID") then
			self.DruidMana = CreateFrame('StatusBar', nil, self)
			self.DruidMana:SetPoint("BOTTOMRIGHT", self.Power, "TOPRIGHT")
			self.DruidMana:SetPoint("BOTTOMLEFT", self.Power, "TOPLEFT")
			self.DruidMana:SetStatusBarTexture(nivDB.texStrMana)
            self.DruidMana:GetStatusBarTexture():SetHorizTile(false)
			self.DruidMana:SetStatusBarColor(0.3, 0.3, 1)
			self.DruidMana:SetHeight(4)
			self.DruidMana:SetScript("OnUpdate", function() DruidManaOnUpdate(self) end)
			self.DruidManaText = setFontString(self.DruidMana, nivDB.fontStrValues, nivcfgDB.fontHeightV)
			self.DruidManaText:SetPoint("LEFT", self.Health, "LEFT", 2, -4)
		end
		
		if(class == "DEATHKNIGHT") then
			RuneFrame:SetParent(self)
			RuneFrame:SetScale(0.75)
			RuneFrame:SetPoint("TOPLEFT", self, "BOTTOMRIGHT", 4 - RuneFrame:GetWidth(), 3)
			
			if IsAddOnLoaded('oUF_RuneBar') then
				local rcol = { {0.77, 0.12, 0.23}, {0.77, 0.12, 0.23}, {0.4, 0.8, 0.1}, {0.4, 0.8, 0.1}, {0, 0.4, 0.7}, {0, 0.4, 0.7},}
				self.RuneBar = {}
				for i = 1, 6 do
					local t = CreateFrame('StatusBar', nil, self)
					if(i == 1) then
						t:SetPoint("BOTTOMLEFT", self.Power, "BOTTOMLEFT", 1, 1)
					else
						t:SetPoint('TOPLEFT', self.RuneBar[i-1], 'TOPRIGHT', 1, 0)
					end
					t:SetStatusBarTexture("Interface\\AddOns\\oUF_Nivaya\\textures\\Minimalist")
					t:SetStatusBarColor(unpack(rcol[i]))
					t:SetHeight(2)
					t:SetWidth(nivcfgDB.ptWidth / 6 - ((i < 6) and 1 or 2) )
					t:SetBackdrop({bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=], insets = {top = -1, left = -1, bottom = -1, right = -1},})
					t:SetBackdropColor(0, 0, 0)
					t:SetMinMaxValues(0, 1)
                    t:SetFrameLevel(3)
                    
                    self.RuneBar[i] = t
				end
			end
		end
		
		if (class == "SHAMAN") and IsAddOnLoaded("oUF_TotemBar") then
			self.TotemBar = {}
			for i = 1, 4 do
				local t = CreateFrame("StatusBar", nil, self)
				if (i == 1) then
					t:SetPoint("BOTTOMLEFT", self.Power, "BOTTOMLEFT", 1, 1)
				else
					t:SetPoint("TOPLEFT", self.TotemBar[i-1], "TOPRIGHT", 1, 0)
				end
				t:SetStatusBarTexture("Interface\\AddOns\\oUF_Nivaya\\textures\\Minimalist")
				t:SetHeight(2)
				t:SetWidth(nivcfgDB.ptWidth / 4 - ((i < 4) and 1 or 2) )
				t:SetBackdrop({bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=], insets = {top = -1, left = -1, bottom = -1, right = -1},})
				t:SetBackdropColor(0, 0, 0)
				t:SetMinMaxValues(0, 1)
                t:SetFrameLevel(3)

				t.bg = t:CreateTexture(nil, "BORDER")
				t.bg:SetAllPoints(t)
				t.bg:SetTexture("Interface\\AddOns\\oUF_Nivaya\\textures\\Minimalist")
				t.bg.multiplier = 0.5
                
                self.TotemBar[i] = t
			end
		end
		
		self.Leader = self:CreateTexture(nil, 'OVERLAY')
		self.Leader:SetHeight(15)
		self.Leader:SetWidth(15)
		self.Leader:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 14.5, 0)
		self.Leader:SetTexture('Interface\\GroupFrame\\UI-Group-LeaderIcon')

		self.PvP = self:CreateTexture(nil, "OVERLAY")
		self.PvP:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 28, -7)
		self.PvP:SetHeight(22)
		self.PvP:SetWidth(22)
		
		self.RestingIcon = self.Power:CreateTexture(nil, 'OVERLAY')
		self.RestingIcon:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 2)
		self.RestingIcon:SetHeight(11)
		self.RestingIcon:SetWidth(11)
		self.RestingIcon:SetTexture('Interface\\CharacterFrame\\UI-StateIcon')
		self.RestingIcon:SetTexCoord(0.09, 0.43, 0.08, 0.42)
		self.Resting = self.RestingIcon 

		self.Leader:SetAlpha(nivcfgDB.showIcons and 1 or 0)
		self.PvP:SetAlpha(nivcfgDB.showIcons and 1 or 0)
		self.Resting:SetAlpha((nivcfgDB.showIcons and nivDB.playerLevel < 80) and 1 or 0)
        
        self.CombatIcon = self.Health:CreateTexture(nil, 'OVERLAY')
		self.CombatIcon:SetPoint('CENTER', self.Health, 'CENTER', 0, 0)
		self.CombatIcon:SetHeight(11)
		self.CombatIcon:SetWidth(11)
		self.CombatIcon:SetTexture('Interface\\CharacterFrame\\UI-StateIcon')
		self.CombatIcon:SetTexCoord(0.58, 0.90, 0.08, 0.41)
		self.Combat = self.CombatIcon
		
		if(IsAddOnLoaded('oUF_Experience')) then
			self.Experience = CreateFrame('StatusBar', nil, self)
			self.Experience:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 0, 15)
			self.Experience:SetPoint('TOPRIGHT', self.Health, 'TOPRIGHT', 0, 23)
			self.Experience:SetStatusBarTexture(nivDB.texStrHealth)
            self.Experience:GetStatusBarTexture():SetHorizTile(false)
			self.Experience:SetStatusBarColor(nivcfgDB.colorHealth.r, nivcfgDB.colorHealth.g, nivcfgDB.colorHealth.b, nivcfgDB.colorHealth.a)
			self.Experience.MouseOver = true
			self.Experience.Tooltip = false
			self.Experience:SetBackdrop({bgFile = 'Interface\\Tooltips\\UI-Tooltip-Background', insets = {top = -1, left = -1, bottom = -1, right = -1}})
			self.Experience:SetBackdropColor(nivDB.colorBD.r, nivDB.colorBD.g, nivDB.colorBD.b, nivDB.colorBD.a)
			self.Experience.Text = setFontString(self.Experience, nivDB.fontStrValues, nivcfgDB.fontHeightV)
			self.Experience.Text:SetPoint('CENTER', self.Experience, 0, 9)

			self.Experience.bg = self.Experience:CreateTexture(nil, 'BORDER')
			self.Experience.bg:SetAllPoints(self.Experience)
			self.Experience.bg:SetTexture(nivDB.texStrHealth)
			self.Experience.bg:SetVertexColor(nivcfgDB.colorBg.r, nivcfgDB.colorBg.g, nivcfgDB.colorBg.b, nivcfgDB.colorBg.a)
			
			self.Experience.PostUpdate = ExpOverrideText
		end
		
		if(IsAddOnLoaded('oUF_Reputation')) then
			self.Reputation = CreateFrame('StatusBar', nil, self)
			self.Reputation:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 0, 23)
			self.Reputation:SetPoint('TOPRIGHT', self.Health, 'TOPRIGHT', 0, 31)
			self.Reputation:SetStatusBarTexture(nivDB.texStrHealth)
            self.Reputation:GetStatusBarTexture():SetHorizTile(false)
			self.Reputation:SetStatusBarColor(nivcfgDB.colorHealth.r, nivcfgDB.colorHealth.g, nivcfgDB.colorHealth.b, nivcfgDB.colorHealth.a)
			self.Reputation.MouseOver = true
			self.Reputation.Tooltip = false
			self.Reputation:SetBackdrop({bgFile = 'Interface\\Tooltips\\UI-Tooltip-Background', insets = {top = -1, left = -1, bottom = -1, right = -1}})
			self.Reputation:SetBackdropColor(nivDB.colorBD.r, nivDB.colorBD.g, nivDB.colorBD.b, nivDB.colorBD.a)
			self.Reputation.Text = setFontString(self.Reputation, nivDB.fontStrValues, nivcfgDB.fontHeightV)
			self.Reputation.Text:SetPoint('CENTER', self.Reputation, 0, 9)

			self.Reputation.bg = self.Reputation:CreateTexture(nil, 'BORDER')
			self.Reputation.bg:SetAllPoints(self.Reputation)
			self.Reputation.bg:SetTexture(nivDB.texStrHealth)
			self.Reputation.bg:SetVertexColor(nivcfgDB.colorBg.r, nivcfgDB.colorBg.g, nivcfgDB.colorBg.b, nivcfgDB.colorBg.a)
			
			self.Reputation.PostUpdate = RepOverrideText
		end
		
	elseif(unit == 'target') then
		self.Power.value:Show()
		self.Power.value:SetPoint("LEFT", self.Health, "LEFT", 2, 0)

		if(class == "ROGUE" or class == "DRUID") then
            if (nivcfgDB.cpText) then
                local CPointsT = setFontString(self, nivDB.fontStrNames, nivcfgDB.fontHeightN + 3)
                CPointsT:SetPoint('RIGHT', self, 'LEFT', -10, 0)
                CPointsT:SetJustifyH('RIGHT')
                self:Tag(CPointsT, '|cffffffff[cpoints]|r')
            else 
                local CPoints = {}
                for i = 1, MAX_COMBO_POINTS do
                    local cp = self:CreateTexture(nil, 'ARTWORK')
                    cp:SetSize(12, 10)
                    
                    local g = 1
                    if (i == 4) then g = .6 elseif (i == 5) then g = 0 end
                    cp:SetVertexColor(1, g, 0)

                    cp:SetPoint('BOTTOMRIGHT', self, 'BOTTOMLEFT', -4, (i - 1) * 8 - 2)
                    CPoints[i] = cp
                end
                self.CPoints = CPoints
            end
        end
			
	elseif(unit=='pet')then
		self.ignoreBanzai = not nivcfgDB.enableBanzai
		if(class == 'HUNTER') then
			self.Power.colorHappiness = true
			self.UNIT_HAPPINESS = self.UNIT_MANA
		else
			self.Power:SetStatusBarColor(nivcfgDB.colorBg.r, nivcfgDB.colorBg.g, nivcfgDB.colorBg.b, nivcfgDB.colorBg.a)
		end
	end

	if (unit=="player" or unit=="target" or unit=="targettarget" or unit=="focus") then
		self.Castbar = CreateFrame("StatusBar")
		self.Castbar:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background", insets ={left = -1, right = -1, top = -1, bottom = -1}})
		self.Castbar:SetBackdropColor(nivDB.colorBD.r, nivDB.colorBD.g, nivDB.colorBD.b, nivDB.colorBD.a)
		self.Castbar:SetWidth(nivcfgDB.castbarWidth)
		if (unit=="player") then
			self.Castbar:SetHeight(20)
			self.Castbar:SetPoint("CENTER", UIParent, "CENTER", nivcfgDB.castbarX, nivcfgDB.castbarY)
		elseif (unit=="targettarget") then
			self.Castbar:SetHeight(10)
            self.Castbar:SetWidth(nivcfgDB.tfWidth)
			if nivcfgDB.cbPosTF=="Bottom" then
				self.Castbar:SetPoint("TOPLEFT", oUF_tot, "BOTTOMLEFT", 0, -1)
			else
				self.Castbar:SetPoint("BOTTOMLEFT", oUF_tot, "TOPLEFT", 0, 1)
			end
		elseif (unit=="focus") then
			self.Castbar:SetHeight(10)
            self.Castbar:SetWidth(nivcfgDB.tfWidth)
			if nivcfgDB.cbPosTF=="Bottom" then
				self.Castbar:SetPoint("TOPLEFT", oUF_focus, "BOTTOMLEFT", 0, -1)
			else
				self.Castbar:SetPoint("BOTTOMLEFT", oUF_focus, "TOPLEFT", 0, 1)
			end
		else
			self.Castbar:SetHeight(10)
			self.Castbar:SetPoint("CENTER", UIParent, "CENTER", nivcfgDB.castbarX, nivcfgDB.castbarY - 17)
		end
		self.Castbar:SetStatusBarTexture(nivDB.texStrHealth)
        self.Castbar:GetStatusBarTexture():SetHorizTile(false)
		self.Castbar:SetStatusBarColor(nivcfgDB.colorHealth.r, nivcfgDB.colorHealth.g, nivcfgDB.colorHealth.b, nivcfgDB.colorHealth.a)	
		self.Castbar:SetParent(self)
		self.Castbar:SetMinMaxValues(1, 100)
		self.Castbar:SetValue(1)
		self.Castbar:Hide()  
		self.Castbar.bg = self.Castbar:CreateTexture(nil, "BORDER")
		self.Castbar.bg:SetAllPoints(self.Castbar)
		self.Castbar.bg:SetTexture("Interface\\AddOns\\oUF_Nivaya\\textures\\Minimalist")
		self.Castbar.bg:SetAlpha(0.05)	
		self.Castbar.Time = self.Castbar:CreateFontString(nil, "OVERLAY")
		self.Castbar.Time:SetPoint("RIGHT", self.Castbar, -2, 0)
		self.Castbar.Time:SetFont(nivDB.fontStrValues, nivcfgDB.fontHeightV)
		self.Castbar.Time:SetTextColor(1, 1, 1)
		self.Castbar.Time:SetJustifyH("RIGHT")
		self.Castbar.Text = self.Castbar:CreateFontString(nil, "OVERLAY")
		self.Castbar.Text:SetPoint("LEFT", self.Castbar, 2, 0)
		self.Castbar.Text:SetWidth(240)
		self.Castbar.Text:SetFont(nivDB.fontStrNames, nivcfgDB.fontHeightN)
		self.Castbar.Text:SetTextColor(1, 1, 1)
		self.Castbar.Text:SetJustifyH("LEFT")
		
		if (unit=="player") then
			self.Castbar.Time:SetTextHeight(nivcfgDB.fontHeightV+2)
			self.Castbar.Text:SetTextHeight(nivcfgDB.fontHeightN+2)
		else
			self.Castbar.Time:SetTextHeight(nivcfgDB.fontHeightV)
			self.Castbar.Text:SetTextHeight(nivcfgDB.fontHeightN)	
		end

		self.Castbar.SafeZone = self.Castbar:CreateTexture(nil,"BORDER")
		self.Castbar.SafeZone:SetTexture(nivDB.texStrHealth)
		self.Castbar.SafeZone:SetVertexColor(1,1,1,0.7)
		self.Castbar.SafeZone:SetPoint("TOPRIGHT")
		self.Castbar.SafeZone:SetPoint("BOTTOMRIGHT")

		if (unit=='player' or unit=='target') and (nivcfgDB.castBar) then
			self.Castbar:SetAlpha(1)
		elseif (unit=='targettarget' or unit=='focus') and (nivcfgDB.castBarTTF) then
			self.Castbar:SetAlpha(1)
		else
			self.Castbar:SetAlpha(0)
		end
        self.Castbar.PostCastStart = PostCastStart        
	end
	
	if(unit=='player' or unit=='target') then
		self.Portrait = CreateFrame('PlayerModel', nil, self)
		self.Portrait:SetFrameLevel(1)
		table.insert(self.__elements, HidePortrait)		
		oUF_Nivaya:UpdatePortrait(self, unit)
		
		self.CombatFeedbackText = setFontString(self.Health, nivDB.fontStrValues, 18, 'OUTLINE')
		self.CombatFeedbackText:SetPoint('CENTER', self.Health, 'CENTER', 0, 0)
		self:SetAttribute('initial-height', nivcfgDB.ptHeight)
		self:SetAttribute('initial-width', nivcfgDB.ptWidth)
		self.Health:SetHeight(nivcfgDB.ptHealthHeight)
		self.Power:SetHeight(nivcfgDB.ptManaHeight)
	elseif(unit == 'pet') then
		self:SetAttribute('initial-height', nivcfgDB.petHeight)
		self:SetAttribute('initial-width', nivcfgDB.petWidth)
		self.Health:SetHeight(nivcfgDB.petHealthHeight)
		self.Power:SetHeight(nivcfgDB.petManaHeight)
	elseif (unitInRaid or unitInParty or unitIsPartyPet) then
		self:SetAttribute('initial-height', nivDB.pry)
		self:SetAttribute('initial-width', nivDB.prx)
		self.Health:SetHeight(nivDB.pr_hp)
		self.Power:SetHeight(nivDB.pr_pw)
	else
		self:SetAttribute('initial-height', nivcfgDB.tfHeight)
		self:SetAttribute('initial-width', nivcfgDB.tfWidth)
		self.Health:SetHeight(nivcfgDB.tfHealthHeight)
		self.Power:SetHeight(nivcfgDB.tfManaHeight)
	end
	self.UNIT_NAME_UPDATE = OverrideUpdateName
    self.Health.PostUpdate = PostUpdateHealth
	self.Power.PostUpdate = PostUpdatePower
    return self
end

oUF:RegisterStyle('Nivaya', styleFunc)
oUF:SetActiveStyle('Nivaya')