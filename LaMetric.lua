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
  local context_help
  if optionalArgs and optionalArgs.context_help then
    context_help = optionalArgs.context_help
  else
    context_help = "Integer value"
  end

  return {
    name = name,
    label = name,
    type = "int",
    default = default_value,
    context_help = context_help,
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
      ["_SEND"] = {
        arguments = {
          enumArgument("_PRIORITY", { "INFO", "WARNING", "CRITICAL" }, "INFO", { context_help = "" }),
          enumArgument("_ICON TYPE", { "NONE", "INFO", "ALERT" }, "NONE", { context_help = "" }),
          stringArgument("_ICON", "2867", { context_help = "Icon id or base64 encoded binary"}),
          stringArgument("_MESSAGE", "", { context_help = "Message to display." }),
          intArgument("_LIFETIME", 120000, 1000, 1000000, { context_help = "Lifetime of the notification in milliseconds. Default is 2 minutes." }),
          intArgument("_CYCLES", 1, 1, 100, { context_help = "The number of times message should be displayed. If cycles is set to 0, notification will stay on the screen until user dismisses it manually."}),
          enumArgument("_SOUND CATEGORY", { "ALARMS", "NOTIFICATIONS" }, "NOTIFICATIONS"),
          stringArgument("_SOUND ID", "notification"),
          intArgument("_SOUND REPEAT", 1, 0, 100, { context_help = "Defines the number of times sound must be played. If set to 0 sound will be played until notification is dismissed."})
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
        context_help = "Start a specific raidio station."
      },
      ["_STOP"] = {
        arguments = {
        },
        context_help = "Stop the radio."
      },
      ["_NEXT"] = {
        arguments = {
        },
        context_help = "Next radio station."
      },
      ["_PREV"] = {
        arguments = {
        },
        context_help = "Previous radio station."
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

local function rest_request(method, endpoint, data)
  local url = create_url(endpoint)
  local payload = data or ""

  if type(data) == "table" then
    payload = tableToJson(data)
  end

  Trace("Sending "..payload.." to "..url)

  local success, result = method(url, payload, create_headers())

  if success ~= true then
    driver.setError()
    Error("Error response: "..result)
    return false, nil
  else
    driver.setOnline()
    Trace("Received: "..result)
    return true, jsonToTable(result)
  end
end

local function post_to_url(endpoint, data)
  return rest_request(urlPost, endpoint, data)
end

local function put_to_url(endpoint, data)
  return rest_request(urlPut, endpoint, data)
end

local function get_from_url(endpoint)
  return rest_request(urlGet, endpoint, "")
end

local function activate(resource)
  return put_to_url("device/apps/"..resource.address.."/activate")
end

local function action(resource, id, params)
  local payload = { id = id, activate = true }
  if next(params) then
    payload.params = params
  end

  return post_to_url("device/apps/"..resource.address.."/actions", payload)
end

local function notification_runtime(command, resource, arguments)
  if command == "_SEND" then
    local payload = {
      priority = string.lower(arguments._PRIORITY),
      icon_type = string.lower(arguments["_ICON TYPE"]),
      lifetime = arguments._LIFETIME,
      model = {
        frames = {
          {
            icon = arguments._ICON,
            text = arguments._MESSAGE,
          }
        }
      },
      sound = {
        category = string.lower(arguments["_SOUND CATEGORY"]),
        id = arguments["_SOUND ID"],
        ["repeat"] = arguments["_SOUND REPEAT"]
      },
      cycles = arguments._CYCLES
    }

    post_to_url("device/notifications", payload)
  else
    Warn("Unknown command '"..command.."'")
  end
end

local function widget_runtime(command, resource, arguments)
  if command == "_ACTIVATE" then
    activate(resource)
  else
    Warn("Unknown command '"..command.."'")
  end
end

local function stopwatch_runtime(command, resource, arguments)
  if command == "_ACTIVATE" then
    activate(resource)
  elseif command == "_START" then
    action(resource, "stopwatch.start")
  elseif command == "_PAUSE" then
    action(resource, "stopwatch.pause")
  elseif command == "_RESET" then
    action(resource, "stopwatch.reset")
  else
    Warn("Unknown command '"..command.."'")
  end
end

local function clock_runtime(command, resource, arguments)
  if command == "_ACTIVATE" then
    activate(resource)
  else
    Warn("Unknown command '"..command.."'")
  end
end

local function countdown_runtime(command, resource, arguments)
  if command == "_ACTIVATE" then
    activate(resource)
  elseif command == "_START" then
    action(resource, "countdown.start")
  elseif command == "_PAUSE" then
    action(resource, "countdown.pause")
  elseif command == "_RESET" then
    action(resource, "countdown.reset")
  else
    Warn("Unknown command '"..command.."'")
  end
end

local function weather_runtime(command, resource, arguments)
  if command == "_ACTIVATE" then
    activate(resource)
  elseif command == "_FORECAST" then
    action(resource, "weather.forecast")
  else
    Warn("Unknown command '"..command.."'")
  end
end

local function radio_runtime(command, resource, arguments)
  if command == "_ACTIVATE" then
    activate(resource)
  elseif command == "_PLAY" then
    action(resource, "radio.play")
  elseif command == "_PLAY CHANNEL" then
    action(resource, "radio.play.at", { idx = arguments._INDEX })
  elseif command == "_STOP" then
    action(resource, "radio.stop")
  elseif command == "_NEXT" then
    action(resource, "radio.next")
  elseif command == "_PREV" then
    action(resource, "radio.prev")
  else
    Warn("Unknown command '"..command.."'")
  end
end

local function create_resource(id, widget, type, description)
  return {
    ["address"]     = widget.package.."/widgets/"..id,
    ["name"]        = widget.settings._title,
    ["type"]        = type,
    ["description"] = description,
    ["areaName"]    = "",
    ["zoneName"]    = ""
  }
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
        local discovered_resource
        if name == "com.lametric.stopwatch" then
          discovered_resource = create_resource(id, widget, "_STOPWATCH", "La metric stopwatch")
        elseif name == "com.lametric.clock" then
          discovered_resource = create_resource(id, widget, "_CLOCK", "La metric clock")
        elseif name == "com.lametric.countdown" then
          discovered_resource = create_resource(id, widget, "_COUNTDOWN", "La metric countdown")
        elseif name == "com.lametric.radio" then
          discovered_resource = create_resource(id, widget, "_RADIO", "La metric radio")
        elseif name == "com.lametric.weather" then
          discovered_resource = create_resource(id, widget, "_WEATHER", "La metric weather")
        else
          discovered_resource = create_resource(id, widget, "_WIDGET", "La metric widget")
        end

        AddDiscoveredResource(discovered_resource)
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
