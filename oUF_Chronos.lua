---------------------
--/ CONFIGURATION \--
---------------------

-- Type true to show/enable or false to hide/disable.

local cToTarget = true			-- Target's Target Frame.
local cToToTarget = false		-- Target's Target's Target Frame.
local cPetTarget = true			-- Pet's Target Frame.
local cFocus = true				-- Focus Frame.
local cFocusTarget = true		-- Focus's Target Frame.

local cSmooth = true			-- Smooth effect.
local cCBP	= true				-- Combo points.
local cTotems = true			-- Totem bar.
local cRune = true				-- Rune bar.
local cClassIcn = true			-- Class Icon bar.

local cTarCastbar = true		-- Target Castbar.
local cPlayCastbar = true		-- Player Castbar.


--------------
--/ LOCALS \--
--------------

--:: TEXTURES & FONT ::--
local statusbar = "Interface\\AddOns\\oUF_Chronos\\media\\statusbar.tga"
local font = "Interface\\AddOns\\oUF_Chronos\\media\\font.ttf"
local cbp = "Interface\\AddOns\\oUF_Chronos\\media\\combo.tga"
local spark = "Interface\\AddOns\\oUF_Chronos\\media\\spark.tga"
local white = "Interface\\AddOns\\oUF_Chronos\\media\\white.tga"
local glow = "Interface\\AddOns\\oUF_Chronos\\media\\glow.tga"
local buffborder = "Interface\\AddOns\\oUF_Chronos\\media\\buffborder.tga"
local backdrop = {
	bgFile = "Interface\\AddOns\\oUF_Chronos\\media\\back.tga",
	insets = {top = -1.3, left = -1.3, bottom = -1.3, right = -1.3},
}
local backdrop2 = {
	bgFile = "Interface\\AddOns\\oUF_Chronos\\media\\back.tga",
	insets = {top = -1, left = -1, bottom = -1, right = -1},
}
local statusback = {
	bgFile = "Interface\\AddOns\\oUF_Chronos\\media\\statusbar.tga",
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

--:: TAGS ::--

oUF.Tags.Events["My_PerHP"] = "UNIT_HEALTH UNIT_MAXHEALTH"
oUF.Tags.Methods["My_PerHP"] = function(unit)

	local curhp, maxhp = UnitHealth(unit), UnitHealthMax(unit);

	if ((maxhp > 0) and (curhp < maxhp)) then

		return math.floor((curhp / maxhp * 100 + 0.05) * 10)/10 .. '%'; -- by myno

	end

end;

oUF.Tags.Events["My_CurHP"] = "UNIT_HEALTH"
oUF.Tags.Methods["My_CurHP"] = function(unit)

	local curhp = UnitHealth(unit);

	if (curhp >= 1e6) then

		return string.format("%.1fm", curhp / 1e6);

	elseif (curhp >= 1e3) then

		return string.format("%.1fk", curhp / 1e3);

	else

		return curhp;

	end

end;

oUF.Tags.Events["My_MaxHP"] = "UNIT_MAXHEALTH"
oUF.Tags.Methods["My_MaxHP"] = function(unit)

	local curhp = UnitHealthMax(unit);

	if (curhp >= 1e6) then

		return string.format("%.1fm", curhp / 1e6);

	elseif (curhp >= 1e3) then

		return string.format("%.1fk", curhp / 1e3);

	else

		return curhp;

	end

end;

--:: THREAT ::--
local function check_threat(self,event,unit)
    if unit then
      if self.unit ~= unit then
        return
      end
      local Threat = UnitThreatSituation(unit)
  		if Threat == 3 then
  		  self.Threat:SetVertexColor(0.5, 0, 0, 1)
  		else
  		  self.Threat:SetVertexColor(0, 0, 0, 0)
  		end
	  end
  end

--:: RAID ICONS ::-- (Taken from oUF_Nivea)

local createRaidIcon = function(self)
	self.RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
	self.RaidIcon:SetTexture("Interface\\AddOns\\oUF_Chronos\\media\\raidicons.blp")
	self.RaidIcon:SetSize(15, 15)
end
	
--:: FREQUENT UPDATE ::--
local FreqUpdate = 0.3

--:: MENU ::--
local function menu(self)
	ToggleDropDownMenu(1, nil, _G[string.gsub(self.unit, '^.', string.upper)..'FrameDropDown'], 'cursor')
end

--:: BUFFBORDER ::--
local PostCreateIcon = function(this, aura)

  aura.overlay:SetTexture(buffborder)

  aura.overlay:SetTexCoord(0.955, 0.05, 0.95, 0.04)

end

--:: GLOWBORDER ::--
local function Glowborder(self)
	self.Glowborder = CreateFrame("Frame", nil, self)
	self.Glowborder:SetFrameLevel(0)
	self.Glowborder:SetPoint("TOPLEFT", self, "TOPLEFT", -5, 5)
	self.Glowborder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 5, -5)
	self.Glowborder:SetBackdrop({bgFile = white, edgeFile =  glow, tile = false, tileSize = 16, edgeSize = 4, insets = {left = 0, right = 0, top = 0, bottom = 0}})
	self.Glowborder:SetBackdropColor(0, 0, 0, 0)
	self.Glowborder:SetBackdropBorderColor(0, 0, 0, 1)
end

--------------
--/ LAYOUT \--
--------------
local Shared = function(self, unit, isSingle)
	self.colors = colors
	self.menu = menu
	self:RegisterForClicks('AnyDown')
	self:SetAttribute('*type2', 'menu')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	if(isSingle) then
		self:SetSize(235, 20)
	end
end
----------------------------------------------------------------------
--||PLAYER||----------------------------------------------||PLAYER||--

