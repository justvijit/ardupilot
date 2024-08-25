local distance=0
local altitude=0
function update()

	-- gcs:send_text(6, "Dynamic FS: One")
	local failsafe = false
	local Flt_mode = vehicle:get_mode()
	-- gcs:send_text(6, "Dynamic FS: Two")
	if arming:is_armed() and Flt_mode~=6 then 

		-- gcs:send_text(6, "Dynamic FS: Three")
		local current_pos = ahrs:get_position() 
		-- gcs:send_text(6, "Dynamic FS: Four")
		local home = ahrs:get_home()        
		-- gcs:send_text(6, "Dynamic FS: Five")    
		if current_pos and home then            
			distance = current_pos:get_distance(home) 
		end	
		local battery_voltage = battery:voltage(0)  
		-- gcs:send_text(6, "Dynamic FS: Six")
		if not battery_voltage then
			-- gcs:send_text(6, "Dynamic FS: Seven")
		   gcs:send_text(6, "Failed to read battery voltage")
		end
		local dist = ahrs:get_relative_position_NED_home()
		if(dist) then 
			altitude = -1*dist:z()
		end
		if battery_voltage < 43 and distance>1000 then
			gcs:send_text(6, "Battery is too less to travel the distance")	
			param:set("RTL_SPEED", 1000)	
			vehicle:set_mode(6)
			gcs:send_text(6,param:get("RTL_SPEED"))
			failsafe = true
		end
		if battery_voltage < 42.5 and distance>500 and failsafe == false then
			gcs:send_text(6, "Battery is too less to travel the distance")
			param:set("RTL_SPEED", 1000)
			vehicle:set_mode(6) 
						
		end
		if battery_voltage < 42 and distance>400 and altitude > 40 and failsafe == false then
			gcs:send_text(6, "Battery is too less to travel the distance")
			param:set("RTL_SPEED", 1000)
			vehicle:set_mode(6) 						
		end
		if battery_voltage < 41 and distance>400 and altitude <= 40 and failsafe == false then
			gcs:send_text(6, "Battery is too less to travel the distance")
			param:set("RTL_SPEED", 1000)
			vehicle:set_mode(6) 						
		end

		if battery_voltage < 42 and distance>100 and altitude > 40 and failsafe == false then
			gcs:send_text(6, "Battery is too less to travel the distance")
			param:set("RTL_SPEED", 500)
			vehicle:set_mode(6) 						
		end
		if battery_voltage < 41 and distance>100 and altitude <= 40 and altitude > 15 and failsafe == false then
			gcs:send_text(6, "Battery is too less to travel the distance")
			param:set("RTL_SPEED", 500)
			vehicle:set_mode(6) 						
		end

		if battery_voltage < 40 and distance>300 and altitude <= 15  and failsafe == false then
			gcs:send_text(6, "Battery is too less to travel the distance")
			param:set("RTL_SPEED", 500)
			vehicle:set_mode(6) 						
		end

		if battery_voltage < 39.5 and distance>200 and  altitude <= 15 and failsafe == false then
			gcs:send_text(6, "Battery is too less to travel the distance")
			param:set("RTL_SPEED", 500)
			vehicle:set_mode(6) 						
		end

		if battery_voltage < 38 and distance>100 and  altitude <= 15 and failsafe == false then
			gcs:send_text(6, "Battery is too less to travel the distance")
			param:set("RTL_SPEED", 500)
			vehicle:set_mode(6) 						
		end
	end
	return update, 500 
	
end

return update, 500 




