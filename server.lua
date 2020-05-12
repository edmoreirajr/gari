ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_garijob:onNPCJobMissionCompleted')
AddEventHandler('esx_garijob:onNPCJobMissionCompleted', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total   = math.random(300, 500);
	xPlayer.addMoney(total)
	TriggerClientEvent('esx:showNotification', source, '~y~Limpeza concluída, Você recebeu ~p~'..total..' ~y~reais.')
end)