local driver1 = CAN:get_device(10)
local device_value
local runCounter = 0
local readDone = 0
local TMEXT = Parameter()
TMEXT:init('TMEXT')

local TMINT = Parameter()
TMINT:init('TMINT')


local BLOCKPARAM = Parameter()
BLOCKPARAM:init('PILOT_SPEED_UP')

local current_value;
local block_value = 51
local gcs_value = 52

function disableGCS()
	gcs:send_text(0,'Disabling GCS Arming')
    BLOCKPARAM:set_and_save(tonumber(gcs_value))
    return update()
end

function disableArming()		
        gcs:send_text(0,'Disabling Arming')
        BLOCKPARAM:set_and_save(tonumber(block_value))
end


function show_frame(dnum, frame)
    gcs:send_text(0,string.format("CAN[%u] msg from " .. tostring(frame:id()) .. ": %i, %i, %i, %i, %i, %i", dnum, frame:data(0), frame:data(1), frame:data(2), frame:data(3), frame:data(4), frame:data(5)))
	device_value=frame:data(0)
	current_value = param:get('TMINT')
	readDone = 1;
	TMEXT:set_and_save(tonumber(device_value))
	if device_value > current_value  then
		disableArming()
	end
	if device_value < current_value  then
	TMINT:set_and_save(tonumber(device_value))
	end

end

function update()
	runCounter = runCounter+1
    if driver1 then
      frame = driver1:read_frame()
		  if frame then		
			 show_frame(1, frame)
		  else 
			gcs:send_text(0,'Unable to find device frame!')
		  end
	else
		gcs:send_text(0,'Unable to locate CAN_DRIVER_1')
    end
	if readDone == 1 then
		return 
	end	
	if runCounter > 30 then
		disableArming()
		return
	end
	return update, 1000
end
return disableGCS()
