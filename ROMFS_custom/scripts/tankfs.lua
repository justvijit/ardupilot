local pwm_in = PWMSource()
local SPRAY_SPEED_MIN = Parameter()      
SPRAY_SPEED_MIN:init('SPRAY_SPEED_MIN')  
local minSpeed = SPRAY_SPEED_MIN:get()
local fuelflag = 0
if not pwm_in:set_pin(54) then -- AUX Pin No (50-55)
  gcs:send_text(0, "Failed to setup PWM in on pin 54")
end
local currentNpn = 0
local pumpPWM
local flightMode
-- local flightMode = vehicle:get_mode()


--_______________pump_warning and liquid faisafe_____________

function liquid_warning()
	flightMode = vehicle:get_mode() 
	if(groundSpeed >= minSpeed) then
		currentNpn = pwm_in:get_pwm_us()
		-- gcs:send_text(4, string.format("PWM: %f",currentNpn))
		if (currentNpn == 0) then
			fuelflag = fuelflag+1
			gcs:send_text(4, string.format("LIQUID FLOW ZERO!!"))
			if(fuelflag == 4 and flightMode == 3) then  
				gcs:send_text(4, string.format("LIQUID FAILSAFE MODE LOITER"))
				vehicle:set_mode(5) 
			end
		else
			fuelflag = 0
		end 
	end		
end




function call()	
	if arming:is_armed() then 
		pumpPWM = rc:get_pwm(8)  --RC Channel No.
		groundSpeed = gps:ground_speed(0)
		groundSpeed = groundSpeed * 100
		if ((groundSpeed) and (pumpPWM) and (pumpPWM >1700)) then
			liquid_warning()			
		end
	end
	return call, 1000
end
return call, 1000