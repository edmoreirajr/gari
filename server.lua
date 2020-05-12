ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_garijob:onNPCJobMissionCompleted')
AddEventHandler('esx_garijob:onNPCJobMissionCompleted', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total   = math.random(Config.faxina_min,Config.faxina_max);
	xPlayer.addMoney(total)
	TriggerClientEvent('esx:showNotification', source, '~y~Limpeza concluída, Você recebeu ~p~'..total..' ~y~reais.')
	TriggerClientEvent('esx:showNotification', source, '~y~Vá para o próximo local de limpeza ou pressione ~p~F7 ~y~para sair do expediente.')
end)