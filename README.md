
LaMetric TIME
=============

This driver supports communication with the LaMetric TIME.

Connection to the TIME device
-----------------------------

Communication to the device is done using an primary resource for the TIME device itslef. This
resource allows sending notifications, basic operation similar to the operating the buttins on
the device, as well as control of simple settings.

You will need to add one system per device you wish to control. Connection settings consist of: IP address or network name of the 
LaMetric TIME device and an API key which can be obtained by accessing the settings on your smartphone app and requesting 
it there.

As the TIME does not support setting a static IP address directly, you must either use
the advertised network name or assign the device a static IP on your router.

Resources
------------------

The supported resource types are:

  + **_LAMETRIC TIME**: control of the device including notifications, basic operation and settings.
  + **_CLOCK APP**: interaction with the alarm clock app.
  + **_TIMER APP**: interaction with the countdown timer app.
  + **_STOPWATCH APP**: interaction with the stopwatch app.
  + **_RADIO APP**: interaction with the radio app.
  + **_WEATHER APP**: interaction with the weather app.
  + **_3RD PARTY APP APP**: generic app from the LaMetric MARKET - no app specific commands are avaiable.

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
    - **\_NOTIFY**
    - **\_NOTIFY WITH DETAILS**
    - **\_NEXT APPLICATION**
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