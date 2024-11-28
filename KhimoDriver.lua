---@diagnostic disable: lowercase-global

--------------------------------------------------------------------------------
-- External Definition to set
--------------------------------------------------------------------------------


---@type string
driver_label = "Driver name"
driver_version = "1.0"
driver_load_system_help = "Driver description"
driver_has_capture = false
driver_help = ""
driver_clear_discovered_resources_on_start = true

--------------------------------------------------------------------------------
-- Argument definition
--------------------------------------------------------------------------------

---@alias StateValues string|integer|number|boolean
---@alias TypeName "int" | "boolean" | "string" | "number"


---@class (exact) ArgumentParameters
---@field context_help? string

---@class (exact) Validation
---@field min integer|number|nil
---@field max integer|number|nil


---@class (exact) ArgumentDefinition
---@field name string
---@field type TypeName
---@field default StateValues?
---@field validation Validation
---@field context_help string

---comment
---@param name string
---@param default string
---@param additional? ArgumentParameters
---@return ArgumentDefinition
function stringArgument(name, default, additional)
    return {}
  end
  
---comment
---@param name string
---@param default string
---@param regex string
---@param additional? ArgumentParameters
---@return ArgumentDefinition
function stringArgumentRegEx(name, default, regex, additional)
    return {}
  end
  
---comment
---@param name string
---@param default boolean
---@param additional? ArgumentParameters
---@return ArgumentDefinition
function boolArgument(name, default, additional)
    return {}
  end

---@alias EnumValue string|integer
---comment
---@param name string
---@param values EnumValue[]
---@param default EnumValue
---@param additional? ArgumentParameters
---@return ArgumentDefinition
function enumArgument(name, values, default, additional)
  return {}
end

---comment
---@param name string
---@param default integer
---@param min integer
---@param max integer
---@param additional? ArgumentParameters
---@return ArgumentDefinition
function numericArgument(name, default, min, max, additional)
  return {}
end

---comment
---@param name string
---@param default number
---@param additional? ArgumentParameters
---@return ArgumentDefinition
function floatArgument(name, default, additional)
  return {}
end

---@alias TemperatureUnit "C" | "F"

---comment
---@param name string
---@param unit TemperatureUnit
---@param default number
---@param additional? ArgumentParameters
---@return table
function temperatureArgument(name, unit, default, additional)
  return {}
end

---comment
---@param v number
---@param unit TemperatureUnit
---@return number
function tempGet(v, unit)
  return v
end

--------------------------------------------------------------------------------
-- Driver channels and implementation
--------------------------------------------------------------------------------


---@class (exact) Channel
---@field attributes fun(string): StateValues
---@field retry fun(string, int)
channel = {}

---comment
---@param name string
---@return StateValues
function channel.attributes(name)
    local x = ""
    return x
end

---comment
---@param userMessage string
---@param pollInterval integer
function channel.retry(userMessage, pollInterval)
end

---@class exact Driver
---@field setOnline fun()
driver = {}

function driver.setOffline()
end

function driver.setOnline()
end

function driver.setConnecting()
end

---comment
---@param name string
---@return any
function loadExtraLib(name)
  return {}
end

---comment
---@param name string
---@param description string
---@param arguments ArgumentDefinition[]
---@return table
function CUSTOM(name, description, arguments)
    return {}
end

CONST = { POLLING = 1 }


--------------------------------------------------------------------------------
-- Resources
--------------------------------------------------------------------------------

---@alias GeneralStates { [string]:StateValues } }
---@alias GeneralArguments { [string]:StateValues }

---@class (exact) GeneralResource
---@field typeId string
---@field address string
---@field states GeneralStates

---comment
---@param typeId string
---@param address string
---@return GeneralResource
function readResource(typeId, address)
    return {}
end

---comment
---@param typeId string
---@return GeneralResource[]
function readAllResources(typeId)
  return {}
end

---comment
---@param typeId string
---@param address string
---@param state GeneralStates
function setResourceState(typeId, address, state)
end

---comment
---@param definition table
function AddDiscoveredResource(definition)
end

---comment
---@param name string
---@param typeId string
---@param address string
---@param state GeneralStates
---@overload fun(name:string, typeId:string, address:string)
function fireEvent(name, typeId, address, state)
end

--------------------------------------------------------------------------------
-- Logging and utilities
--------------------------------------------------------------------------------


---comment
---@param message string
---@param isUser? boolean
function Info(message, isUser)
end

---comment
---@param message string
---@param isUser? boolean
function Warn(message, isUser)
end

---comment
---@param message string
---@param isUser? boolean
function Error(message, isUser)
end

---comment
---@param message string
---@param isUser? boolean
function Fatal(message, isUser)
end

---comment
---@param message string
---@param isUser? boolean
function Debug(message, isUser)
end

---comment
---@param message string
---@param isUser? boolean
function Trace(message, isUser)
end


--------------------------------------------------------------------------------
-- Rest Api calls
--------------------------------------------------------------------------------


---@alias JsonDocument table
---@alias Headers {[string]:string})
---@alias Payload JsonDocument|string

---comment
---@param url string
---@param payload Payload?
---@param headers Headers
---@return boolean
---@return string?
function urlGet(url, payload, headers)
    return true, ""
end

---comment
---@param url string
---@param payload Payload?
---@param headers Headers
---@return boolean
---@return string?
function urlPost(url, payload, headers)
    return true, ""
end

---comment
---@param url string
---@param payload Payload?
---@param headers Headers
---@return boolean
---@return string?
function urlPut(url, payload, headers)
    return true, ""
end

---comment
---@param x string
---@return string
function encBase64(x)
  return ""
end

---comment
---@param jsonTable JsonDocument
---@return string
function tableToJson(jsonTable)
    return ""
end

---comment
---@param jsonString string
---@return JsonDocument
function jsonToTable(jsonString)
    return {}
end


--------------------------------------------------------------------------------
-- External API to implement
--------------------------------------------------------------------------------

---@return boolean, integer
function requestResources1()
  return false, 0
end

---@return integer
function process1()
  return CONST.POLLING
end

---@param command string
---@param resource GeneralResource
---@param arguments GeneralArguments
function executeCommand1(command, resource, arguments)
end

---comment
---@param resource GeneralResource
function onResourceDelete1(resource)
end

---comment
---@param resource GeneralResource
function onResourceUpdate1(resource)
end

---comment
---@param resource GeneralResource
function onResourceAdd1(resource)
end
