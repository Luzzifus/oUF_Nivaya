oUF_Nivaya = CreateFrame('Frame', 'oUF_Nivaya', UIParent)
oUF_Nivaya:SetScript('OnEvent', function(self, event, ...) self[event](self, event, ...) end)
oUF_Nivaya:RegisterEvent("ADDON_LOADED")
local sm = LibStub("LibSharedMedia-3.0")
oUF_Nivaya.banzai = LibStub("LibBanzai-2.0")

-- Here you may change all the default values for configurable settings.
-- However you should use the ingame configuration to do this on-the-fly by typing "/ouf".

-- These are only default values. That means they only take effect on the first load of the addon or
-- once after you reset its saved variables!

local defaults = {
	unlocked = false,
	castBar = true, 			-- Toggle castbar display
	castBarTTF = true,
	
    enableBanzai = true,        -- Toggle aggro coloring
    enableHealPred = true,      -- Toggle heal prediction
    hpOverflow = 1.5,           -- maximum overflow of heal prediction
    
	dbHighlightFilter = true,	-- Toggle filtering of debuff highlighting, 
								-- true means you only see highlighting for debuffs you can cure
	playerX = 380,
	playerY = 123,				-- position of player frame, everything else will be arranged to this

	enablePR = true,
	verticalGroups = true,
	hmverticalGroups = false,
    maxRaidGroups = 8,          -- maximum number of raidgroups to be shown
	
	enableTTT = false,			-- Target of Target of Target
	enableFT = false,			-- Focus Target

	partyX = 909.5,
	partyY = 118,				-- position of party- and raidframes

	hmpartyX = 410,
	hmpartyY = 450,				-- position of party- and raidframes for Healer Mode
	
	raidOffset = -3,			-- X-Offset between raidgroups
	hmraidOffset = -3,
	
	targetSym = true,			-- Settings for Target frame positions
	targetX = 30,
	targetY = 0,
	
	totX = 2,
	totY = -8,					-- Offsets for Target of Target, Focus and Pet frames
	focusX = -2,
	focusY = -8,
	petX = 0,
	petY = -2,
	
	tttX = 2,
	tttY = 0,
	ftX = -2,
	ftY = 0,
	
	castbarX = 0,				-- Offsets for the Castbars
	castbarY = -205,
	castbarWidth = 302,			-- Castbar Width

	healerMode = false,			-- Different Party-/Raidframes position and appearance meant for healers,
								-- this makes the frames a bit bigger and they contain more information.
								
	autoHMtoggle = true,		-- Automatically activate HealerMode based on character class or name.
								-- This being "true" overwrites the manually set "healerMode".
								-- The exact behaviour depends on class settings.
    hmDK = false,
    hmDRUID = false,
    hmHUNTER = false,
    hmMAGE = false,
    hmPALA = false,
    hmPRIEST = false,
    hmROGUE = false,
    hmSHAM = false,
    hmWL = false,
    hmWARR = false,
    
    texHealth = 'Healbot',		-- Texture Settings for Health- and Manabars
    texMana = 'Healbot',
    
    							-- Font Settings for Unit Names and Health/Mana Values
    fontValues = 'Friz Quadrata TT',
    fontNames = 'Friz Quadrata TT',
    fontHeightV = 8,
    fontHeightN = 8,
    
    colorHealth = {r = 0.35, g = 0.35, b = 0.45, a = 1},
    colorBg = {r = 1, g = 1, b = 1, a = 0.75},
    
    ptWidth = 140,				-- Size Variables for Player and Target frames
    ptHeight = 28,
    ptHealthHeight = 22,
    ptManaHeight = 5,
    
    ptShowPortrait = false,		-- Portrait Settings
    ptPortraitHeight = 10,
    ptPortraitWidth = 28,
    ptPortraitPos = 'Left',
    ptPortraitSym = true,
    
    tfWidth = 100,				-- Size Variables for Target of Target and Focus frames
    tfHeight = 21,
    tfHealthHeight = 16,
    tfManaHeight = 3.5,    

    petWidth = 50,				-- Size Variables for the Pet frame
    petHeight = 11,
    petHealthHeight = 9,
    petManaHeight = 1,

	prWidth = 23,				-- Raidframe Sizes for normal Mode
	prHeight = 19,
	prHealthHeight = 14,
	prManaHeight = 3.5,
	prNameLen = 4,

	prWidthHM = 33,				-- Raidframe Sizes for Healer Mode
	prHeightHM = 28,
	prHealthHeightHM = 23,
	prManaHeightHM = 3.5,
	prNameLenHM = 5,
	
	buffSize = 14,				-- Buff/Debuff icon sizes
	debuffSize = 14,
    
    hideBlizzAuras = false,     -- hide default buff frame
    
    cpText = false,             -- show ComboPoints as text instead of bubbles
    
    cdPos = "TopRight",         -- position of class specific display (SoulShards, HolyPower)
	
	buffs = {	['player'] 				= { enabled = false, pos = "LeftBottom", },
				['target']				= { enabled = true,  pos = "TopLeft", },
				['pet']					= { enabled = false, pos = "TopRight", },
				['targettarget'] 		= { enabled = false, pos = "TopRight", },
				['focus'] 				= { enabled = false, pos = "TopRight", }, },

	debuffs = {	['player'] 				= { enabled = true,  pos = "TopRight", combine = false, },
				['target']				= { enabled = true,  pos = "TopLeft", combine = true,  },
				['pet']					= { enabled = false, pos = "BottomRight", combine = false, },
				['targettarget'] 		= { enabled = false, pos = "BottomRight", combine = false, },
				['focus'] 				= { enabled = false, pos = "BottomRight", combine = false, }, },

	names = {	['player'] 				= { enabled = true, pos = "Bottom", },
				['target']				= { enabled = true, pos = "Bottom", },
				['targettarget'] 		= { enabled = true, pos = "Top", },
				['targettargettarget'] 	= { enabled = true, pos = "Top", },
				['focus'] 				= { enabled = true, pos = "Top", },
				['focustarget']			= { enabled = true, pos = "Top", }, },
	
	showIcons = true,			-- Toggle status icons
	
	cbTextLen = 30,				-- Castbar settings
	cbTextLenTF = 10,
	cbPosTF = "Bottom",
	
	colorClassHealth = false,
	colorClassMana = true,
	colorReactHealth = false,
	colorReactMana = true,
}

