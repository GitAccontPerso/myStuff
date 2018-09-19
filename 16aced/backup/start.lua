local start={}
print("start.lua")


if file.open("sandbox.lua", "r") then
		iot.printm("Starting SandBox...")
		file.close()
        require"sandbox"
		--file.remove("sandbox.lua")
		require"sandbox"
	else
	    iot.printm("SandBox disabled!") 
        require"blacklistwifi"
        relay=require"relay"
        serv=require"servers"
        --touch=require"button"
	end

return start
