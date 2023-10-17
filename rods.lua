os.loadAPI("rom/apis/invmanager")


local LZH_Slots = { 6, 7, 8, 9, 10, 26, 27, 28, 29, 30 }

local Rod_Slots = { 19, 20, 21, 22, 23,
					37, 38, 39, 40, 41 }

local Rod_Slots_Size = #Rod_Slots

local Channels = {
 invmanager.wrap("back:white"), invmanager.wrap("back:red"), invmanager.wrap("back:blue"), invmanager.wrap("back:green"),
 invmanager.wrap("back:lime"), invmanager.wrap("back:yellow"), invmanager.wrap("back:gray"), invmanager.wrap("back:black"),
 invmanager.wrap("back:orange"), invmanager.wrap("back:pink"), invmanager.wrap("back:cyan"), invmanager.wrap("back:brown") }

local SelsynColors = {
colors.white, colors.orange, colors.magenta, colors.lightBlue,
colors.yellow, colors.lime, colors.pink, colors.gray,
colors.lightGray, colors.cyan, colors.purple, colors.blue}

local Screen_Sensor = peripheral.wrap("bottom:white")

Screen_Sensor.setCursorPos(1,1)

local Channels_Count = #Channels

local Selected_Rod_Slots = { }

local Selected_Channel = 1

local Mode = 0

local r_gbi = rs.testBundledInput
local r_sbo = rs.setBundledOutput

r_sbo("bottom", colors.red)


local t_w = term.write
local t_c = term.clear
local t_sc = term.setCursorPos

local Saor_Worked = false


rs.setBundledOutput("front", 0)

Screen_Sensor.setTextColor(colors.orange)

Screen_Sensor.setTextScale(4)


for Calibration = 0, 12 do

	for I = 1, #SelsynColors do
		
		sleep(0.1)
		rs.setBundledOutput("right", 0)
		sleep(0.1)
		rs.setBundledOutput("right", SelsynColors[I])




	end
		Screen_Sensor.write("CB")
	
end

rs.setBundledOutput("right", 0)


