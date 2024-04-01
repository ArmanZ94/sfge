if CLIENT then
    local fg_enabled = CreateClientConVar("pp_filmgrain", "0", true, false)
    local fg_alpha = CreateClientConVar("pp_filmgrain_alpha", "4", true, false)
	local fg_addalpha = CreateClientConVar("pp_filmgrain_addalpha", "3", true, false)
	
	list.Set("PostProcess", "Film Grain", {
		icon = "gui/postprocess/sfge.jpg",
		convar = "pp_filmgrain",
		category = "#shaders_pp",
		cpanel = function(CPanel)
		
			local params = {
				Options = {},
              	CVars = {},
              	MenuButton = "1",
				Folder = "filmgrain"
			}

			params.Options["#preset.default"] = {
				pp_filmgrain_alpha = "4",
				pp_filmgrain_addalpha = "3"
			}	
	
			params.CVars = table.GetKeys(params.Options["#preset.default"])
			CPanel:AddControl("ComboBox", params)
	
			CPanel:AddControl("CheckBox", { 
				Label = "Enable", 
				Command = "pp_filmgrain" 
			})
			
			CPanel:AddControl("Slider", {
				Label = "Noise Transparency",
				Command = "pp_filmgrain_alpha",
				Type = "Integer",
				Min = "0",
				Max = "25"
			})
			
			CPanel:AddControl("Slider", {
				Label = "Noise Addition",
				Command = "pp_filmgrain_addalpha",
				Type = "Integer",
				Min = "0",
				Max = "25"
			})
		end
	})
	
	local NoiseTexture = Material("filmgrain/noise")
	local NoiseTexture2 = Material("filmgrain/noiseadd")
	--[[local NoiseTexture = Material(fg_texture:GetString())
	cvars.AddChangeCallback("pp_filmgrain_texture", function (_, __, ___)
		NoiseTexture:SetTexture("$basetexture", fg_texture:GetString())
	end)]]
	
    hook.Add("RenderScreenspaceEffects", "FilmGrain", function()
		if (!fg_enabled:GetBool()) then return end
        surface.SetMaterial(NoiseTexture)
        surface.SetDrawColor(255, 255, 255, fg_alpha:GetInt())
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
		
		surface.SetMaterial(NoiseTexture2)
        surface.SetDrawColor(255, 255, 255, fg_addalpha:GetInt()*10)
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    end)
end