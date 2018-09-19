if file.open("dir", "w") then
	file.close()
	file.remove("dir")
	end
if file.open("dir", "w") then
	print("Listing files")
        for k,v in pairs(file.list()) do file.writeline(k..":"..v) end
		file.close()
        end
