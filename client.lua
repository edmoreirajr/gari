Citizen.CreateThread(function()
	local blip_gari = AddBlipForCoord(1384.20,-2079.79,52.19)
	SetBlipSprite (blip_gari, 318)
	SetBlipColour (blip_gari, 51)
	SetBlipAsShortRange(blip_gari, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Central dos Garis')
	EndTextCommandSetBlipName(blip_gari)
end)

------------------------------------------------------------------------------------------------------------------------------------------
-- INICIANDO ESX
-----------------------------------------------------------------------------------------------------------------------------------------
ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS DE LIMPEZA
-----------------------------------------------------------------------------------------------------------------------------------------
local locs = {
	[1] = { ['x'] = 162.32, ['y'] = -988.75, ['z'] = 30.1 },
	[2] = { ['x'] = 222.16, ['y'] = -984.86, ['z'] = 29.27 },
	[3] = { ['x'] = 162.8, ['y'] = -913.1, ['z'] = 30.22 },
	[4] = { ['x'] = 228.73, ['y'] = -892.21, ['z'] = 30.69 },
	[5] = { ['x'] = 142.84, ['y'] = -950.08, ['z'] = 29.72 },
	[6] = { ['x'] = 128.56, ['y'] = -987.9, ['z'] = 29.31 },
	[7] = { ['x'] = 187.47, ['y'] = -1007.57, ['z'] = 29.32 },
	[8] = { ['x'] = 209.91, ['y'] = -1022.84, ['z'] = 29.37 },
	[9] = { ['x'] = 239.59, ['y'] = -939.9, ['z'] = 29.28 },
	[10] = { ['x'] = 247.06, ['y'] = -881.84, ['z'] = 30.05 },
	[11] = { ['x'] = 202.13, ['y'] = -921.1, ['z'] = 30.69 },
	[12] = { ['x'] = 191.1, ['y'] = -855.41, ['z'] = 31.33 },
	[13] = { ['x'] = 138.47, ['y'] = -991.33, ['z'] = 29.36 }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = nil
local selecionado = 0
local emservico = false
local CoordenadaX = 1384.20
local CoordenadaY = -2079.79
local CoordenadaZ = 52.19
local vassoumodel = "prop_tool_broom"

-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local ped = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(ped))
		local bowz,cdz = GetGroundZFor_3dCoord(CoordenadaX,CoordenadaY,CoordenadaZ)
		local distance = GetDistanceBetweenCoords(CoordenadaX,CoordenadaY,cdz,x,y,z,true)

		if not emservico then
			if distance <= 20 then
				DrawMarker(21,CoordenadaX,CoordenadaY,CoordenadaZ-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,0,0,50,0,0,0,1)
				if distance <= 3 then
					drawTxt("PRESSIONE  ~r~E~w~  PARA INICIAR O EXPEDIENTE",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) then
						--emP.addGroup()
						emservico = true
						selecionado = math.random(#locs)
						CriandoBlip(locs,selecionado)
						ApplyGariSkin()
						ESX.ShowNotification('~y~Você entrou em serviço.')
					end
				end
			end
		else
			if distance <= 20 then
				DrawMarker(21,CoordenadaX,CoordenadaY,CoordenadaZ-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,0,0,50,0,0,0,1)
				if distance <= 3 then
					drawTxt("PRESSIONE  ~r~F7~w~  PARA SAIR DO EXPEDIENTE",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,168) then
						emservico = false
						RemoveBlip(blips)
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
						end)
						ESX.ShowNotification('~y~Você saiu do serviço.')
					end
				end
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPEZA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if emservico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
			local distance = GetDistanceBetweenCoords(locs[selecionado].x,locs[selecionado].y,cdz,x,y,z,true)

			if distance <= 50.0 then
				DrawMarker(27,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z+0.20,0,0,0,0,180.0,130.0,2.0,2.0,1.0,255,165,0,50,1,0,0,1)
				if distance <= 3 then
					drawTxt("APERTE  ~r~Z~w~  PARA INICIAR A LIMPEZA",4,0.5,0.93,0.50,255,255,255,180)
					if(IsControlJustReleased(0, 20))then
						local cSCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
						local vassouspawn = CreateObject(GetHashKey(vassoumodel), cSCoords.x, cSCoords.y, cSCoords.z, 1, 1, 1)
						local netid = ObjToNet(vassouspawn)
						ESX.Streaming.RequestAnimDict("amb@world_human_janitor@male@idle_a", function()
							TaskPlayAnim(PlayerPedId(), "amb@world_human_janitor@male@idle_a", "idle_a", 8.0, -8.0, -1, 0, 0, false, false, false)
							AttachEntityToEntity(vassouspawn,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422),-0.005,0.0,0.0,360.0,360.0,0.0,1,1,0,1,0,1)
							vassour_net = netid
						end)
						ESX.SetTimeout(10000, function()
							disable_actions = false
							DetachEntity(NetToObj(vassour_net), 1, 1)
							DeleteEntity(NetToObj(vassour_net))
							vassour_net = nil
							ClearPedTasks(PlayerPedId())
							TriggerServerEvent('esx_garijob:onNPCJobMissionCompleted')
						end)
						lselecionado = selecionado
						while true do
							if lselecionado == selecionado then
								selecionado = math.random(#locs)
							else
								break
							end
							Citizen.Wait(1)
						end
						Citizen.Wait(10000)
						RemoveBlip(blips)
						CriandoBlip(locs,selecionado)
					end
				end
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if emservico then
			if IsControlJustPressed(0,168) then
				emservico = false
				RemoveBlip(blips)
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
					end)
				ESX.ShowNotification('~y~Você saiu do serviço.')
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DESENHAR TEXTO 3D
-----------------------------------------------------------------------------------------------------------------------------------------

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CRIAR BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
function CriandoBlip(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Limpeza da Praça")
	EndTextCommandSetBlipName(blips)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- TROCAR ROUPA DO GARI
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyGariSkin()
	local playerPed = PlayerPedId()
	if DoesEntityExist(playerPed) then
		Citizen.CreateThread(function()
			TriggerEvent('skinchanger:getSkin', function(skin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['gari_wear'].male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['gari_wear'].female)
				end
			end)
		SetPedArmour(playerPed, 0)
		ClearPedBloodDamage(playerPed)
		ResetPedVisibleDamage(playerPed)
		ClearPedLastWeaponDamage(playerPed)
		ResetPedMovementClipset(playerPed, 0)
		end)
	end
end