local cPlayer = function(self)
		self:SetSize(235, 20)

	--:: BACKGROUND ::--
	
		Back = CreateFrame('Frame', nil, self)
		Back:SetPoint('TOPRIGHT', self)
		Back:SetPoint('TOPLEFT', self)
		Back:SetFrameStrata('BACKGROUND')
		Back:SetBackdrop(backdrop)
		Back:SetBackdropColor(0.05, 0.05, 0.05)
		Back:SetHeight(35)
		
	--:: HEALTH ::--
	
		--: BAR :--
		self.Health = CreateFrame('StatusBar', nil, self)
		self.Health:SetBackdrop(statusback)
		self.Health:SetBackdropColor(0, 0, 0)
		self.Health:SetFrameStrata('LOW')
		self.Health:SetPoint('TOPRIGHT', self)
		self.Health:SetPoint('TOPLEFT', self)
		self.Health:SetStatusBarTexture(statusbar)
		self.Health:SetStatusBarColor(0.28, 0.28, 0.28)
		self.Health.frequentUpdates = FreqUpdate
		self.Health.Smooth = cSmooth
		self.Health:SetHeight(20)
		self.Health.colorClass = false
		
		--: PORTRAIT :--
		self.Portrait = CreateFrame('PlayerModel', nil, self)
		self.Portrait:SetFrameLevel(8)
		self.Portrait:SetAllPoints(self.Health)
		self.Portrait:SetAlpha(.5)
		self.Health:SetPoint("TOPLEFT", 0, 0)
		self.Health:SetPoint("TOPRIGHT")

		--: TEXT NUM :--
		self.Health.Text = self.Health:CreateFontString(nil, 'OVERLAY') 
		self.Health.Text:SetFont(font, 10, 'THINOUTLINE')
		self:Tag(self.Health.Text,'[My_CurHP] / [My_MaxHP]|r')
		self.Health.Text:SetShadowOffset(1, -1) 
		self.Health.Text.frequentUpdates = FreqUpdate
		self.Health.Text:SetJustifyH('LEFT')
		self.Health.Text:SetPoint('TOPLEFT',self.Health,'BOTTOMLEFT', 0, -9)
		
		-- TEXT PERCENT --
		self.Health.Text = self.Health:CreateFontString(nil, 'OVERLAY') 
		self.Health.Text:SetFont(font, 10, 'THINOUTLINE')
		self.Health.Text:SetShadowOffset(1, -1) 
		self.Health.Text.frequentUpdates = FreqUpdate
		self:Tag(self.Health.Text,'[My_PerHP]|r')
		self.Health.Text:SetJustifyH('CENTER')
		self.Health.Text:SetPoint('LEFT',self, 30, 9)
	
	--:: POWER ::--
	
		--: BAR :--
		self.Power = CreateFrame('StatusBar', nil, self)
		self.Power:SetBackdrop(statusback)
		self.Power:SetBackdropColor(0.165,0.165,0.165)
		self.Power:SetFrameStrata('LOW')
		self.Power:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', 0, -1)
		self.Power:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, -1)
		self.Power:SetStatusBarTexture(statusbar)
		self.Power:SetStatusBarColor(0.28,0.28,0.28)
		self.Power.frequentUpdates = FreqUpdate
		self.Power.Smooth = cSmooth
		self.Power:SetHeight(6)
		self.Power.colorClass = true
		
		--: TEXT :--
		self.Power.Text = self.Health:CreateFontString(nil, 'OVERLAY') 
		self.Power.Text:SetFont(font, 10, 'THINOUTLINE')
		self.Power.Text:SetShadowOffset(1, -1) 
		self.Power.Text.frequentUpdates = FreqUpdate
		self:Tag(self.Power.Text,'[raidcolor] [curpp]|r')
		self.Power.Text:SetJustifyH('RIGHT')
		self.Power.Text:SetPoint('TOPRIGHT',self.Health,'BOTTOMRIGHT', 0, -9)
		
	--:: NAME ::--
	
		self.Info = self.Health:CreateFontString(nil, 'OVERLAY')
		self.Info:SetShadowOffset(1, -1)
		self.Info:SetAlpha(1)
		self.Info:SetFont(font, 16, 'THINOUTLINE')
		self:Tag(self.Info,'[raidcolor] [name]' )
		self.Info:SetJustifyH('LEFT')
		self.Info:SetPoint('TOPLEFT',self.Power,'BOTTOMLEFT', -7, -15)
		
	--:: BLANK BAR ::--
	
		self.Blank = CreateFrame('StatusBar', nil, self)
		self.Blank:SetFrameStrata('LOW')
		self.Blank:SetPoint('TOPRIGHT', self.Power, 'BOTTOMRIGHT', 0, -1)
		self.Blank:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -1)
		self.Blank:SetStatusBarTexture(statusbar)
		self.Blank:SetHeight(7)
		
	--:: THREAT BAR ::--
	
		self.Threat = self.Blank:CreateTexture(nil, "OVERLAY")
		self.Threat:SetAllPoints()
		self.Threat:SetTexture(statusbar)
		self.Threat:SetAlpha(0.5)
		self.Threat:SetVertexColor(0.47,0.4,0.4)
		self.Threat.frequentUpdates = FreqUpdate
	
		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", check_threat)		

	--:: ICONS ::--

		--: LEADER :--
		self.Leader = self.Health:CreateTexture(nil, 'OVERLAY')
		self.Leader:SetPoint('LEFT', self, 1, 10 )
		self.Leader:SetHeight(14)
		self.Leader:SetWidth(14)

		--: MASTERLOOTER :--
		self.MasterLooter = self.Health:CreateTexture(nil, 'OVERLAY')
		self.MasterLooter:SetPoint('LEFT', self, 16, 10 )
		self.MasterLooter:SetHeight(11)
		self.MasterLooter:SetWidth(11)
		
		--: PVP FLAG :--
		self.PvP = self.Health:CreateTexture(nil, 'OVERLAY')
		self.PvP:SetPoint('RIGHT', self, 9, 3)
		self.PvP:SetHeight(25)
		self.PvP:SetWidth(25)

		--: LFD ROLE :--
		self.LFDRole = self.Health:CreateTexture(nil, "OVERLAY")
		self.LFDRole:SetPoint('RIGHT', self, -5, 8)
		self.LFDRole:SetHeight(12)
		self.LFDRole:SetWidth(12)
			
		--: RAIDS ICONS :--
		createRaidIcon(self)
			self.RaidIcon:SetPoint("CENTER", self.Health, "CENTER", 0, 9)
				
		--: COMBOPOINTS :--
		if cCBP == true then
			self.CPoints = CreateFrame("Frame", nil, self)
			self.CPoints:SetPoint("BOTTOMRIGHT", self.Health, "BOTTOMRIGHT", -3, 3)
			self.CPoints:SetHeight(10)
			self.CPoints:SetWidth(150)
			for i = 1, 5 do
				self.CPoints[i] = CreateFrame("StatusBar", nil, self)
				self.CPoints[i]:SetStatusBarTexture(statusbar)
				self.CPoints[i]:SetHeight(10)
				self.CPoints[i]:SetWidth((150-4)/5)
				self.CPoints[i]:SetBackdrop(backdrop)
				self.CPoints[i]:SetBackdropColor(0, 0, 0)
				if i == 1 then
					self.CPoints[i]:SetPoint("BOTTOMRIGHT", self.Health, "TOPRIGHT", 0, 5)
				else
					self.CPoints[i]:SetPoint("RIGHT", self.CPoints[i-1], "LEFT", -1, 0)
				end
				if i == 5 then
					self.CPoints[i]:SetStatusBarColor(1, 0, 0)
				else
					self.CPoints[i]:SetStatusBarColor(1, 1, 1)
				end
			end
		end

		--: CLASSICON :--
		local _, class = UnitClass('player')
		if class == "PRIEST" or class == "PALADIN" or class == "MONK" or class == "WARLOCK" and cClassIcn == true then
			self.ClassIcons = CreateFrame("Frame", nil, self)
			self.ClassIcons:SetPoint("BOTTOMRIGHT", self.Health, "BOTTOMRIGHT", -3, 3)
			self.ClassIcons:SetHeight(10)
			self.ClassIcons:SetWidth(150)
			for i = 1, 5 do
				self.ClassIcons[i] = self:CreateTexture(nil, "StatusBar")
				self.ClassIcons[i]:SetTexture(statusbar)
				self.ClassIcons[i]:SetHeight(10)
				self.ClassIcons[i]:SetWidth((150-4)/5)
				if i == 1 then
					self.ClassIcons[i]:SetPoint("BOTTOMRIGHT", self.Health, "TOPRIGHT", 0, 5)
				else
					self.ClassIcons[i]:SetPoint("RIGHT", self.ClassIcons[i-1], "LEFT", -1, 0)
				end
			end
		end
			
		--: DEATHKNIGHT RUNEBAR :--
		local _, class = UnitClass("player")
		if class == "DEATHKNIGHT" and cRune == true then
			self.Runes = CreateFrame("Frame", nil, self)
			self.Runes:SetPoint("BOTTOMRIGHT", self.Health, "TOPRIGHT", 0, 5)
			self.Runes:SetHeight(10)
			self.Runes:SetWidth(150)
			for i = 1, 6 do
				self.Runes[i] = CreateFrame("StatusBar", nil, self)
				self.Runes[i]:SetStatusBarTexture(statusbar)
				self.Runes[i]:SetHeight(10)
				self.Runes[i]:SetWidth((150-5)/6)
				self.Runes[i]:SetBackdrop(backdrop)
				self.Runes[i]:SetBackdropColor(0, 0, 0)
				if i == 1 then
					self.Runes[i]:SetPoint("BOTTOMRIGHT", self.Health, "TOPRIGHT", 0, 5)
				else
					self.Runes[i]:SetPoint("RIGHT", self.Runes[i-1], "LEFT", -1, 0)
				end

				self.Runes[i].bg = self.Runes[i]:CreateTexture(nil, "BORDER")
				self.Runes[i].bg:SetAllPoints(self.Runes[i])
				self.Runes[i].bg:SetTexture(statusbar)
				self.Runes[i].bg.multiplier = 0.3
			end
		end

		--: DRUID ECLIPSEBAR :--
		

	
			local _, class = UnitClass('player')
			if class == 'DRUID' then
				
				local EclipsePostUnitAura = function(self)
					if self.hasSolarEclipse then
						self.Glowborder:Show()
						self.Glowborder:SetBackdropBorderColor(255/255, 166/255, 0/255, 1)
						self.spark:SetVertexColor(255/255, 166/255, 0/255)
						self.spark:SetPoint('CENTER', self.SolarBar, 'LEFT', 1, 0)
					elseif self.hasLunarEclipse then
						self.Glowborder:Show()
						self.Glowborder:SetBackdropBorderColor(0/255, 108/255, 255/255, 1)
						self.spark:SetVertexColor(0/255, 108/255, 255/255)
						self.spark:SetPoint('CENTER', self.SolarBar, 'LEFT', -1, 0)
					else
						self.Glowborder:Hide()
					end
				end
			
				self.EclipseBar = CreateFrame('Frame', nil, self)
				self.EclipseBar:SetPoint("BOTTOMRIGHT", self.Health, "TOPRIGHT", 0, 5)
				self.EclipseBar:SetHeight(10)
				self.EclipseBar:SetWidth(150)
				self.EclipseBar:SetBackdrop(backdrop)
				self.EclipseBar:SetBackdropColor(0.05, 0.05, 0.05)
				Glowborder(self.EclipseBar)

				self.EclipseBar.LunarBar = CreateFrame('StatusBar', nil, self.EclipseBar)
				self.EclipseBar.LunarBar:SetPoint('LEFT', self.EclipseBar, 'LEFT', 0, 0)
				self.EclipseBar.LunarBar:SetHeight(10)
				self.EclipseBar.LunarBar:SetWidth(150)
				self.EclipseBar.LunarBar:SetStatusBarTexture(statusbar)
				self.EclipseBar.LunarBar:SetStatusBarColor(0, 0.3, 0.8)
				self.EclipseBar.LunarBar.frequentUpdates = FreqUpdate
		
				self.EclipseBar.SolarBar = CreateFrame('StatusBar', nil, self.EclipseBar)
				self.EclipseBar.SolarBar:SetPoint('LEFT', self.EclipseBar.LunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
				self.EclipseBar.SolarBar:SetHeight(10)
				self.EclipseBar.SolarBar:SetWidth(150)
				self.EclipseBar.SolarBar:SetStatusBarTexture(statusbar)
				self.EclipseBar.SolarBar:SetStatusBarColor(1, 3/5, 0)
				self.EclipseBar.SolarBar.frequentUpdates = FreqUpdate

				self.EclipseBarText = self.EclipseBar.SolarBar:CreateFontString(nil, 'OVERLAY')
				self.EclipseBarText:SetPoint('CENTER', self.EclipseBar, 'CENTER', 0, 0)
				self.EclipseBarText:SetFont(font, 8, 'THINOUTLINE')
				self:Tag(self.EclipseBarText, '[pereclipse]')
				
				self.EclipseBar.spark = self.EclipseBar.SolarBar:CreateTexture(nil, 'OVERLAY')
				self.EclipseBar.spark:SetTexture(spark)
				self.EclipseBar.spark:SetBlendMode('ADD')
				self.EclipseBar.spark:SetHeight(10+3.5)
				self.EclipseBar.spark:SetWidth(10)
				self.EclipseBar.spark:SetPoint('CENTER', self.EclipseBar.SolarBar, 'LEFT', 0, 0)
				self.EclipseBar.spark:SetVertexColor(255/255, 166/255, 0/255)
				
				self.EclipseBar.PostUnitAura = EclipsePostUnitAura
			end

		--: SHAMAN TOTEMBAR :--
		local _, class = UnitClass('player')
		if IsAddOnLoaded("oUF_TotemBar") and class == "SHAMAN" and cTotems == true then
			self.TotemBar = {}
			self.TotemBar.Destroy = true
			for i = 1, 4 do
				self.TotemBar[i] = CreateFrame("StatusBar", nil, self)
				self.TotemBar[i]:SetStatusBarTexture(statusbar)
				self.TotemBar[i]:SetBackdrop(backdrop2)
				self.TotemBar[i]:SetBackdropColor(0, 0, 0)
				self.TotemBar[i]:SetHeight(7)
				self.TotemBar[i]:SetWidth((150-2)/4)
				self.TotemBar[i]:SetMinMaxValues(0, 1)
				if i == 1 then
					self.TotemBar[i]:SetPoint("BOTTOMRIGHT", self.Health, "TOPRIGHT", 0, 5)
				else
					self.TotemBar[i]:SetPoint("RIGHT", self.TotemBar[i-1], "LEFT", -1, 0)
				end

				self.TotemBar[i].bg = self.TotemBar[i]:CreateTexture(nil, "BORDER")
				self.TotemBar[i].bg:SetAllPoints(self.TotemBar[i])
				self.TotemBar[i].bg:SetTexture(statusbar)
				self.TotemBar[i].bg.multiplier = 0.3
			end
		end
		
	--:: CASTBAR ::--

		--: BAR :--
		if cPlayCastbar == true then
			self.Castbar = CreateFrame('StatusBar', nil, self)
			self.Castbar:SetFrameStrata('MEDIUM')
			self.Castbar:SetFrameLevel(10)
			self.Castbar:SetWidth(300)
			self.Castbar:SetHeight(15)
			self.Castbar:SetPoint("CENTER", UIParent, "CENTER", 0, -170)
			self.Castbar:SetStatusBarTexture(statusbar)
			self.Castbar:SetStatusBarColor(0.28,0.28,0.28)
		
		--: SAFEZONE :--
			self.Castbar.SafeZone = self.Castbar:CreateTexture(nil,'ARTWORK')
			self.Castbar.SafeZone:SetTexture(statusbar)
			self.Castbar.SafeZone:SetVertexColor(0.7, 0, 0 ,0.7)
			self.Castbar.SafeZone:SetPoint('LEFT', self.Castbar, 'LEFT')

		--: TEXT :--
			self.Castbar.Text = self.Castbar:CreateFontString(nil, 'OVERLAY')
			self.Castbar.Text:SetFont(font, 9, 'THINOUTLINE')
			self.Castbar.Text:SetPoint('LEFT', self.Castbar,'LEFT', 2, 0)
			self.Castbar.Text:SetWidth(200)
			self.Castbar.Text:SetTextColor(1,1,1)
			self.Castbar.Text:SetJustifyH('LEFT')

		--: TIME :--
			self.Castbar.Time = self.Castbar:CreateFontString(nil, 'OVERLAY') 
			self.Castbar.Time:SetFont(font, 9, 'THINOUTLINE')
			self.Castbar.Time:SetPoint('RIGHT', self.Castbar,'RIGHT',-2, 0)
			self.Castbar.Time:SetWidth(50)
			self.Castbar.Time:SetTextColor(1,1,1)
			self.Castbar.Time:SetJustifyH('RIGHT')
			
		--: BG :--
			self.Castbar.Bg = self.Castbar:CreateTexture(nil, 'BACKGROUND')
			self.Castbar.Bg:SetPoint('CENTER', self.Castbar)
			self.Castbar.Bg:SetWidth(302)
			self.Castbar.Bg:SetHeight(17)
			self.Castbar.Bg:SetTexture(statusbar)
			self.Castbar.Bg:SetVertexColor(0.05, 0.05, 0.05, 0.9)
		end
end

----------------------------------------------------------------------
--||TARGET||----------------------------------------------||TARGET||--

local cTarget = function(self)
		self:SetSize(235, 20)

	--:: BACKGROUND ::--
	
		Back = CreateFrame('Frame', nil, self)
		Back:SetPoint('TOPRIGHT', self)
		Back:SetPoint('TOPLEFT', self)
		Back:SetFrameStrata('BACKGROUND')
		Back:SetBackdrop(backdrop)
		Back:SetBackdropColor(0.05, 0.05, 0.05)
		Back:SetHeight(35)
		
	--:: HEALTH ::--
	
		--: BAR :--
		self.Health = CreateFrame('StatusBar', nil, self)
		self.Health:SetBackdrop(statusback)
		self.Health:SetBackdropColor(0, 0, 0)
		self.Health:SetFrameStrata('LOW')
		self.Health:SetPoint('TOPLEFT', self)
		self.Health:SetPoint('TOPRIGHT', self)
		self.Health:SetStatusBarTexture(statusbar)
		self.Health:SetStatusBarColor(0.28,0.28,0.28)
		self.Health.frequentUpdates = FreqUpdate
		self.Health.Smooth = cSmooth
		self.Health:SetHeight(20)
		self.Health.colorClass = false
		
		--: PORTRAIT :--
		self.Portrait = CreateFrame('PlayerModel', nil, self)
		self.Portrait:SetFrameLevel(8)
		self.Portrait:SetAllPoints(self.Health)
		self.Portrait:SetAlpha(.5)
		self.Health:SetPoint("TOPLEFT", 0, 0)
		self.Health:SetPoint("TOPRIGHT")

		--: TEXT NUM :--
		self.Health.Text = self.Health:CreateFontString(nil, 'OVERLAY') 
		self.Health.Text:SetFont(font, 10, 'THINOUTLINE')
		self:Tag(self.Health.Text,'[My_CurHP] / [My_MaxHP]|r')
		self.Health.Text:SetShadowOffset(1, -1) 
		self.Health.Text.frequentUpdates = FreqUpdate
		self.Health.Text:SetJustifyH('RIGHT')
		self.Health.Text:SetPoint('TOPRIGHT',self.Health,'BOTTOMRIGHT', 0, -9)
		
		-- TEXT PERCENT --
		self.Health.Text = self.Health:CreateFontString(nil, 'OVERLAY') 
		self.Health.Text:SetFont(font, 10, 'THINOUTLINE')
		self.Health.Text:SetShadowOffset(1, -1) 
		self.Health.Text.frequentUpdates = FreqUpdate
		self:Tag(self.Health.Text,'[My_PerHP]|r')
		self.Health.Text:SetJustifyH('CENTER')
		self.Health.Text:SetPoint('RIGHT',self, -30, 9)
	
	--:: POWER ::--
	
		--: BAR :--
		self.Power = CreateFrame('StatusBar', nil, self)
		self.Power:SetBackdrop(statusback)
		self.Power:SetBackdropColor(0.165,0.165,0.165)
		self.Power:SetFrameStrata('LOW')
		self.Power:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', 0, -1)
		self.Power:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, -1)
		self.Power:SetStatusBarTexture(statusbar)
		self.Power:SetStatusBarColor(0.28,0.28,0.28)
		self.Power.frequentUpdates = FreqUpdate
		self.Power.Smooth = cSmooth
		self.Power:SetHeight(6)
		self.Power.colorClass = true
		
		--: TEXT :--
		self.Power.Text = self.Health:CreateFontString(nil, 'OVERLAY') 
		self.Power.Text:SetFont(font, 10, 'THINOUTLINE')
		self.Power.Text:SetShadowOffset(1, -1) 
		self.Power.Text.frequentUpdates = FreqUpdate
		self:Tag(self.Power.Text,'[raidcolor] [curpp]|r')
		self.Power.Text:SetJustifyH('LEFT')
		self.Power.Text:SetPoint('TOPLEFT',self.Health,'BOTTOMLEFT', 0, -9)
		
	--:: NAME ::--
	
		self.Info = self.Health:CreateFontString(nil, 'OVERLAY')
		self.Info:SetShadowOffset(1, -1)
		self.Info:SetAlpha(1)
		self.Info:SetFont(font, 16, 'THINOUTLINE')
		self:Tag(self.Info,'[raidcolor] [name]' )
		self.Info:SetJustifyH('RIGHT')
		self.Info:SetPoint('TOPRIGHT',self.Power,'BOTTOMRIGHT', 3, -15)
		
	--:: BLANK BAR ::--

		self.Blank = CreateFrame('StatusBar', nil, self)
		self.Blank:SetFrameStrata('LOW')
		self.Blank:SetPoint('TOPRIGHT', self.Power, 'BOTTOMRIGHT', 0, -1)
		self.Blank:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -1)
		self.Blank:SetStatusBarTexture(statusbar)
		self.Blank:SetHeight(7)
		
	--:: BUFFS ::--

		self.Buffs = CreateFrame('Frame', nil, self)
		self.Buffs.size = 4.5 * 4.5
		self.Buffs.spacing = 1
		self.Buffs:SetWidth(150)
		self.Buffs:SetHeight(5)
		self.Buffs.initialAnchor = 'BOTTOMLEFT'
		self.Buffs['growth-x'] = 'RIGHT'
		self.Buffs['growth-y'] = 'UP'
		self.Buffs.showBuffType = true
		self.Buffs.num = 14
		self.Buffs.filter = false
		self.Buffs:SetPoint('BOTTOMLEFT',self.Health,'TOPLEFT', 0, 10)
		self.Buffs.PostCreateIcon = PostCreateIcon
		
	--:: ICONS ::--

		--: LEADER :--
		self.Leader = self.Health:CreateTexture(nil, 'OVERLAY')
		self.Leader:SetPoint('RIGHT', self, -1, 10 )
		self.Leader:SetHeight(14)
		self.Leader:SetWidth(14)

		--: MASTERLOOTER :--
		self.MasterLooter = self.Health:CreateTexture(nil, 'OVERLAY')
		self.MasterLooter:SetPoint('RIGHT', self, -16, 10 )
		self.MasterLooter:SetHeight(11)
		self.MasterLooter:SetWidth(11)
		
		--: PVP FLAG :--
		self.PvP = self.Health:CreateTexture(nil, 'OVERLAY')
		self.PvP:SetPoint('LEFT', self, 0, 3)
		self.PvP:SetHeight(25)
		self.PvP:SetWidth(25)

		--: LFD ROLE :--
		self.LFDRole = self.Health:CreateTexture(nil, "OVERLAY")
		self.LFDRole:SetPoint('LEFT', self, 5, 8)
		self.LFDRole:SetHeight(12)
		self.LFDRole:SetWidth(12)
			
		--: RAIDS ICONS :--
		createRaidIcon(self)
			self.RaidIcon:SetPoint("CENTER", self.Health, "CENTER", 0, 9)
				
	--:: CASTBAR ::--

		--: BAR :--
		if cTarCastbar == true then
			self.Castbar = CreateFrame('StatusBar', nil, self)
			self.Castbar:SetFrameStrata('MEDIUM')
			self.Castbar:SetFrameLevel(10)
			self.Castbar:SetWidth(300)
			self.Castbar:SetHeight(15)
			self.Castbar:SetPoint("CENTER", UIParent, "CENTER", 0, -152)
			self.Castbar:SetStatusBarTexture(statusbar)
			self.Castbar:SetStatusBarColor(0.28,0.28,0.28)

		--: TEXT :--
			self.Castbar.Text = self.Castbar:CreateFontString(nil, 'OVERLAY')
			self.Castbar.Text:SetFont(font, 9, 'THINOUTLINE')
			self.Castbar.Text:SetPoint('LEFT', self.Castbar,'LEFT', 2, 0)
			self.Castbar.Text:SetWidth(200)
			self.Castbar.Text:SetTextColor(1,1,1)
			self.Castbar.Text:SetJustifyH('LEFT')

		--: TIME :--
			self.Castbar.Time = self.Castbar:CreateFontString(nil, 'OVERLAY') 
			self.Castbar.Time:SetFont(font, 9, 'THINOUTLINE')
			self.Castbar.Time:SetPoint('RIGHT', self.Castbar,'RIGHT', -2, 0)
			self.Castbar.Time:SetWidth(50)
			self.Castbar.Time:SetTextColor(1,1,1)
			self.Castbar.Time:SetJustifyH('RIGHT')
			
		--: BG :--
			self.Castbar.Bg = self.Castbar:CreateTexture(nil, 'BACKGROUND')
			self.Castbar.Bg:SetPoint('CENTER', self.Castbar)
			self.Castbar.Bg:SetWidth(302)
			self.Castbar.Bg:SetHeight(17)
			self.Castbar.Bg:SetTexture(statusbar)
			self.Castbar.Bg:SetVertexColor(0.05, 0.05, 0.05, 0.9)
		end
