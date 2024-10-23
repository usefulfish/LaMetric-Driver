-- Driver definitions
driver_label = "LaMetric"
driver_load_system_help = "Allows integration with LaMetric Time device."
driver_has_capture = false
driver_help = [[
LaMetric TIME
=============

This driver supports communication with the LaMetric TIME.

Connection to the TIME device
-----------------------------

Communication to the device is done using a primary resource for the TIME device itslef. This
resource allows sending notifications, basic operation similar to the operating the buttins on
the device, as well as control of simple settings.

You will need to add one system per device you wish to control. Connection settings consist of: IP address or network name of the 
LaMetric TIME device and an API key which can be obtained by accessing the settings on your smartphone app and requesting 
it there.

As the TIME does not support setting a static IP address directly, you must either use
the advertised network name or assign the device a static IP on your router.

Resources
---------------

The supported resource types are:

  + **_LAMETRIC TIME**: control of the device including notifications, basic operation and settings.
  + **_CLOCK APP**: interaction with the alarm clock app.
  + **_TIMER APP**: interaction with the countdown timer app.
  + **_STOPWATCH APP**: interaction with the stopwatch app.
  + **_RADIO APP**: interaction with the radio app.
  + **_WEATHER APP**: interaction with the weather app.
  + **_3RD PARTY APP**: generic app from the LaMetric MARKET - no app specific commands are avaiable.

Resource addresses
------------------

The IP for the device is defined at system drive level. The resource address for the TIME device and apps
and set by resource discovery. For app, the unique address can change if you delete the appfrom your TIME deviceand re-install
it - in this case you would nedd to use the resource discovery to get the new address and update it. 

Events
---------------
The LaMetric TIME does not support events over its API, but the driver will poll For
changes on the device and raise appropriate state update events as expected. Given that the primary
usage of this drive would be to send notifications and some basic operation of the built-in apps, then
it is not expected that you would rely on these updates so polling can be kept to a minimum.

Commands
-----------------
  + \_LAMETRIC TIME
    - **\_NOTIFY**:
    - **\_NOTIFY WITH DETAILS**:
    - **\_NEXT APPLICATION**:
    - **\_PREV APPLICATION**: Pressing on the button repeatedly
    - **\_SET MODE**: Releasing a button after a long press (HOLD)
    - **\_SET VOLUME**: 
    - **\_SET SCREENSAVER**:
  + \__CLOCK APP
    - **\_ACTIVATE**: Makes the clock the currently displayed app.
    - **\_SET ALARM**:
    - **\_ENABLE ALARM**:
    - **\_SET CLOCKFACE**:
  + \_TIMER APP
    - **\_ACTIVATE**: Makes the timer the currently displayed app.
    - **\_START**:
    - **\_PAUSE**:
    - **\_RESET**:
    - **\_CONFIGURE**:
  + \_STOPWATCH APP
    - **\_ACTIVATE**: Makes the stopwatch the currently displayed app.
    - **\_START**:
    - **\_PAUSE**:
    - **\_RESET**:
  + \_RADIO APP
    - **\_ACTIVATE**: Makes the radio the currently displayed app.
    - **\_PLAY**:
    - **\_PLAY CHANNEL**:
    - **\_STOP**:
    - **\_NEXT**:
    - **\_PREV**:
  + \_WEATHER APP
    - **\_ACTIVATE**: Makes the weather the currently displayed app.
    - **\_FORECAST**:
  + \_3RD PARTY APP
    - **\_ACTIVATE**: Makes the 3rd party app the currently displayed app.

Resource State
--------------
  + \_LAMETRIC TIME
    - **\_MODE**: The state of the LED (0 means OFF and 1 ON)
    - **\_VOLUME**: The state of the LED (0 means OFF and 1 ON)
    - **\_SCREENSAVER ENABLED**: The state of the LED (0 means OFF and 1 ON)
  + \__CLOCK APP
    - **\_VISIBLE**: Indicates whether the app is currently displayed on the TIME device
  + \_TIMER APP
    - **\_VISIBLE**: Indicates whether the app is currently displayed on the TIME device
  + \_STOPWATCH APP
    - **\_VISIBLE**: Indicates whether the app is currently displayed on the TIME device
  + \_RADIO APP
    - **\_VISIBLE**: Indicates whether the app is currently displayed on the TIME device
  + \_WEATHER APP
    - **\_VISIBLE**: Indicates whether the app is currently displayed on the TIME device
  + \_3RD PARTY APP
    - **\_VISIBLE**: Indicates whether the app is currently displayed on the TIME device
]]

driver_clear_discovered_resources_on_start = true
driver_version = "1.0"

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
  intArgument("_pollInterval", 60, 1, 10000, { context_help = "Number of seconds between poll events." })
}

driver_channels = {
  CUSTOM("LaMetric connection", "Connection to the LaMetric Time device", channel_arguments)
}

