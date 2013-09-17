This is TODO file of the LongOS project. Planned features will be listed here.
Currently there are 106 registered features.

TODO
========

For v 1.0.1
--------
- [X] F98: Add http events support for applications, windows and threads.
- [X] F85: Add image position option to the wallpaper manager program.
- [X] F96: GvinFileManager: Add sorting by types for directories/files.
- [X] F88: Add file type icons to the GvinFileManager manager.
- [X] F64: Create file extensions association configuration and use it in GvinFileManager.
- [X] F104: Add errors processing and retrying to the downloader.
- [X] #23 GvinTerminal: Second click isn't sended to the program in terminal on double clicking.
- [ ] F82: Add working directory property to the application.
- [ ] F61: Create file browsing component.
- [ ] F99: Add Updater program for updation OS to the current released version.
- [ ] F101: Add installation path writing on OS installation.
- [ ] F106: Add default configuration to the configuration managers.


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
- [ ] F70: Create Panel component.
- [ ] F76: Create video files and video player.
- [ ] F83: Add possibility to use "full screen" mod in windows.
- [ ] F84: Add posibility to minimize windows to control panel.
- [ ] F87: Improve components ierarchy.
- [ ] F89: Add multiple files selection to the GvinFileManager.
- [ ] F90: Improve loading to use classes.
- [ ] F91: Create List class with storing objects type specifying.
- [ ] F100: Add error value checks everywhere where needed.
- [ ] F102: Add posibility to filter chars in Edit component.
- [ ] F103: Add on click cursor position changing for edit component.
- [ ] F105: Create application for editing file assotiations configuration.
- [ ] #20 System hangs on launching LongOS in the terminal emulator in some cases.


History
========

For v 1.0
--------
- [X] F92: Update class diagrams. 
- [X] F93: Create users guide.
- [X] F94: Create programming guide. 
- [X] F95: Create installer program.
- [X] F97: Add checking for color availability on startup. 
- [X] #21 About System: Error when label is empty
- [X] #22 Years are counted from 0.

For v 0.6
--------
- [X] F78: Improve namespaces declaration.
- [X] F80: Create "About system" application.
- [X] F77: Move "enable" and "visible" properties to the Component class.
- [X] F86: Update error generation in methods of classes to use GetClassName.
- [X] F81: Use selection color configuration in the GvinFileManager.
- [X] F75: Create more beautiful loading screen.
- [X] F79: Change color configuration window to use ListBox.
- [X] #16 Java exception when trying to relaunch system after log off.
- [X] #17 Unable to add standard programs to "Applications" menu without using full name.
- [X] #15 System hangs on shutting down terminal after program end.
- [X] #18 BiriPaint: Error when opening a nonexistent file
- [X] #14 It is possible to have day 0 in calendar.
- [X] #19 About System Button don`t use color from color configuration

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
- [X] F74: Add BiriPaint launching on double click on ".image" files.
- [X] F73: Rework rednet support for proper parameters pathing.
- [X] F57: Create application for desktop wallpapers changing.
- [X] F50: Change applications configuration extension to XML.
- [X] F58: Create application for changing applications configuration.
- [X] #10 GvinFileManager: Error when trying to remove "rom" folder.
- [X] #11 System error when using Ctrl + T keys combination.
- [X] #12 GvinFileManager: Error whet trying to create files or folders with some names.

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
- [X] F72: [DUPLICATE] Create file extensions association configuration.
- [X] #13 [NOT A BUG] Modal window is hidden by not modal window if Show was called after the ShowModal call.