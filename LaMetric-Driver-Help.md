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
  - **\_ENABLE ALARM**: Turn the alarm on or off. This will act on the *first* alarm set on the TIME device.
    - *\_ENABLED*: Turns on the alarm if set to true, turns it off otherwise
    - *\_WAKE WITH RADIO*: If true, radio will be activated when alarm goes off
  - **\_SET ALARM**: Change the time and action of the alarm for a specified time. This command will create a new alarm or mofidy an existing alarm if one already exists matching the supplied time.
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
  