nivDB = {
	-- Party-/Raidframes size variables and other stuff based on healerMode --
	prx = 23,
	pry = 19,
	pr_hp = 14,
	pr_pw = 3.5,
	pr_namelen = 4,

	colorBD = {r = 0, g = 0, b = 0, a = 1},

	-- Don't ever touch the following values! --
	healerMode = false,
	texStrHealth = '',
	texStrMana = '',
	fontStrNames = '',
	fontStrValues = '',
	SMactive = false,
}

function oUF_Nivaya:LoadDefaults()
	nivcfgDB = nivcfgDB or {}
	for k,v in pairs(defaults) do
		if(type(nivcfgDB[k]) == 'nil') then
			nivcfgDB[k] = v
		end
	end
end

function oUF_Nivaya:InitSMVars()
	nivDB.SMactive = IsAddOnLoaded('SharedMedia')
	if (nivDB.SMactive) then
		nivDB.texStrHealth = sm:Fetch('statusbar', nivcfgDB.texHealth)
		nivDB.texStrMana = sm:Fetch('statusbar', nivcfgDB.texMana)
		nivDB.fontStrNames = sm:Fetch('font', nivcfgDB.fontNames)
		nivDB.fontStrValues = sm:Fetch('font', nivcfgDB.fontValues)		
	else
		nivDB.texStrHealth = "Interface\\AddOns\\oUF_Nivaya\\textures\\Healbot"
		nivDB.texStrMana = "Interface\\AddOns\\oUF_Nivaya\\textures\\Healbot"
		nivDB.fontStrNames = "Fonts\\FRIZQT__.TTF"
		nivDB.fontStrValues = "Fonts\\FRIZQT__.TTF"
	end
