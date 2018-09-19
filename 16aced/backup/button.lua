
print("Start BP module")
bp1 = 5 -- GPIO14
bp2 = 6 -- GPIO12
bp3 = 7 -- GPIO13
bp4 = 12 -- GPIO10
gpio.mode(bp1,gpio.INT, gpio.PULLUP)
gpio.mode(bp2,gpio.INT, gpio.PULLUP)
gpio.mode(bp3,gpio.INT, gpio.PULLUP)
gpio.mode(bp4,gpio.INT, gpio.PULLUP)
timerBP = tmr.create()
tmr.register(timerBP, 300, tmr.ALARM_SEMI, function()
	if bpp1 and bpp3 then 	print ("All UP")
							iot.printm("/grenier/relayA","UP")
							iot.printm("/grenier/relayB","UP")
							relay.run("A","UP")
							relay.run("B","UP")
    elseif bpp2 and bpp4 then 	print ("All DOWN")
								iot.printm("/grenier/relayA","DOWN")
								iot.printm("/grenier/relayB","DOWN")
								relay.run("A","DOWN")
								relay.run("B","DOWN")
    elseif bpp1 then print ("bp1") iot.printm("/grenier/relayA","Invert")
    elseif bpp2 then print ("bp2") iot.printm("/grenier/relayB","Invert")
    elseif bpp3 then print ("bp3") relay.run("A","Invert")
    elseif bpp4 then print ("bp4") relay.run("B","Invert")
    end
    bpp1,bpp2,bpp3,bpp4=false
end)

delay=300000
last=0


function rebond()
    now=tmr.now()
	delta=now - last
	if delta < 0 then last=0 end
    if delta < delay then return 0 end
	last=now return 1
end

function pincb()
	tmr.start(timerBP)
	if gpio.read(bp1)==0 then bpp1=true end 
	if gpio.read(bp2)==0 then bpp2=true end 
	if gpio.read(bp3)==0 then bpp3=true end
	if gpio.read(bp4)==0 then bpp4=true end	
end

gpio.trig(bp1, "down",pincb)
gpio.trig(bp2, "down",pincb)
gpio.trig(bp3, "down",pincb)
gpio.trig(bp4, "down",pincb)

