-- Driver definitions
driver_label = "LaMetric"
driver_load_system_help = "Allows integration with LaMetric Time device."
driver_has_capture = false
--driver_help = "LaMetric-Driver-Help.md"
driver_help = [[
## LaMetric TIME

The primamy usage would be to display notifications, but resoures are also available which allow interaction
with the various built-in apps.

### Connection to the TIME device

You will need to add one instance of the driver per LaMetric TIME device you wish to
interact with. Once connected, each instacne will talk to a single device and expose 
the apps available on it via resource discovery.

The TIME device does not support setting a static IP address directly, you must either use
the advertised network name availble in the settings, or assign the device a network name 
or static IP using your router.

Connection settings are:
- **La metric time api key**: This can be obtained by accessing the settings for the device from the smartphone app and requesting it there
- **La metric time host**: IP address or network name of the LaMetric TIME device
- **Poll interval**: The number of seconds betwwen polling for resource state updates. Probably should keep polling to a minimum.
- **Check server certificate**: This shouild be turned off

### Available Resources

Allows interaction wih the device via a primary resource for the TIME device itslef. This
resource allows sending notifications, basic operation similar to the operating the buttins on
the device, as well as control of some simple settings.

The supported resource types are:

+ **\_LAMETRIC TIME**: Main interaction with the device for notifications and some basic settings.
+ **\_CLOCK APP**: interaction with the built-in alarm clock app.
+ **\_TIMER APP**: interaction with the built-in countdown timer app.
+ **\_STOPWATCH APP**: interaction with the built-in stopwatch app.
+ **\_RADIO APP**: interaction with the built-in radio app.
+ **\_WEATHER APP**: interaction with the built-in weather app.
+ **\_3RD PARTY APP**: interaction with a generic app from the LaMetric MARKET. No app specific commands are avaiable.


This driver is tested against firmware running **v2.3.0** of the API, but full support should only 
require **v2.1.0**. The *_LAMETRIC TIME* notifications and  settings (except screensaver and 
app control) should work with **v2.0** but apps and screensaver setting is not supported in this version.

### Resource addresses and discovery

Resource discovery is available and is required becuse of the way in which the TIME device 
allocates address to applications. The primary devica and all installed apps will be listed 
for you to add to your probject. Only installed apps will show up, so if an app is removed from the
device then it will not be listed.

The addresses for the TIME device and apps are populated by the resource discovery. For an app, the unique address 
can change if you delete the app from your TIME deviceand re-install it - in this case you would need 
to use the resource discovery again to find the new addres and then you can update it from there. 

### Resource Events

The LaMetric TIME does not support events over its API, but the driver will poll For
changes on the device and raise appropriate state update events as expected. Given that the primary
usage of this drive would be to send notifications and some basic operation of the built-in apps, then
it is not expected that you would rely on these updates so polling should be kept to a minimum.

### Resource Commands

#### Device Notifications

The primary use case wold be to sned notifications and alerts to be displayed on the TIME device. The device supports
rich customisation of these notifications so we have exposed two commands for this: a basic one to easily send a simple notification to the device, and an enhanced one giving the full range of customisation.

*\_LAMETRIC TIME*

- **\_NOTIFY**: Display a simple message on the TIME device.
  - *\_NOTIFICATION PRIORITY*: Controls how the notification is handled by the device
    - INFO: This level of notification should be used for notifications like news, weather, temperature, etc. This notification will not be shown when screensaver is active.
    - WARNING: Should be used to notify the user about something important but not critical. For example, events like “someone is coming home” should use this priority when sending notifications.
    - CRITICAL: The most important notifications. Interrupts notification with priority INFO or WARNING and is displayed even if screensaver is active. Use with care as these notifications can pop in the middle of the night. Must be used only for really important notifications like notifications from smoke detectors, water leak sensors, etc. Use it for events that require human interaction immediately.
  - *\_MESSAGE*: The text of the message to display
- **\_NOTIFY WITH DETAILS**: Display a customised message on the TIME device. Arguments are populated with defaults which match the simple message command
  - *\_MESSAGE*: The text of the message to display
  - *\_MESSAGE ICON*: Icon id or base64 encoded binary. There is a huge array of possible options. Choose here: [LaMetric Icons](https://developer.lametric.com/icons)
  - *\_MESSAGE REPEAT*: The number of times message should be repeated. If this is set to 0, notification will stay on the screen until user dismisses it manually.
  - *\_NOTIFICATION LIFETIME*: Lifetime of the notification in seconds. Default is 2 minutes
  - *\_NOTIFICATION PRIORITY*: As above
  - *\_NOTIFICATION TYPE*: Indicates the nature of the notification. This defines an optional "announcing" icon which is displayed before the message is displayed.
    - NONE: No notification preabble will be shown.
    - INFO: "i" icon will be displayed prior to the notification. Means that notification contains information, no need to take actions on it.
    - ALERT: "!!!" icon will be displayed prior to the notification. Use it when you want the user to pay attention to that notification as it indicates that something bad happened and user must take immediate action.
  - *\_SOUND CATEGORY*: Indicates the category of the sound id selected.
    - ALARMS: The sound id supplied should be one of the *alarm sound ids* listed below
    - NOTIFICATIONS: The sound id supplied should be one of the *notification sound ids* listed below
  - *\_SOUND ID*: Should be one of the ids listed below for the above category e.g. alarm1 or dog etc.
  - *\_SOUND REPEAT*: Defines the number of times sound must be played. If set to 0 sound will be played until notification is dismissed

Full list of **alarm sound ids** currently defined: alarm1, alarm2, alarm3, alarm4, alarm5, alarm6, alarm7 ,alarm8,alarm9, alarm10, alarm11, alarm12, alarm13

Full list of **notification sound ids** currently defined: bicycle, car, cash, cat, dog, dog2, energy, knock-knock, letter_email, lose1, lose2, 
negative1, negative2, negative3, negative4, negative5, 
notification, notification2, notification3, notification4,
open_door, positive1, positive2, positive3, positive4, positive5, positive6
statistic, thunder, water1, water2, win, win2, wind, wind_short

#### Device General Commands

The *_LAMETRIC TIME* resource also supports the following app and settings commands:

+ *\_LAMETRIC TIME*
  - **\_NEXT APPLICATION**: Make the next app visible
  - **\_PREV APPLICATION**: Make the previous app visible
  - **\_SET MODE**: Set the app switching mode of the device. This might be required if you want a selected app to remain visible.
    - *\_MODE*: The mode to select - see resource states below
  - **\_SET VOLUME**: Set the volume of the device. This will affect sounds played as part of a notification as well as the radio.
    - *\_VOLUME*: The volume to set. 
  - **\_SET SCREENSAVER**: Enables or disables the screensaver. This might be required because app switching will not work when the screensaver is active.
    - *\_ENABLED*: True to enable the screensaver, false to disable it.

#### Interaction with aps and app switching

+ \_CLOCK APP
  - **\_ACTIVATE**: Makes the clock the currently displayed app.
  - **\_ENABLE ALARM**: Turn the alarm on or off
    - *\_ENABLED*: Turns on the alarm if set to true, turns it off otherwise
    - *\_WAKE WITH RADIO*: If true, radio will be activated when alarm goes off
  - **\_SET ALARM**: Change the time and action of the alarm
    - *\_ENABLED*: Turns on the alarm if set to true, turns it off otherwise
    - *\_TIME*: Local time in format "HH:mm" or "HH:mm:ss"
    - *\_WAKE WITH RADIO*: If true, radio will be activated when alarm goes off
  - **\_SET CLOCKFACE**:
    - *\_TYPE*:
      - NONE:
      - WEATHER:
      - PAGE_A_DAY:
+ \_TIMER APP
  - **\_ACTIVATE**: Makes the timer the currently displayed app.
  - **\_START**: Start the timer
  - **\_PAUSE**: Pause the timer
  - **\_RESET**: Reset the timer
  - **\_CONFIGURE**:
    - *\_DURATION*: Time in seconds
    - *\_START NOW*: If set to true countdown will start immediately
+ \_STOPWATCH APP
  - **\_ACTIVATE**: Makes the stopwatch the currently displayed app.
  - **\_START**: Start the stopwatch
  - **\_PAUSE**: Pause the stopwatch
  - **\_RESET**: Reset the stopwatch
+ \_RADIO APP
  - **\_ACTIVATE**: Makes the radio the currently displayed app.
  - **\_PLAY**: Start the radio
  - **\_PLAY CHANNEL**: Start a specific raidio station
    - *\_INDEX*: The station to play
  - **\_STOP**: Stop the radio
  - **\_NEXT**: Next radio station
  - **\_PREV**: Previous radio station
+ \_WEATHER APP
  - **\_ACTIVATE**: Makes the weather the currently displayed app.
  - **\_FORECAST**: Display the weather forecast
+ \_3RD PARTY APP
  - **\_ACTIVATE**: Makes the 3rd party app the currently displayed app.

### Resource States

The main device resource has state which is updated on each poll.

+ \_LAMETRIC TIME
  - **\_MODE**:
    - *MANUAL*: Click to scroll mode, when user can manually switch between apps
    - *AUTO*: Auto-scroll mode, when the device switches between apps automatically
    - *SCHEDULE*: Mode when apps get switched according to a schedule
    - *KIOSK*: Kiosk mode when single app is locked on the device
  - **\_VOLUME**: The current volums set on the device
  - **\_SCREENSAVER ENABLED**: Indicates whether the screen save is allowed to operate

All the app resources simply expose a single state which indicates whether the app if currently visible 
on the device. Only one app can be visible at a time and the state is only updated on polling.
  
+ \_CLOCK APP, \_TIMER APP, \_STOPWATCH APP, \_RADIO APP, \_WEATHER APP and \_3RD PARTY APP
  - **\_VISIBLE**: Indicates whether the app is currently displayed on the TIME device

### Change Log

#### v1.0 | 30/10/2024

  - Initial version
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
          stringArgument("_MESSAGE", "", { context_help = "Message to display." }),
          enumArgument("_NOTIFICATION PRIORITY", { "INFO", "WARNING", "CRITICAL" }, "INFO", { context_help = "" })
        },
        context_help = "Displays an alert."
      },
      ["_NOTIFY WITH DETAILS"] = {
        arguments = {
          stringArgument("_MESSAGE", "", { context_help = "Message to display." }),
          stringArgument("_MESSAGE ICON", "2867", { context_help = "Icon id or base64 encoded binary"}),
          intArgument("_MESSAGE REPEAT", 1, 0, 100, { context_help = "The number of times message should be displayed. If cycles is set to 0, notification will stay on the screen until user dismisses it manually."}),
          intArgument("_NOTIFICATION LIFETIME", 120, 1, 1000000, { context_help = "Lifetime of the notification in seconds. Default is 2 minutes." }),
          enumArgument("_NOTIFICATION PRIORITY", { "INFO", "WARNING", "CRITICAL" }, "INFO", { context_help = "" }),
          enumArgument("_NOTIFICATION TYPE", { "NONE", "INFO", "ALERT" }, "NONE", { context_help = "" }),
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
      intArgument("_VOLUME", 100, 0, 100, { context_help = "The volume set on the device." }),
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
          boolArgument("_ENABLED", true, { context_help = "Activates the alarm if set to true, deactivates otherwise."}),
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
        context_help = "Start the timer."
      },
      ["_PAUSE"] = {
        arguments = {
        },
        context_help = "Pause the timer."
      },
      ["_RESET"] = {
        arguments = {
        },
        context_help = "Reset the timer."
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
    Warn("Error response: "..result)
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
      priority = string.lower(arguments["_NOTIFICATION PRIORITY"]),
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
      priority = string.lower(arguments["_NOTIFICATION PRIORITY"]),
      icon_type = string.lower(arguments["_NOTIFICATION TYPE"]),
      lifetime = arguments["_NOTIFICATION LIFETIME"] * 1000,
      model = {
        frames = {
          {
            icon = arguments["_MESSAGE ICON"],
            text = arguments._MESSAGE,
          }
        },
        sound = {
          category = string.lower(arguments["_SOUND CATEGORY"]),
          id = arguments["_SOUND ID"],
          ["repeat"] = arguments["_SOUND REPEAT"]
        },
        cycles = arguments["_MESSAGE REPEAT"]
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
    put_to_url("device/display", { screensaver = { enabled = arguments._ENABLED }})
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
    action(resource, "clock.alarm", { enabled = arguments._ENABLED, wake_with_radio = arguments["_WAKE WITH RADIO"] })
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
         _VOLUME = device.audio.volume
        }

      local screensaver = device.display.screensaver
      if screensaver ~= nil then --screensaver is not supported in all versions
        state["_SCREENSAVER ENABLED"] = screensaver.enabled
      end

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