end

function oUF_Nivaya:SetPRvisible(value)
	prh:SetFrameStrata(value and "HIGH" or "LOW")
	prh:EnableMouse(value)
	prh.texture:SetAlpha(value and 0.7 or 0)
	prh.text:SetAlpha(value and 1 or 0)
end

function oUF_Nivaya:UpdatePrh()
	if not prh then return end
	local tXs, tYs = oUF_Raid1:GetLeft(), oUF_Raid1:GetTop()
	prh:ClearAllPoints()
	local offs = nivDB.healerMode and nivcfgDB.hmraidOffset or nivcfgDB.raidOffset
    local rg, rg1 = nivDB.maxRaidGroups, nivDB.maxRaidGroups - 1
	if (offs > 0) then
		if nivDB.vg then
			prh:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', tXs, tYs)
			prh:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMLEFT', tXs+rg*nivDB.prx+rg1*offs, tYs-5*nivDB.pry-4*3)
		else
			prh:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', tXs, tYs-nivDB.pry)
			prh:SetPoint('TOPRIGHT', UIParent, 'BOTTOMLEFT', tXs+5*nivDB.prx+4*3, tYs+rg1*nivDB.pry+rg1*offs)
		end
	else
		if nivDB.vg then
			prh:SetPoint('TOPRIGHT', UIParent, 'BOTTOMLEFT', tXs+nivDB.prx, tYs)
			prh:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', tXs-rg1*nivDB.prx+rg1*offs, tYs-5*nivDB.pry-4*3)
		else
			prh:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', tXs, tYs)
			prh:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMLEFT', tXs+5*nivDB.prx+4*3, tYs-rg*nivDB.pry+rg1*offs)
		end
	end
end

