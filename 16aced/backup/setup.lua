str=wifi.ap.getmac()
ssidTemp=string.format("%s%s%s",string.sub(str,10,11),string.sub(str,13,14),string.sub(str,16,17));

-- Configuration to connect to the MQTT broker.
BROKER = "192.168.0.41"   
BRPORT = 1883             
BRUSER = ""           
BRPWD  = ""            
CLIENTID = "16aced"
RTopic = "/16aced/"
SOCATPORT = 3335

ALabel = "Bureau"
BLabel = "Chambre"

cfgIP= {
    ip = "192.168.0.71",
    netmask = "255.255.255.0",
    gateway = "192.168.0.254"
    }
wifi.sta.setip(cfgIP)
