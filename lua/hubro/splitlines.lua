-- How the FUCK is this function not built-in

return function(text)
  local lines = {}
  for line in text:gmatch("([^\n]+)") do
    table.insert(lines, line)
  end
  return lines
end
