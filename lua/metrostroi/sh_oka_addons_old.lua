----------------------------------------------------------------------------------------
-- Скрипт для инжекта дополнений для 81-760 (для обновления 2018 года)
----------------------------------------------------------------------------------------
-- Вэн, 2022
-- Made by Ven, 2022
-- DS: Вэн#2254
-- Steam: https://steamcommunity.com/id/kosmik641/
----------------------------------------------------------------------------------------
if Metrostroi.Version > 1537278077 then return end

hook.Add("MetrostroiLoaded","760AddonConfLoad",function()
	Metrostroi.AddPassSchemeTex("760_advert","Blank",{"metrostroi_skins/81-760_adverts/int_advert_blank"})
	Metrostroi.AddPassSchemeTex("760_advert","81-760 Logo",{"metrostroi_skins/81-760_adverts/int_advert"})
end)

local function sharedInject()
	local Train = scripted_ents.GetStored("gmod_subway_81-760").t

	-- Проверяем наличие инжекта
	local trainSpawner760Updated = false
	for i=1,#Train.Spawner do
		if Train.Spawner[i][1] == "Adverts" then
			trainSpawner760Updated = true
			break
		end
	end

	if not trainSpawner760Updated then
		table.insert(Train.Spawner,{ --Добавляем недостающий пункт
			[1] = "Adverts", --Передаваемая переменная
			[2] = GetConVarString("metrostroi_language") == "ru" and "Реклама в салоне" or "Adverts", --Для перевода
			[3] = "List", --Тип
			[4] = function()
				local Adverts = {}
				for k,v in pairs(Metrostroi.Skins["760_advert_schemes"] or {}) do
					Adverts[k] = v.name or k
				end
				return Adverts
			end -- Возвращаем список в спавнер
		})
		table.insert(Train.Spawner,{ --Добавляем недостающий пункт
			[1] = "Halogen", --Передаваемая переменная
			[2] = GetConVarString("metrostroi_language") == "ru" and "Галогенные фары" or "Old headlight", --Для перевода
			[3] = "Boolean", --Тип
		})
	end

	local Train = scripted_ents.GetStored("gmod_subway_81-760a").t

	-- Проверяем наличие инжекта
	local trainSpawner760aUpdated = false
	for i=1,#Train.Spawner do
		if Train.Spawner[i][1] == "Adverts" then
			trainSpawner760aUpdated = true
			break
		end
	end

	if not trainSpawner760aUpdated then
		table.insert(Train.Spawner,{ --Добавляем недостающий пункт
			[1] = "Adverts", --Передаваемая переменная
			[2] = GetConVarString("metrostroi_language") == "ru" and "Реклама в салоне" or "Adverts", --Для перевода
			[3] = "List", --Тип
			[4] = function()
				local Adverts = {}
				for k,v in pairs(Metrostroi.Skins["760_advert_schemes"] or {}) do
					Adverts[k] = v.name or k
				end
				return Adverts
			end -- Возвращаем список в спавнер
		})
		-- Галогенок на баклажан не будет
	end
end

