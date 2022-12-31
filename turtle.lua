local monitor = peripheral.find("monitor")

internal_background_color = colors.blue
internal_background_setting_color = colors.red
internal_background_notification_color = colors.yellow
internal_background_notification_color_top = colors.orange
--lmfayoooooooooooooo


--some function

internal_text_color = colors.white
internal_text_highlighted_color = colors.black
internal_text_highlighted_background_color = colors.white
internal_text_setting_color = colors.black
internal_text_notification_color = colors.black

--DO NOT CHANGE THESE!
directionx=0
directiony=0
offsetx=0
offsety=0
stepsinceempty=0
stepcycle = 0
step = -1
totalstep = 0
facing= 1
vertn = 3 --Vertical n length
horin = 5 --Horizontal n lentgh
torch = true
screenid = 0
logfile="turtle.log"

lavathreat=false

function strip_after_comma(s)--Made by open ai! o.O
  local _, end_pos = string.find(s, ',')
  if end_pos then
    return string.sub(s, 1, end_pos - 1)
  else
    return s
  end
end

function getItemNameBySerial(str)
	return strip_after_comma(string.sub(str, 7))
end

function isBlockin(myblock, inspectedblock)
	--example isBlockin("gravel", data)
	answer=string.match(textutils.serialise(inspectedblock), myblock)
	if (answer ~= nil) then 
	return true
	else false
end

function printLog(text)
	logfile.writeLine((string.format("[%s][%s;%s|%s:%s|%s] %s", os.time(), offsetx, offsety, stepcycle, step, facing, text)))
	logfile.flush()
end

function openLogEntry()
	fs.delete("turtle.log")
	logfile=fs.open("turtle.log", "w")
	printLog("--START OF LOG SESSION--")
end

function CorrectTurtleOffsetDirByFacing()
	if (getTurtleFacing() == 1) then setOffsetDirection(0, 1) end
	if (getTurtleFacing() == 2) then setOffsetDirection(1, 0) end
	if (getTurtleFacing() == 3) then setOffsetDirection(0, -1) end
	if (getTurtleFacing() == 4) then setOffsetDirection(-1, 0) end
	
end

function TurtlePlace(up, mid, low)
	up=up or false
	mid=mid or false
	low=low or false
	
	if up then
		turtle.placeUp() 
	end
	if mid then
		turtle.place() 
	end
	if low then
		turtle.placeDown() 
	end
end
function TurtleDig(up, mid, low)
	up=up or false
	mid=mid or false
	low=low or false
	
	if not lavathreat then
		if up then
			print(string.format("Digging above me.[X%s Y%s]", offsetx, offsety))
			turtle.digUp() 
		end
		if mid then
			print(string.format("Digging infront of me.[X%s Y%s]", offsetx, offsety))
			turtle.dig() 
		end
		if low then
			print(string.format("Digging under me.[X%s Y%s]", offsetx, offsety))
			SensitiveDigDown() 
		end
	end
end
function TurtleForward()
	turtle.forward()
	calculateOffset()
end
function TurtleBack()
	turtle.back()
	calculateOffset(true)
end
function TurtleTurnLeft()
	turtle.turnLeft()
	setTurtleFacing(getTurtleFacing()-1)
	CorrectTurtleOffsetDirByFacing()
end
function TurtleTurnRight()
	turtle.turnRight()
	setTurtleFacing(getTurtleFacing()+1)
	CorrectTurtleOffsetDirByFacing()
end
function terminateOS()
	while (true) do
		os.sleep(10)
		--NOP
	end
end
function getTurtleFacing()
	return tonumber(facing)
end
function setTurtleFacing(faceing)
	facing=tonumber(faceing)
	if (facing<1) then
		facing=facing+4
	elseif (facing>4) then
		facing=facing-4
	end
end
function returnToCenter(backSteps)
	totalstep=0
	backSteps=tonumber(backSteps) or 0
	print(string.format("Returning to center and %s back from [X%s Y%s]", backSteps, offsetx, offsety))
	print(string.format("[FACING: %s]", getTurtleFacing()))
	returning=true
	while (returning) do
		while (offsetx ~= 0) do
			--printLog("wod")
			if (getTurtleFacing()==2) then
				if (offsetx > 0) then
					TurtleBack()
				else
					TurtleForward()
				end
				
				os.sleep(1)
			elseif (getTurtleFacing()==4) then
				if (offsetx < 0) then
					TurtleBack()
				else
					TurtleForward()
				end
				--printLog("back")
				os.sleep(1)
			end
		end
		while (getTurtleFacing() ~= 1) do
			TurtleTurnLeft()
			os.sleep(0.5)
		end
		--if (getTurtleFacing()==1) then CorrectTurtleOffsetDirByFacing() end
		while (totalstep<backSteps and offsety>0) do
			TurtleBack()
			totalstep=totalstep+1
			os.sleep(0.3)
		end
		printLog("end of returntocenter")
		returning=false
	end