function oUF_Nivaya:ADDON_LOADED(event, addon)
	if (addon ~= 'oUF_Nivaya') then return end
	self:UnregisterEvent(event)
	self:LoadDefaults()
	nivcfgDB.unlocked = false
	self:InitSMVars()
	
	nivDB.healerMode = nivcfgDB.healerMode
	nivDB.playerLevel = UnitLevel('player')
    nivDB.maxRaidGroups = nivcfgDB.maxRaidGroups
	
	nivDB.ccH, nivDB.ccM, nivDB.crH, nivDB.crM = nivcfgDB.colorClassHealth, nivcfgDB.colorClassMana, nivcfgDB.colorReactHealth, nivcfgDB.colorReactMana
	
    if nivcfgDB.hideBlizzAuras then
        BuffFrame:Hide()
        TemporaryEnchantFrame:Hide()
    end
    
	-- Conditions for HealerMode activation --
	if nivcfgDB.autoHMtoggle then	
		playerName = UnitName("player")
		local _,playerClass = UnitClass("player")
	
		if (playerClass=="DEATHKNIGHT") then nivDB.healerMode = nivcfgDB.hmDK
		elseif (playerClass=="DRUID") 	then nivDB.healerMode = nivcfgDB.hmDRUID
		elseif (playerClass=="HUNTER") 	then nivDB.healerMode = nivcfgDB.hmHUNTER
		elseif (playerClass=="MAGE") 	then nivDB.healerMode = nivcfgDB.hmMAGE
		elseif (playerClass=="PALADIN") then nivDB.healerMode = nivcfgDB.hmPALA
	    elseif (playerClass=="PRIEST") 	then nivDB.healerMode = nivcfgDB.hmPRIEST
   	    elseif (playerClass=="ROGUE") 	then nivDB.healerMode = nivcfgDB.hmROGUE
	    elseif (playerClass=="SHAMAN") 	then nivDB.healerMode = nivcfgDB.hmSHAM
	    elseif (playerClass=="WARLOCK") then nivDB.healerMode = nivcfgDB.hmWL
	    elseif (playerClass=="WARRIOR") then nivDB.healerMode = nivcfgDB.hmWARR
	   	end
	end

	if nivDB.healerMode then
		nivDB.prx, nivDB.pry, nivDB.pr_hp, nivDB.pr_pw, nivDB.pr_namelen, nivDB.vg = nivcfgDB.prWidthHM, nivcfgDB.prHeightHM, nivcfgDB.prHealthHeightHM, nivcfgDB.prManaHeightHM, nivcfgDB.prNameLenHM, nivcfgDB.hmverticalGroups
	else
		nivDB.prx, nivDB.pry, nivDB.pr_hp, nivDB.pr_pw, nivDB.pr_namelen, nivDB.vg = nivcfgDB.prWidth, nivcfgDB.prHeight, nivcfgDB.prHealthHeight, nivcfgDB.prManaHeight, nivcfgDB.prNameLen, nivcfgDB.verticalGroups
	end	

	oUF:Spawn('player', 'oUF_player'):SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', nivcfgDB.playerX, nivcfgDB.playerY)
	oUF:Spawn('pet', 'oUF_pet'):SetPoint('TOPRIGHT', oUF.units.player, 'BOTTOMRIGHT', nivcfgDB.petX, nivcfgDB.petY)

	oUF:Spawn('target', 'oUF_target')
	if nivcfgDB.targetSym then
		oUF_target:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -nivcfgDB.playerX, nivcfgDB.playerY)
	else
		oUF_target:SetPoint('BOTTOMLEFT', oUF_player, 'BOTTOMRIGHT', nivcfgDB.targetX, nivcfgDB.targetY)
	end

	oUF:Spawn('targettarget', 'oUF_tot'):SetPoint('BOTTOMLEFT', oUF.units.target, 'TOPRIGHT', nivcfgDB.totX, nivcfgDB.totY)
	oUF:Spawn('focus', 'oUF_focus'):SetPoint('BOTTOMRIGHT', oUF.units.player, 'TOPLEFT', nivcfgDB.focusX, nivcfgDB.focusY)
	
	if nivcfgDB.enableTTT then 
		oUF:Spawn('targettargettarget', 'oUF_ttt'):SetPoint('TOPLEFT', oUF_tot, 'TOPRIGHT', nivcfgDB.tttX, nivcfgDB.tttY)
	end
	
	if nivcfgDB.enableFT then
		oUF:Spawn('focustarget', 'oUF_ft'):SetPoint('TOPRIGHT', oUF_focus, 'TOPLEFT', nivcfgDB.ftX, nivcfgDB.ftY)
	end

	if nivcfgDB.enablePR then

		prh = CreateFrame("Frame",nil,UIParent)
		prh:SetWidth(nivDB.prx)
		prh:SetHeight(nivDB.pry)
			
		local tex1 = prh:CreateTexture(nil,"BACKGROUND")
		tex1:SetTexture("Interface\\AddOns\\oUF_Nivaya\\textures\\Minimalist")
		tex1:SetAllPoints(prh)
		tex1:SetVertexColor(0,0,0,0.7)		
		prh.texture = tex1

		prh.text = prh:CreateFontString(nil, "OVERLAY")
		prh.text:SetFont(nivDB.fontStrNames, nivcfgDB.fontHeightN)
		prh.text:SetShadowColor(0,0,0)
		prh.text:SetShadowOffset(0.8, -0.8)
		prh.text:SetTextColor(1,1,1)
		prh.text:SetJustifyH("CENTER")
		prh.text:SetPoint("CENTER")
		prh.text:SetText("Party- / Raidframes")
		
		local tX, tY, offs
		if nivDB.healerMode then 
			tX, tY, offs = nivcfgDB.hmpartyX, nivcfgDB.hmpartyY, nivcfgDB.hmraidOffset
		else 
			tX, tY, offs = nivcfgDB.partyX, nivcfgDB.partyY, nivcfgDB.raidOffset
		end
		local vg = nivDB.vg
		
		local party = oUF:SpawnHeader('oUF_Party', nil, 'party', 
            'showParty', true, 
            'showPlayer', true, 
            vg and 'yOffset' or 'xOffset', vg and -3 or 3, 
            (not vg) and 'point' or nil, (not vg) and "LEFT" or nil,
            'oUF-initialConfigFunction', ([[
                self:SetWidth(%d)
                self:SetHeight(%d)
            ]]):format(nivDB.prx, nivDB.pry)
        )

        local tOffs
		if (offs > 0) then 
			if vg then
				prh:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", tX, tY) 
				party:SetPoint('TOPLEFT', prh, 'TOPLEFT')
			else
				prh:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", tX, tY) 
				party:SetPoint('BOTTOMLEFT', prh, 'BOTTOMLEFT')
			end
			tOffs = 2*(vg and nivDB.prx or nivDB.pry)
		else 
			if vg then
				prh:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", tX, tY) 
				party:SetPoint('TOPRIGHT', prh, 'TOPRIGHT')
			else
				prh:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", tX, tY) 
				party:SetPoint('TOPLEFT', prh, 'TOPLEFT')
			end
	    	tOffs = 0
		end

		local raid = {}
		for i = 1, nivDB.maxRaidGroups do
			local raidgroup = oUF:SpawnHeader('oUF_Raid'..i, nil, 'raid',
                'groupFilter', tostring(i),
                'showRaid', true,
                'showParty', false,
                'showPlayer', false,
                vg and 'yOffset' or 'xOffset', vg and -3 or 3, 
                (not vg) and 'point' or nil, (not vg) and "LEFT" or nil,
                'oUF-initialConfigFunction', ([[
                    self:SetWidth(%d)
                    self:SetHeight(%d)
                ]]):format(nivDB.prx, nivDB.pry)
            )
            
            table.insert(raid, raidgroup)
            if(i==1) then
                local ap
                if (offs > 0) then ap = vg and 'TOPLEFT' or 'BOTTOMLEFT' else ap = vg and 'TOPRIGHT' or 'TOPLEFT' end
                raidgroup:SetPoint(ap, prh, ap)
            else
                if vg then 
                    raidgroup:SetPoint('TOPRIGHT', raid[i-1], 'TOPLEFT', offs+tOffs, 0)
                else 
                    raidgroup:SetPoint('TOPLEFT', raid[i-1], 'BOTTOMLEFT', 0, offs+tOffs) 
                end
            end
			raidgroup:Show()
		end
		
		oUF_Nivaya:SetPRvisible(false)
		oUF_Nivaya:UpdatePrh()

		local partyToggle = CreateFrame('Frame')

		partyToggle:RegisterEvent('PLAYER_LOGIN')
		partyToggle:RegisterEvent('RAID_ROSTER_UPDATE')
		partyToggle:RegisterEvent('PARTY_LEADER_CHANGED')
		partyToggle:RegisterEvent('PARTY_MEMBERS_CHANGED')
		partyToggle:SetScript('OnEvent', function(self, event)
			if(InCombatLockdown()) then
				self:RegisterEvent('PLAYER_REGEN_ENABLED')
			else
				self:UnregisterEvent('PLAYER_REGEN_ENABLED')
				if(GetNumRaidMembers() > 0) then
					party:Hide()	
				else
					party:Show()
				end
			end
		end)

        -- hide blizzard raidmanager and raidcontainer
        CompactRaidFrameManager:UnregisterAllEvents()
        CompactRaidFrameManager:Hide()
        CompactRaidFrameManager:Hide()
        CompactRaidFrameContainer:UnregisterAllEvents()
        CompactRaidFrameContainer:Hide()
        CompactRaidFrameContainer:Hide()
	end