resource_types = {
  ["_LAMETRIC TIME"] = {
    standardResourceType = "_LAMETRIC TIME",
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
        context_help = "Make the next app visible."
      },
      ["_PREV APPLICATION"] = {
        arguments = {
        },
        context_help = "Make the previous app visible."
      },
      ["_SET MODE"] = {
        arguments = {
          enumArgument("_MODE", { "MANUAL", "AUTO", "SCHEDULE", "KIOSK" }, "MANUAL", { context_help = "The mode of the device."})
        },
        context_help = "Set the app switching mode of the device."
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
  ["_3RD PARTY APP"] = {
    standardResourceType = "_3RD PARTY APP",
    address = stringArgument("address", "ID", { context_help = "Device id." }),
    commands = {
      ["_ACTIVATE"] = {
        arguments = {
        },
        context_help = "Activate this app."
      }
    },
    states = {
      boolArgument("_VISIBLE", false, { context_help = "Indicates whether the app is currently displayed on the TIME device"})
    }
  },
  ["_STOPWATCH APP"] = {
    standardResourceType = "_STOPWATCH APP",
    address = stringArgument("address", "ID", { context_help = "Device id." }),
    commands = {
      ["_ACTIVATE"] = {
        arguments = {
        },
        context_help = "Activate this app."
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
      boolArgument("_VISIBLE", false, { context_help = "Indicates whether the app is currently displayed on the TIME device"})
    }
  },
  ["_RADIO APP"] = {
    standardResourceType = "_RADIO APP",
    address = stringArgument("address", "ID", { context_help = "Device id." }),
    commands = {
      ["_ACTIVATE"] = {
        arguments = {
        },
        context_help = "Activate this app."
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
      boolArgument("_VISIBLE", false, { context_help = "Indicates whether the app is currently displayed on the TIME device"})
    }
  },
  ["_CLOCK APP"] = {
    standardResourceType = "_CLOCK APP",
    address = stringArgument("address", "ID", { context_help = "Device id." }),
    commands = {
      ["_ACTIVATE"] = {
        arguments = {
        },
        context_help = "Activate this app."
      },
      ["_SET ALARM"] = {
        arguments = {
          boolArgument("_ENABLED", true, { context_help = "Activates the alarm if set to true, deactivates otherwise."}),
          stringArgumentRegEx("_TIME", "07:00", "[0-2][0-9]:[0-5][0-9]\\(\\?::[0-5][0-9]\\)\\?", { context_help = " Local time in format \"HH:mm:ss\"."}),
          boolArgument("_WAKE WITH RADIO", false, { context_help = "If true, radio will be activated when alarm goes off."})
        }
      },
      ["_ENABLE ALARM"] = {
        arguments = {
          boolArgument("_ENABLED", true, { context_help = "Activates the alarm if set to true, deactivates otherwise."})
        }
      },
      ["_SET CLOCKFACE"] = {
        arguments = {
          enumArgument("_TYPE", { "NONE", "WEATHER", "PAGE_A_DAY" }, "NONE", { context_help = "Specifies the clockface type."})
        }
      }
    },
    states = {
      boolArgument("_VISIBLE", false, { context_help = "Indicates whether the app is currently displayed on the TIME device"})
    }
  },
  ["_TIMER APP"] = {
    standardResourceType = "_TIMER APP",
    address = stringArgument("address", "ID", { context_help = "Device id." }),
    commands = {
      ["_ACTIVATE"] = {
        arguments = {
        },
        context_help = "Activate this app."
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
      boolArgument("_VISIBLE", false, { context_help = "Indicates whether the app is currently displayed on the TIME device"})
    }
  },
  ["_WEATHER APP"] = {
    standardResourceType = "_WEATHER APP",
    address = stringArgument("address", "ID", { context_help = "Device id." }),
    commands = {
      ["_ACTIVATE"] = {
        arguments = {
        },
        context_help = "Activate this app."
      },
      ["_FORECAST"] = {
        arguments = {
        },
        context_help = "Display the weather forecast."
      }
    },
    states = {
      boolArgument("_VISIBLE", false, { context_help = "Indicates whether the app is currently displayed on the TIME device"})
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
  elseif command == "_ENABLE ALARM" then
    action(resource, "clock.alarm", { enabled = arguments._ENABLED  })
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
      ["type"]        = "_LAMETRIC TIME",
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
          discovered_resource = create_resource(id, widget, "_STOPWATCH APP", "La metric stopwatch app")
        elseif name == "com.lametric.clock" then
          discovered_resource = create_resource(id, widget, "_CLOCK APP", "La metric clock app")
        elseif name == "com.lametric.countdown" then
          discovered_resource = create_resource(id, widget, "_TIMER APP", "La metric timer app")
        elseif name == "com.lametric.radio" then
          discovered_resource = create_resource(id, widget, "_RADIO APP", "La metric radio app")
        elseif name == "com.lametric.weather" then
          discovered_resource = create_resource(id, widget, "_WEATHER APP", "La metric weather app")
        else
          discovered_resource = create_resource(id, widget, "_3RD PARTY APP", "La metric app")
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
    local resource = readResource("_LAMETRIC TIME", device.serial_number)
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
          typeId = "_STOPWATCH APP"
        elseif name == "com.lametric.clock" then
          typeId = "_CLOCK APP"
        elseif name == "com.lametric.countdown" then
          typeId = "_TIMER APP"
        elseif name == "com.lametric.radio" then
          typeId = "_RADIO APP"
        elseif name == "com.lametric.weather" then
          typeId = "_WEATHER APP"
        else
          typeId = "_3RD PARTY APP"
        end

        local resource = readResource(typeId, widget.package.."/widgets/"..id)
        if resource then
          setResourceState(resource.typeId, resource.address, { _VISIBLE = widget.visible})
        end
      end
    end
  end

  channel.retry("Polling completed", channel.attributes("_pollInterval"))

  return CONST.POLLING
end

function executeCommand(command, resource, arguments)
  if resource.typeId == "_LAMETRIC TIME" then
    notification_runtime(command, resource, arguments)
  elseif resource.typeId == "_STOPWATCH APP" then
    stopwatch_runtime(command, resource, arguments)
  elseif resource.typeId == "_CLOCK APP" then
    clock_runtime(command, resource, arguments)
  elseif resource.typeId == "_TIMER APP" then
    countdown_runtime(command, resource, arguments)
  elseif resource.typeId == "_WEATHER APP" then
    weather_runtime(command, resource, arguments)
  elseif resource.typeId == "_RADIO APP" then
    radio_runtime(command, resource, arguments)
  elseif resource.typeId == "_3RD PARTY APP" then
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
