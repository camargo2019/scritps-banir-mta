------------------------------------------
--- 		CAMARGO SCRIPTS  		   ---
	  -----	    BANIR BRP		-----
------------------------------------------
function CMR_ProtecaoCamargoScripts()
	local NomeDoScripts_CMRScripts = "[Scripts]Banir"
	outputDebugString("Proteção iniciada com sucesso! [Camargo Scripts] ["..NomeDoScripts_CMRScripts.."]")
	return
end
addEvent("CMR:ProtecaoCamargoScripts:Banir", true)
addEventHandler("CMR:ProtecaoCamargoScripts:Banir", root, CMR_ProtecaoCamargoScripts)

function CMR_ProtecaoCamargoScripts_Player_Banir()
	local NomeDoScripts_CMRScripts = "[Scripts]Banir"
	return
end
addEvent("CMR:ProtecaoCamargoScripts:Player:Banir", true)
addEventHandler("CMR:ProtecaoCamargoScripts:Player:Banir", root, CMR_ProtecaoCamargoScripts_Player_Banir)

function CMR_BanirConnect_Banir(res)
	if res == getThisResource() then
		triggerEvent("CMR:ProtecaoCamargoScripts:Banir", root)
		db = dbConnect('sqlite', 'banimentos.db')
		if (not db) then
			outputDebugString("ERROR: Não foi possivel conectar ao banco de dados do sistema de banimento!")
		else
			outputDebugString("SUCCESS: Banco de Dados do sistema de banimento conectado com sucesso!")
		end
	end
end
addEventHandler("onResourceStart", root, CMR_BanirConnect_Banir)

function CMR_CarregarBanidos_Banir(res)
	if res == getThisResource() then
		for i, a in ipairs(getElementsByType("player")) do
			local data = dbPoll(dbQuery(db, "SELECT * FROM cmr_banimentos WHERE serial = ?", getPlayerSerial(a)), -1)
			local bans = 0
			if data then
				for b, dat in ipairs(data) do
					bans = bans+1
				end
			end
			if bans >= 3 then
				banPlayer(a, true, true, true, "BRP|Camargo", "Você possui mais de 3 Banimentos, compre seu unban em: https://discord.gg/eajjPbzqwM", 863999913600)
			end
		end
	end
end
addEventHandler("onResourceStart", root, CMR_CarregarBanidos_Banir)

function CMR_PlayerJoin_Banir()
	if isElement(source) then
		if getElementType(source) == "player" then
			local data = dbPoll(dbQuery(db, "SELECT * FROM cmr_banimentos WHERE serial = ?", getPlayerSerial(source)), -1)
			local bans = 0
			if data then
				for b, dat in ipairs(data) do
					bans = bans+1
				end
			end
			if bans >= 3 then
				banPlayer(source, true, true, true, "BRP|Camargo", "Você possui mais de 3 Banimentos, compre seu unban em: https://discord.gg/eajjPbzqwM", 863999913600)
			end
		end
	end
end
addEventHandler("onPlayerJoin", root, CMR_PlayerJoin_Banir)

function CMR_AbrirPainel_Banir(s, cmd)
	if isElement(s) then
		if getElementType(s) == "player" then
			local acc = getAccountName(getPlayerAccount(s))
			for i, acl in ipairs(AclsBanir) do
				if isObjectInACLGroup("user."..acc, aclGetGroup(acl[1])) then
					triggerClientEvent(s, "CMR:Painel:Banir", s)
					return
				end
			end
		end
	end
end
addCommandHandler(CommandoAbrir, CMR_AbrirPainel_Banir)

function CMR_BanirJogador_Banir(source, IdJogador, TempBan, TempoSelec, MotivoBan)
	local FdpBanido = getPlayerID(IdJogador)
	if IdJogador == 1 then
		return
	end
	local Multiplicador = 60
	if TempoSelec == "Segundo(s)" then
		Multiplicador = 1
	elseif TempoSelec == "Minuto(s)" then
		Multiplicador = 60
	elseif TempoSelec == "Hora(s)" then
		Multiplicador = 3600
	elseif TempoSelec == "Dia(s)" then
		Multiplicador = 86400
	end
	Tempo = TempBan * Multiplicador
	local account = getAccountByID(IdJogador)
	if not FdpBanido then
		dbExec(db, "INSERT INTO cmr_banimentos (id, contaLogin, serial, idBanido, Motivo, Tempo, BanidoPor) VALUES (NULL, ?, ?, ?, ?, ?, ?)", getAccountName(account), getAccountSerial(account), IdJogador, MotivoBan, Tempo, getAccountName(getPlayerAccount(source)))
  		addBan(nil, nil, getAccountSerial(account), getPlayerName(source), tostring(MotivoBan), Tempo)
  	else
  		dbExec(db, "INSERT INTO cmr_banimentos (id, contaLogin, serial, idBanido, Motivo, Tempo, BanidoPor) VALUES (NULL, ?, ?, ?, ?, ?, ?)", getAccountName(getPlayerAccount(FdpBanido)), getPlayerSerial(FdpBanido), IdJogador, MotivoBan, Tempo, getAccountName(getPlayerAccount(source)))
  		banPlayer(FdpBanido, true, true, true, getPlayerName(source), tostring(MotivoBan), Tempo)
  	end
  	triggerClientEvent(root, "CMR:TocarMusica:Banir", root, IdJogador, MotivoBan, TempBan, TempoSelec)
end
addEvent("CMR:BanirJogador:Banir", true)
addEventHandler("CMR:BanirJogador:Banir", root, CMR_BanirJogador_Banir)

function CMR_Notification_Banir(source, mensagem, tipo)
	if source and mensagem and tipo then
		exports.cmr_dxmessages:outputDx(source, tostring(mensagem), tostring(tipo))
	end
end
addEvent("CMR:Notification:Banir", true)
addEventHandler("CMR:Notification:Banir", root, CMR_Notification_Banir)


function getPlayerID(player)
	v = false
	for i, p in ipairs(getElementsByType("player")) do
		if tonumber(getElementData(player, "ID") or 0) == tonumber(ID) then
			v = player
			break
		end
	end
	return v
end