end

function oUF_Nivaya:UpdatePortrait(self, unit)
	if (nivcfgDB.ptShowPortrait) then 
		self.Portrait:Show()
		self.Portrait:SetCamera(0)
		
		self.Portrait:ClearAllPoints()
		self.Health:ClearAllPoints()
		self.Power:ClearAllPoints()		
		
		local s = nivcfgDB.ptPortraitPos
		local t = nivcfgDB.ptPortraitSym
		local u = (unit == 'player')
		
		if ((s == 'Left') and not t) or ((s == 'Left') and u and t) or ((s == 'Right') and not u and t) then 
			self.Portrait:SetPoint('TOPLEFT', self, 'TOPLEFT', 1, 0)
			self.Portrait:SetPoint('BOTTOMRIGHT', self, 'BOTTOMLEFT', nivcfgDB.ptPortraitWidth+1, 0)
			self.Health:SetPoint("TOPLEFT", self.Portrait, "TOPRIGHT", 2, 0)
			self.Health:SetPoint("TOPRIGHT") 
			self.Power:SetPoint("LEFT", self.Portrait, "RIGHT", 2, 0)
			self.Power:SetPoint("RIGHT")
			self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, -1)
		elseif ((s == 'Right') and not t) or ((s == 'Left') and not u and t) or ((s == 'Right') and u and t) then 
			self.Portrait:SetPoint('TOPRIGHT', self, 'TOPRIGHT')
			self.Portrait:SetPoint('BOTTOMLEFT', self, 'BOTTOMRIGHT', -nivcfgDB.ptPortraitWidth, 0)
			self.Health:SetPoint("TOPLEFT")
			self.Health:SetPoint("TOPRIGHT", self.Portrait, "TOPLEFT", -2, 0)
			self.Power:SetPoint("LEFT")
			self.Power:SetPoint("RIGHT", self.Portrait, "LEFT", -2, 0)
			self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, -1)
		elseif (s == 'Top') then
			self.Portrait:SetPoint('TOPRIGHT', self, 'TOPRIGHT')
			self.Portrait:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, -nivcfgDB.ptPortraitHeight)
			self.Health:SetPoint("TOPLEFT", self.Portrait, "BOTTOMLEFT", 0, -1)
			self.Health:SetPoint("TOPRIGHT", self.Portrait, "BOTTOMRIGHT", 0, -1)
			self.Power:SetPoint("LEFT")
			self.Power:SetPoint("RIGHT")
			self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, -1)
		elseif (s == 'Middle') then
			self.Health:SetPoint("TOPLEFT")
			self.Health:SetPoint("TOPRIGHT")
			self.Portrait:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, -1)
			self.Portrait:SetPoint('BOTTOMRIGHT', self.Health, 'BOTTOMRIGHT', 0, -nivcfgDB.ptPortraitHeight-1)
			self.Power:SetPoint("LEFT")
			self.Power:SetPoint("RIGHT")
			self.Power:SetPoint("TOP", self.Portrait, "BOTTOM", 0, -1)
		elseif (s == 'Bottom') then
			self.Health:SetPoint("TOPLEFT")
			self.Health:SetPoint("TOPRIGHT")
			self.Power:SetPoint("LEFT")
			self.Power:SetPoint("RIGHT")
			self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, -1)
			self.Portrait:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -1)
			self.Portrait:SetPoint('BOTTOMRIGHT', self.Power, 'BOTTOMRIGHT', 0, -nivcfgDB.ptPortraitHeight-1)
		else
			self.Portrait:SetPoint('TOPLEFT', self, 'TOPLEFT', 1, 0)
			self.Portrait:SetPoint('BOTTOMRIGHT', self, 'BOTTOMLEFT', nivcfgDB.ptPortraitWidth+1, 0)
			self.Health:SetPoint("TOPLEFT", self.Portrait, "TOPRIGHT", 2, 0)
			self.Health:SetPoint("TOPRIGHT") 
			self.Power:SetPoint("LEFT", self.Portrait, "RIGHT", 2, 0)
			self.Power:SetPoint("RIGHT")
			self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, -1)
		end
	else 
		self.Portrait:Hide()

		self.Health:ClearAllPoints()
		self.Health:SetPoint("TOPLEFT")
		self.Health:SetPoint("TOPRIGHT") 
		self.Power:ClearAllPoints()
		self.Power:SetPoint("LEFT")
		self.Power:SetPoint("RIGHT")
		self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, -1)
	end
