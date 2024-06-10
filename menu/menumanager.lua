_G.DHMEndScreen = DHMEndScreen or {}
DHMEndScreen.path = ModPath
DHMEndScreen.save_path = SavePath .. "DHMEndScreen.txt"
DHMEndScreen.settings = {
	healmit_mit_enabled = true,
	healmit_dmg_enabled = true,
	healmit_heal_enabled = true,
	healmit_lang_value = 1
}
	
function DHMEndScreen:Save()
	local file = io.open(self.save_path,"w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

function DHMEndScreen:Load()
	local file = io.open(self.save_path, "r")
	if (file) then
		for k, v in pairs(json.decode(file:read("*all"))) do
			self.settings[k] = v
		end
	else
		self:Save()
	end
end

Hooks:Add("MenuManagerInitialize", "DHMEndScreen_MenuManagerInitialize", function(menu_manager)
	MenuCallbackHandler.healmit_lang_callback = function(self,item)
		local value = tonumber(item:value())
		DHMEndScreen.settings.healmit_lang_value = value
		DHMEndScreen:Save()
	end
	
	MenuCallbackHandler.healmit_dmg_callback = function(self,item) 
		local value = item:value() == "on"
		DHMEndScreen.settings.healmit_dmg_enabled = value 
		DHMEndScreen:Save()
	end
	
	MenuCallbackHandler.healmit_heal_callback = function(self,item) 
		local value = item:value() == "on"
		DHMEndScreen.settings.healmit_heal_enabled = value 
		DHMEndScreen:Save()
	end
	
	MenuCallbackHandler.healmit_mit_callback = function(self,item) 
		local value = item:value() == "on"
		DHMEndScreen.settings.healmit_mit_enabled = value 
		DHMEndScreen:Save()
	end
	
	MenuCallbackHandler.healmit_closed = function(self)
		DHMEndScreen:Save()
	end
	
	DHMEndScreen:Load()
	MenuHelper:LoadFromJsonFile(DHMEndScreen.path .. "menu/options.txt", DHMEndScreen, DHMEndScreen.settings)
end)

Hooks:Add("LocalizationManagerPostInit", "DHMEndScreen_LocalizationManagerPostInit", function(loc)
	DHMEndScreen:Load()
	local t = DHMEndScreen.path .. "loc/"
	if DHMEndScreen.settings.healmit_lang_value == 1 then
	    for _, filename in pairs(file.GetFiles(t)) do
		    local str = filename:match('^(.*).txt$')
		    if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
			    loc:load_localization_file(t .. filename)
			    return
		    end
	    end
	    loc:load_localization_file(t .. "english.txt")
	elseif DHMEndScreen.settings.healmit_lang_value == 2 then
		loc:load_localization_file(t .. "english.txt")
	elseif DHMEndScreen.settings.healmit_lang_value == 3 then
	    loc:load_localization_file(t .. "schinese.txt")
	end
end)