-- Driver definitions
driver_label = "LaMetric"
driver_load_system_help = "Allows integration with LaMetric Time device."
driver_has_capture = false
driver_help = "LaMetric.md"
driver_clear_discovered_resources_on_start = true
driver_version = "0.1"

local channel_arguments = {
  stringArgument("_laMetricTimeHost", "", { context_help = "The IP or host name of the LaMetric Time device" }),
  stringArgument("_laMetricTimeApiKey", "", { context_help = "The api key for the device as generated in the app" })
}

driver_channels = {
  CUSTOM("LaMetric connection", "Connection to the LaMetric Time device", channel_arguments)
}

resource_types = {
  ["_NOTIFICATION"] = {
    standardResourceType = "_NOTIFICATION",
    address = stringArgument("address", "ID", { context_help = "Device id." }),
    commands = {
      ["_SEND"] = {
        code = "_SEND",
        arguments = {
          stringArgument("_MESSAGE", "", { context_help = "Message to display." })
        },
        context_help = "Displays an alert."
      }
    },
    states = {
    }
  }
}

-- Public API implementation
function requestResources()
  local disc_res = {
    ["address"]     = "NOTIFICATION_APP",
    ["name"]        = "Alert notification",
    ["type"]        = "_NOTIFICATION",
    ["description"] = "Messaging",
    ["areaName"]    = "",
    ["zoneName"]    = ""
  }

  AddDiscoveredResource(disc_res)
  return true, 1
end

function process()
  channel.retry("", 30)

  return CONST.CONNECTED
end

function executeCommand(command, resource, arguments)
  if command == "_SEND" then
    local message = arguments["_MESSAGE"]
    if message then
      local data = "{\"model\":{\"frames\":[{\"icon\":2867,\"text\":\""..message.."\"}]}}"
      local headers   = {
        ["Content-Type"] = "application/json",
        ["Authorization"] = "Basic "..encBase64("dev:"..channel.attributes("_laMetricTimeApiKey"))
      }

      local url = "https://"..channel.attributes("_laMetricTimeHost")..":4343/api/v2/device/notifications"
      
      Trace("Sending "..data.." to "..url)
      
      local success,result = urlPost(url, data, headers)
      if (not success) then
        driver.setError()
      	Trace("Error response: "..result)
      else
        driver.setOnline()
      end
    end
  end
end

function onResourceDelete(resource)
end

function onResourceUpdate(resource)
end

function onResourceAdd(resource)
end