end

function oUF_Nivaya:UpdateAuraPos(self, unit, type, init)
	if not unit then return end

	local b, sb
	if (type == "buff") then
		b = nivcfgDB.buffs[unit]
		sb = self.Buffs
	elseif (type == "debuff") then
		b = nivcfgDB.debuffs[unit]
		sb = self.Debuffs
	else return end
	
	if not b then return end
	if b.enabled then sb:Show() else sb:Hide() end
	
	local pt = (unit == "player") or (unit == "target")
	local w
	if pt then w = nivcfgDB.ptWidth else w = nivcfgDB.tfWidth end
	sb:SetWidth(w)
	
	sb:ClearAllPoints()
	if (b.pos == "TopLeft") then
		sb:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 1)
		sb.initialAnchor = 'BOTTOMLEFT'
		sb['growth-x'] = 'RIGHT'
		sb['growth-y'] = 'UP'
	elseif (b.pos == "TopRight") then
		sb:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 1)
		sb.initialAnchor = 'BOTTOMRIGHT'
		sb['growth-x'] = 'LEFT'
		sb['growth-y'] = 'UP'
	elseif (b.pos == "BottomLeft") then
		sb:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -1)
		sb.initialAnchor = 'TOPLEFT'
		sb['growth-x'] = 'RIGHT'
		sb['growth-y'] = 'DOWN'
	elseif (b.pos == "BottomRight") then
		sb:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -1)
		sb.initialAnchor = 'TOPRIGHT'
		sb['growth-x'] = 'LEFT'
		sb['growth-y'] = 'DOWN'
	elseif (b.pos == "LeftTop") then
		sb:SetPoint("TOPRIGHT", self, "TOPLEFT", -2, 0)
		sb.initialAnchor = 'TOPRIGHT'
		sb['growth-x'] = 'LEFT'
		sb['growth-y'] = 'DOWN'
	elseif (b.pos == "LeftBottom") then
		sb:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", -2, 0)
		sb.initialAnchor = 'BOTTOMRIGHT'
		sb['growth-x'] = 'LEFT'
		sb['growth-y'] = 'UP'
	elseif (b.pos == "RightTop") then
		sb:SetPoint("TOPLEFT", self, "TOPRIGHT", 2, 0)
		sb.initialAnchor = 'TOPLEFT'
		sb['growth-x'] = 'RIGHT'
		sb['growth-y'] = 'DOWN'
	elseif (b.pos == "RightBottom") then
		sb:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", 2, 0)
		sb.initialAnchor = 'BOTTOMLEFT'
		sb['growth-x'] = 'RIGHT'
		sb['growth-y'] = 'UP'
	end
	
	oUF_Nivaya:UpdateBuffCombine()
