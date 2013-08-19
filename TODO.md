This is TODO file of the LongOS project. Planned features will be listed here.
Currently there are 73 registered features.

TODO
========

For v 0.5
--------
- [X] F8: Add terminal programs support.
- [X] F59: Add namespaces with standard classes.
- [X] F66: Refactor loading.
- [X] F67: Update BiriPaint.
- [X] F65: Add more events to the components, windows and dialogs.
- [X] F68: Add ToString method to all classes.
- [X] F69: Refactor terminal programm for better errors catching.
- [X] F71: Rework isModal property setting for windows.
- [X] F62: GvinFileManager: Add posibility to launch programs with "exec" extension.
- [X] F60: GvinFileManager: Add posibility to run programs.
- [X] F63: GvinFileManager: Add "Run in terminal" option to the popup menu.
- [X] F43: Add ability to add programs to the startup.
- [X] #10 GvinFileManager: Error when trying to remove "rom" folder.
- [ ] F50: Change applications configuration extension to XML.
- [ ] F57: Create application for desktop wallpapers changing.
- [ ] F58: Create application for changing applications configuration.
- [ ] F73: Rework rednet support for proper parameters pathing.
- [ ] #11 System error when using Ctrl + T keys combination.
- [ ] #12 GvinFileManager: Error whet trying to create files or folders with some names.

For all versions
--------
- [ ] F7: Create class diagrams for all classes.
- [ ] F1: Make code refactoring.

Further releases
--------
- [ ] F15: Improve PopupMenu to support submenues.
- [ ] F19: Add desktop icons.
- [ ] F19.1: Add Icon class.
- [ ] F19.2: Add DesktopIcon class.
- [ ] F20: Add program to draw icons.
- [ ] F49: Add window size and position storing on application closing.
- [ ] F61: Create file browsing component.
- [ ] F64: Create file extensions association configuration and use it in GvinFileManager.
- [ ] F70: Create Panel component.
- [ ] F72: Create file extensions association configuration.



History
========

For v 0.4
--------
- [X] F47: Move wallpapers to the "Wallpapers" folder.
- [X] F48: Add minimal window size.
- [X] F35: Add windows resizing.
- [X] F40: Add posibility to maximize window on double clicking the title.
- [X] F41: Add window minimizing when trying to move maximized window.
- [X] F45: Add Image resizing.
- [X] F51: Extend stringExtAPI with trim function.
- [X] F53: Rewrite Window constructor.
- [X] F54: Add support for multiple event handlers.
- [X] F55: Add scroll event support.
- [X] F56: Move system applications to the SystemUtilities folder.
- [X] F25: Separate configuration manager into single application.
- [X] F33: Move errors catching from WindowsManager to the ApplicationsManager.
- [X] F28: Refactor components.
- [X] F16: Improve components ierarchy.
- [X] F42: Change components layouts for better corner coordinates.
- [X] F44: Add Enabled property to the components.
- [X] F52: Update calculator program.
- [X] #5 Edit's cursor isn't setted to the last position when opening window with text in edit
- [X] #7 Cursor from back window's edit is visible on front window
- [X] #8 System error appears when calling "error" function without parameters.
- [X] #9 Close and maximize buttons is on the right position when left position specified in the config.

For v 0.3
--------
- [X] F26: Remove Timer class.
- [X] F27: Add Canvas class.
- [X] F23: Add real threads.
- [X] F29: Add Event class.
- [X] F30: Add drawing methods to the Image class.
- [X] F14: Add drag-n-drop support.
- [X] F31: Update components and system to use EventHandler.
- [X] F32: Update dialogs to use EventHandler.
- [X] F36: Add onResize event invoking on window maximizing/minimizing.
- [X] F37: Update ColorPicker dialog to use EventHandler.
- [X] F38: Add right and left mouse drag events instead of simple drag event.
- [X] F39: Remove GvinPaint and create BiriPaint.
- [X] #3 Getting mouse click event in window on left clicking the menu.
- [X] #4 Dragging outside the window.
- [X] #6 Wrong window is selected as current after closing subdialog.

For v0.2
--------

- [X] F2: Create Image class.
- [X] F3: Create ConfigurationManager class.
- [X] F4: Add XML support.
- [X] F5: Change configs extension to XML (Result of F4).
- [X] F5.1: Change color schema config extension to XML.
- [X] F5.2: Change interface config extension to XML.
- [X] F5.3: Change mouse config extension to XML.
- [X] F6: Create Pixel class.
- [X] F9: Create stringExtAPI.
- [X] F10: Rename all files to be equal with class names.
- [X] F12: Improve configuration acess.
- [X] F13: Add events manager.
- [X] F21: Add GetClassName function to all classes.
- [X] F22: Remove ModemMonitor.
- [X] #1: OS global error on right click on the desktop with any active window on the screen.
- [X] #2: Error when moving window to the right border of the screen.

Rejected
--------
- [X] F17: [REJECTED] Add TimersManager class.
- [X] F18: [REJECTED] Update GvinPaint.
- [X] F18.1: [REJECTED] Use Image class instead of direct file working.
- [X] F18.2: [REJECTED] Add more tools.
- [X] F18.3: [REJECTED] Add custom dialogs.
- [X] F46: [REJECTED] Refactor window title drawing.
- [X] F34: [REJECTED] Rename Application to Process.
- [X] F11: [REJECTED] Add packets manager.
- [X] F24: [REJECTED] Create application for components testing.