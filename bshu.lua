os.loadAPI("ocs/apis/sensor")
local monitors = {
	peripheral.wrap("back:white"),
	peripheral.wrap("back:red"),
	peripheral.wrap("back:blue"),
	peripheral.wrap("back:green"),
	peripheral.wrap("back:lime"),
	peripheral.wrap("back:yellow"),
	peripheral.wrap("back:gray"),
	peripheral.wrap("back:black"),
	peripheral.wrap("back:orange"),
	peripheral.wrap("back:pink"),
	peripheral.wrap("back:cyan"),
	peripheral.wrap("back:brown"),
}

local sensors = {
	sensor.wrap("left:white"),
	sensor.wrap("left:red"),
	sensor.wrap("left:blue"),
	sensor.wrap("left:green"),
	sensor.wrap("left:lime"),
	sensor.wrap("left:yellow"),
	sensor.wrap("left:gray"),
	sensor.wrap("left:black"),
	sensor.wrap("left:orange"),
	sensor.wrap("left:pink"),
	sensor.wrap("left:cyan"),
	sensor.wrap("left:brown"),
}

skala = peripheral.wrap("left:purple")

local SFKRE = peripheral.wrap("back:purple")
SFKRE.setTextColor(colors.orange)
SFKRE.setTextScale(4)

local PowerOf = 3200 / 1104

local m_ceil = math.floor

local Overall_Temp = 0

local Request_For_Saor = false

local Power = 0

local i_for_skala = 0

local Power_String = 0

local temp_to_color = {
	100,
	1000,
	5000,
	9000,
}

local power_to_color = {
	10,
	35,
	70,
	85,
}

local Cycles = {
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0}

local Temp_Delta = {
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0}

local Temp_Delta2 = {
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0}

local Temp_Switch = 0

function get_color(mode, value)
	if mode == "Heat" then
	
		if value > temp_to_color[4] then
			return colors.red
		elseif value > temp_to_color[3] then
			return colors.orange
		elseif value > temp_to_color[2] then
			return colors.yellow
		elseif value > temp_to_color[1] then
			return colors.cyan
		elseif value < temp_to_color[1] then
			return colors.lightBlue
		end
		
	end
		
	if mode == "Output" then
		if value > power_to_color[4] then
			return colors.lime
		elseif value > power_to_color[3] then
			return colors.yellow
		elseif value > power_to_color[2] then
			return colors.orange
		elseif value > power_to_color[1] then
			return colors.red
		elseif value < power_to_color[1] then
			return colors.black
		end
		
		end


end




while true do
	for i = 1, #sensors do
	
	Cycles[i] = Cycles[i] + 1
	
		mode = "Heat"

		local Sensor_Data = sensors[i].getTargetDetails("0,0,-1")
		
		
		local lever = rs.testBundledInput("bottom", colors.orange)
		
		if lever then
			mode = "Output"
		end
		
		if(Cycles[i] == 1) then
		
		Temp_Delta[i] = Sensor_Data["Heat"]

		end
			
		Power = Power + Sensor_Data["Output"]
		
		
		

		color = get_color(mode, Sensor_Data[mode])
		monitors[i].clear()
		
		if color then
		
			monitors[i].setBackgroundColor(color)
		
		else
		
			rs.setBundledOutput("bottom", colors.white)
			

		end
		

		
		if(Cycles[i] == 4) then
		
			Sensor_Data = sensors[i].getTargetDetails("0,0,-1")
			Temp_Delta2[i] = Sensor_Data["Heat"] - Temp_Delta[i]
		
			if(Temp_Delta[i] and Temp_Delta2[i]) then

				if(Temp_Delta2[i] > 0) then

				rs.setBundledOutput("right", colors.purple)
				
				end
			
			end
			Cycles[i] = 0
		end

		 
	end
	
	for I = 1, #Temp_Delta2 do
	
		Temp_Switch = Temp_Switch + Temp_Delta2[I]
  
	
	end
	
	if Temp_Switch <= 0 then
	
		rs.setBundledOutput("right", 0)
	
	end
	
	SFKRE.clear()
	
	Number_Power = m_ceil(PowerOf * Power) + m_ceil(Temp_Delta2[1] + Temp_Delta2[2] + Temp_Delta2[3] + Temp_Delta2[4] + Temp_Delta2[5] + Temp_Delta2[6] + Temp_Delta2[7] + Temp_Delta2[8] + Temp_Delta2[9] + Temp_Delta2[10] + Temp_Delta2[11] + Temp_Delta2[12])

 if Number_Power >= 0 then
  Power_String = tostring(Number_Power)
  
 else
  Power_String = tostring(0)
  
 end
  
 if Number_Power > 3200 then
  rs.setOutput("front", true)
  
 else
  rs.setOutput("front", false)
  
 end
	
	SFKRE.setCursorPos(5 - string.len(Power_String)/2, 1)
	
	SFKRE.write(Power_String)
 
 i_for_skala = i_for_skala + 1  
 print(i_for_skala)
 if i_for_skala % 100 == 0 then
  local time = textutils.formatTime(os.time(), true)
  
  skala.newPage()
  skala.setPageTitle("Skala LOG")
  
  skala.write("--- SCALA LOG ---")
  skala.setCursorPos(1, 3)
  skala.write("Power is: ")
  skala.setCursorPos(13, 3)
  skala.write(Power_String)
  skala.setCursorPos(1, 5)
  skala.write(time)
  skala.setCursorPos(1, 1)
  skala.endPage()
  
 end

	print(Power)
	Power = 0

	for K = 1, #Temp_Delta do

	Overall_Temp = Temp_Delta[K]

	end

	if (Overall_Temp >= 5000) and rs.testBundledInput("top", colors.red) == false then
		rs.setBundledOutput("top", colors.orange)
		sleep(0.1)
		rs.setBundledOutput("top", 0)
		sleep(0.1)
	elseif rs.testBundledInput("top", colors.red) == true then
		rs.setBundledOutput("top", colors.lightBlue)
	else
		rs.setBundledOutput("top", 0)
	end

		
			
	
	sleep(0.1)
	
	rs.setBundledOutput("bottom", 0)
	Temp_Switch = 0
	Overall_Temp = 0
	
end
