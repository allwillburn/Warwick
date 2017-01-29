local ver = "0.01"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "Warwick" then return end


require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Warwick/master/Warwick.lua', SCRIPT_PATH .. 'Warwick.lua', function() PrintChat('<font color = "#00FFFF">Warwick Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No Warwick updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Warwick/master/Warwick.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local WarwickMenu = Menu("Warwick", "Warwick")

WarwickMenu:SubMenu("Combo", "Combo")

WarwickMenu.Combo:Boolean("Q", "Use Q in combo", true)
WarwickMenu.Combo:Boolean("W", "Use W in combo", true)
WarwickMenu.Combo:Boolean("E", "Use E in combo", true)
WarwickMenu.Combo:Boolean("R", "Use R in combo", true)
WarwickMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
WarwickMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
WarwickMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
WarwickMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
WarwickMenu.Combo:Boolean("RHydra", "Use RHydra", true)
WarwickMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
WarwickMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
WarwickMenu.Combo:Boolean("Randuins", "Use Randuins", true)


WarwickMenu:SubMenu("AutoMode", "AutoMode")
WarwickMenu.AutoMode:Boolean("Level", "Auto level spells", false)
WarwickMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
WarwickMenu.AutoMode:Boolean("Q", "Auto Q", false)
WarwickMenu.AutoMode:Boolean("W", "Auto W", false)
WarwickMenu.AutoMode:Boolean("E", "Auto E", false)
WarwickMenu.AutoMode:Boolean("R", "Auto R", false)

WarwickMenu:SubMenu("LaneClear", "LaneClear")
WarwickMenu.LaneClear:Boolean("Q", "Use Q", true)
WarwickMenu.LaneClear:Boolean("W", "Use W", true)
WarwickMenu.LaneClear:Boolean("E", "Use E", true)
WarwickMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
WarwickMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

WarwickMenu:SubMenu("Harass", "Harass")
WarwickMenu.Harass:Boolean("Q", "Use Q", true)
WarwickMenu.Harass:Boolean("W", "Use W", true)

WarwickMenu:SubMenu("KillSteal", "KillSteal")
WarwickMenu.KillSteal:Boolean("Q", "KS w Q", true)
WarwickMenu.KillSteal:Boolean("E", "KS w E", true)

WarwickMenu:SubMenu("AutoIgnite", "AutoIgnite")
WarwickMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

WarwickMenu:SubMenu("Drawings", "Drawings")
WarwickMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

WarwickMenu:SubMenu("SkinChanger", "SkinChanger")
WarwickMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
WarwickMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)

	--AUTO LEVEL UP
	if WarwickMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if WarwickMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 700) then
				if target ~= nil then 
                                      CastTargetSpell(target, _Q)
                                end
            end

            if WarwickMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 700) then
				CastSpell(_W)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
            if WarwickMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if WarwickMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if WarwickMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if WarwickMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if WarwickMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 700) then
			 CastSpell(_E)
	    end

            if WarwickMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 700) then
				if target ~= nil then 
                                      CastTargetSpell(target, _Q)
                                end
              end

            if WarwickMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if WarwickMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if WarwickMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	    if WarwickMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 700) then
			CastSpell(_W)
	    end
	    
	    
            if WarwickMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 700) and (EnemiesAround(myHeroPos(), 700) >= WarwickMenu.Combo.RX:Value()) then
			CastSkillShot(_R, target)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 700) and WarwickMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                      CastTargetSpell(target, _Q)
		         end
                end 

                if IsReady(_E) and ValidTarget(enemy, 187) and WarwickMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastSpell(_E)
  
                end
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if WarwickMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 700) then
	        	CastTargetSpell(closeminion, _Q)
                end

                if WarwickMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 700) then
	        	CastSpell(_W)
	        end

                if WarwickMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 187) then
	        	CastSpell(_E)
	        end

                if WarwickMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if WarwickMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if WarwickMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 700) then
		      CastTargetSpell(target, _Q)
          end
        end 
        if WarwickMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 700) then
	  	      CastSpell(_W)
          end
        end
        if WarwickMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 125) then
		      CastSpell(_E)
	  end
        end
        if WarwickMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 700) then
		      CastSpell(_R)
	  end
        end
                
	--AUTO GHOST
	if WarwickMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if WarwickMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 700, 0, 200, GoS.Red)
	end

end)





local function SkinChanger()
	if WarwickMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Warwick</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