end

----------------------------------------------------------------------
--||TARGETTARGET||----------------------------------||TARGETTARGET||--

local cToTarget = function(self)
	if cToTarget == true then
		self:SetSize(78, 17)

	--:: BACKGROUND ::--
	
		Back = CreateFrame('Frame', nil, self)
		Back:SetPoint('TOPRIGHT', self)
		Back:SetPoint('TOPLEFT', self)
		Back:SetFrameStrata('BACKGROUND')
		Back:SetBackdrop(backdrop)
		Back:SetBackdropColor(0.05, 0.05, 0.05)
		Back:SetHeight(22)
		
	--:: HEALTH ::--
	
		--: BAR :--
		self.Health = CreateFrame('StatusBar', nil, self)
		self.Health:SetBackdrop(statusback)
		self.Health:SetBackdropColor(0.18,0.18,0.18)
		self.Health:SetFrameStrata('LOW')
		self.Health:SetPoint('TOPRIGHT', self)
		self.Health:SetPoint('TOPLEFT', self)
		self.Health:SetStatusBarTexture(statusbar)
		self.Health:SetStatusBarColor(0.28,0.28,0.28)
		self.Health.frequentUpdates = FreqUpdate
		self.Health.Smooth = cSmooth
		self.Health:SetHeight(17)
		self.Health.colorClass = true
	
	--:: POWER ::--
	
		--: BAR :--
		self.Power = CreateFrame('StatusBar', nil, self)
		self.Power:SetBackdrop(statusback)
		self.Power:SetBackdropColor(0.165,0.165,0.165)
		self.Power:SetFrameStrata('LOW')
		self.Power:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', 0, -1)
		self.Power:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, -1)
		self.Power:SetStatusBarTexture(statusbar)
		self.Power:SetStatusBarColor(0.28,0.28,0.28)
		self.Power.frequentUpdates = FreqUpdate
		self.Power.Smooth = cSmooth
		self.Power:SetHeight(4)
		self.Power.colorClass = false
		
	--:: NAME ::--
	
		self.Info = self.Health:CreateFontString(nil, 'OVERLAY')
		self.Info:SetShadowOffset(1, -1)
		self.Info:SetAlpha(1)
		self.Info:SetFont(font, 10, '')
		self:Tag(self.Info,'[name]' )
		self.Info:SetJustifyH('CENTER')
		self.Info:SetPoint('CENTER',self)
			
		--: RAIDS ICONS :--
		createRaidIcon(self)
			self.RaidIcon:SetPoint("CENTER", self.Health, "CENTER", 0, 9)
	end
