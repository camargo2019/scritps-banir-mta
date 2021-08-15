local sx, sy = guiGetScreenSize()
local font = dxCreateFont("font/font.ttf", 10)

function dxDrawEditBox(text, x, y, w, h, password, maxCharacter, element)
	local getText = getElementData(element, "CMR_Texto") or setElementData(element, "CMR_Texto", "")
	local state = getElementData(element, "state") or setElementData(element, "state", false)
	local character = getElementData(element, "maximum") or setElementData(element, "maximum", maxCharacter)
	--dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 130), false)
	if (#getElementData(element, "CMR_Texto") == 0) then
		dxDrawText(text, x + 5, y, x + w - 10, y + h, tocolor(0, 0, 0, 150), 1, font, "center", "center", true, false, false)
	end
	if (dxGetTextWidth(password and string.gsub(getElementData(element, "CMR_Texto"), ".", "•") or getElementData(element, "CMR_Texto"), 1, font) <= w - 10) then
		dxDrawText(password and string.gsub(getElementData(element, "CMR_Texto"), ".", "•") or getElementData(element, "CMR_Texto"), x + 5, y, x + w - 10, y + h, tocolor(0, 0, 0, 255), 1, font, "left", "center", true, false, false)
	else
		dxDrawText(password and string.gsub(getElementData(element, "CMR_Texto"), ".", "•") or getElementData(element, "CMR_Texto"), x + 5, y, x + w - 10, y + h, tocolor(0, 0, 0, 255), 1, font, "right", "center", true, false, false)
	end
	if (getElementData(element, "state") == true) then
		if (dxGetTextWidth(password and string.gsub(getElementData(element, "CMR_Texto"), ".", "•") or getElementData(element, "CMR_Texto"), 1, font) <= w - 10) then
			dxDrawLine(x + 5 + dxGetTextWidth(password and string.gsub(getElementData(element, "CMR_Texto"), ".", "•") or getElementData(element, "CMR_Texto"), 1, font), y + 5, x + 5 + dxGetTextWidth(password and string.gsub(getElementData(element, "CMR_Texto"), ".", "•") or getElementData(element, "CMR_Texto"), 1, font), y + h - 5, tocolor(0, 0, 0, math.abs(math.sin(getTickCount() / 255) * 255)), 1, false)
		else
			dxDrawLine(x + w - 10, y + 5, x + w - 10, y + h - 5, tocolor(0, 0, 0, math.abs(math.sin(getTickCount() / 255) * 255)), 1, false)
		end
	end
	if (isCursorOnElement(x, y, w, h)) then
		setElementData(element, "mouseState", "hovered")
	else
		setElementData(element, "mouseState", "normal")
	end
end

function dxClickElement(button, state, cx, cy)
	if (button == "left") and (state == "down") then
		local buttonId = false
		for id, element in ipairs(getElementsByType("dxButton")) do
			if (getElementData(element, "mouseState") == "hovered") then
				buttonId = id
			end
		end
		if (buttonId) then
			if (isElement(getElementsByType("dxButton")[buttonId])) then
				setElementData(getElementsByType("dxButton")[buttonId], "mouseState", "clicked")
				triggerEvent("onClickButton", getElementsByType("dxButton")[buttonId])
			end
		end
	end
	if (button == "left") and (state == "down") then
		local editBoxId = false
		for id, element in ipairs(getElementsByType("CMR_dxEditBox")) do
			if (getElementData(element, "mouseState") == "hovered") then
				editBoxId = id
			elseif (getElementData(element, "mouseState") == "normal") then
				if (getElementData(element, "state") == true) then
					guiSetInputMode("allow_binds")
					setElementData(element, "state", false)
				end
			end
		end
		if (editBoxId) then
			if (isElement(getElementsByType("CMR_dxEditBox")[editBoxId])) then
				if (getElementData(getElementsByType("CMR_dxEditBox")[editBoxId], "state") == false) then
					guiSetInputMode("no_binds")
					setElementData(getElementsByType("CMR_dxEditBox")[editBoxId], "state", true)
				end
			end
		end
	end
	if (button == "left") and (state == "down") then
		local checkBoxId = false
		for id, element in ipairs(getElementsByType("dxCheckBox")) do
			if (getElementData(element, "mouseState") == "hovered") then
				checkBoxId = id
			end
		end
		if (checkBoxId) then
			if (isElement(getElementsByType("dxCheckBox")[checkBoxId])) then
				if (getElementData(getElementsByType("dxCheckBox")[checkBoxId], "state") == true) then
					setElementData(getElementsByType("dxCheckBox")[checkBoxId], "state", false)
				else
					setElementData(getElementsByType("dxCheckBox")[checkBoxId], "state", true)
				end
			end
		end
	end
	if (button == "left") then
		for _, element in ipairs(getElementsByType("dxGridList")) do
			if (getElementData(element, "mouseState") == "hovered") then
				local barCount = getElementData(element, "barCount")
				local barList = getElementData(element, "barList")
				if (#barList > barCount) then
					local x = getElementData(element, "x")
					local y = getElementData(element, "y")
					local w = getElementData(element, "w")
					local h = getElementData(element, "h")
					local scrollOffset = getElementData(element, "scrollOffset")
					local scrollY = getElementData(element, "scrollY")
					local scrollSpace = #barList > barCount and 11 or 0
					local size = barCount / #barList
					local scrollList = scrollOffset / #barList
					if (state == "down") then
						if (cx >= x + w - scrollSpace) and (cx <= x + w - scrollSpace + 3) and (cy >= y + scrollList * h) and (cy <= y + scrollList * h + size * h) then
							setElementData(element, "scrollAlpha", 255)
							setElementData(element, "scrollAttached", true)
							local mouseOffset = y + scrollY * (1 - size) * h
							setElementData(element, "scrollAttachedOffset", cy - mouseOffset)
						end
					end
				end
				if (state == "up") and not (getElementData(element, "scrollAttached")) then
					setElementData(element, "selected", {getElementData(element, "barAttached")[1], getElementData(element, "barAttached")[2] or ""})
					triggerEvent("loginClick", element)
				end
			end
			if (state == "up") then
				setElementData(element, "scrollAttached", false)
				setElementData(element, "scrollAlpha", 150)
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), dxClickElement)

