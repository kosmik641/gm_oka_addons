----------------------------------------------------------------------------------------
-- Скрипт для инжекта дополнений для 81-760 (для обновления 2022 года)
----------------------------------------------------------------------------------------
-- Вэн, 2022
-- Made by Ven, 2022
-- DS: Вэн#2254
-- Steam: https://steamcommunity.com/id/kosmik641/
----------------------------------------------------------------------------------------
if Metrostroi.Version < 1623941696 then return end

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
	Train.Lights[5] = {"headlight",Vector(513,0,-39),Angle(0,0,0),Color(216,161,92),farz=5144,brightness = 4, fov=100, texture = "models/metrostroi_train/equipment/headlight",shadows = 1,headlight=true}
	Train.Lights[6]  = { "light",Vector(513,-34.8,-39), Angle(0,0,0), Color(255,220,180), brightness = 0.3, scale = 2.5, texture = "sprites/light_glow02", size = 2}
    Train.Lights[7]  = { "light",Vector(513, 34.8,-39), Angle(0,0,0), Color(255,220,180), brightness = 0.3, scale = 2.5, texture = "sprites/light_glow02", size = 2}

	-- Красные фонари
	Train.Lights[16] = { "light",Vector(513,-45.5,-37.7), Angle(0,0,0), Color(255,50,50), brightness = 0.2, scale = 1, texture = "sprites/light_glow02", size=2} -- Левый нижний
    Train.Lights[17] = { "light",Vector(513, 45.5,-37.7), Angle(0,0,0), Color(255,50,50), brightness = 0.2, scale = 1, texture = "sprites/light_glow02", size=2} -- Правый нижний
	Train.Lights[18] = { "light",Vector(495,-44.6, 59.7), Angle(0,0,0), Color(255,50,50), brightness = 0.2, scale = 1, texture = "sprites/light_glow02", size=2} -- Левый верхний
    Train.Lights[19] = { "light",Vector(495, 44.6, 59.7), Angle(0,0,0), Color(255,50,50), brightness = 0.2, scale = 1, texture = "sprites/light_glow02", size=2} -- Правый верхний

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
		
		-- Свечение красных фар
		local RL = self.Anims["backlights4"].value
		self:SetLightPower(16,RL > 0,RL)
		self:SetLightPower(17,RL > 0,RL)
		self:SetLightPower(18,RL > 0,RL)
		self:SetLightPower(19,RL > 0,RL)

		-- Управляем фарами
		self:ShowHide("HalogenHeadlights",halogen)
		if halogen then
			self:SetLightPower(1,false,0)
			self:SetLightPower(2,false,0)
			self:SetLightPower(3,false,0)
			self:ShowHideSmooth("HeadLights0",0)
			self:ShowHideSmooth("HeadLights1",0)
			self:ShowHideSmooth("HeadLights2",0)
			
			local headl = self.Anims["headlights1"].value*0.5 + self.Anims["headlights2"].value
			self:SetLightPower(5,headl > 0,headl)
			self:SetLightPower(6,headl > 0,headl^0.5)
			self:SetLightPower(7,headl > 0,headl^0.5)
			self:ShowHideSmooth("HalogenHeadlights0", self.Anims["headlights0"].value*1.12)
			self:ShowHideSmooth("HalogenHeadlights1", self.Anims["headlights1"].value*1.12)
			self:ShowHideSmooth("HalogenHeadlights2", self.Anims["headlights2"].value*1.12)
		else
			self:SetLightPower(5,false,0)
			self:SetLightPower(6,false,0)
			self:SetLightPower(7,false,0)
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

	-- Красные фонари
	Train.Lights[16] = { "light",Vector(513,-45.5,-37.7), Angle(0,0,0), Color(255,50,50), brightness = 0.2, scale = 1, texture = "sprites/light_glow02", size=2} -- Левый нижний
    Train.Lights[17] = { "light",Vector(513, 45.5,-37.7), Angle(0,0,0), Color(255,50,50), brightness = 0.2, scale = 1, texture = "sprites/light_glow02", size=2} -- Правый нижний
	Train.Lights[18] = { "light",Vector(495,-44.6, 59.7), Angle(0,0,0), Color(255,50,50), brightness = 0.2, scale = 1, texture = "sprites/light_glow02", size=2} -- Левый верхний
    Train.Lights[19] = { "light",Vector(495, 44.6, 59.7), Angle(0,0,0), Color(255,50,50), brightness = 0.2, scale = 1, texture = "sprites/light_glow02", size=2} -- Правый верхний

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
		
		-- Свечение красных фар
		local RL = self.Anims["backlights4"].value
		self:SetLightPower(16,RL > 0,RL)
		self:SetLightPower(17,RL > 0,RL)
		self:SetLightPower(18,RL > 0,RL)
		self:SetLightPower(19,RL > 0,RL)
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

timer.Simple(1,function()
	sharedInject()
	if CLIENT then clientInject() end
	if SERVER then
		resource.AddWorkshop("1925235871")
	end
end)