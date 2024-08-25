local obj_min_dist = 20
local obj_max_dist = 1.5
local warn_ms = 500
local orient = 0
local last_warn = 0
local AVOID_ENABLE = Parameter()      
AVOID_ENABLE:init('AVOID_ENABLE')  
local isEnabled = AVOID_ENABLE:get()

local OA_TYPE = Parameter()      
OA_TYPE:init('OA_TYPE')  
local isBendy = OA_TYPE:get()



function obstacle()
	local dist = ahrs:get_relative_position_NED_home()
	if(dist) then 
		local altitude = -1*dist:z()
		
		local obj_dist = rangefinder:distance_cm_orient(0) *0.01
		local obj_dist1 = rangefinder:distance_cm_orient(4) *0.01		
		
		if (altitude and altitude >= 1) then
			
			if(obj_dist and (obj_dist < obj_min_dist and obj_dist > obj_max_dist)) then    -- if mode is in auto 
			    vehicle:set_mode(5) --set mode to loiter
				gcs:send_text(4, string.format("Obstacle Warning Front obstacle: %f meters",obj_dist))
				gcs:send_text(4, string.format("CHANGING to LOITER MODE"))
			end
			
			if(obj_dist1 and (obj_dist1 < obj_min_dist and obj_dist1 > obj_max_dist)) then
				vehicle:set_mode(5) --set mode to loiter
				gcs:send_text(4, string.format("Obstacle Warning Back obstacle: %f meters",obj_dist1))
				gcs:send_text(4, string.format("CHANGING to LOITER MODE"))
				--return update, warn_ms	
			end
		end
	end

end



function call()
	if arming:is_armed() then 
		flightMode = vehicle:get_mode()
		if (flightMode and (flightMode==3 or flightMode==6 or flightMode==16) and (isEnabled == 2) and (isBendy == 0))	then
			obstacle()
		end		
	end
	return call, 100
end
return call,100