# Project
This project is a watchface for garmin devices.
More information can be found [here](https://apps.garmin.com/en-US/apps/c69e79c4-9263-4f09-9dc8-a7c22c6bc03d)

### version 2.1.0
* Added new possibility for goal components (floors and steps): show only value, only bar or both (thank you -again- Amy for the request)

### version 2.0.0
##### Attention:
* Due to deep refactoring, some properties might have been reset!
* Floors Climbed conponent only works for devices having this monitoring possibility. This hasn't been tested outside the software Simulator.

##### Changes
* Deep code refactoring to have components in modules
* Layout has been reviewed in zones to let the user choose it's favorite component. Not all the component are displayable in each zone because of the size of the components.
* Added calories component (thank you Kit and Hufo for the request)
* Added distance component; unit depending on the setting of the watch
* Added floors climbing component; must be supported by your device (thank you Amy for the request)
* Added option for seconds color (thank you Amy for the request)

### version 1.70
* Added setting to keep seconds always displayed (thank you Amanda for the request)
* BugFix related to the display of the heart rate when constant monitoring (thank you John for reporting)

### version 1.6.2
* Setting to change the color of each icon
* Setting to change the font size of each label (except the Clock)
* Improvement to reduce the used memory (icon's footprint)
* Setting to show / hide the battery value
* Code rework to use a garmin barrel
* All Icons added to the Lucy mode
* Better vertical alignment for icons linked to labels
* Battery fully centered (depending on text)

### version 1.5.1
* Added color setting option for the foreground
* Added color setting option for icons
* Added the "Show Notification" option
* Better alignment management
* Code cleaning

### version 1.4.0
* Hour is displayed in 12h or 24h format depending on the System settings of the watch
* Better accuracy in the battery component

### version 1.3.1
* Seconds are only shown if requested
* Heart rate is only shown if requested
* Heart rate can keep monitoring when screen enters sleep mode