local mqttmod={}

mqttmr = tmr.create()
tmr.register(mqttmr, 500, 1, function() print("Try...") connectBKR() end)

print ("mqtt starting")
m = mqtt.Client(CLIENTID, 5, BRUSER, BRPWD)
m:lwt("/lwt", CLIENTID.." offline testament", 0, 0)


tmr.start(mqttmr)
-----
function mqttmod.printm(topic, message)
	if message==nil then message=topic topic="/tty"..RTopic end
    if message~="\n" and Connected then m:publish(topic,message,2,0, function(client) end)end
end

-----
function connectBKR()
    m:connect(BROKER, BRPORT, 0, function(client)
        tmr.stop(mqttmr) Connected=true node.output(mqttmod.s_output, 1)
        m:subscribe(RTopic.."#",2, function(client) print("subscribe success to "..RTopic) end) 
        
        m:on("offline", function(client) 
            Connected=false 
            print ("Broker lost !") 
            node.output(nil) m:close() 
            m=nil
            m = mqtt.Client(CLIENTID, 5, BRUSER, BRPWD)
            m:lwt("/lwt", CLIENTID.." offline testament", 0, 0)
            tmr.start(mqttmr)
            end)
        
        m:on("message", function(client, topic, data) 
            if topic~=RTopic.."tty/" then print("Receved : "..topic .." .. "..data) end 
            if data ~= nil then
                if topic==RTopic.."read" then readfilem(data) end
                if topic==RTopic.."write" then writefilem(data) end
                if topic==RTopic.."tty" then node.input(data) end
                if topic==RTopic.."relayA" then relay.run("A",data) end
                if topic==RTopic.."relayB" then relay.run("B",data) end
                if topic==RTopic.."Telnet" then serv.telnet() end
                if topic==RTopic.."Web" then serv.web()end
                if topic==RTopic.."list" then listfiles() end
                if topic==RTopic.."sctw" then sctw(data) end
                if topic==RTopic.."sctr" then sctr(data) end
                end
            end)
        end)
end

function mqttmod.s_output(str)
    mqttmod.printm("/tty"..RTopic, str)
end


function sctr(fname)
    buf=""
    if file.open(fname, "r") then
        print ("Socat Read File : " ..fname)
        srv = net.createConnection(net.TCP, 0)
        tmr.alarm(2,  200, 0, function()   
			print("Try to connect")
			srv:connect(SOCATPORT,BROKER)
		end)
		        
        srv:on("connection", function(sck, c)
			buf=file.read(1024)
            print ("Connected, sending "..string.len(buf).." first bloc of " ..fname)
			sck:send(buf)                 
			end)
        
        srv:on("sent", function(sck, c)
            buf=file.read(1024)
                if buf~=nil then print ("Sending "..string.len(buf).." new bloc of " ..fname) sck:send(buf)
                else  srv:close()
				end
            end)
            
        srv:on("disconnection", function(sck, c)
            file.close()
            print ("Socat Read end, closing file : "..fname)
        end)
    else print("file not exist !") 
    end
end

function sctw(fname)
    print ("Socat Write File : ".. fname)
    srv = net.createConnection(net.TCP, 0)
	
	srv:on("connection", function(sck, c)
		print ("Connected from  Socat")                
		end)
    
    srv:on("receive", function(sck, c)
		print ("Receive "..string.len(c).."  bloc of "..fname)
		file.write(c)
		end)
    
    srv:on("disconnection", function(sck, c)
        file.close()
        print ("Socat Write end, closing file : "..fname)
		end)
    
    if file.open(fname, "a+") then
        srv:connect(SOCATPORT,BROKER)
        end
end

function listfiles()
for n,s in pairs(file.list()) do print(n.." size: "..s) end
end

return mqttmod

