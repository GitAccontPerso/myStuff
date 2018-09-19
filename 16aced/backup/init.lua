print('\nRock\'n roll !!!\n')

require"setup"
iot=require"bootstrap"
print ("Waiting 7 sec in case of infinite loop")

tmr.alarm(6,  7000, 0, function()   
		if file.open("start.lua", "r") then
			file.close()
			sb=require"start"
		else
		   iot.printm("start.lua not found") 
		end
	end)