local function clientInject()
	--------------------------------------------------
	-- 81-760
	--------------------------------------------------
	local Train = scripted_ents.GetStored("gmod_subway_81-760").t

	-- Client props
	Train.ClientProps["Advert"] = {
		model = "models/metrostroi_train/81-760/81_760_advert.mdl",
		pos = Vector(0,0,0),
		ang = Angle(0,0,0),
		hide = 2
	}
	Train.ClientProps["HalogenHeadlights"] = {
		model = "models/metrostroi_train/81-760/81_760_headlamps_old.mdl",
		pos = Vector(0,0,0),
		ang = Angle(0,0,0),
		nohide = true
	}

	Train.ClientProps["HalogenHeadlights0"] = {
		model = "models/metrostroi_train/81-760/81_760_headlamps_old_off.mdl",
		pos = Vector(0.16,0,0),
		ang = Angle(0,0,0),
		nohide = true
	}
	Train.ClientProps["HalogenHeadlights1"] = {
		model = "models/metrostroi_train/81-760/81_760_headlamps_old_g1.mdl",
		pos = Vector(0.16,0,0),
		ang = Angle(0,0,0),
		nohide = true
	}
	Train.ClientProps["HalogenHeadlights2"] = {
		model = "models/metrostroi_train/81-760/81_760_headlamps_old_g2.mdl",
		pos = Vector(0.16,0,0),
		ang = Angle(0,0,0),
		nohide = true
	}

	-- Фары
	Train.Lights[4] = {"headlight",Vector(513,0,-39),Angle(0,0,0),Color(216,161,92),farz=5144,brightness = 4, fov=100, texture = "models/metrostroi_train/equipment/headlight",shadows = 1,headlight=true}

	Train.UpdateTextures_Old_OkaAddons = Train.UpdateTextures_Old_OkaAddons or Train.UpdateTextures
	function Train:UpdateTextures()
		self:UpdateTextures_Old_OkaAddons()
		self.Advert = self:GetNW2Int("Adverts")
		local advModel = self.ClientEnts["Advert"]
		if IsValid(advModel) and Metrostroi.Skins["760_advert_schemes"] and Metrostroi.Skins["760_advert_schemes"][self.Advert] then
			local adv = Metrostroi.Skins["760_advert_schemes"][self.Advert]
			advModel:SetSubMaterial(0,adv[1])
		end
	end

	Train.Think_Old_OkaAddons = Train.Think_Old_OkaAddons or Train.Think
	function Train:Think()
		-- Выключаем датчик света
		local halogen = self:GetNW2Bool("Halogen")
		if halogen then
			self.valTimer = CurTime()
			self.val = 0
		end

		-- Выполняем старый Think
		self:Think_Old_OkaAddons()
		if self.Advert ~= self:GetNW2Int("Adverts") then self:UpdateTextures() end

		-- Управляем фарами
		self:ShowHide("HalogenHeadlights",halogen)
		if halogen then
			self:SetLightPower(1,false,0)
			self:ShowHideSmooth("HeadLights0",0)
			self:ShowHideSmooth("HeadLights1",0)
			self:ShowHideSmooth("HeadLights2",0)
			
			local animHL0 = self.Anims["headlights0"] and self.Anims["headlights0"].value or 0
			local animHL1 = self.Anims["headlights1"] and self.Anims["headlights1"].value or 0
			local animHL2 = self.Anims["headlights2"] and self.Anims["headlights2"].value or 0
			local headl = animHL1*0.5 + animHL2
			self:SetLightPower(4,headl > 0,headl)
			
			self:ShowHideSmooth("HalogenHeadlights0", animHL0*1.12)
			self:ShowHideSmooth("HalogenHeadlights1", animHL1*1.12)
			self:ShowHideSmooth("HalogenHeadlights2", animHL2*1.12)
		else
			self:SetLightPower(4,false,0)
			self:ShowHideSmooth("HalogenHeadlights0",0)
			self:ShowHideSmooth("HalogenHeadlights1",0)
			self:ShowHideSmooth("HalogenHeadlights2",0)
		end
	end

	--------------------------------------------------
	-- 81-760A
	--------------------------------------------------
	local Train = scripted_ents.GetStored("gmod_subway_81-760a").t

	-- Client props
	Train.ClientProps["Advert"] = {
		model = "models/metrostroi_train/81-760/81_763_advert.mdl",
		pos = Vector(0,0,0),
		ang = Angle(0,0,0),
		hide = 2
	}

	Train.UpdateTextures_Old_OkaAddons = Train.UpdateTextures_Old_OkaAddons or Train.UpdateTextures
	function Train:UpdateTextures()
		self:UpdateTextures_Old_OkaAddons()
		self.Advert = self:GetNW2Int("Adverts")
		local advModel = self.ClientEnts["Advert"]
		if IsValid(advModel) and Metrostroi.Skins["760_advert_schemes"] and Metrostroi.Skins["760_advert_schemes"][self.Advert] then
			local adv = Metrostroi.Skins["760_advert_schemes"][self.Advert]
			advModel:SetSubMaterial(0,adv[1])
		end
	end

	Train.Think_Old_OkaAddons = Train.Think_Old_OkaAddons or Train.Think
	function Train:Think()
		-- Выполняем старый Think
		self:Think_Old_OkaAddons()
		if self.Advert ~= self:GetNW2Int("Adverts") then self:UpdateTextures() end
	end

	--------------------------------------------------
	-- 81-761
	--------------------------------------------------
	local Train = scripted_ents.GetStored("gmod_subway_81-761").t

	-- Client props
	Train.ClientProps["Advert"] = {
		model = "models/metrostroi_train/81-760/81_761_advert.mdl",
		pos = Vector(0,0,0),
		ang = Angle(0,0,0),
		hide = 2
	}

	Train.UpdateTextures_Old_OkaAddons = Train.UpdateTextures_Old_OkaAddons or Train.UpdateTextures
	function Train:UpdateTextures()
		self:UpdateTextures_Old_OkaAddons()
		self.Advert = self:GetNW2Int("Adverts")
		local advModel = self.ClientEnts["Advert"]
		if IsValid(advModel) and Metrostroi.Skins["760_advert_schemes"] and Metrostroi.Skins["760_advert_schemes"][self.Advert] then
			local adv = Metrostroi.Skins["760_advert_schemes"][self.Advert]
			advModel:SetSubMaterial(0,adv[1])
		end
	end

	Train.Think_Old_OkaAddons = Train.Think_Old_OkaAddons or Train.Think
	function Train:Think()
		-- Выполняем старый Think
		self:Think_Old_OkaAddons()
		if self.Advert ~= self:GetNW2Int("Adverts") then self:UpdateTextures() end
	end

	--------------------------------------------------
	-- 81-761A
	--------------------------------------------------
	local Train = scripted_ents.GetStored("gmod_subway_81-761a").t

	-- Client props
	Train.ClientProps["Advert"] = {
		model = "models/metrostroi_train/81-760/81_763_advert.mdl",
		pos = Vector(0,0,0),
		ang = Angle(0,0,0),
		hide = 2
	}

	Train.UpdateTextures_Old_OkaAddons = Train.UpdateTextures_Old_OkaAddons or Train.UpdateTextures
	function Train:UpdateTextures()
		self:UpdateTextures_Old_OkaAddons()
		self.Advert = self:GetNW2Int("Adverts")
		local advModel = self.ClientEnts["Advert"]
		if IsValid(advModel) and Metrostroi.Skins["760_advert_schemes"] and Metrostroi.Skins["760_advert_schemes"][self.Advert] then
			local adv = Metrostroi.Skins["760_advert_schemes"][self.Advert]
			advModel:SetSubMaterial(0,adv[1])
		end
	end

	Train.Think_Old_OkaAddons = Train.Think_Old_OkaAddons or Train.Think
	function Train:Think()
		-- Выполняем старый Think
		self:Think_Old_OkaAddons()
		if self.Advert ~= self:GetNW2Int("Adverts") then self:UpdateTextures() end
	end

	--------------------------------------------------
	-- 81-763A
	--------------------------------------------------
	local Train = scripted_ents.GetStored("gmod_subway_81-763a").t

	-- Client props
	Train.ClientProps["Advert"] = {
		model = "models/metrostroi_train/81-760/81_763_advert.mdl",
		pos = Vector(0,0,0),
		ang = Angle(0,0,0),
		hide = 2
	}

	Train.UpdateTextures_Old_OkaAddons = Train.UpdateTextures_Old_OkaAddons or Train.UpdateTextures
	function Train:UpdateTextures()
		self:UpdateTextures_Old_OkaAddons()
		self.Advert = self:GetNW2Int("Adverts")
		local advModel = self.ClientEnts["Advert"]
		if IsValid(advModel) and Metrostroi.Skins["760_advert_schemes"] and Metrostroi.Skins["760_advert_schemes"][self.Advert] then
			local adv = Metrostroi.Skins["760_advert_schemes"][self.Advert]
			advModel:SetSubMaterial(0,adv[1])
		end
	end

	Train.Think_Old_OkaAddons = Train.Think_Old_OkaAddons or Train.Think
	function Train:Think()
		-- Выполняем старый Think
		self:Think_Old_OkaAddons()
		if self.Advert ~= self:GetNW2Int("Adverts") then self:UpdateTextures() end
	end
