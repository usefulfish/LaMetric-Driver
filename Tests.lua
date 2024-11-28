function Test1()
  local resource = {
    typeId = "_LAMETRIC TIME",
    address = "1",
    states = {}
  }

  local parameters = {
    _MODE = "MANUAL"
  }

  executeCommand("_SET MODE", resource, parameters)
end

Test1()

local x = 7
x = x + 3