function dxCharacterElement(button)
	if (isChatBoxInputActive()) or (isConsoleActive()) or (isMainMenuActive()) then
		return
	end
	for _, element in ipairs(getElementsByType("CMR_dxEditBox")) do
		if (getElementData(element, "state") == true) then
			if (#getElementData(element, "CMR_Texto") < getElementData(element, "maximum")) then
				setElementData(element, "CMR_Texto", getElementData(element, "CMR_Texto")..button)
			end
		end
	end
end
addEventHandler("onClientCharacter", getRootElement(), dxCharacterElement)

function dxKeyElement(button, press)
	if (isChatBoxInputActive()) or (isConsoleActive()) or (isMainMenuActive()) then
		return
	end
	if (press) and (button == "backspace") then
		for _, element in ipairs(getElementsByType("CMR_dxEditBox")) do
			if (getElementData(element, "state") == true) then
				if (#getElementData(element, "CMR_Texto") > 0) then
					setElementData(element, "CMR_Texto", string.sub(getElementData(element, "CMR_Texto"), 1, #getElementData(element, "CMR_Texto") - 1))
				end
			end
		end
	end
end
addEventHandler("onClientKey", getRootElement(), dxKeyElement)

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
	if 
		type( sEventName ) == 'string' and 
		isElement( pElementAttachedTo ) and 
		type( func ) == 'function' 
	then
		local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
		if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
			for i, v in ipairs( aAttachedFunctions ) do
				if v == func then
					return true
				end
			end
		end
	end

	return false
end

function isCursorOnElement( posX, posY, width, height )
  if isCursorShowing( ) then
    local mouseX, mouseY = getCursorPosition( )
    local clientW, clientH = guiGetScreenSize( )
    local mouseX, mouseY = mouseX * clientW, mouseY * clientH
    if ( mouseX > posX and mouseX < ( posX + width ) and mouseY > posY and mouseY < ( posY + height ) ) then
      return true
    end
  end
  return false
end