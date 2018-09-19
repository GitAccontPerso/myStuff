local relay={}
rel1=1 -- GPIO5
rel2=2 -- GPIO4
rel3=3 -- GPIO0
rel4=4 -- GPIO2

--function relay.init()
relaystatus={}
gpio.write(rel1, gpio.HIGH)
gpio.write(rel2, gpio.HIGH)

gpio.write(rel3, gpio.HIGH)
gpio.write(rel4, gpio.HIGH)
gpio.mode(rel1, gpio.OUTPUT)
gpio.mode(rel2, gpio.OUTPUT)
gpio.mode(rel3, gpio.OUTPUT)
gpio.mode(rel4, gpio.OUTPUT)
timerA = tmr.create()
timerB = tmr.create()
tmr.register(timerA, 30000, tmr.ALARM_SEMI, function()
    print("Store A off")
    gpio.write(rel3, gpio.HIGH)
    gpio.write(rel4, gpio.HIGH)
    tmr.interval(timerA,30000)
    end)

tmr.register(timerB, 30000, tmr.ALARM_SEMI, function()
    print("Store B off")
    gpio.write(rel1, gpio.HIGH)
    gpio.write(rel2, gpio.HIGH)
    tmr.interval(timerB,30000)
	end)

function relay.run(group,dir)
    if relaystatus[group] ~= nil then
        print ("relay status ".. group .. " = ".. relaystatus[group]) end
    if group=="A" then
        pw=rel4; sense=rel3;
        if tmr.state(timerA) then tmr.interval(timerA,1) return
                             else tmr.start(timerA) end

    elseif group=="B" then
        pw=rel2; sense=rel1;
        if tmr.state(timerB) then tmr.interval(timerB,1) return
                             else tmr.start(timerB) end
    else return end
    if dir=="Invert" then if relaystatus[group]==1 then dir="DOWN" else dir="UP" end end
    if dir=="DOWN" then gpio.write(sense, gpio.LOW) relaystatus[group]=0
    elseif dir=="UP" then gpio.write(sense, gpio.HIGH) relaystatus[group]=1
    else return end
    gpio.write(pw, gpio.LOW)

    print ("Store "..group.." "..dir)
    print ("relay status ".. group .. " = ".. relaystatus[group])
end

return relay

