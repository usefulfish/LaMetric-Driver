-- Driver definitions
driver_label = "LaMetric"
driver_load_system_help = "Allows integration with LaMetric Time device."
driver_has_capture = false
driver_help = [[
example driver
==============

This driver supports communication with Lutron Radio RA2.

Connection to a Radio RA2 system
--------------------------------

Communication with Radio RA2 is done via the Radio RA2 Main Repeater,
which allows interaction with the system via 100 programmable virtual
buttons (*phantom buttons*).

Connection settings consist of: IP address of the Main
Repeater (default: 192.168.1.50), login (default: lutron), password
(default: integration) and telnet IP port (default: 23).

Resources
------------------

The supported resource types are:

  + **Button**: a keypad or control unit button.
  + **LED**: a single LED used for status.

Resource address format
-----------------------

Resource addresses use *Integration ID* which by default is a
number, but can also be a user defined string; and a sub-address called 
*Component Number*.

## Availability of events and commands

Lutron supports a lot of different hardware models and combinations.

Not all hardware setups support the whole set of events and commands.

Check the Lutron documentation (*Lutron Integration Protocol*), or use
the monitoring facilities in BLI to verify that the hardware actually
supports a command or event type.

A typical example is the `_MULTI TAP` event, which is available on a
limited combination of Lutron hardware.

Events
---------------
  + Button
    - **PRESS**
    - **RELEASE**
    - **HOLD**
    - **\_MULTI TAP**: Pressing on the button repeatedly
    - **\_HOLD RELEASE**: Releasing a button after a long press (HOLD)

Commands
-----------------
  + Button
    - **PRESS**
    - **RELEASE**
    - **HOLD**
    - **\_MULTI TAP**: Pressing on the button repeatedly
    - **\_HOLD RELEASE**: Releasing a button after a long press (HOLD)

Resource State
--------------
  + LED
    - **\_STATE**: The state of the LED (0 means OFF and 1 ON)
]]

driver_clear_discovered_resources_on_start = true
driver_version = "0.1"

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

local channel_arguments = {
  stringArgument("_laMetricTimeHost", "", { context_help = "The IP or host name of the LaMetric Time device" }),
  stringArgument("_laMetricTimeApiKey", "", { context_help = "The api key for the device as generated in the app" }),
  intArgument("_poll_interval", 60, 1, 10000, { context_help = "Number of seconds to poll." })
}

driver_channels = {
  CUSTOM("LaMetric connection", "Connection to the LaMetric Time device", channel_arguments)
}