end

function checkGravelism()
--Gravel is a shitty thang. :@
	local isgravel=false
	local has_block, data = turtle.inspect()
    if has_block then --

		[[--obj = textutils.serialise(data)
        if (string.match(obj, "gravel") or string.match(obj, "sand")) then--]]
		if (isBlockin("gravel", data)) then
			print("Found damned gravel...")
			isgravel=true
			while isgravel do
				os.sleep(0.4)
				local has_blockb, datab = turtle.inspect()
				if has_blockb then --
					--print(textutils.serialise(data))
					-- {
					--   name = "minecraft:oak_log",
					--   state = { axis = "x" },
					--   tags = { ["minecraft:logs"] = true, ... },
					-- }
					--[[os.loadAPI("json")]]
					if (string.match(textutils.serialise(datab), "gravel") or string.match(textutils.serialise(datab), "sand")) then
						print("Excavating dog shit.")
						TurtleDig(true, true)
						--Dig gravel
					else
						isgravel=false
						print("Way is free!")
						os.sleep(0.4)
						isAir()
					end
				else
					isgravel=false
					print("Way is free!")
					os.sleep(0.4)
					isAir()
				end
			end
		else isAir()
		end
	else isAir()
	end
end

function placeTorch()
    if torch then
        for i = 16, 13, -1 do
            turtle.select(i)
            if (turtle.getItemCount() > 1) then
                torchstr = textutils.serialise(turtle.getItemDetail())
                if not (string.match(torchstr, "torch")) then
                else
                    TurtlePlace(false, false, true)
                    break
                end
            end
        end
    end
end

function placeLavaWall()
	for i = 16, 1, -1 do
		turtle.select(i)
		os.sleep(0.25)
		if (turtle.getItemCount() > 1) then
			torchstr = textutils.serialise(turtle.getItemDetail())
			os.sleep(0.1)
			if (string.find(torchstr, "cobblestone") or string.find(torchstr, "diorite") or string.find(torchstr, "andesite") or string.find(torchstr, "granite") or string.find(torchstr, "minecraft:stone") or string.find(torchstr, "minecraft:dirt") or string.find(torchstr, "minecraft:tuff") or string.find(torchstr, "minecraft:deepslate")) then
				os.sleep(0.2)
				TurtlePlace(true, true, true)
				break
			else
				print("Fatal error! Cannot fill lava with block! Help!")
			end
		end
	end
end

function countEmptySlots()
  print("Counting empty slots...")
  emptyslots=0
  for i = 16, 1, -1 do
    turtle.select(i)
    if (turtle.getItemDetail()==nil) then emptyslots = emptyslots + 1 end
  end
  if (emptyslots<2) then placeChest() print("Placed a chest to empty inventory.") end
end

function placeChest()
    if torch then
        for i = 16, 13, -1 do
            turtle.select(i)
            if (turtle.getItemCount() > 1) then
                torchstr = textutils.serialise(turtle.getItemDetail())
                if not (string.match(torchstr, "chest")) then
                  print("No chest to unload into.")
                else
					os.sleep(1)
                    TurtlePlace(false, false, true)
					os.sleep(1)
                    for ib = 16, 1, -1 do
                      turtle.select(ib)
                      torchstr = textutils.serialise(turtle.getItemDetail())
                      if not (string.match(torchstr, "chest") or string.match(torchstr, "torch")) then
                        turtle.dropDown()
                      end
                    end
                end
            end
        end
    end
  stepsinceempty=0
end
function SensitiveDigDown()
	local has_block, data = turtle.inspectDown()
    if has_block then --
        --print(textutils.serialise(data))
        -- {
        --   name = "minecraft:oak_log",
        --   state = { axis = "x" },
        --   tags = { ["minecraft:logs"] = true, ... },
        -- }
        --[[os.loadAPI("json")]] obj = textutils.serialise(data)
        if (string.match(obj, "chest") or string.match(obj, "torch")) then
			print("Skipped underblock, because it has mining machine equipment.")
            --Skip
        else
			turtle.digDown()
			print("Digging under me.")
            os.sleep(0.25)
		end
	end
end