function c()
	for Sel_Ch_Calibration = 1, Channels_Count do
		for I = 1, Rod_Slots_Size do
			Channels[Sel_Ch_Calibration].move("south", "north", Rod_Slots[I])
		end
	Selected_Rod_Slots[#Selected_Rod_Slots + 1] = 1
	t_c()
	t_sc(1,1)
	t_w("Registered channel... " .. #Selected_Rod_Slots)
	end
end

c()


while true do

		local Line = 3
		local Row = 1

	local Protection = r_gbi("top", colors.black) or r_gbi("top", colors.green) or r_gbi("top", colors.yellow) or r_gbi("top", colors.lightGray)

	if Protection == false and Saor_Worked == false then
	
	
	if r_gbi("top", colors.brown) then
	
		Mode = Mode + 1
		
		r_sbo("bottom", colors.blue)
		
		sleep(1.5)
		
		if Mode > 1 then
		
			Mode = 0
		
		r_sbo("bottom", colors.red)
		
			sleep(1.5)
		end
		
	end
	
	
	else
	
	if r_gbi("top", colors.black) then
	
		Mode = 2
	
	elseif r_gbi("top", colors.green) then
	
		Mode = 3
	
	elseif r_gbi("top", colors.yellow) then
	
		Mode = 4

	elseif r_gbi("top", colors.purple) == true then

		Mode = 5

	end
	end
	
		
	
	if Mode == 0 then
		if r_gbi("top", colors.orange) and Selected_Channel < Channels_Count  then
			Selected_Channel = Selected_Channel + 1
			sleep(0.2)
		end
			if r_gbi("top", colors.cyan) and Selected_Channel > 1  then
			Selected_Channel = Selected_Channel - 1
			sleep(0.2)
		end
		if r_gbi("top", colors.red) and Selected_Rod_Slots[Selected_Channel] <= Rod_Slots_Size then
			for I = 1, Rod_Slots_Size do
				if Channels[Selected_Channel].read("north", I) ~= 0 then
					rs.setBundledOutput("front", colors.brown)
					Channels[Selected_Channel].move("north", "south", I, Rod_Slots[Selected_Rod_Slots[Selected_Channel]], 1)
					Selected_Rod_Slots[Selected_Channel] = Selected_Rod_Slots[Selected_Channel] + 1
					rs.setBundledOutput("front", SelsynColors[Selected_Channel])
					rs.setBundledOutput("front", SelsynColors[Selected_Channel])		
					sleep(0.1)
					rs.setBundledOutput("front", 0)
					sleep(0)
					break
				end
			end
		end
		
		if r_gbi("top", colors.blue) and Selected_Rod_Slots[Selected_Channel] > 1 then
			rs.setBundledOutput("right", colors.brown)
			Channels[Selected_Channel].move("south", "north", Rod_Slots[Selected_Rod_Slots[Selected_Channel]-1])
			Selected_Rod_Slots[Selected_Channel] = Selected_Rod_Slots[Selected_Channel] - 1
			rs.setBundledOutput("right", SelsynColors[Selected_Channel])		
			sleep(0.1)
			rs.setBundledOutput("right", 0)
			sleep(0)
		end
		Screen_Sensor.clear()
		Screen_Sensor.setCursorPos(1,1)
		Screen_Sensor.write(tostring(Selected_Channel))
		rs.setBundledOutput("right", 0)
		sleep(0)
	end



    
	
	if Mode == 1 then
		if r_gbi("top", colors.red) then
			for V = 1, Channels_Count do
				for I = 1, Rod_Slots_Size do
					if Channels[V].read("north", I) ~= 0 and Selected_Rod_Slots[V] <= Rod_Slots_Size then
					rs.setBundledOutput("front", colors.brown)
					Channels[V].move("north", "south", I, Rod_Slots[Selected_Rod_Slots[V]], 1)
					Selected_Rod_Slots[V] = Selected_Rod_Slots[V] + 1
					rs.setBundledOutput("front", SelsynColors[V])		
					sleep(0.1)
					rs.setBundledOutput("front", 0)
					sleep(0)
					break		
					end
				end
			end
		end
		if r_gbi("top", colors.blue) then
			for V = 1, Channels_Count do
				rs.setBundledOutput("right", colors.brown)
				if(Selected_Rod_Slots[V] > 1) then
				Channels[V].move("south", "north", Rod_Slots[Selected_Rod_Slots[V] - 1])
				Selected_Rod_Slots[V] = Selected_Rod_Slots[V] - 1
				rs.setBundledOutput("right", SelsynColors[V])
				sleep(0.1)
				rs.setBundledOutput("right", 0)
				sleep(0)
				end
			end
		end
		Screen_Sensor.clear()
		Screen_Sensor.setCursorPos(1,1)
		Screen_Sensor.write("AC")
		sleep(0)
	end

	if Mode == 2 then
	


			for V = 1, Channels_Count do
			
				rs.setBundledOutput("right", colors.brown)
				if(Selected_Rod_Slots[V] - 1 > 0) then
			
				Channels[V].move("south", "north", Rod_Slots[Selected_Rod_Slots[V] - 1])
				

				
				Selected_Rod_Slots[V] = Selected_Rod_Slots[V] - 1
				
				rs.setBundledOutput("right", SelsynColors[V])
				sleep(0.1)
				rs.setBundledOutput("right", 0)
				sleep(0)
				
				

				
				end
				
			end
			


		
		Screen_Sensor.clear()
		Screen_Sensor.setCursorPos(1,1)
		Screen_Sensor.write("AZ5")
	
	
	
	end
	
	if Mode == 3 then
	


			for V = 1, Channels_Count do
			
				rs.setBundledOutput("right", colors.brown)
				if(Selected_Rod_Slots[V] - 1 > 5) then
			
				Channels[V].move("south", "north", Rod_Slots[Selected_Rod_Slots[V] - 1])
				

				
				Selected_Rod_Slots[V] = Selected_Rod_Slots[V] - 1
				
				rs.setBundledOutput("right", SelsynColors[V])
				sleep(0.1)
				rs.setBundledOutput("right", 0)
				sleep(0)
				
				

				
				end
				
			end
			


		
		Screen_Sensor.clear()
		Screen_Sensor.setCursorPos(1,1)
		Screen_Sensor.write("AZ1")
	
	
	
	end
	
	if Mode == 4 then
	


			for V = 1, Channels_Count do
			
				rs.setBundledOutput("right", colors.brown)
				if(Selected_Rod_Slots[V] - 1 > 7) then
			
				Channels[V].move("south", "north", Rod_Slots[Selected_Rod_Slots[V] - 1])
				

				
				Selected_Rod_Slots[V] = Selected_Rod_Slots[V] - 1
				
				rs.setBundledOutput("right", SelsynColors[V])
				sleep(0.1)
				rs.setBundledOutput("right", 0)
				sleep(0)
				
				

				
				end
				
			end
			


		
		Screen_Sensor.clear()
		Screen_Sensor.setCursorPos(1,1)
		Screen_Sensor.write("AZ2")
	
	
	
	end


	if Mode == 5 then

		Saor_Worked = true

		for V = 1, Channels_Count do
		
			rs.setBundledOutput("right", colors.brown)
			if(Selected_Rod_Slots[V] - 1 > 0) then
			Channels[V].move("south", "north", Rod_Slots[Selected_Rod_Slots[V] - 1])
			Selected_Rod_Slots[V] = Selected_Rod_Slots[V] - 1
			rs.setBundledOutput("right", SelsynColors[V])
			sleep(0.1)
			rs.setBundledOutput("right", 0)
			sleep(0)

			end

		end

		for V = 1, Channels_Count do
			
			for K = 1, Rod_Slots_Size do
				Channels[V].move("east", "south", 1, Rod_Slots[K], 1)
				saor = saor + 1
				print(saor)
			end
		
		end
		

		
	
		Screen_Sensor.clear()
		Screen_Sensor.setCursorPos(1,1)
		Screen_Sensor.write("SR")

	end

end