end
		
----------------------------------------------------------------------
--||TARGETTARGETTARGET||----------------------||TARGETTARGETTARGET||--

local cToToTarget = function(self)
	if cToToTarget == true then
		self:SetSize(78, 17)

	--:: BACKGROUND ::--
	
		Back = CreateFrame('Frame', nil, self)
		Back:SetPoint('TOPRIGHT', self)
		Back:SetPoint('TOPLEFT', self)
		Back:SetFrameStrata('BACKGROUND')
		Back:SetBackdrop(backdrop)
		Back:SetBackdropColor(0.05, 0.05, 0.05)
		Back:SetHeight(10)
		
	--:: HEALTH ::--
	
		--: BAR :--
		self.Health = CreateFrame('StatusBar', nil, self)
		self.Health:SetBackdrop(statusback)
		self.Health:SetBackdropColor(0.18,0.18,0.18)
		self.Health:SetFrameStrata('LOW')
		self.Health:SetPoint('TOPRIGHT', self)
		self.Health:SetPoint('TOPLEFT', self)
		self.Health:SetStatusBarTexture(statusbar)
		self.Health:SetStatusBarColor(0.28,0.28,0.28)
		self.Health.frequentUpdates = FreqUpdate
		self.Health.Smooth = cSmooth
		self.Health:SetHeight(10)
		self.Health.colorClass = true

	--:: NAME ::--
	
		self.Info = self.Health:CreateFontString(nil, 'OVERLAY')
		self.Info:SetShadowOffset(1, -1)
		self.Info:SetAlpha(1)
		self.Info:SetFont(font, 8, '')
		self:Tag(self.Info,'[name]' )
		self.Info:SetJustifyH('CENTER')
		self.Info:SetPoint('CENTER',self.Health, 'CENTER')
	end