function foundLava()
	lavathreat=true
    print("Found lava! Security terminating!")
	TurtleBack()
	os.sleep(0.5)
	placeLavaWall()
	returnToCenter(7)
	os.sleep(0.25)
	terminateOS()
end

function foundAir()
    print("Found air infront of me.")
    TurtleDig(true, false, false)
end
--If there's air do x
function isAir()
    local has_block, data = turtle.inspect()
    if has_block then --
        --print(textutils.serialise(data))
        -- {
        --   name = "minecraft:oak_log",
        --   state = { axis = "x" },
        --   tags = { ["minecraft:logs"] = true, ... },
        -- }
        --[[os.loadAPI("json")]] 
		obj = textutils.serialise(data)
        if (string.match(obj, "water")) then
            foundAir()
        elseif (string.match(obj, "lava")) then
            foundLava()
        else
            TurtleDig(true, true, true)
        end
    else
        foundAir()
    end
end
function setOffsetDirection(x, y)
	directionx=x
	directiony=y
end
function calculateOffset(backward)
	backward=backward or false
	if (backward) then
		offsetx=offsetx-directionx
		offsety=offsety-directiony
	else
		offsetx=offsetx+directionx
		offsety=offsety+directiony
	end
	if (debugmode) then print(string.format("X %s, Y %s", offsetx, offsety)) end
end
function doStep(maxsteps)
	steplimit=maxsteps or 99999
    while (steplimit > totalstep) do	
		if (math.fmod(offsetx, 7) == 0) then placeTorch() end
		if (math.fmod(offsety, 7) == 0) then placeTorch() end
		
        if (step == vertn) then
            TurtleTurnRight()
		elseif (step > 1 and step < vertn) then
			if (offsetx == 0 and stepsinceempty>90) then countEmptySlots() end
		elseif (step == vertn + horin) then
            TurtleTurnRight()
            os.sleep(1.1)
            TurtleTurnRight()
        elseif (step == vertn + (horin * 3)) then
            TurtleTurnRight()
            os.sleep(1.1)
            TurtleTurnRight()
        elseif (step == vertn + (horin * 4)) then
            TurtleTurnLeft()
            os.sleep(0.75)
            step = -1
            stepcycle = stepcycle + 1
        end
        checkGravelism()
        step = step + 1
		totalstep= totalstep + 1
        stepsinceempty = stepsinceempty + 1
        TurtleForward()
        os.sleep(0.75)
    end
end

function openSettings()
    os.sleep(0.3)
    screenid = 2
    term.setBackgroundColor(internal_background_notification_color)
    term.clear()
    term.setCursorPos(1, 1)
    term.setTextColor(internal_background_notification_color_top)
    term.setBackgroundColor(internal_background_notification_color_top)
    term.write("------------------------------------------------")
    term.setCursorPos(15, 1)
    term.setTextColor(internal_text_notification_color)
    term.write("[SETTINGS]")

    term.setCursorPos(1, 4)
    term.setBackgroundColor(colors.red)
    term.setTextColor(colors.black)
    term.write("[")
    term.write(horin)
    term.write("]")
    term.setBackgroundColor(internal_background_notification_color)
    term.setTextColor(internal_text_notification_color)
    term.write("<opt.width> side tunnel length")

  
    term.setCursorPos(1, 5)
    term.setBackgroundColor(colors.red)
    term.setTextColor(colors.black)
    term.write("[")
    term.write(vertn)
    term.write("]")
    term.setBackgroundColor(internal_background_notification_color)
    term.setTextColor(internal_text_notification_color)
    term.write("<opt.length> forward tunnel length")

    
    local TORCHSTATE = "OFF"
    if torch then
        TORCHSTATE = "ON"
    end
    term.setCursorPos(1, 6)
    term.setBackgroundColor(colors.red)
    term.setTextColor(colors.black)
    term.write("[")
    term.write(TORCHSTATE)
    term.write("]")
    term.setBackgroundColor(internal_background_notification_color)
    term.setTextColor(internal_text_notification_color)
    term.write("<opt.torch> Auto-Torch(SLOT13-16)")

    while true do
        local event, button, x, y = os.pullEvent("mouse_click")
        if (screenid == 2 and ((tonumber(x) >= 4 and tonumber(y) >= 3) and (tonumber(x) <= 15 and tonumber(y) <= 4))) then
            --opt.width
            term.setBackgroundColor(internal_background_setting_color)
            term.clear()
            term.setTextColor(internal_text_setting_color)
            term.setCursorPos(1, 1)
            print("Length of side tunnels:")
            term.setCursorPos(1, 2)
            horin = io.read()
            horin = tonumber(horin)
            os.sleep(3)
            startApp()
        end
        if (screenid == 2 and ((tonumber(x) >= 4 and tonumber(y) >= 4) and (tonumber(x) <= 15 and tonumber(y) <= 5))) then
            --opt.length
            term.setBackgroundColor(internal_background_setting_color)
            term.clear()
            term.setTextColor(internal_text_setting_color)
            term.setCursorPos(1, 1)
            print("Length of forward tunnels:")
            term.setCursorPos(1, 2)
            vertn = io.read()
            vertn = tonumber(vertn)
            os.sleep(3)
            startApp()
        end
        if (screenid == 2 and ((tonumber(x) >= 4 and tonumber(y) >= 5) and (tonumber(x) <= 15 and tonumber(y) <= 6))) then
            --opt.torch
            term.setBackgroundColor(internal_background_setting_color)
            term.clear()
            term.setTextColor(internal_text_setting_color)
            term.setCursorPos(1, 1)
            if (torch) then
                print("Torching mode has been turned off.")
                torch = false
            else
                print("Torching mode has been turned on.")
                torch = true
            end
            os.sleep(3)
            startApp()
        end
    end
