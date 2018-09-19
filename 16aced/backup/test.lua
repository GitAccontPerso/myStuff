local servers={}
s=net.createServer(net.TCP)

function servers.telnet()
print ("starting telnet server")
s:close()
s:listen(23,function(c)
   con_std = c
   function s_output(str)
      if(con_std~=nil) then con_std:send(str) end

   end
   node.output(s_output, 0)   -- re-direct output to function s_ouput.
   c:on("receive",function(c,l)
      node.input(l)           -- works like pcall(loadstring(l)) but support multiple separate line
   end)
   c:on("disconnection",function(c)
      con_std = nil
      node.output(nil)        -- un-regist the redirect output function, output goes to serial
    end)
end)

end

function servers.web()
    --s:close()
    print("Web server started")
    --node.output(iot.s_output, 1)
    s:listen(80,function(connw)
    connw:on("receive", function(clientw,requestw)
        local buf = "";
        local _, _, method, path, vars = string.find(requestw, "([A-Z]+) (.+)?(.+) HTTP");

        if(method == nil)then
            _, _, method, path = string.find(requestw, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end

		buf = buf.."<h1> "..CLIENTID.." "..ssidTemp.." - New Web Server !!!</h1>"
        buf = buf.."<p>"..ALabel.." <a href=\"?pin=AUP\"><button>UP</button></a>&nbsp;<a href=\"?pin=ADOWN\"><button>DOWN</button></a></p>";
        buf = buf.."<p>"..BLabel.." <a href=\"?pin=BUP\"><button>UP</button></a>&nbsp;<a href=\"?pin=BDOWN\"><button>DOWN</button></a></p>";
        local _on,_off = "",""
        if(_GET.pin == "reset")then node.restart()
        elseif(_GET.pin == "AUP")then relay.run("A", "UP")
        elseif(_GET.pin == "ADOWN")then relay.run("A", "DOWN")
        elseif(_GET.pin == "BUP")then relay.run("B", "UP")
        elseif(_GET.pin == "BDOWN")then relay.run("B", "DOWN")
        end
        clientw:send(buf);
		end)
	connw:on("sent", function(clientw)
		clientw:close()
		end)
end)
end
servers.web()
return servers