end

local function serverInject()
	--------------------------------------------------
	-- 81-760
	--------------------------------------------------
	local Train = scripted_ents.GetStored("gmod_subway_81-760").t
	
	Train.Initialize_Old_OkaAddons = Train.Initialize_Old_OkaAddons or Train.Initialize
	function Train:Initialize()
		self:Initialize_Old_OkaAddons()
		-- Свечение галогенок
		self.Lights[3]  = { "light",Vector(513,-34.8,-39), Angle(0,0,0), Color(255,220,180), brightness = 0.3, scale = 2.5}
        self.Lights[4]  = { "light",Vector(513, 34.8,-39), Angle(0,0,0), Color(255,220,180), brightness = 0.3, scale = 2.5}

		-- Красные фонари
		self.Lights[5]  = { "light",Vector(513,-45.5,-37.7), Angle(0,0,0), Color(255,50,50), brightness = 0.2, scale = 1} -- Левый нижний
        self.Lights[6]  = { "light",Vector(513, 45.5,-37.7), Angle(0,0,0), Color(255,50,50), brightness = 0.2, scale = 1} -- Правый нижний
        self.Lights[7]  = { "light",Vector(495,-44.6, 59.7), Angle(0,0,0), Color(255,50,50), brightness = 0.2, scale = 1} -- Левый верхний
        self.Lights[8]  = { "light",Vector(495, 44.6, 59.7), Angle(0,0,0), Color(255,50,50), brightness = 0.2, scale = 1} -- Правый верхний
	end

	Train.Think_Old_OkaAddons = Train.Think_Old_OkaAddons or Train.Think
	function Train:Think()
		local retVal = self:Think_Old_OkaAddons()

		-- Свечение красных фар
		local RL = self.Panel.RedLights
		self:SetLightPower(5,RL > 0,RL)
		self:SetLightPower(6,RL > 0,RL)
		self:SetLightPower(7,RL > 0,RL)
		self:SetLightPower(8,RL > 0,RL)

		local halogen = self:GetNW2Bool("Halogen")
		if halogen then
			self:SetLightPower(1,false,0)
			self:SetLightPower(2,false,0)
			local HeadlightsPower = self.Panel.HeadlightsFull > 0 and 1 or self.Panel.HeadlightsHalf > 0 and 0.5 or 0
			self:SetLightPower(3,HeadlightsPower > 0,HeadlightsPower^0.5)
    		self:SetLightPower(4,HeadlightsPower > 0,HeadlightsPower^0.5)
		else
			self:SetLightPower(3,false,0)
			self:SetLightPower(4,false,0)
		end
		
		return retVal
	end

	--------------------------------------------------
	-- 81-760A
	--------------------------------------------------
	local Train = scripted_ents.GetStored("gmod_subway_81-760a").t
	
	Train.Initialize_Old_OkaAddons = Train.Initialize_Old_OkaAddons or Train.Initialize
	function Train:Initialize()
		self:Initialize_Old_OkaAddons()

		-- Красные фонари
		self.Lights[5]  = { "light",Vector(513,-45.5,-37.7), Angle(0,0,0), Color(255,50,50), brightness = 0.2, scale = 1} -- Левый нижний
        self.Lights[6]  = { "light",Vector(513, 45.5,-37.7), Angle(0,0,0), Color(255,50,50), brightness = 0.2, scale = 1} -- Правый нижний
        self.Lights[7]  = { "light",Vector(495,-44.6, 59.7), Angle(0,0,0), Color(255,50,50), brightness = 0.2, scale = 1} -- Левый верхний
        self.Lights[8]  = { "light",Vector(495, 44.6, 59.7), Angle(0,0,0), Color(255,50,50), brightness = 0.2, scale = 1} -- Правый верхний
	end

	Train.Think_Old_OkaAddons = Train.Think_Old_OkaAddons or Train.Think
	function Train:Think()
		local retVal = self:Think_Old_OkaAddons()

		-- Свечение красных фар
		local RL = self.Panel.RedLights
		self:SetLightPower(5,RL > 0,RL)
		self:SetLightPower(6,RL > 0,RL)
		self:SetLightPower(7,RL > 0,RL)
		self:SetLightPower(8,RL > 0,RL)
		
		return retVal
	end
end

timer.Simple(1,function()
	sharedInject()
	if CLIENT then clientInject() end
	if SERVER then
		resource.AddWorkshop("1925235871")
		serverInject()
	end
end)