end
					
----------------------------------------------------------------------
--||PET||----------------------------------------------------||PET||--

local cPet = function(self)
		self:SetSize(95, 20)

	--:: BACKGROUND ::--
	
		Back = CreateFrame('Frame', nil, self)
		Back:SetPoint('TOPRIGHT', self)
		Back:SetPoint('TOPLEFT', self)
		Back:SetFrameStrata('BACKGROUND')
		Back:SetBackdrop(backdrop)
		Back:SetBackdropColor(0.05, 0.05, 0.05)
		Back:SetHeight(35)
		
	--:: HEALTH ::--
	
		--: BAR :--
		self.Health = CreateFrame('StatusBar', nil, self)
		self.Health:SetBackdrop(statusback)
		self.Health:SetBackdropColor(0.18,0.18,0.18)
		self.Health:SetFrameStrata('LOW')
		self.Health:SetPoint('TOPRIGHT', self)
		self.Health:SetPoint('TOPLEFT', self)
		self.Health:SetStatusBarTexture(statusbar)
		self.Health:SetStatusBarColor(0.28,0.28,0.28)
		self.Health.frequentUpdates = FreqUpdate
		self.Health.Smooth = cSmooth
		self.Health:SetHeight(20)
		self.Health.colorClass = false

		--: TEXT NUM :--
		self.Health.Text = self.Health:CreateFontString(nil, 'OVERLAY') 
		self.Health.Text:SetFont(font, 8, 'THINOUTLINE')
		self:Tag(self.Health.Text,'[My_CurHP] / [My_MaxHP]|r')
		self.Health.Text:SetShadowOffset(1, -1) 
		self.Health.Text.frequentUpdates = FreqUpdate
		self.Health.Text:SetJustifyH('RIGHT')
		self.Health.Text:SetPoint('TOPRIGHT',self.Health,'BOTTOMRIGHT', 0, -9)
		
		-- TEXT PERCENT --
		self.Health.Text = self.Health:CreateFontString(nil, 'OVERLAY') 
		self.Health.Text:SetFont(font, 8, 'THINOUTLINE')
		self.Health.Text:SetShadowOffset(1, -1) 
		self.Health.Text.frequentUpdates = FreqUpdate
		self:Tag(self.Health.Text,'[My_PerHP]|r')
		self.Health.Text:SetJustifyH('CENTER')
		self.Health.Text:SetPoint('RIGHT',self, -30, 9)
	
	--:: POWER ::--
	
		--: BAR :--
		self.Power = CreateFrame('StatusBar', nil, self)
		self.Power:SetBackdrop(statusback)
		self.Power:SetBackdropColor(0.165,0.165,0.165)
		self.Power:SetFrameStrata('LOW')
		self.Power:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', 0, -1)
		self.Power:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, -1)
		self.Power:SetStatusBarTexture(statusbar)
		self.Power:SetStatusBarColor(0.28,0.28,0.28)
		self.Power.frequentUpdates = FreqUpdate
		self.Power.Smooth = cSmooth
		self.Power:SetHeight(6)
		self.Power.colorClass = true
		
		--: TEXT :--
		self.Power.Text = self.Health:CreateFontString(nil, 'OVERLAY') 
		self.Power.Text:SetFont(font, 8, 'THINOUTLINE')
		self.Power.Text:SetShadowOffset(1, -1) 
		self.Power.Text.frequentUpdates = FreqUpdate
		self:Tag(self.Power.Text,'[raidcolor] [curpp]|r')
		self.Power.Text:SetJustifyH('LEFT')
		self.Power.Text:SetPoint('TOPLEFT',self.Health,'BOTTOMLEFT', 0, -9)
	
	--:: NAME ::--
	
		self.Info = self.Health:CreateFontString(nil, 'OVERLAY')
		self.Info:SetShadowOffset(1, -1)
		self.Info:SetFont(font, 16, 'THINOUTLINE')
		self:Tag(self.Info,'[raidcolor] [name]' )
		self.Info:SetJustifyH('RIGHT')
		self.Info:SetPoint('TOPRIGHT',self.Power,'BOTTOMRIGHT', 0, -15)
		
	--:: BLANK BAR ::--
	
		self.Blank = CreateFrame('StatusBar', nil, self)
		self.Blank:SetFrameStrata('LOW')
		self.Blank:SetPoint('TOPRIGHT', self.Power, 'BOTTOMRIGHT', 0, -1)
		self.Blank:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -1)
		self.Blank:SetStatusBarTexture(statusbar)
		self.Blank:SetHeight(7)
		
	--:: THREAT BAR ::--
	
		self.Threat = self.Blank:CreateTexture(nil, "OVERLAY")
		self.Threat:SetAllPoints()
		self.Threat:SetTexture(statusbar)
		self.Threat:SetAlpha(0.5)
		self.Threat:SetVertexColor(0.47,0.4,0.4)
		self.Threat.frequentUpdates = FreqUpdate
			
		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", check_threat)		

	--:: CASTBAR ::--

		--: BAR :--
		self.Castbar = CreateFrame('StatusBar', nil, self)
		self.Castbar:SetFrameStrata('MEDIUM')
		self.Castbar:SetFrameLevel(10)
		self.Castbar:SetWidth(95)
		self.Castbar:SetHeight(6)
		self.Castbar:SetPoint("CENTER", self.Power, "CENTER")
		self.Castbar:SetStatusBarTexture(statusbar)
		self.Castbar:SetStatusBarColor(0.8, 0.8, 0.8, 0.5)
		
		--: SAFEZONE :--
		self.Castbar.SafeZone = self.Castbar:CreateTexture(nil,'ARTWORK')
		self.Castbar.SafeZone:SetTexture(statusbar)
		self.Castbar.SafeZone:SetVertexColor(0.7, 0, 0 ,0.5)
		self.Castbar.SafeZone:SetPoint('LEFT', self.Castbar, 'LEFT')

		--: TEXT :--
		self.Castbar.Text = self.Castbar:CreateFontString(nil, 'OVERLAY')
		self.Castbar.Text:SetFont(font, 8, '')
		self.Castbar.Text:SetPoint('BOTTOMLEFT', self.Castbar,'TOPLEFT', 2, -4)
		self.Castbar.Text:SetWidth(200)
		self.Castbar.Text:SetTextColor(1,1,1)
		self.Castbar.Text:SetJustifyH('LEFT')

		--: TIME :--
		self.Castbar.Time = self.Castbar:CreateFontString(nil, 'OVERLAY') 
		self.Castbar.Time:SetFont(font, 8, '')
		self.Castbar.Time:SetPoint('BOTTOMRIGHT', self.Castbar,'TOPRIGHT', -2, -4)
		self.Castbar.Time:SetShadowOffset(1, -1) 
		self.Castbar.Time:SetWidth(50)
		self.Castbar.Time:SetTextColor(1,1,1)
		self.Castbar.Time:SetJustifyH('RIGHT')