end

--Main function
function startApp()
    screenid = 0
    term.setBackgroundColor(internal_background_color)
    term.clear()
    term.setTextColor(internal_text_color)
    term.setCursorPos(1, 1)
    print("Welcome to the mining machine.")
    term.setCursorPos(1, 2)
    term.write("Click ")
    term.setBackgroundColor(internal_text_highlighted_background_color)
    term.setTextColor(internal_text_highlighted_color)
    term.write("<mine>")
    term.setBackgroundColor(internal_background_color)
    term.setTextColor(internal_text_color)
    term.write(" to start mining.")

    term.setCursorPos(1, 3)
    term.write("Click ")
    term.setBackgroundColor(internal_text_highlighted_background_color)
    term.setTextColor(internal_text_highlighted_color)
    term.write("<refuel>")
    term.setBackgroundColor(internal_background_color)
    term.setTextColor(internal_text_color)
    term.write(" to refuel.")

    term.setCursorPos(1, 4)
    term.write("Click ")
    term.setBackgroundColor(internal_text_highlighted_background_color)
    term.setTextColor(internal_text_highlighted_color)
    term.write("<settings>")
    term.setBackgroundColor(internal_background_color)
    term.setTextColor(internal_text_color)
    term.write(" to list settings.")
    term.setCursorPos(1, 13)
    term.setBackgroundColor(colors.green)
    term.setTextColor(colors.white)
    term.write(" Fuel ")
    term.setBackgroundColor(colors.red)
    term.setTextColor(colors.black)
    term.write(" ")
    term.write(turtle.getFuelLevel())
    term.write(" ")
    --print(string.format("  Fuel: %s  ", turtle.getFuelLevel()))

    --local command=io.read()
    while true do
        local event, button, x, y = os.pullEvent("mouse_click")
        if (screenid == 0 and ((tonumber(x) >= 5 and tonumber(y) >= 2) and (tonumber(x) <= 12 and tonumber(y) <= 2))) then
            --mine()
            screenid = 1
            term.setBackgroundColor(internal_background_notification_color)
            term.clear()
            term.setTextColor(internal_text_notification_color)
            term.setCursorPos(1, 1)
			totalstep = 0
            step = -1
			offsetx=0
			offsety=0
			directionx=0
			directiony=1
            doStep()
        end
        if (screenid == 0 and ((tonumber(x) >= 6 and tonumber(y) >= 3) and (tonumber(x) <= 14 and tonumber(y) <= 3))) then
            --refuel()
            screenid = 1
            term.setBackgroundColor(internal_background_notification_color)
            term.clear()
            term.setTextColor(internal_text_notification_color)
            term.setCursorPos(1, 1)
            print("Refueling...")
            turtle.refuel()
            os.sleep(1)
            term.setCursorPos(1, 1)
            local level = turtle.getFuelLevel()
            local new_level = turtle.getFuelLevel()
            print(("Refueled %d, current level is %d"):format(new_level - level, new_level))
            os.sleep(3)
            startApp()
        end

        if (screenid == 0 and ((tonumber(x) >= 6 and tonumber(y) >= 4) and (tonumber(x) <= 16 and tonumber(y) <= 4))) then
            --settings()
            openSettings()
        end
    end
end

--------------------------------------------------
--Call main function
openLogEntry()
startApp()

---------------------------------------------------------------------------