end

local buffsVisible = false
function oUF_Nivaya:UpdateBuffCombine()
	if not oUF_target then return end
	if not (oUF_target.Buffs and oUF_target.Debuffs) then return end
	
	local ib = nivcfgDB.buffs['target']
	local id = nivcfgDB.debuffs['target']
	if id.combine and ib.enabled and id.enabled and (id.pos == ib.pos) then 
		oUF_target:SetScript('OnMouseUp', function(self, mouseButton)
			if (mouseButton == 'LeftButton') and (not IsModifierKeyDown()) then
			    if buffsVisible then
					self.Buffs:Hide()
					self.Debuffs:Show()
					buffsVisible = false
				else
					self.Buffs:Show()
					self.Debuffs:Hide()
					buffsVisible = true
				end
			end
		end)
		oUF_target.Buffs:Hide()
		oUF_target.Debuffs:Show()
		buffsVisible = false
	else
		if ib.enabled then oUF_target.Buffs:Show() else	oUF_target.Buffs:Hide() end
		if id.enabled then oUF_target.Debuffs:Show() else oUF_target.Debuffs:Hide() end
		oUF_target:SetScript('OnMouseUp', nil)
	end
end

function oUF_Nivaya:UpdateNamePos(self, unit)
	local v = nivcfgDB.names[unit]
	if not unit then return end
	if not self.Name then return end
	if not v then return end

	if v.enabled then self.Name:Show() else self.Name:Hide() end
	self.Name:ClearAllPoints()
	if (v.pos == "Top") then
		self.Name:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 1, 3)
	else
		self.Name:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 1, -2)
	end			