end	
			
----------------------------------------------------------------------
--||PETTARGET||----------------------------------------||PETTARGET||--

local cPetTarget = function(self)
		self:SetSize(95, 17)

	--:: BACKGROUND ::--
	
		Back = CreateFrame('Frame', nil, self)
		Back:SetPoint('TOPRIGHT', self)
		Back:SetPoint('TOPLEFT', self)
		Back:SetFrameStrata('BACKGROUND')
		Back:SetBackdrop(backdrop)
		Back:SetBackdropColor(0.05, 0.05, 0.05)
		Back:SetHeight(10)
		
	--:: HEALTH ::--
	
		--: BAR :--
		self.Health = CreateFrame('StatusBar', nil, self)
		self.Health:SetBackdrop(statusback)
		self.Health:SetBackdropColor(0.18,0.18,0.18)
		self.Health:SetFrameStrata('LOW')
		self.Health:SetPoint('TOPRIGHT', self)
		self.Health:SetPoint('TOPLEFT', self)
		self.Health:SetStatusBarTexture(statusbar)
		self.Health:SetStatusBarColor(0.28,0.28,0.28)
		self.Health.frequentUpdates = FreqUpdate
		self.Health.Smooth = cSmooth
		self.Health:SetHeight(10)
		self.Health.colorClass = true

	--:: NAME ::--
	
		self.Info = self.Health:CreateFontString(nil, 'OVERLAY')
		self.Info:SetShadowOffset(1, -1)
		self.Info:SetAlpha(1)
		self.Info:SetFont(font, 8, '')
		self:Tag(self.Info,'[name]' )
		self.Info:SetJustifyH('CENTER')
		self.Info:SetPoint('CENTER',self.Health,'CENTER')