resource_types = {
  ["_LAMETRIC TIME DEVICE"] = {
    standardResourceType = "_LAMETRIC TIME DEVICE",
    address = stringArgument("address", "ID", { context_help = "Device id." }),
    commands = {
      ["_NOTIFY"] = {
        arguments = {
          enumArgument("_PRIORITY", { "INFO", "WARNING", "CRITICAL" }, "INFO", { context_help = "" }),
          stringArgument("_MESSAGE", "", { context_help = "Message to display." }),
        },
        context_help = "Displays an alert."
      },
      ["_NOTIFY WITH DETAILS"] = {
        arguments = {
          enumArgument("_PRIORITY", { "INFO", "WARNING", "CRITICAL" }, "INFO", { context_help = "" }),
          enumArgument("_ICON TYPE", { "NONE", "INFO", "ALERT" }, "NONE", { context_help = "" }),
          stringArgument("_ICON", "2867", { context_help = "Icon id or base64 encoded binary"}),
          stringArgument("_MESSAGE", "", { context_help = "Message to display." }),
          intArgument("_LIFETIME", 120000, 1000, 1000000, { context_help = "Lifetime of the notification in milliseconds. Default is 2 minutes." }),
          intArgument("_CYCLES", 1, 0, 100, { context_help = "The number of times message should be displayed. If cycles is set to 0, notification will stay on the screen until user dismisses it manually."}),
          enumArgument("_SOUND CATEGORY", { "ALARMS", "NOTIFICATIONS" }, "NOTIFICATIONS"),
          stringArgument("_SOUND ID", "notification"),
          intArgument("_SOUND REPEAT", 1, 0, 100, { context_help = "Defines the number of times sound must be played. If set to 0 sound will be played until notification is dismissed."})
        },
        context_help = "Displays an alert."
      },
      ["_NEXT APPLICATION"] = {
        arguments = {
        },
        context_help = "Make the next application visible."
      },
      ["_PREV APPLICATION"] = {
        arguments = {
        },
        context_help = "Make the previous application visible."
      },
      ["_SET MODE"] = {
        arguments = {
          enumArgument("_MODE", { "MANUAL", "AUTO", "SCHEDULE", "KIOSK" }, "MANUAL", { context_help = "The mode of the device."})
        },
        context_help = "Set the mode of the device."
      },
      ["_SET VOLUME"] = {
        arguments = {
          intArgument("_VOLUME", 90, 0, 100, { context_help = "Set the volume of the device." })
        }
      },
      ["_SET SCREENSAVER"] = {
        arguments = {
          boolArgument("_ENABLED", false, { context_help = "Enables or disables the screensaver." })
        }
      }
    },
    states = {
      enumArgument("_MODE", { "MANUAL", "AUTO", "SCHEDULE", "KIOSK" }, "MANUAL", { context_help = "The mode of the device."}),
      intArgument("_VOLUME", 90, 0, 100, { context_help = "The volume set on the device." }),
      boolArgument("_SCREENSAVER ENABLED", false, { context_help = "Screensaver enabled." })
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
      boolArgument("_VISIBLE", false, { context_help = "Indicates whether the widget is currently displayed on the TIME device"})
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
      },
      ["_SET ALARM"] = {
        arguments = {
          boolArgument("_ENABLED", true, { context_help = "Activates the alarm if set to true, deactivates otherwise."}),
          stringArgumentRegEx("_TIME", "07:00:00", "[0-2][0-9]:[0-5][0-9]:[0-5][0-9]", { context_help = " Local time in format \"HH:mm:ss\"."}),
          boolArgument("_WAKE WITH RADIO", false, { context_help = "If true, radio will be activated when alarm goes off."})
        }
      },
      ["_SET CLOCKFACE"] = {
        arguments = {
          enumArgument("_TYPE", { "NONE", "WEATHER", "PAGE_A_DAY" }, "NONE", { context_help = "Specifies the clockface type."})
        }
      }
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
      },
      ["_CONFIGURE"] = {
        arguments = {
          intArgument("_DURATION", 30, 1, 10000000, { context_help = "Time in seconds."}),
          boolArgument("_START NOW", true, { context_help = "If set to true countdown will start immediately."})
        }
      }
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
    --Trace("Received: "..result)
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
  if params and next(params) then
    payload.params = params
  end

  return post_to_url("device/apps/"..resource.address.."/actions", payload)
end

local function notification_runtime(command, resource, arguments)
  if command == "_NOTIFY" then
    local payload = {
      priority = string.lower(arguments._PRIORITY),
      model = {
        frames = {
          {
            text = arguments._MESSAGE,
          }
        }
      }
    }

    post_to_url("device/notifications", payload)
  elseif command == "_NOTIFY WITH DETAILS" then
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
        },
        sound = {
          category = string.lower(arguments["_SOUND CATEGORY"]),
          id = arguments["_SOUND ID"],
          ["repeat"] = arguments["_SOUND REPEAT"]
        },
        cycles = arguments._CYCLES
      }
    }

    post_to_url("device/notifications", payload)
  elseif command == "_NEXT APPLICATION" then
    put_to_url("device/apps/next")
  elseif command == "_PREV APPLICATION" then
    put_to_url("device/apps/prev")
  elseif command == "_SET MODE" then
    put_to_url("device", { mode = string.lower(arguments._MODE) })
  elseif command == "_SET VOLUME" then
    put_to_url("device/audio",{ volume = arguments._VOLUME })
  elseif command == "_SET SCREENSAVER" then
    put_to_url("device/display",{ screensaver = { enabled = arguments._ENABLED }})
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
  elseif command == "_SET ALARM" then
    action(resource, "clock.alarm", { enabled = arguments._ENABLED, time = arguments._TIME, wake_with_radio = arguments["_WAKE WITH RADIO"]})
  elseif command == "_SET CLOCKFACE" then
    action(resource, "clock.clockface", { type = string.lower(arguments._TYPE)})
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
  elseif command == "_CONFIGURE" then
    action(resource, "countdown.configure", { duration = arguments._DURATION, start_now = arguments["_START NOW"] })
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
  local number_of_resources = 0

  local success, device = get_from_url("device")
  if success and device then
    AddDiscoveredResource({
      ["address"]     = device.serial_number,
      ["name"]        = device.name,
      ["type"]        = "_LAMETRIC TIME DEVICE",
      ["description"] = "LaMetric TIME device",
      ["areaName"]    = "",
      ["zoneName"]    = ""
    })

    number_of_resources = number_of_resources + 1
  end


  local success, apps = get_from_url("device/apps")
  if success and apps then
    for name, app in pairs(apps) do
      for id, widget in pairs(app.widgets) do
        local discovered_resource
        if name == "com.lametric.stopwatch" then
          discovered_resource = create_resource(id, widget, "_STOPWATCH", "La metric stopwatch widget")
        elseif name == "com.lametric.clock" then
          discovered_resource = create_resource(id, widget, "_CLOCK", "La metric clock widget")
        elseif name == "com.lametric.countdown" then
          discovered_resource = create_resource(id, widget, "_COUNTDOWN", "La metric timer widget")
        elseif name == "com.lametric.radio" then
          discovered_resource = create_resource(id, widget, "_RADIO", "La metric radio widget")
        elseif name == "com.lametric.weather" then
          discovered_resource = create_resource(id, widget, "_WEATHER", "La metric weather widget")
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
  local success, device = get_from_url("device")
  if success and device then
    local resource = readResource("_LAMETRIC TIME DEVICE", device.serial_number)
    if resource then
      local state = {
         _MODE = string.upper(device.mode),
         _VOLUME = device.audio.volume,
         ["_SCREENSAVER ENABLED"] = device.display.screensaver.enabled
        }

      setResourceState(resource.typeId, resource.address, state)
    end
  end

  --process app visibility state
  local success, apps = get_from_url("device/apps")
  if success and apps then
    for name, app in pairs(apps) do
      for id, widget in pairs(app.widgets) do
        local typeId
        if name == "com.lametric.stopwatch" then
          typeId = "_STOPWATCH"
        elseif name == "com.lametric.clock" then
          typeId = "_CLOCK"
        elseif name == "com.lametric.countdown" then
          typeId = "_COUNTDOWN"
        elseif name == "com.lametric.radio" then
          typeId = "_RADIO"
        elseif name == "com.lametric.weather" then
          typeId = "_WEATHER"
        else
          typeId = "_WIDGET"
        end

        local resource = readResource(typeId, widget.package.."/widgets/"..id)
        if resource then
          setResourceState(resource.typeId, resource.address, { _VISIBLE = widget.visible})
        end
      end
    end
  end

  channel.retry("Polling completed", channel.attributes("_poll_interval"))

  return CONST.POLLING
end

function executeCommand(command, resource, arguments)
  if resource.typeId == "_LAMETRIC TIME DEVICE" then
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