end

function oUF_Nivaya:UpdateClassDisplayPos()
    local v
    if oUF_player.SoulShards then v = oUF_player.SoulShards
    elseif oUF_player.HolyPower then v = oUF_player.HolyPower 
    else return end
    
    for i = 1, 3 do
        v[i]:ClearAllPoints()
        if i == 1 then
            if nivcfgDB.cdPos == "TopLeft" then
                v[i]:SetPoint("BOTTOMLEFT", oUF_player, "TOPLEFT", 1, 3)
            elseif nivcfgDB.cdPos == "TopRight" then
                v[i]:SetPoint("BOTTOMRIGHT", oUF_player, "TOPRIGHT", -1, 3)
            elseif nivcfgDB.cdPos == "BottomLeft" then
                v[i]:SetPoint("TOPLEFT", oUF_player, "BOTTOMLEFT", 1, -3)
            elseif nivcfgDB.cdPos == "BottomRight" then
                v[i]:SetPoint("TOPRIGHT", oUF_player, "BOTTOMRIGHT", -1, -3)
            end
        else
            if (nivcfgDB.cdPos == "TopLeft") or (nivcfgDB.cdPos == "BottomLeft") then
                v[i]:SetPoint("TOPLEFT", v[i - 1], "TOPRIGHT", 3, 0)
            elseif (nivcfgDB.cdPos == "TopRight") or (nivcfgDB.cdPos == "BottomRight") then
                v[i]:SetPoint("TOPRIGHT", v[i - 1], "TOPLEFT", -3, 0)
            end
        end
    end
end

function oUF_Nivaya:ShortName(tS, i, d)
	if not tS then return end
	local slen = tS:len()
	if (slen<=i) then return tS else
		local l,p = 0,1
		while (p<=slen) and (l<i) do
			local c = tS:byte(p)
			if (c>0 and c<128) then p=p+1
			elseif (c>=192 and c<224) then p=p+2
			elseif (c>=224 and c<240) then p=p+3
			elseif (c>=240 and c<248) then p=p+4 end
			l=l+1
		end
		if (l>=i and p<=slen) then return tS:sub(1,p-1)..(d and '...' or '') else return tS end
	end
end

function oUF_Nivaya:openConfig(args)

end

oUF_Nivaya.LDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("oUF_Nivaya", {
	type = "launcher",
	text = "oUF_Nivaya",
	icon = "Interface\\AddOns\\oUF_Nivaya\\textures\\icon",
	OnClick = oUF_Nivaya.openConfig,
	OnTooltipShow = function(tooltip)
		if not tooltip or not tooltip.AddLine then return end
		tooltip:AddLine("oUF_Nivaya")
		tooltip:AddLine("Click to open the config window.")
	end,	
})

local function StatusMsg(str1, str2, data, name, short)
    local R,G,t = '|cFFFF0000', '|cFF00FF00', ''
    if (data ~= nil) then t = data and G..(short and 'on|r' or 'enabled|r') or R..(short and 'off|r' or 'disabled|r') end
    t = (name and '|cFFFFFF00oUF_Nivaya:|r ' or '')..str1..t..str2
    ChatFrame1:AddMessage(t)
end

local function HandleSlash(str)
	if(not IsAddOnLoaded('oUF_Nivaya_Config')) then
		LoadAddOn('oUF_Nivaya_Config')
	end
	local str,str2 = strsplit(" ", str)
    if str == 'unlock' or str == 'lock' then
        value = not nivcfgDB.unlocked
        nivcfgDB.unlocked = value
        SetFrameMovable(oUF_player, value)
        if prh then
            oUF_Nivaya:SetPRvisible(value)
            SetFrameMovable(prh, value)
        end
        StatusMsg('Player- and Party-/Raidframe lock is now ', '.', not value, true, false)
    else
        InterfaceOptionsFrame_OpenToCategory('oUF Nivaya') 
    end
end    

SLASH_OUFC1 = '/ouf'
SlashCmdList.OUFC = HandleSlash