end
			
----------------------------------------------------------------------
--||FOCUS||------------------------------------------------||FOCUS||--

local cFocus = function(self)
	if cFocus == true then
		self:SetSize(78, 17)

	--:: BACKGROUND ::--
	
		Back = CreateFrame('Frame', nil, self)
		Back:SetPoint('TOPRIGHT', self)
		Back:SetPoint('TOPLEFT', self)
		Back:SetFrameStrata('BACKGROUND')
		Back:SetBackdrop(backdrop)
		Back:SetBackdropColor(0.05, 0.05, 0.05)
		Back:SetHeight(22)
		
	--:: HEALTH ::--
	
		--: BAR :--
		self.Health = CreateFrame('StatusBar', nil, self)
		self.Health:SetBackdrop(statusback)
		self.Health:SetBackdropColor(0.18,0.18,0.18)
		self.Health:SetFrameStrata('LOW')
		self.Health:SetPoint('TOPRIGHT', self)
		self.Health:SetPoint('TOPLEFT', self)
		self.Health:SetStatusBarTexture(statusbar)
		self.Health:SetStatusBarColor(0.28,0.28,0.28)
		self.Health.frequentUpdates = FreqUpdate
		self.Health.Smooth = cSmooth
		self.Health:SetHeight(17)
		self.Health.colorClass = true
			
	--:: POWER ::--
	
		--: BAR :--
		self.Power = CreateFrame('StatusBar', nil, self)
		self.Power:SetBackdrop(statusback)
		self.Power:SetBackdropColor(0.165,0.165,0.165)
		self.Power:SetFrameStrata('LOW')
		self.Power:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', 0, -1)
		self.Power:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, -1)
		self.Power:SetStatusBarTexture(statusbar)
		self.Power:SetStatusBarColor(0.28,0.28,0.28)
		self.Power.frequentUpdates = FreqUpdate
		self.Power.Smooth = cSmooth
		self.Power:SetHeight(4)
		self.Power.colorClass = false
		
	--:: NAME ::--
	
		self.Info = self.Health:CreateFontString(nil, 'OVERLAY')
		self.Info:SetShadowOffset(1, -1)
		self.Info:SetAlpha(1)
		self.Info:SetFont(font, 10, '')
		self:Tag(self.Info,'[name]' )
		self.Info:SetJustifyH('CENTER')
		self.Info:SetPoint('CENTER',self)
			
		--: RAIDS ICONS :--
		createRaidIcon(self)
			self.RaidIcon:SetPoint("CENTER", self.Health, "CENTER", 0, 9)
	end
