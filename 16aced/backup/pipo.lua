ok, json = pcall(sjson.encode, {key="value"})
if ok then
  print(json)
else
  print("failed to encode!")
end