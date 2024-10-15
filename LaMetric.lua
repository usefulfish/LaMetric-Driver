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

local function intArgument(name, default_value, min_val, max_val, optionalArgs)
  local label_value
  if optionalArgs and optionalArgs.context_help then
    label_value = optionalArgs.context_help
  else
    label_value = name
  end

  return {
    name = name,
    label = label_value,
    type = "int",
    default = default_value,
    validation = {
      min = min_val,
      max = max_val
    }
  }
end

resource_types = {
  ["_NOTIFICATION"] = { --this is really the device - can go next / prev and send notifications
    standardResourceType = "_NOTIFICATION",
    address = stringArgument("address", "ID", { context_help = "Device id." }),
    commands = {
      -- priority:(info, warning, critical)
      -- icon_type:(none, info, alert)
      -- lifetime, sound (categoty, id, repeat), frames
      -- model
      ---- cycles
      ---- frames[]
      ------ (message) icon, text
      ------ (goal) icon, start, end, current, unit
      ------ (spike chart I don't think so!!!)
      ---- sound
      ------ category:(alarms, notifications)
      ------ id
      ------ repeat

      --{"priority": "critical","icon_type":"alert","lifetime":5000,"model": { "frames": [ { "icon":1237,"text":"Armed!"}], "sound": {"category": "alarms", "id": "alarm9","repeat":2}}}

      ["_SEND"] = {
        arguments = {
          stringArgument("_MESSAGE", "", { context_help = "Message to display." })
        },
        context_help = "Displays an alert."
      }
    },
    states = {
    }
  },
  ["_WIDGET"] = {
    standardResourceType = "_WIDGET",
    address = stringArgument("address", "ID", { context_help = "Device id." }),
    commands = {
      ["_ACTIVATE"] = {
        arguments = {
        },
        context_help = "Activate this widget."
      }
    },
    states = {
      boolArgument("_ACTIVE", false, { context_help = "Indicates whether the widget is currently displayed on the TIME device"})
    }
  },
  ["_STOPWATCH"] = {
    standardResourceType = "_STOPWATCH",
    address = stringArgument("address", "ID", { context_help = "Device id." }),
    commands = {
      ["_ACTIVATE"] = {
        arguments = {
        },
        context_help = "Activate this widget."
      },
      ["_START"] = {
        arguments = {
        },
        context_help = "Start the stopwatch."
      },
      ["_PAUSE"] = {
        arguments = {
        },
        context_help = "Pause the stopwatch."
      },
      ["_RESET"] = {
        arguments = {
        },
        context_help = "Reset the stopwatch."
      }
    },
    states = {
      boolArgument("_VISIBLE", false, { context_help = "Indicates whether the widget is currently displayed on the TIME device"})
    }
  },
  ["_RADIO"] = {
    standardResourceType = "_RADIO",
    address = stringArgument("address", "ID", { context_help = "Device id." }),
    commands = {
      ["_ACTIVATE"] = {
        arguments = {
        },
        context_help = "Activate this widget."
      },
      ["_PLAY"] = {
        arguments = {
        },
        context_help = "Start the radio."
      },
      ["_PLAY CHANNEL"] = {
        arguments = {
          intArgument("_INDEX", 1, 1, 10)
        },
        context_help = "Start the radio."
      },
      ["_STOP"] = {
        arguments = {
        },
        context_help = "Stop the radio."
      },
      ["_NEXT"] = {
        arguments = {
        },
        context_help = "Next radio channel."
      },
      ["_PREV"] = {
        arguments = {
        },
        context_help = "Previous radio channel."
      }
    },
    states = {
      boolArgument("_VISIBLE", false, { context_help = "Indicates whether the widget is currently displayed on the TIME device"})
    }
  },
  ["_CLOCK"] = {
    standardResourceType = "_CLOCK",
    address = stringArgument("address", "ID", { context_help = "Device id." }),
    commands = {
      ["_ACTIVATE"] = {
        arguments = {
        },
        context_help = "Activate this widget."
      }
      -- add clock.alarm action with enabled, time, wake_with_radio
    },
    states = {
      boolArgument("_VISIBLE", false, { context_help = "Indicates whether the widget is currently displayed on the TIME device"})
    }
  },
  ["_COUNTDOWN"] = {
    standardResourceType = "_COUNTDOWN",
    address = stringArgument("address", "ID", { context_help = "Device id." }),
    commands = {
      ["_ACTIVATE"] = {
        arguments = {
        },
        context_help = "Activate this widget."
      },
      ["_START"] = {
        arguments = {
        },
        context_help = "Start the countdown."
      },
      ["_PAUSE"] = {
        arguments = {
        },
        context_help = "Pause the countdown."
      },
      ["_RESET"] = {
        arguments = {
        },
        context_help = "Reset the countdown."
      }
      --add countdown.configure with duration and start_now
    },
    states = {
      boolArgument("_VISIBLE", false, { context_help = "Indicates whether the widget is currently displayed on the TIME device"})
    }
  },
  ["_WEATHER"] = {
    standardResourceType = "_WEATHER",
    address = stringArgument("address", "ID", { context_help = "Device id." }),
    commands = {
      ["_ACTIVATE"] = {
        arguments = {
        },
        context_help = "Activate this widget."
      },
      ["_FORECAST"] = {
        arguments = {
        },
        context_help = "Display the weather forecast."
      }
    },
    states = {
      boolArgument("_VISIBLE", false, { context_help = "Indicates whether the widget is currently displayed on the TIME device"})
    }
  }
}

local function create_headers()
  return {
    ["Content-Type"] = "application/json",
    ["Authorization"] = "Basic "..encBase64("dev:"..channel.attributes("_laMetricTimeApiKey"))
  }
end

local function create_url(url)
  return "https://"..channel.attributes("_laMetricTimeHost")..":4343/api/v2/"..url
end

local function post_to_url(endpoint, data)
  local url = create_url(endpoint)
  local payload = data

  if type(data) == "table" then
    payload = tableToJson(data)
  end

  Trace("Sending "..payload.." to "..url)

  local success, result = urlPost(url, payload, create_headers())

  Trace("Received: "..result)

  if (not success) then
    driver.setError()
    Trace("Error response: "..result)
    return false, nil
  else
    driver.setOnline()
    return true, jsonToTable(result)
  end
end

local function put_to_url(endpoint, data)
  local url = create_url(endpoint)
  local payload = data

  if type(data) == "table" then
    payload = tableToJson(data)
  end

  Trace("Sending "..payload.." to "..url)

  local success, result = urlPut(url, payload, create_headers())

  Trace("Received: "..result)

  if (not success) then
    driver.setError()
    Trace("Error response: "..result)
    return false, nil
  else
    driver.setOnline()
    return true, jsonToTable(result)
  end
end

local function get_from_url(endpoint)
  local url = create_url(endpoint)
  Trace("Getting from "..url)

  local success, result = urlGet(url, "", create_headers())

  Trace("Received: "..result)

  if (not success) then
    driver.setError()
    Trace("Error response: "..result)
    return false, nil
  else
    driver.setOnline()
    return true, jsonToTable(result)
  end
end

local function notification_runtime(command, resource, arguments)
  if command == "_SEND" then
    local message = arguments._MESSAGE
    if message then
      local data_table = {
        model = {
          frames = {
            {
              icon = 2867,
              text = message
            }
          }
        }
      }

      post_to_url("device/notifications", data_table)
    end
  else
    Warn("Unknown command '"..command.."'")
  end
end

local function widget_runtime(command, resource, arguments)
  if command == "_ACTIVATE" then
    put_to_url("device/apps/"..resource.address.."/activate", "")
  else
    Warn("Unknown command '"..command.."'")
  end
end

local function stopwatch_runtime(command, resource, arguments)
  if command == "_ACTIVATE" then
    put_to_url("device/apps/"..resource.address.."/activate", "")
  elseif command == "_START" then
    post_to_url("device/apps/"..resource.address.."/actions", { id = "stopwatch.start", activate = true })
  elseif command == "_PAUSE" then
    post_to_url("device/apps/"..resource.address.."/actions", { id = "stopwatch.pause", activate = true })
  elseif command == "_RESET" then
    post_to_url("device/apps/"..resource.address.."/actions", { id = "stopwatch.reset", activate = true })
  else
    Warn("Unknown command '"..command.."'")
  end
end

local function clock_runtime(command, resource, arguments)
  if command == "_ACTIVATE" then
    put_to_url("device/apps/"..resource.address.."/activate", "")
  else
    Warn("Unknown command '"..command.."'")
  end
end

local function countdown_runtime(command, resource, arguments)
  if command == "_ACTIVATE" then
    put_to_url("device/apps/"..resource.address.."/activate", "")
  elseif command == "_START" then
    post_to_url("device/apps/"..resource.address.."/actions", { id = "countdown.start", activate = true })
  elseif command == "_PAUSE" then
    post_to_url("device/apps/"..resource.address.."/actions", { id = "countdown.pause", activate = true })
  elseif command == "_RESET" then
    post_to_url("device/apps/"..resource.address.."/actions", { id = "countdown.reset", activate = true })
  else
    Warn("Unknown command '"..command.."'")
  end
end

local function weather_runtime(command, resource, arguments)
  if command == "_ACTIVATE" then
    put_to_url("device/apps/"..resource.address.."/activate", "")
  elseif command == "_FORECAST" then
    post_to_url("device/apps/"..resource.address.."/actions", { id = "weather.forecast", activate = true })
  else
    Warn("Unknown command '"..command.."'")
  end
end

local function radio_runtime(command, resource, arguments)
  if command == "_ACTIVATE" then
    put_to_url("device/apps/"..resource.address.."/activate", "")
  elseif command == "_PLAY" then
    post_to_url("device/apps/"..resource.address.."/actions", { id = "radio.play", activate = true })
  elseif command == "_PLAY CHANNEL" then
    post_to_url("device/apps/"..resource.address.."/actions", { id = "radio.play", activate = true, params = { idx = arguments._INDEX } })
  elseif command == "_STOP" then
    post_to_url("device/apps/"..resource.address.."/actions", { id = "radio.stop", activate = true })
  elseif command == "_NEXT" then
    post_to_url("device/apps/"..resource.address.."/actions", { id = "radio.next", activate = true })
  elseif command == "_PREV" then
    post_to_url("device/apps/"..resource.address.."/actions", { id = "radio.prev", activate = true })
  else
    Warn("Unknown command '"..command.."'")
  end
end



-- Public API implementation
function requestResources()
  AddDiscoveredResource({
    ["address"]     = "NOTIFICATION_APP",
    ["name"]        = "Alert notification",
    ["type"]        = "_NOTIFICATION",
    ["description"] = "Messaging",
    ["areaName"]    = "",
    ["zoneName"]    = ""
  })
  local number_of_resources = 1

  local success, apps = get_from_url("device/apps")
  if success and apps then
    for name, app in pairs(apps) do
      for id, widget in pairs(app.widgets) do
        if name == "com.lametric.stopwatch" then
          AddDiscoveredResource({
            ["address"]     = widget.package.."/widgets/"..id,
            ["name"]        = widget.settings._title,
            ["type"]        = "_STOPWATCH",
            ["description"] = "La metric stopwatch",
            ["areaName"]    = "",
            ["zoneName"]    = ""
          })
        elseif name == "com.lametric.clock" then
          AddDiscoveredResource({
            ["address"]     = widget.package.."/widgets/"..id,
            ["name"]        = widget.settings._title,
            ["type"]        = "_CLOCK",
            ["description"] = "La metric clock",
            ["areaName"]    = "",
            ["zoneName"]    = ""
          })
        elseif name == "com.lametric.countdown" then
          AddDiscoveredResource({
            ["address"]     = widget.package.."/widgets/"..id,
            ["name"]        = widget.settings._title,
            ["type"]        = "_COUNTDOWN",
            ["description"] = "La metric countdown",
            ["areaName"]    = "",
            ["zoneName"]    = ""
          })
        elseif name == "com.lametric.radio" then
          AddDiscoveredResource({
            ["address"]     = widget.package.."/widgets/"..id,
            ["name"]        = widget.settings._title,
            ["type"]        = "_RADIO",
            ["description"] = "La metric radio",
            ["areaName"]    = "",
            ["zoneName"]    = ""
          })
        elseif name == "com.lametric.weather" then
          AddDiscoveredResource({
            ["address"]     = widget.package.."/widgets/"..id,
            ["name"]        = widget.settings._title,
            ["type"]        = "_WEATHER",
            ["description"] = "La metric weather",
            ["areaName"]    = "",
            ["zoneName"]    = ""
          })
        else
          AddDiscoveredResource({
            ["address"]     = widget.package.."/widgets/"..id,
            ["name"]        = widget.settings._title,
            ["type"]        = "_WIDGET",
            ["description"] = "La metric widget",
            ["areaName"]    = "",
            ["zoneName"]    = ""
          })
        end

        number_of_resources = number_of_resources + 1
      end
    end
  end

  return true, number_of_resources
end

function process()
  channel.retry("", 30)

  return CONST.CONNECTED
end

function executeCommand(command, resource, arguments)
  if resource.typeId == "_NOTIFICATION" then
    notification_runtime(command, resource, arguments)
  elseif resource.typeId == "_STOPWATCH" then
    stopwatch_runtime(command, resource, arguments)
  elseif resource.typeId == "_CLOCK" then
    clock_runtime(command, resource, arguments)
  elseif resource.typeId == "_COUNTDOWN" then
    countdown_runtime(command, resource, arguments)
  elseif resource.typeId == "_WEATHER" then
    weather_runtime(command, resource, arguments)
  elseif resource.typeId == "_RADIO" then
    radio_runtime(command, resource, arguments)
  elseif resource.typeId == "_WIDGET" then
    widget_runtime(command, resource, arguments)
  else
    Warn("Unknown resource type '"..resource.typeId.."'")
  end
end

function onResourceDelete(resource)
end

function onResourceUpdate(resource)
end

function onResourceAdd(resource)
end