end

----------------------------------------------------------------------
--||FOCUSTARGET||------------------------------------||FOCUSTARGET||--

local cFocusTarget = function(self)
	if cFocusTarget == true then
		self:SetSize(78, 17)

	--:: BACKGROUND ::--
	
		Back = CreateFrame('Frame', nil, self)
		Back:SetPoint('TOPRIGHT', self)
		Back:SetPoint('TOPLEFT', self)
		Back:SetFrameStrata('BACKGROUND')
		Back:SetBackdrop(backdrop)
		Back:SetBackdropColor(0.05, 0.05, 0.05)
		Back:SetHeight(10)
		
	--:: HEALTH ::--
	
		--: BAR :--	
		self.Health = CreateFrame('StatusBar', nil, self)
		self.Health:SetBackdrop(statusback)
		self.Health:SetBackdropColor(0.18,0.18,0.18)
		self.Health:SetFrameStrata('LOW')
		self.Health:SetPoint('TOPRIGHT', self)
		self.Health:SetPoint('TOPLEFT', self)
		self.Health:SetStatusBarTexture(statusbar)
		self.Health:SetStatusBarColor(0.28,0.28,0.28)
		self.Health.frequentUpdates = FreqUpdate
		self.Health.Smooth = cSmooth
		self.Health:SetHeight(10)
		self.Health.colorClass = true

	--:: NAME ::--
	
		self.Info = self.Health:CreateFontString(nil, 'OVERLAY')
		self.Info:SetShadowOffset(1, -1)
		self.Info:SetAlpha(1)
		self.Info:SetFont(font, 8, '')
		self:Tag(self.Info,'[name]' )
		self.Info:SetJustifyH('CENTER')
		self.Info:SetPoint('CENTER',self.Health, 'CENTER')
	end
end

-----------------------
--/ SPECIFIC LAYOUT \--
-----------------------

local UnitSpecific = {
	player = function(self, ...)
		Shared(self, ...)		
		cPlayer(self)	
	end,
	target = function(self, ...)
		Shared(self, ...)		
		cTarget(self)
	end,
	targettarget = function(self, ...)
		Shared(self, ...)		
		cToTarget(self)
	end,
	targettargettarget = function(self, ...)
		Shared(self, ...)		
		cToToTarget(self)
	end,
	pet = function(self, ...)
		Shared(self, ...)		
		cPet(self)
	end,
	pettarget = function(self, ...)
		Shared(self, ...)		
		cPetTarget(self)
	end,
	focus = function(self, ...)
		Shared(self, ...)		
		cFocus(self)
	end,
	focustarget = function(self, ...)
		Shared(self, ...)		
		cFocusTarget(self)
	end,
}
---------------------------------------
-- register style(s) and spawn units --
---------------------------------------
oUF:RegisterStyle("Chronos", Shared)
for unit,layout in next, UnitSpecific do
	-- Capitalize the unit name, so it looks better.
	oUF:RegisterStyle('Chronos - ' .. unit:gsub("^%l", string.upper), layout)
end

-- A small helper to change the style into a unit specific, if it exists.
local spawnHelper = function(self, unit, ...)
	if(UnitSpecific[unit]) then
		self:SetActiveStyle('Chronos - ' .. unit:gsub("^%l", string.upper))
		local object = self:Spawn(unit)
		object:SetPoint(...)
		return object
	else
		self:SetActiveStyle'Chronos'
		local object = self:Spawn(unit)
		object:SetPoint(...)
		return object
	end
end

oUF:Factory(function(self)
	local player = spawnHelper(self, 'player', "CENTER", -275, -153)
	local target = spawnHelper(self, 'target', "CENTER", 275, -153)
	local targettarget = spawnHelper(self, 'targettarget', "CENTER", 354, -120)
	local targettargettarget = spawnHelper(self, 'targettargettarget', "CENTER", 354, -105)
	local pet = spawnHelper(self, 'pet', "CENTER", -450, -153)
	local pettarget = spawnHelper(self, 'pettarget', "CENTER", -450, -133)
	local focus = spawnHelper(self, 'focus', "CENTER", -354, -120)
	local focustarget = spawnHelper(self, 'focustarget', "CENTER", -354, -105)
end)

oUF:DisableBlizzard('party')
