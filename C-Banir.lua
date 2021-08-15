------------------------------------------
--- 		CAMARGO SCRIPTS  		   ---
	  -----	    BANIR BRP		-----
------------------------------------------
local screenW, screenH = guiGetScreenSize()
local resW, resH = 1366, 768
local x, y = (screenW/resW), (screenH/resH)

local CMR_Font_18 = dxCreateFont("font/font.ttf", x*18)
local CMR_Font_16 = dxCreateFont("font/font.ttf", x*16)
local CMR_Font_14 = dxCreateFont("font/font.ttf", x*14)
local CMR_Font_12 = dxCreateFont("font/font.ttf", x*12)
local CMR_Font_11 = dxCreateFont("font/font.ttf", x*11)
local CMR_Font_10 = dxCreateFont("font/font.ttf", x*10)
local CMR_Font_8 = dxCreateFont("font/font.ttf", x*8)
local CMR_Font_6 = dxCreateFont("font/font.ttf", x*6)

local CMR_Font_10_impact = dxCreateFont("font/impact.ttf", x*10)

local Banir = false

CMR_gridList = dxGrid:Create(x*530, y*378, x*300, y*160)
colum = CMR_gridList:AddColumn("Tempo", x*300)
CMR_gridList:SetVisible(false)

local components = { "Segundo(s)", "Minuto(s)", "Hora(s)", "Dia(s)" }
for _, component in ipairs(components) do
	 CMR_gridList:AddItem(colum ,component)
end

local ID = createElement("CMR_dxEditBox") 
local Motivo = createElement("CMR_dxEditBox")
local Tempo = createElement("CMR_dxEditBox")

function CMR_PainelDX_Banir()
	dxDrawImage(x*483, y*184, x*400, y*400, "img/TelaBanir.png")
	dxDrawEditBox("ID Jogador", x*560, y*245, x*240, y*40, false, 100, ID)
	dxDrawEditBox("Motivo do Ban", x*560, y*300, x*240, y*40, false, 200, Motivo)
	dxDrawEditBox("Tempo do Ban",x*560, y*355, x*240, y*40, false, 200, Tempo)
end

function CMR_Painel_Banir()
	if not isEventHandlerAdded("onClientRender", root, CMR_PainelDX_Banir) then
		triggerServerEvent("CMR:ProtecaoCamargoScripts:Player:Banir", localPlayer)
		addEventHandler("onClientRender", root , CMR_PainelDX_Banir)
		showCursor(true)
		CMR_gridList:SetVisible(true)
	else
		removeEventHandler("onClientRender", root , CMR_PainelDX_Banir)
		showCursor(false)
		CMR_gridList:SetVisible(false)
	end
end
addEvent("CMR:Painel:Banir", true)
addEventHandler("CMR:Painel:Banir", root, CMR_Painel_Banir)


function CMR_ClickBanir_Banir(_, state)
  if isEventHandlerAdded("onClientRender", root, CMR_PainelDX_Banir) then
    if state == "down" then
      if isCursor(x*595, y*515, x*180, y*55) then
        local IdJogador = getElementData(ID, "CMR_Texto")
        local MotivoBan = getElementData(Motivo, "CMR_Texto")
        local TempBan = getElementData(Tempo, "CMR_Texto")
        local gridItem = CMR_gridList:GetSelectedItem()
        local TempoSelec = CMR_gridList:GetItemDetails(colum, gridItem, 1) or nil
        if tonumber(IdJogador) == 0 or not tonumber(IdJogador) or tonumber(IdJogador) == nil then
          triggerServerEvent("CMR:Notification:Banir", localPlayer, localPlayer, "Você precisa colocar o ID do cidadão!", "error")
          return
        end
        if tonumber(TempBan) == 0 or not tonumber(TempBan) or tonumber(TempBan) == nil then
          triggerServerEvent("CMR:Notification:Banir", localPlayer, localPlayer, "Você precisa colocar o Tempo de banimento!", "error")
          return
        end
        if TempoSelec == nil then
          triggerServerEvent("CMR:Notification:Banir", localPlayer, localPlayer, "Você precisa selecionar o tempo de banimento!", "error")
          return
        end
        triggerServerEvent("CMR:BanirJogador:Banir", localPlayer, localPlayer, IdJogador, TempBan, TempoSelec, MotivoBan)
      end
    end
  end
end
addEventHandler("onClientClick", root, CMR_ClickBanir_Banir)


function isEventHandlerAdded(sEventName, pElementAttachedTo, func)
	if type(sEventName) == 'string' and isElement(pElementAttachedTo) and type(func) == 'function' then
		local aAttachedFunctions = getEventHandlers(sEventName, pElementAttachedTo)
		if type(aAttachedFunctions) == 'table' and #aAttachedFunctions > 0 then
			for i, v in ipairs(aAttachedFunctions) do
				if v == func then
					return true
				end
			end
		end
	end

	return false
end

function CMR_MensagemAtivacao_Banir()
	local IDBanido = getElementData(localPlayer, "CMR:BanidoID:Banir")
	local MotivoBanido = getElementData(localPlayer, "CMR:BanidoMotivoBanir:Banir")
	local TempBanido = getElementData(localPlayer, "CMR:BanidoTmpBanir:Banir")
	local TempoSelecBan = getElementData(localPlayer, "CMR:BanidoTempoSelecionado:Banir")
    if getElementData(localPlayer, "CMR:Banido:Banir") == "Sim" then
        dxDrawText("O Jogador do ID #FF0000"..IDBanido.." #FFFFFF Foi banido por #FF0000"..MotivoBanido.." \n#FFFFFFPelo Tempo de "..TempBanido.." #FFFFFF"..TempoSelecBan..".", x*1066, y*450, x*1366, y*768, tocolor(0, 0, 0, 255), x*1.00, CMR_Font_12, "center", "center", false, false, false, true, false)
    end
end
addEventHandler("onClientRender", root, CMR_MensagemAtivacao_Banir)

function CMR_TocarMusica_Banir(IDBanido, MotivoBanido, TempBanido, TempoSelecBan)
	setElementData(localPlayer, "CMR:BanidoID:Banir", IDBanido)
	setElementData(localPlayer, "CMR:BanidoMotivoBanir:Banir", MotivoBanido)
	setElementData(localPlayer, "CMR:BanidoTmpBanir:Banir", TempBanido)
	setElementData(localPlayer, "CMR:BanidoTempoSelecionado:Banir", TempoSelecBan)
	setElementData(localPlayer, "CMR:Banido:Banir", "Sim")
	setTimer(function() 
		setElementData(localPlayer, "CMR:Banido:Banir", "Não") 
		setElementData(localPlayer, "CMR:BanidoTmpBanir:Banir", false)
		setElementData(localPlayer, "CMR:BanidoMotivoBanir:Banir", false)
		setElementData(localPlayer, "CMR:BanidoID:Banir", false)
		setElementData(localPlayer, "CMR:BanidoTempoSelecionado:Banir", false)
	end, 9000, 1)
	setSoundVolume(playSound("Banimento.mp3"), 0.3)
end
addEvent("CMR:TocarMusica:Banir", true)
addEventHandler("CMR:TocarMusica:Banir", root, CMR_TocarMusica_Banir)

function isCursor(x,y,w,h)
	local mx,my = getCursorPosition()
	if mx and my then
		local fullx,fully = guiGetScreenSize()
		
		cursorx, cursory = mx*fullx,my*fully
		
		if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
			return true
		else
			return false
		end
	end
end