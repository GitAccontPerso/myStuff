allowed_mac_list={
"bc:e6:3f:33:f9:a0", --Didier
"80:d2:1d:6a:11:f5", 
"9c:d9:17:89:c0:a2",
"14:d6:4d:4b:98:db"} --Dlink Usb

acceptAP=true
wifi.eventmon.register(wifi.eventmon.AP_STACONNECTED, function(T)
  print("\n\tAP - STATION CONNECTED".."\n\tMAC: "..T.MAC.."\n\tAID: "..T.AID)
  if(allowed_mac_list~=nil) then
    for _, v in pairs(allowed_mac_list) do
      if(v == T.MAC and acceptAP) then return end
    end
  end
  wifi.ap.deauth(T.MAC)
  print("\tStation DeAuthed!")
end)

wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T)
    print("\n\tSTA - CONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..
        T.BSSID.."\n\tChannel: "..T.channel)
    wifi.ap.deauth() acceptAP=false
    print("stop wifi AP mode for 30s")
    tmr.alarm(1,  30000, 0, function()   
        print("restart STATIONAP mode")
        acceptAP=true
        end) 
    end)
	
wifi.eventmon.register(wifi.eventmon.AP_STADISCONNECTED, function(T)
 print("\n\tAP - STATION DISCONNECTED".."\n\tMAC: "..T.MAC.."\n\tAID: "..T.AID)
 end)	
